import SwiftUI

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var selectedCategory: GoalCategory = .all
    @Published var selectedStatus: GoalStatus = .all
    @Published var showingAddGoal = false
    @Published var newGoalTitle: String = ""
    @Published var newGoalDescription: String = ""
    @Published var newGoalDeadline: Date = Date().addingTimeInterval(86400 * 7)
    @Published var newGoalCategory: GoalCategory = .personal
    @Published var newGoalPriority: Priority = .medium
    
    enum GoalCategory: String, CaseIterable {
        case all = "All"
        case personal = "Personal"
        case work = "Work"
        case health = "Health"
        case learning = "Learning"
        case financial = "Financial"
    }
    
    enum GoalStatus: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
        case paused = "Paused"
        case cancelled = "Cancelled"
    }
    
    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    struct Goal: Identifiable {
        let id = UUID()
        var title: String
        var description: String
        var deadline: Date
        var category: GoalCategory
        var priority: Priority
        var status: GoalStatus
        var progress: Double
        var milestones: [Milestone]
        var createdAt: Date
        var completedAt: Date?
        
        struct Milestone: Identifiable {
            let id = UUID()
            var title: String
            var isCompleted: Bool
            var completedAt: Date?
        }
    }
    
    init() {
        loadGoals()
    }
    
    func loadGoals() {
        goals = [
            Goal(
                title: "Complete iOS Project",
                description: "Finish the mobile application development",
                deadline: Date().addingTimeInterval(86400 * 14),
                category: .work,
                priority: .high,
                status: .active,
                progress: 0.65,
                milestones: [
                    Goal.Milestone(title: "Design phase", isCompleted: true, completedAt: Date().addingTimeInterval(-86400 * 5)),
                    Goal.Milestone(title: "Development phase", isCompleted: true, completedAt: Date().addingTimeInterval(-86400 * 2)),
                    Goal.Milestone(title: "Testing phase", isCompleted: false, completedAt: nil),
                    Goal.Milestone(title: "Launch", isCompleted: false, completedAt: nil)
                ],
                createdAt: Date().addingTimeInterval(-86400 * 30),
                completedAt: nil
            ),
            Goal(
                title: "Learn SwiftUI",
                description: "Master SwiftUI framework and best practices",
                deadline: Date().addingTimeInterval(86400 * 30),
                category: .learning,
                priority: .high,
                status: .active,
                progress: 0.40,
                milestones: [
                    Goal.Milestone(title: "Basics", isCompleted: true, completedAt: Date().addingTimeInterval(-86400 * 10)),
                    Goal.Milestone(title: "Advanced", isCompleted: false, completedAt: nil),
                    Goal.Milestone(title: "Projects", isCompleted: false, completedAt: nil)
                ],
                createdAt: Date().addingTimeInterval(-86400 * 20),
                completedAt: nil
            ),
            Goal(
                title: "Run 5K",
                description: "Complete a 5K run without stopping",
                deadline: Date().addingTimeInterval(86400 * 21),
                category: .health,
                priority: .medium,
                status: .active,
                progress: 0.75,
                milestones: [
                    Goal.Milestone(title: "1K run", isCompleted: true, completedAt: Date().addingTimeInterval(-86400 * 7)),
                    Goal.Milestone(title: "3K run", isCompleted: true, completedAt: Date().addingTimeInterval(-86400 * 3)),
                    Goal.Milestone(title: "5K run", isCompleted: false, completedAt: nil)
                ],
                createdAt: Date().addingTimeInterval(-86400 * 14),
                completedAt: nil
            ),
            Goal(
                title: "Save $5000",
                description: "Build emergency fund",
                deadline: Date().addingTimeInterval(86400 * 90),
                category: .financial,
                priority: .high,
                status: .active,
                progress: 0.30,
                milestones: [
                    Goal.Milestone(title: "Save $1000", isCompleted: true, completedAt: Date().addingTimeInterval(-86400 * 20)),
                    Goal.Milestone(title: "Save $2500", isCompleted: false, completedAt: nil),
                    Goal.Milestone(title: "Save $5000", isCompleted: false, completedAt: nil)
                ],
                createdAt: Date().addingTimeInterval(-86400 * 30),
                completedAt: nil
            )
        ]
    }
    
    func addGoal() {
        guard !newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newGoal = Goal(
            title: newGoalTitle,
            description: newGoalDescription,
            deadline: newGoalDeadline,
            category: newGoalCategory,
            priority: newGoalPriority,
            status: .active,
            progress: 0.0,
            milestones: [],
            createdAt: Date(),
            completedAt: nil
        )
        
        goals.append(newGoal)
        
        newGoalTitle = ""
        newGoalDescription = ""
        newGoalDeadline = Date().addingTimeInterval(86400 * 7)
        newGoalCategory = .personal
        newGoalPriority = .medium
        showingAddGoal = false
    }
    
    func updateGoalProgress(_ goal: Goal, progress: Double) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            var updatedGoal = goals[index]
            updatedGoal.progress = min(max(progress, 0), 1)
            if updatedGoal.progress >= 1.0 && updatedGoal.status != .completed {
                completeGoal(updatedGoal)
            } else {
                goals[index] = updatedGoal
            }
        }
    }
    
    func completeGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            var updatedGoal = goals[index]
            updatedGoal.status = .completed
            updatedGoal.progress = 1.0
            updatedGoal.completedAt = Date()
            goals[index] = updatedGoal
        }
    }
    
    func pauseGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            var updatedGoal = goals[index]
            updatedGoal.status = .paused
            goals[index] = updatedGoal
        }
    }
    
    func resumeGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            var updatedGoal = goals[index]
            updatedGoal.status = .active
            goals[index] = updatedGoal
        }
    }
    
    func cancelGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            var updatedGoal = goals[index]
            updatedGoal.status = .cancelled
            goals[index] = updatedGoal
        }
    }
    
    func toggleMilestone(_ milestone: Goal.Milestone, in goal: Goal) {
        if let goalIndex = goals.firstIndex(where: { $0.id == goal.id }),
           let milestoneIndex = goals[goalIndex].milestones.firstIndex(where: { $0.id == milestone.id }) {
            var updatedMilestone = goals[goalIndex].milestones[milestoneIndex]
            updatedMilestone.isCompleted.toggle()
            if updatedMilestone.isCompleted {
                updatedMilestone.completedAt = Date()
            } else {
                updatedMilestone.completedAt = nil
            }
            goals[goalIndex].milestones[milestoneIndex] = updatedMilestone
            
            updateGoalProgressFromMilestones(goal: goals[goalIndex])
        }
    }
    
    private func updateGoalProgressFromMilestones(goal: Goal) {
        guard !goal.milestones.isEmpty else { return }
        let completedCount = goal.milestones.filter { $0.isCompleted }.count
        let progress = Double(completedCount) / Double(goal.milestones.count)
        updateGoalProgress(goal, progress: progress)
    }
    
    func addMilestone(to goal: Goal, title: String) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            let newMilestone = Goal.Milestone(title: title, isCompleted: false, completedAt: nil)
            goals[index].milestones.append(newMilestone)
        }
    }
    
    var filteredGoals: [Goal] {
        var filtered = goals
        
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if selectedStatus != .all {
            filtered = filtered.filter { $0.status == selectedStatus }
        }
        
        return filtered
    }
    
    func getGoalsCount() -> Int {
        filteredGoals.count
    }
    
    func getActiveGoalsCount() -> Int {
        goals.filter { $0.status == .active }.count
    }
    
    func getCompletedGoalsCount() -> Int {
        goals.filter { $0.status == .completed }.count
    }
    
    func getAverageProgress() -> Double {
        guard !goals.isEmpty else { return 0 }
        let sum = goals.reduce(0.0) { $0 + $1.progress }
        return sum / Double(goals.count)
    }
}

