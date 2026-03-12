import SwiftUI
import CoreData

struct ChronosHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dayIdentifier, ascending: false)],
        animation: .default)
    private var allTasks: FetchedResults<Task>
    
    var groupedTasks: [Date: [Task]] {
        Dictionary(grouping: allTasks) { task in
            Calendar.current.startOfDay(for: task.dayIdentifier ?? Date())
        }
    }
    
    var sortedDates: [Date] {
        groupedTasks.keys.sorted(by: >)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(yourCode: "#2C3E50"),
                        Color(yourCode: "#34495E"),
                        Color(yourCode: "#2C3E50")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Journey History")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(yourCode: "#FFFFFF"))
                        
                        Text("Review Your Progress")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    if sortedDates.isEmpty {
                        // Empty state
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 64))
                                .foregroundColor(Color(yourCode: "#FFD93D").opacity(0.6))
                            
                            Text("No History Yet")
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            Text("Start adding tasks to see your journey unfold")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(sortedDates, id: \.self) { date in
                                    HistoryDayCard(
                                        date: date,
                                        tasks: groupedTasks[date] ?? []
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
    }
}

struct HistoryDayCard: View {
    let date: Date
    let tasks: [Task]
    
    @State private var isExpanded = false
    
    private var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }
    
    private var progressPercentage: Float {
        guard !tasks.isEmpty else { return 0 }
        return Float(completedTasks.count) / Float(tasks.count)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var isYesterday: Bool {
        Calendar.current.isDateInYesterday(date)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 16) {
                    // Date and status
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(isToday ? "Today" : isYesterday ? "Yesterday" : dateFormatter.string(from: date))
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            if isToday {
                                Circle()
                                    .fill(Color(yourCode: "#FFD93D"))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        
                        Text("\(completedTasks.count) of \(tasks.count) completed")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Progress circle
                    ZStack {
                        Circle()
                            .stroke(Color(yourCode: "#3B4C63"), lineWidth: 4)
                            .frame(width: 40, height: 40)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(progressPercentage))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(yourCode: "#FFD93D"),
                                        Color(yourCode: "#FFA500")
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(progressPercentage * 100))%")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(Color(yourCode: "#FFFFFF"))
                    }
                    
                    // Expand indicator
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(yourCode: "#FFD93D"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded content
            if isExpanded {
                VStack(spacing: 12) {
                    Divider()
                        .background(Color(yourCode: "#FFD93D").opacity(0.3))
                        .padding(.horizontal, 20)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(tasks.sorted(by: { $0.priority > $1.priority }), id: \.id) { task in
                            HistoryTaskRow(task: task)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#3B4C63").opacity(0.8),
                            Color(yourCode: "#2C3E50").opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(yourCode: "#FFD93D").opacity(0.4),
                                    Color(yourCode: "#FFA500").opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: Color(yourCode: "#C68C00").opacity(0.2),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
    }
}

struct HistoryTaskRow: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion indicator
            Circle()
                .fill(task.isCompleted ? 
                      LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#FFD93D"),
                            Color(yourCode: "#FFA500")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      ) :
                      LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#3B4C63"),
                            Color(yourCode: "#2C3E50")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                      )
                )
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(
                            task.isCompleted ? 
                            Color(yourCode: "#C68C00") : 
                            Color(yourCode: "#FFD93D").opacity(0.4),
                            lineWidth: 1
                        )
                )
                .overlay(
                    Group {
                        if task.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(Color(yourCode: "#2C3E50"))
                        }
                    }
                )
            
            // Task content
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title ?? "Untitled Task")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(task.isCompleted ? 
                                   Color(yourCode: "#FFFACD").opacity(0.7) : 
                                   Color(yourCode: "#FFFFFF"))
                    .strikethrough(task.isCompleted)
                
                if let goalTag = task.goalTag, !goalTag.isEmpty {
                    Text(goalTag)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.5))
                }
            }
            
            Spacer()
            
            // Priority indicator
            Circle()
                .fill(getPriorityColor(task.priority))
                .frame(width: 8, height: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(yourCode: "#2C3E50").opacity(0.3))
        )
    }
    
    private func getPriorityColor(_ priority: Int16) -> Color {
        switch priority {
        case 0: return Color(yourCode: "#FFFACD") // Low - light yellow
        case 1: return Color(yourCode: "#FFA500") // Medium - orange  
        case 2: return Color(yourCode: "#FFD93D") // High - bright yellow
        default: return Color(yourCode: "#FFA500")
        }
    }
}
