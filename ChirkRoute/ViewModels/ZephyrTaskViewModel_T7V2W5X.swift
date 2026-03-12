import Foundation
import CoreData
import SwiftUI

class ZephyrTaskViewModel: ObservableObject {
    private let persistenceController = PersistenceQuantumController.shared
    private var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    @Published var todayTasks: [Task] = []
    @Published var showingAddTask = false
    @Published var newTaskTitle = ""
    @Published var newTaskPriority: Int16 = 1
    @Published var dailyProgress: Float = 0.0
    @Published var completedTasksCount = 0
    @Published var totalTasksCount = 0
    @Published var rayAnimations: [UUID] = []
    
    init() {
        fetchTodayTasks()
        updateDailyProgress()
    }
    
    func fetchTodayTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        request.predicate = NSPredicate(format: "dayIdentifier >= %@ AND dayIdentifier < %@", today as NSDate, tomorrow as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Task.priority, ascending: false),
            NSSortDescriptor(keyPath: \Task.dateCreated, ascending: true)
        ]
        
        do {
            todayTasks = try context.fetch(request)
            updateDailyProgress()
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func addNewTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let task = Task(context: context)
        task.id = UUID()
        task.title = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        task.priority = newTaskPriority
        task.isCompleted = false
        task.dateCreated = Date()
        task.dayIdentifier = Calendar.current.startOfDay(for: Date())
        
        persistenceController.save()
        
        newTaskTitle = ""
        newTaskPriority = 1
        showingAddTask = false
        
        fetchTodayTasks()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            // Trigger compass animation
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        
        if task.isCompleted {
            task.dateCompleted = Date()
            triggerRayAnimation(for: task.id!)
        } else {
            task.dateCompleted = nil
        }
        
        persistenceController.save()
        updateDailyProgress()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            fetchTodayTasks()
        }
    }
    
    private func updateDailyProgress() {
        totalTasksCount = todayTasks.count
        completedTasksCount = todayTasks.filter { $0.isCompleted }.count
        
        if totalTasksCount > 0 {
            dailyProgress = Float(completedTasksCount) / Float(totalTasksCount)
        } else {
            dailyProgress = 0.0
        }
    }
    
    private func triggerRayAnimation(for taskId: UUID) {
        rayAnimations.append(taskId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.rayAnimations.removeAll { $0 == taskId }
        }
    }
    
    func getPriorityColor(_ priority: Int16) -> Color {
        switch priority {
        case 0: return Color(yourCode: "#FFFACD") // Low - light yellow
        case 1: return Color(yourCode: "#FFA500") // Medium - orange  
        case 2: return Color(yourCode: "#FFD93D") // High - bright yellow
        default: return Color(yourCode: "#FFA500")
        }
    }
    
    func getPriorityText(_ priority: Int16) -> String {
        switch priority {
        case 0: return "Low"
        case 1: return "Medium"
        case 2: return "High"
        default: return "Medium"
        }
    }
}

extension Color {
    init(yourCode: String) {
        var int: UInt64 = 0
        let new = yourCode.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        Scanner(string: new).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch new.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue:  Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }
}
