import SwiftUI

struct ZenithJournalView: View {
    @StateObject private var viewModel = ZephyrTaskViewModel()
    
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Today's Journey")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            Text("Plan • Focus • Achieve")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                        }
                        .padding(.top, 20)
                        
                        // Compass View
                        VortexCompassView(
                            progress: $viewModel.dailyProgress,
                            rayAnimations: viewModel.rayAnimations
                        )
                        .padding(.vertical, 20)
                        
                        // Progress Summary
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(viewModel.completedTasksCount)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFD93D"))
                                
                                Text("Completed")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            
                            Rectangle()
                                .fill(Color(yourCode: "#FFD93D").opacity(0.3))
                                .frame(width: 1, height: 40)
                            
                            VStack {
                                Text("\(viewModel.totalTasksCount)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFA500"))
                                
                                Text("Total")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(yourCode: "#3B4C63").opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(yourCode: "#FFD93D").opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal)
                        
                        // Tasks List
                        VStack(spacing: 12) {
                            HStack {
                                Text("Today's Tasks")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFFFFF"))
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        viewModel.showingAddTask = true
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus")
                                            .font(.system(size: 14, weight: .bold))
                                        
                                        Text("Add Task")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    }
                                    .foregroundColor(Color(yourCode: "#2C3E50"))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(yourCode: "#FFD93D"),
                                                        Color(yourCode: "#FFA500")
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .shadow(color: Color(yourCode: "#C68C00").opacity(0.4), radius: 4, x: 0, y: 2)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .scaleEffect(viewModel.showingAddTask ? 0.95 : 1.0)
                            }
                            
                            if viewModel.todayTasks.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "location.north.circle")
                                        .font(.system(size: 48))
                                        .foregroundColor(Color(yourCode: "#FFD93D").opacity(0.6))
                                    
                                    Text("No tasks yet")
                                        .font(.system(size: 18, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                                    
                                    Text("Add your first task to start your journey")
                                        .font(.system(size: 14, weight: .regular, design: .rounded))
                                        .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.5))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 40)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.todayTasks, id: \.id) { task in
                                        QuantumTaskCard(task: task) {
                                            viewModel.toggleTaskCompletion(task)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddTask) {
            AstralAddTaskView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchTodayTasks()
        }
    }
}

struct AstralAddTaskView: View {
    @ObservedObject var viewModel: ZephyrTaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var taskTitle = ""
    @State private var selectedPriority: Int16 = 1
    @State private var goalTag = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(yourCode: "#2C3E50"),
                        Color(yourCode: "#34495E")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    Text("New Task")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Color(yourCode: "#FFFFFF"))
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        // Task Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task Title")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD"))
                            
                            TextField("Enter your task...", text: $taskTitle)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(yourCode: "#3B4C63").opacity(0.8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(yourCode: "#FFD93D").opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        // Priority Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD"))
                            
                            HStack(spacing: 12) {
                                ForEach([2, 1, 0], id: \.self) { priority in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedPriority = Int16(priority)
                                        }
                                    }) {
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(getPriorityColor(Int16(priority)))
                                                .frame(width: 12, height: 12)
                                            
                                            Text(getPriorityText(Int16(priority)))
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                        }
                                        .foregroundColor(selectedPriority == priority ? Color(yourCode: "#2C3E50") : Color(yourCode: "#FFFACD"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(selectedPriority == priority ? 
                                                     getPriorityColor(Int16(priority)) : 
                                                     Color(yourCode: "#3B4C63").opacity(0.6))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(getPriorityColor(Int16(priority)).opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        // Goal Tag (Optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal Tag (Optional)")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD"))
                            
                            TextField("e.g., Health, Work, Personal...", text: $goalTag)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(yourCode: "#3B4C63").opacity(0.8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(yourCode: "#FFD93D").opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(yourCode: "#FFFACD"))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(yourCode: "#3B4C63").opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(yourCode: "#FFFACD").opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        Button("Add Task") {
                            viewModel.newTaskTitle = taskTitle
                            viewModel.newTaskPriority = selectedPriority
                            viewModel.addNewTask()
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(yourCode: "#2C3E50"))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(yourCode: "#FFD93D"),
                                            Color(yourCode: "#FFA500")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color(yourCode: "#C68C00").opacity(0.4), radius: 4, x: 0, y: 2)
                        )
                        .disabled(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            taskTitle = viewModel.newTaskTitle
            selectedPriority = viewModel.newTaskPriority
        }
    }
    
    private func getPriorityColor(_ priority: Int16) -> Color {
        switch priority {
        case 0: return Color(yourCode: "#FFFACD") // Low - light yellow
        case 1: return Color(yourCode: "#FFA500") // Medium - orange  
        case 2: return Color(yourCode: "#FFD93D") // High - bright yellow
        default: return Color(yourCode: "#FFA500")
        }
    }
    
    private func getPriorityText(_ priority: Int16) -> String {
        switch priority {
        case 0: return "Low"
        case 1: return "Medium"
        case 2: return "High"
        default: return "Medium"
        }
    }
}
