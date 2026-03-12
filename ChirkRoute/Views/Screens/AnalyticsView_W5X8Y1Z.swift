import SwiftUI
import Charts

class AnalyticsViewModel: ObservableObject {
    @Published var selectedMetric: MetricType = .productivity
    @Published var selectedPeriod: PeriodType = .week
    @Published var analyticsData: [AnalyticsDataPoint] = []
    @Published var insights: [Insight] = []
    @Published var trends: [Trend] = []
    @Published var isRefreshing: Bool = false
    
    enum MetricType: String, CaseIterable {
        case productivity = "Productivity"
        case completion = "Completion Rate"
        case time = "Time Spent"
        case efficiency = "Efficiency"
    }
    
    enum PeriodType: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case quarter = "Quarter"
        case year = "Year"
    }
    
    struct AnalyticsDataPoint: Identifiable {
        let id = UUID()
        let label: String
        let value: Double
        let date: Date
        let category: String?
    }
    
    struct Insight: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let type: InsightType
        let impact: ImpactLevel
        let icon: String
        
        enum InsightType {
            case positive
            case warning
            case suggestion
        }
        
        enum ImpactLevel {
            case high
            case medium
            case low
        }
    }
    
    struct Trend: Identifiable {
        let id = UUID()
        let name: String
        let direction: TrendDirection
        let percentage: Double
        let period: String
        
        enum TrendDirection {
            case up
            case down
            case stable
        }
    }
    
    init() {
        loadAnalytics()
    }
    
    func loadAnalytics() {
        generateAnalyticsData()
        generateInsights()
        generateTrends()
    }
    
    func refreshAnalytics() {
        isRefreshing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadAnalytics()
            self.isRefreshing = false
        }
    }
    
    func changeMetric(_ metric: MetricType) {
        selectedMetric = metric
        generateAnalyticsData()
    }
    
    func changePeriod(_ period: PeriodType) {
        selectedPeriod = period
        generateAnalyticsData()
    }
    
    private func generateAnalyticsData() {
        let calendar = Calendar.current
        let now = Date()
        var dataPoints: [AnalyticsDataPoint] = []
        
        let daysToShow = selectedPeriod == .day ? 1 : selectedPeriod == .week ? 7 : selectedPeriod == .month ? 30 : selectedPeriod == .quarter ? 90 : 365
        
        for i in 0..<daysToShow {
            if let date = calendar.date(byAdding: .day, value: -i, to: now) {
                let baseValue = Double.random(in: 50...100)
                let value = calculateMetricValue(baseValue: baseValue, metric: selectedMetric)
                let formatter = DateFormatter()
                formatter.dateFormat = selectedPeriod == .day ? "HH:mm" : "MMM dd"
                let label = formatter.string(from: date)
                
                dataPoints.append(AnalyticsDataPoint(
                    label: label,
                    value: value,
                    date: date,
                    category: i % 3 == 0 ? "Work" : i % 3 == 1 ? "Personal" : "Other"
                ))
            }
        }
        
        analyticsData = dataPoints.reversed()
    }
    
    private func calculateMetricValue(baseValue: Double, metric: MetricType) -> Double {
        switch metric {
        case .productivity:
            return baseValue * 1.2
        case .completion:
            return min(baseValue, 100.0)
        case .time:
            return baseValue * 0.5
        case .efficiency:
            return baseValue * 0.8
        }
    }
    
    private func generateInsights() {
        insights = [
            Insight(
                title: "Peak Productivity Time",
                description: "You're most productive between 9-11 AM",
                type: .positive,
                impact: .high,
                icon: "sun.max.fill"
            ),
            Insight(
                title: "Completion Rate Improving",
                description: "Your completion rate increased by 15% this week",
                type: .positive,
                impact: .medium,
                icon: "chart.line.uptrend.xyaxis"
            ),
            Insight(
                title: "Low Activity Detected",
                description: "Consider setting more tasks for better progress",
                type: .warning,
                impact: .medium,
                icon: "exclamationmark.triangle.fill"
            ),
            Insight(
                title: "Weekend Productivity",
                description: "Try breaking tasks into smaller chunks on weekends",
                type: .suggestion,
                impact: .low,
                icon: "lightbulb.fill"
            )
        ]
    }
    
    private func generateTrends() {
        trends = [
            Trend(name: "Task Completion", direction: .up, percentage: 12.5, period: "vs last week"),
            Trend(name: "Time Efficiency", direction: .up, percentage: 8.3, period: "vs last week"),
            Trend(name: "Productivity Score", direction: .stable, percentage: 0.0, period: "vs last week"),
            Trend(name: "Task Creation", direction: .down, percentage: -5.2, period: "vs last week")
        ]
    }
    
    func getAverageValue() -> Double {
        guard !analyticsData.isEmpty else { return 0 }
        let sum = analyticsData.reduce(0.0) { $0 + $1.value }
        return sum / Double(analyticsData.count)
    }
    
    func getMaxValue() -> Double {
        analyticsData.map { $0.value }.max() ?? 0
    }
    
    func getMinValue() -> Double {
        analyticsData.map { $0.value }.min() ?? 0
    }
    
    func getTotalValue() -> Double {
        analyticsData.reduce(0.0) { $0 + $1.value }
    }
}

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    @State private var selectedChartStyle: ChartStyle = .line
    
    enum ChartStyle: String, CaseIterable {
        case line = "Line"
        case bar = "Bar"
        case area = "Area"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    metricSelector
                    
                    periodSelector
                    
                    summaryCards
                    
                    chartSection
                    
                    trendsSection
                    
                    insightsSection
                }
                .padding()
            }
            .navigationTitle("Analytics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshAnalytics()
                    }) {
                        Image(systemName: viewModel.isRefreshing ? "arrow.clockwise" : "arrow.clockwise")
                            .rotationEffect(.degrees(viewModel.isRefreshing ? 360 : 0))
                            .animation(viewModel.isRefreshing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isRefreshing)
                    }
                }
            }
        }
    }
    
    private var metricSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AnalyticsViewModel.MetricType.allCases, id: \.self) { metric in
                    MetricChip(
                        title: metric.rawValue,
                        isSelected: viewModel.selectedMetric == metric
                    ) {
                        viewModel.changeMetric(metric)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var periodSelector: some View {
        Picker("Period", selection: $viewModel.selectedPeriod) {
            ForEach(AnalyticsViewModel.PeriodType.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedPeriod) { newValue in
            viewModel.changePeriod(newValue)
        }
    }
    
    private var summaryCards: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                SummaryCard(
                    title: "Average",
                    value: String(format: "%.1f", viewModel.getAverageValue()),
                    color: .blue
                )
                SummaryCard(
                    title: "Maximum",
                    value: String(format: "%.1f", viewModel.getMaxValue()),
                    color: .green
                )
            }
            
            HStack(spacing: 12) {
                SummaryCard(
                    title: "Minimum",
                    value: String(format: "%.1f", viewModel.getMinValue()),
                    color: .orange
                )
                SummaryCard(
                    title: "Total",
                    value: String(format: "%.1f", viewModel.getTotalValue()),
                    color: .purple
                )
            }
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Chart Style", selection: $selectedChartStyle) {
                ForEach(ChartStyle.allCases, id: \.self) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
            
            if #available(iOS 16.0, *) {
                Chart(viewModel.analyticsData) { dataPoint in
                    switch selectedChartStyle {
                    case .line:
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Value", dataPoint.value)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
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
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple.opacity(0.6), .purple.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .frame(height: 250)
            } else {
                Text("Charts require iOS 16+")
                    .frame(height: 250)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trends")
                .font(.headline)
            
            ForEach(viewModel.trends) { trend in
                TrendRow(trend: trend)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.headline)
            
            ForEach(viewModel.insights) { insight in
                InsightCard(insight: insight)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct MetricChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct SummaryCard: View {
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

struct TrendRow: View {
    let trend: AnalyticsViewModel.Trend
    
    var body: some View {
        HStack {
            Image(systemName: iconForDirection(trend.direction))
                .foregroundColor(colorForDirection(trend.direction))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trend.name)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(trend.period)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(formatPercentage(trend.percentage))
                .font(.headline)
                .foregroundColor(colorForDirection(trend.direction))
        }
        .padding(.vertical, 8)
    }
    
    private func iconForDirection(_ direction: AnalyticsViewModel.Trend.TrendDirection) -> String {
        switch direction {
        case .up:
            return "arrow.up.right"
        case .down:
            return "arrow.down.right"
        case .stable:
            return "minus"
        }
    }
    
    private func colorForDirection(_ direction: AnalyticsViewModel.Trend.TrendDirection) -> Color {
        switch direction {
        case .up:
            return .green
        case .down:
            return .red
        case .stable:
            return .gray
        }
    }
    
    private func formatPercentage(_ value: Double) -> String {
        if value == 0 {
            return "0%"
        } else if value > 0 {
            return "+\(String(format: "%.1f", value))%"
        } else {
            return "\(String(format: "%.1f", value))%"
        }
    }
}

struct InsightCard: View {
    let insight: AnalyticsViewModel.Insight
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colorForType(insight.type).opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: insight.icon)
                    .foregroundColor(colorForType(insight.type))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.headline)
                
                Text(insight.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            impactBadge
        }
        .padding()
        .background(colorForType(insight.type).opacity(0.05))
        .cornerRadius(12)
    }
    
    private var impactBadge: some View {
        Text(impactText)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colorForImpact(insight.impact))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var impactText: String {
        switch insight.impact {
        case .high:
            return "HIGH"
        case .medium:
            return "MED"
        case .low:
            return "LOW"
        }
    }
    
    private func colorForType(_ type: AnalyticsViewModel.Insight.InsightType) -> Color {
        switch type {
        case .positive:
            return .green
        case .warning:
            return .orange
        case .suggestion:
            return .blue
        }
    }
    
    private func colorForImpact(_ impact: AnalyticsViewModel.Insight.ImpactLevel) -> Color {
        switch impact {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        }
    }
}


