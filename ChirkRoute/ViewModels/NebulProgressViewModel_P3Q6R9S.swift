import Foundation
import CoreData
import SwiftUI

class NebulProgressViewModel: ObservableObject {
    private let persistenceController = PersistenceQuantumController.shared
    private var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    @Published var weeklyProgress: [DayProgressData] = []
    @Published var currentWeekProgress: Float = 0.0
    @Published var totalWeeklyTasks = 0
    @Published var completedWeeklyTasks = 0
    @Published var selectedDay: Date = Date()
    
    struct DayProgressData: Identifiable {
        let id = UUID()
        let date: Date
        let completedTasks: Int
        let totalTasks: Int
        let progress: Float
        let dayName: String
    }
    
    init() {
        loadWeeklyProgress()
    }
    
    func loadWeeklyProgress() {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        var weekData: [DayProgressData] = []
        var totalCompleted = 0
        var totalTasks = 0
        
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: weekStart) {
                let dayStart = calendar.startOfDay(for: day)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let request: NSFetchRequest<Task> = Task.fetchRequest()
                request.predicate = NSPredicate(format: "dayIdentifier >= %@ AND dayIdentifier < %@", dayStart as NSDate, dayEnd as NSDate)
                
                do {
                    let tasks = try context.fetch(request)
                    let completed = tasks.filter { $0.isCompleted }.count
                    let total = tasks.count
                    
                    totalCompleted += completed
                    totalTasks += total
                    
                    let progress = total > 0 ? Float(completed) / Float(total) : 0.0
                    let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: day) - 1]
                    
                    weekData.append(DayProgressData(
                        date: day,
                        completedTasks: completed,
                        totalTasks: total,
                        progress: progress,
                        dayName: dayName
                    ))
                } catch {
                    print("Error fetching tasks for day: \(error)")
                }
            }
        }
        
        weeklyProgress = weekData
        completedWeeklyTasks = totalCompleted
        totalWeeklyTasks = totalTasks
        currentWeekProgress = totalTasks > 0 ? Float(totalCompleted) / Float(totalTasks) : 0.0
    }
    
    func getProgressColor(for progress: Float) -> Color {
        if progress >= 1.0 {
            return Color(yourCode: "#FFD93D")
        } else if progress >= 0.5 {
            return Color(yourCode: "#FFA500")
        } else {
            return Color(yourCode: "#3B4C63")
        }
    }
    
    func getProgressGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(yourCode: "#FFD93D"),
                Color(yourCode: "#FFA500")
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
