import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [SearchResult] = []
    @Published var recentSearches: [String] = []
    @Published var isSearching: Bool = false
    @Published var selectedFilter: SearchFilter = .all
    @Published var sortOption: SortOption = .relevance
    
    enum SearchFilter: String, CaseIterable {
        case all = "All"
        case tasks = "Tasks"
        case notes = "Notes"
        case tags = "Tags"
        case dates = "Dates"
    }
    
    enum SortOption: String, CaseIterable {
        case relevance = "Relevance"
        case date = "Date"
        case alphabetical = "A-Z"
    }
    
    struct SearchResult: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let type: ResultType
        let date: Date?
        let relevance: Double
        let metadata: [String: Any]
        
        enum ResultType {
            case task
            case note
            case tag
            case date
        }
    }
    
    init() {
        loadRecentSearches()
    }
    
    func loadRecentSearches() {
        recentSearches = ["project", "meeting", "deadline", "review"]
    }
    
    func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchResults = self.generateSearchResults(for: self.searchText)
            self.isSearching = false
            
            if !self.recentSearches.contains(self.searchText) {
                self.recentSearches.insert(self.searchText, at: 0)
                if self.recentSearches.count > 10 {
                    self.recentSearches.removeLast()
                }
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
    }
    
    func removeRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
    }
    
    func selectFilter(_ filter: SearchFilter) {
        selectedFilter = filter
        if !searchText.isEmpty {
            performSearch()
        }
    }
    
    func selectSortOption(_ option: SortOption) {
        sortOption = option
        sortResults()
    }
    
    private func sortResults() {
        switch sortOption {
        case .relevance:
            searchResults.sort { $0.relevance > $1.relevance }
        case .date:
            searchResults.sort { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
        case .alphabetical:
            searchResults.sort { $0.title < $1.title }
        }
    }
    
    private func generateSearchResults(for query: String) -> [SearchResult] {
        let lowerQuery = query.lowercased()
        var results: [SearchResult] = []
        
        let mockTasks = [
            ("Complete project documentation", "Task", Date().addingTimeInterval(-86400)),
            ("Review code changes", "Task", Date().addingTimeInterval(-172800)),
            ("Prepare presentation", "Task", Date().addingTimeInterval(-259200))
        ]
        
        let mockNotes = [
            ("Meeting notes from Monday", "Note", Date().addingTimeInterval(-3600)),
            ("Project ideas and thoughts", "Note", Date().addingTimeInterval(-7200))
        ]
        
        for (title, type, date) in mockTasks {
            if title.lowercased().contains(lowerQuery) || type.lowercased().contains(lowerQuery) {
                let relevance = calculateRelevance(query: query, text: title)
                results.append(SearchResult(
                    title: title,
                    subtitle: type,
                    type: .task,
                    date: date,
                    relevance: relevance,
                    metadata: [:]
                ))
            }
        }
        
        for (title, type, date) in mockNotes {
            if title.lowercased().contains(lowerQuery) || type.lowercased().contains(lowerQuery) {
                let relevance = calculateRelevance(query: query, text: title)
                results.append(SearchResult(
                    title: title,
                    subtitle: type,
                    type: .note,
                    date: date,
                    relevance: relevance,
                    metadata: [:]
                ))
            }
        }
        
        if lowerQuery.contains("tag") || lowerQuery.contains("label") {
            results.append(SearchResult(
                title: "Work Tag",
                subtitle: "Tag",
                type: .tag,
                date: nil,
                relevance: 0.7,
                metadata: [:]
            ))
        }
        
        sortResults()
        return filterResults(results)
    }
    
    private func filterResults(_ results: [SearchResult]) -> [SearchResult] {
        switch selectedFilter {
        case .all:
            return results
        case .tasks:
            return results.filter { $0.type == .task }
        case .notes:
            return results.filter { $0.type == .note }
        case .tags:
            return results.filter { $0.type == .tag }
        case .dates:
            return results.filter { $0.type == .date }
        }
    }
    
    private func calculateRelevance(query: String, text: String) -> Double {
        let lowerQuery = query.lowercased()
        let lowerText = text.lowercased()
        
        if lowerText == lowerQuery {
            return 1.0
        } else if lowerText.hasPrefix(lowerQuery) {
            return 0.9
        } else if lowerText.contains(lowerQuery) {
            return 0.7
        } else {
            let queryWords = lowerQuery.components(separatedBy: .whitespaces)
            let matchingWords = queryWords.filter { lowerText.contains($0) }
            return Double(matchingWords.count) / Double(queryWords.count) * 0.5
        }
    }
    
    var filteredAndSortedResults: [SearchResult] {
        var results = filterResults(searchResults)
        
        switch sortOption {
        case .relevance:
            results.sort { $0.relevance > $1.relevance }
        case .date:
            results.sort { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
        case .alphabetical:
            results.sort { $0.title < $1.title }
        }
        
        return results
    }
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBarSection
                
                if viewModel.isSearching {
                    searchingIndicator
                } else if viewModel.searchText.isEmpty {
                    if viewModel.recentSearches.isEmpty {
                        emptyStateView
                    } else {
                        recentSearchesSection
                    }
                } else if viewModel.filteredAndSortedResults.isEmpty {
                    noResultsView
                } else {
                    searchResultsSection
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var searchBarSection: some View {
        VStack(spacing: 12) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search...", text: $viewModel.searchText)
                        .focused($isSearchFocused)
                        .onSubmit {
                            viewModel.performSearch()
                        }
                        .onChange(of: viewModel.searchText) { _ in
                            if !viewModel.searchText.isEmpty {
                                viewModel.performSearch()
                            } else {
                                viewModel.searchResults = []
                            }
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.clearSearch()
                            isSearchFocused = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            if !viewModel.searchText.isEmpty {
                filterAndSortSection
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private var filterAndSortSection: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SearchViewModel.SearchFilter.allCases, id: \.self) { filter in
                        FilterButton(
                            title: filter.rawValue,
                            isSelected: viewModel.selectedFilter == filter
                        ) {
                            viewModel.selectFilter(filter)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Menu {
                ForEach(SearchViewModel.SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        viewModel.selectSortOption(option)
                    }) {
                        HStack {
                            Text(option.rawValue)
                            if viewModel.sortOption == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Sort")
                }
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .padding(.trailing)
        }
    }
    
    private var searchingIndicator: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Searching...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    viewModel.clearRecentSearches()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ForEach(viewModel.recentSearches, id: \.self) { search in
                Button(action: {
                    viewModel.searchText = search
                    viewModel.performSearch()
                }) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        Text(search)
                        Spacer()
                        Button(action: {
                            viewModel.removeRecentSearch(search)
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top)
    }
    
    private var searchResultsSection: some View {
        List(viewModel.filteredAndSortedResults) { result in
            SearchResultRow(result: result)
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Start Searching")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enter keywords to find tasks, notes, and more")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Results")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Try different keywords or filters")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

struct SearchResultRow: View {
    let result: SearchViewModel.SearchResult
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForType(result.type))
                .font(.title3)
                .foregroundColor(colorForType(result.type))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(result.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let date = result.date {
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if result.relevance > 0.5 {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func iconForType(_ type: SearchViewModel.SearchResult.ResultType) -> String {
        switch type {
        case .task:
            return "checkmark.circle"
        case .note:
            return "note.text"
        case .tag:
            return "tag"
        case .date:
            return "calendar"
        }
    }
    
    private func colorForType(_ type: SearchViewModel.SearchResult.ResultType) -> Color {
        switch type {
        case .task:
            return .green
        case .note:
            return .blue
        case .tag:
            return .orange
        case .date:
            return .purple
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