struct GoalsView: View {
    @StateObject private var viewModel = GoalsViewModel()
    @State private var selectedGoal: GoalsViewModel.Goal?
    @State private var showingMilestoneSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                filtersSection
                
                if viewModel.filteredGoals.isEmpty {
                    emptyStateView
                } else {
                    goalsList
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingAddGoal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddGoal) {
                AddGoalView(viewModel: viewModel)
            }
            .sheet(item: $selectedGoal) { goal in
                GoalDetailView(goal: goal, viewModel: viewModel)
            }
        }
    }
    
    private var filtersSection: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(GoalsViewModel.GoalCategory.allCases, id: \.self) { category in
                        GoalFilterChip(
                            title: category.rawValue,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(GoalsViewModel.GoalStatus.allCases, id: \.self) { status in
                        GoalFilterChip(
                            title: status.rawValue,
                            isSelected: viewModel.selectedStatus == status
                        ) {
                            viewModel.selectedStatus = status
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            statsBar
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private var statsBar: some View {
        HStack(spacing: 20) {
            StatItem(label: "Total", value: "\(viewModel.getGoalsCount())")
            StatItem(label: "Active", value: "\(viewModel.getActiveGoalsCount())")
            StatItem(label: "Completed", value: "\(viewModel.getCompletedGoalsCount())")
            StatItem(label: "Avg Progress", value: String(format: "%.0f%%", viewModel.getAverageProgress() * 100))
        }
        .padding(.horizontal)
    }
    
    private var goalsList: some View {
        List {
            ForEach(viewModel.filteredGoals) { goal in
                GoalCard(goal: goal) {
                    selectedGoal = goal
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if goal.status == .active {
                        Button(role: .destructive) {
                            viewModel.cancelGoal(goal)
                        } label: {
                            Label("Cancel", systemImage: "xmark.circle")
                        }
                        
                        Button {
                            viewModel.pauseGoal(goal)
                        } label: {
                            Label("Pause", systemImage: "pause.circle")
                        }
                        .tint(.orange)
                    } else if goal.status == .paused {
                        Button {
                            viewModel.resumeGoal(goal)
                        } label: {
                            Label("Resume", systemImage: "play.circle")
                        }
                        .tint(.green)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Goals")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create your first goal to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                viewModel.showingAddGoal = true
            }) {
                Text("Add Goal")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GoalFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct StatItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct GoalCard: View {
    let goal: GoalsViewModel.Goal
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    categoryBadge
                    Spacer()
                    priorityBadge
                    statusBadge
                }
                
                Text(goal.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                if !goal.description.isEmpty {
                    Text(goal.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                progressBar
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatDate(goal.deadline))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if !goal.milestones.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                            Text("\(goal.milestones.filter { $0.isCompleted }.count)/\(goal.milestones.count)")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    private var categoryBadge: some View {
        Text(goal.category.rawValue)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colorForCategory(goal.category).opacity(0.2))
            .foregroundColor(colorForCategory(goal.category))
            .cornerRadius(8)
    }
    
    private var priorityBadge: some View {
        Image(systemName: priorityIcon(goal.priority))
            .font(.caption)
            .foregroundColor(priorityColor(goal.priority))
    }
    
    private var statusBadge: some View {
        Text(goal.status.rawValue)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor(goal.status).opacity(0.2))
            .foregroundColor(statusColor(goal.status))
            .cornerRadius(8)
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(progressColor)
                    .frame(width: geometry.size.width * goal.progress, height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
    
    private var progressColor: Color {
        if goal.progress >= 0.75 {
            return .green
        } else if goal.progress >= 0.5 {
            return .yellow
        } else if goal.progress >= 0.25 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func colorForCategory(_ category: GoalsViewModel.GoalCategory) -> Color {
        switch category {
        case .all:
            return .gray
        case .personal:
            return .blue
        case .work:
            return .purple
        case .health:
            return .green
        case .learning:
            return .orange
        case .financial:
            return .yellow
        }
    }
    
    private func priorityIcon(_ priority: GoalsViewModel.Priority) -> String {
        switch priority {
        case .low:
            return "arrow.down"
        case .medium:
            return "minus"
        case .high:
            return "arrow.up"
        }
    }
    
    private func priorityColor(_ priority: GoalsViewModel.Priority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
    
    private func statusColor(_ status: GoalsViewModel.GoalStatus) -> Color {
        switch status {
        case .all:
            return .gray
        case .active:
            return .blue
        case .completed:
            return .green
        case .paused:
            return .orange
        case .cancelled:
            return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddGoalView: View {
    @ObservedObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $viewModel.newGoalTitle)
                    TextField("Description", text: $viewModel.newGoalDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Settings")) {
                    DatePicker("Deadline", selection: $viewModel.newGoalDeadline, displayedComponents: .date)
                    
                    Picker("Category", selection: $viewModel.newGoalCategory) {
                        ForEach(GoalsViewModel.GoalCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    Picker("Priority", selection: $viewModel.newGoalPriority) {
                        ForEach(GoalsViewModel.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue).tag(priority)
                        }
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addGoal()
                        dismiss()
                    }
                    .disabled(viewModel.newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct GoalDetailView: View {
    let goal: GoalsViewModel.Goal
    @ObservedObject var viewModel: GoalsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var progressValue: Double
    @State private var showingAddMilestone = false
    @State private var newMilestoneTitle = ""
    
    init(goal: GoalsViewModel.Goal, viewModel: GoalsViewModel) {
        self.goal = goal
        self.viewModel = viewModel
        _progressValue = State(initialValue: goal.progress)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    
                    progressSection
                    
                    milestonesSection
                    
                    actionsSection
                }
                .padding()
            }
            .navigationTitle(goal.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddMilestone) {
                AddMilestoneView(
                    title: $newMilestoneTitle,
                    onAdd: {
                        viewModel.addMilestone(to: goal, title: newMilestoneTitle)
                        newMilestoneTitle = ""
                        showingAddMilestone = false
                    }
                )
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !goal.description.isEmpty {
                Text(goal.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Deadline: \(formatDate(goal.deadline))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(goal.priority.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Progress")
                    .font(.headline)
                Spacer()
                Text("\(Int(progressValue * 100))%")
                    .font(.headline)
            }
            
            Slider(value: $progressValue, in: 0...1)
                .onChange(of: progressValue) { newValue in
                    viewModel.updateGoalProgress(goal, progress: newValue)
                }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * progressValue, height: 12)
                        .cornerRadius(6)
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Milestones")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showingAddMilestone = true
                }) {
                    Image(systemName: "plus.circle")
                }
            }
            
            if goal.milestones.isEmpty {
                Text("No milestones yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(goal.milestones) { milestone in
                    MilestoneRow(milestone: milestone) {
                        viewModel.toggleMilestone(milestone, in: goal)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var actionsSection: some View {
        VStack(spacing: 10) {
            if goal.status == .active {
                Button(action: {
                    viewModel.completeGoal(goal)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    viewModel.pauseGoal(goal)
                }) {
                    HStack {
                        Image(systemName: "pause.circle.fill")
                        Text("Pause Goal")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            } else if goal.status == .paused {
                Button(action: {
                    viewModel.resumeGoal(goal)
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Resume Goal")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct MilestoneRow: View {
    let milestone: GoalsViewModel.Goal.Milestone
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(milestone.isCompleted ? .green : .gray)
                    .font(.title3)
                
                Text(milestone.title)
                    .font(.body)
                    .strikethrough(milestone.isCompleted)
                    .foregroundColor(milestone.isCompleted ? .secondary : .primary)
                
                Spacer()
                
                if let completedAt = milestone.completedAt {
                    Text(formatDate(completedAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct AddMilestoneView: View {
    @Binding var title: String
    let onAdd: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Milestone Title", text: $title)
            }
            .navigationTitle("Add Milestone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        onAdd()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

