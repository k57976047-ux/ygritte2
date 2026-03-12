import SwiftUI

struct QuantumTaskCard: View {
    let task: Task
    let onToggle: () -> Void
    
    @State private var cardScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.0
    @State private var checkmarkScale: CGFloat = 0.8
    
    var body: some View {
        HStack(spacing: 16) {
            // Custom checkbox
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    checkmarkScale = 0.6
                    cardScale = 0.95
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onToggle()
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        checkmarkScale = task.isCompleted ? 1.2 : 0.8
                        cardScale = 1.0
                        glowOpacity = task.isCompleted ? 0.8 : 0.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            checkmarkScale = 1.0
                            glowOpacity = task.isCompleted ? 0.3 : 0.0
                        }
                    }
                }
            }) {
                ZStack {
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
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(
                                    task.isCompleted ? 
                                    Color(yourCode: "#C68C00") : 
                                    Color(yourCode: "#FFD93D").opacity(0.4),
                                    lineWidth: 2
                                )
                        )
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(yourCode: "#2C3E50"))
                            .scaleEffect(checkmarkScale)
                    }
                    
                    // Glow effect for completed tasks
                    if task.isCompleted {
                        Circle()
                            .fill(Color(yourCode: "#FFD93D"))
                            .frame(width: 28, height: 28)
                            .blur(radius: 8)
                            .opacity(glowOpacity)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title ?? "Untitled Task")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(task.isCompleted ? 
                                       Color(yourCode: "#FFFACD").opacity(0.7) : 
                                       Color(yourCode: "#FFFFFF"))
                        .strikethrough(task.isCompleted)
                    
                    Spacer()
                    
                    // Priority indicator
                    Circle()
                        .fill(getPriorityColor(task.priority))
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color(yourCode: "#C68C00").opacity(0.6), lineWidth: 1)
                        )
                }
                
                if let goalTag = task.goalTag, !goalTag.isEmpty {
                    Text(goalTag)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#3B4C63").opacity(task.isCompleted ? 0.6 : 0.9),
                            Color(yourCode: "#2C3E50").opacity(task.isCompleted ? 0.4 : 0.7)
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
                                    Color(yourCode: "#FFD93D").opacity(0.3),
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
        .scaleEffect(cardScale)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: task.isCompleted)
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
