import SwiftUI
import Charts

class StatisticsViewModel: ObservableObject {
    @Published var totalTasksCompleted: Int = 0
    @Published var totalTasksCreated: Int = 0
    @Published var averageCompletionTime: TimeInterval = 0
    @Published var longestStreak: Int = 0
    @Published var currentStreak: Int = 0
    @Published var completionRate: Double = 0.0
    @Published var selectedTimeRange: TimeRange = .week
    @Published var chartData: [ChartDataPoint] = []
    @Published var categoryStats: [CategoryStat] = []
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All Time"
    }
    
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
        let label: String
    }
    
    struct CategoryStat: Identifiable {
        let id = UUID()
        let category: String
        let count: Int
        let percentage: Double
        let color: Color
    }
    
    init() {
        loadStatistics()
    }
    
    func loadStatistics() {
        generateMockData()
    }
    
    func changeTimeRange(_ range: TimeRange) {
        selectedTimeRange = range
        generateMockData()
    }
    
    func refreshStatistics() {
        loadStatistics()
    }
    
    private func generateMockData() {
        let calendar = Calendar.current
        let now = Date()
        var dataPoints: [ChartDataPoint] = []
        
        let daysToShow = selectedTimeRange == .week ? 7 : selectedTimeRange == .month ? 30 : selectedTimeRange == .year ? 365 : 365
        
        for i in 0..<daysToShow {
            if let date = calendar.date(byAdding: .day, value: -i, to: now) {
                let value = Double.random(in: 0...100)
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd"
                let label = formatter.string(from: date)
                dataPoints.append(ChartDataPoint(date: date, value: value, label: label))
            }
        }
        
        chartData = dataPoints.reversed()
        
        totalTasksCompleted = Int.random(in: 100...1000)
        totalTasksCreated = totalTasksCompleted + Int.random(in: 0...100)
        completionRate = Double(totalTasksCompleted) / Double(totalTasksCreated) * 100
        longestStreak = Int.random(in: 5...30)
        currentStreak = Int.random(in: 0...longestStreak)
        
        categoryStats = [
            CategoryStat(category: "Work", count: 45, percentage: 35.0, color: .blue),
            CategoryStat(category: "Personal", count: 30, percentage: 23.0, color: .green),
            CategoryStat(category: "Health", count: 25, percentage: 19.0, color: .red),
            CategoryStat(category: "Learning", count: 20, percentage: 15.0, color: .orange),
            CategoryStat(category: "Other", count: 10, percentage: 8.0, color: .gray)
        ]
    }
    
    func calculateAverageCompletionTime() -> String {
        let hours = Int(averageCompletionTime) / 3600
        let minutes = (Int(averageCompletionTime) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedChartType: ChartType = .line
    
    enum ChartType: String, CaseIterable {
        case line = "Line"
        case bar = "Bar"
        case area = "Area"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    statsOverviewSection
                    
                    timeRangePicker
                    
                    chartSection
                    
                    categoryStatsSection
                    
                    detailedStatsSection
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshStatistics()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    private var statsOverviewSection: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                StatCard(title: "Completed", value: "\(viewModel.totalTasksCompleted)", color: .green)
                StatCard(title: "Created", value: "\(viewModel.totalTasksCreated)", color: .blue)
            }
            
            HStack(spacing: 20) {
                StatCard(title: "Rate", value: String(format: "%.1f%%", viewModel.completionRate), color: .orange)
                StatCard(title: "Streak", value: "\(viewModel.currentStreak)", color: .red)
            }
        }
    }
    
    private var timeRangePicker: some View {
        Picker("Time Range", selection: $viewModel.selectedTimeRange) {
            ForEach(StatisticsViewModel.TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedTimeRange) { newValue in
            viewModel.changeTimeRange(newValue)
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading) {
            Picker("Chart Type", selection: $selectedChartType) {
                ForEach(ChartType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            
            if #available(iOS 16.0, *) {
                Chart(viewModel.chartData) { dataPoint in
                    switch selectedChartType {
                    case .line:
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Value", dataPoint.value)
                        )
                        .foregroundStyle(.blue)
                    case .bar:
                        BarMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Value", dataPoint.value)
                        )
                        .foregroundStyle(.green)
                    case .area:
                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Value", dataPoint.value)
                        )
                        .foregroundStyle(.orange.opacity(0.3))
                    }
                }
                .frame(height: 200)
            } else {
                Text("Charts require iOS 16+")
                    .frame(height: 200)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var categoryStatsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("By Category")
                .font(.headline)
            
            ForEach(viewModel.categoryStats) { stat in
                HStack {
                    Circle()
                        .fill(stat.color)
                        .frame(width: 12, height: 12)
                    
                    Text(stat.category)
                        .font(.body)
                    
                    Spacer()
                    
                    Text("\(stat.count)")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("(\(String(format: "%.1f", stat.percentage))%)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var detailedStatsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detailed Statistics")
                .font(.headline)
            
            StatRow(label: "Longest Streak", value: "\(viewModel.longestStreak) days")
            StatRow(label: "Current Streak", value: "\(viewModel.currentStreak) days")
            StatRow(label: "Average Time", value: viewModel.calculateAverageCompletionTime())
            StatRow(label: "Completion Rate", value: String(format: "%.2f%%", viewModel.completionRate))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}


