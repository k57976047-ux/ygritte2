import SwiftUI

struct CelestialProgressView: View {
    @StateObject private var viewModel = NebulProgressViewModel()
    
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
                            Text("Progress Overview")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            Text("Track Your Journey")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                        }
                        .padding(.top, 20)
                        
                        // Weekly Progress Circle
                        VStack(spacing: 16) {
                            Text("This Week")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            ZStack {
                                // Background circle
                                Circle()
                                    .stroke(Color(yourCode: "#3B4C63"), lineWidth: 12)
                                    .frame(width: 160, height: 160)
                                
                                // Progress circle
                                Circle()
                                    .trim(from: 0, to: CGFloat(viewModel.currentWeekProgress))
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(yourCode: "#FFD93D"),
                                                Color(yourCode: "#FFA500")
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.spring(response: 1.0, dampingFraction: 0.8), value: viewModel.currentWeekProgress)
                                
                                // Center content
                                VStack(spacing: 4) {
                                    Text("\(Int(viewModel.currentWeekProgress * 100))%")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(yourCode: "#FFD93D"))
                                    
                                    Text("Complete")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                                }
                            }
                            
                            // Week stats
                            HStack(spacing: 30) {
                                VStack {
                                    Text("\(viewModel.completedWeeklyTasks)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
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
                                    Text("\(viewModel.totalWeeklyTasks)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
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
                        }
                        
                        // Daily Progress Chart
                        VStack(spacing: 16) {
                            Text("Daily Breakdown")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            HStack(alignment: .bottom, spacing: 12) {
                                ForEach(viewModel.weeklyProgress) { dayData in
                                    VStack(spacing: 8) {
                                        // Bar
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        viewModel.getProgressColor(for: dayData.progress),
                                                        viewModel.getProgressColor(for: dayData.progress).opacity(0.7)
                                                    ]),
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(width: 32, height: max(8, CGFloat(dayData.progress) * 80))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Color(yourCode: "#C68C00").opacity(0.4), lineWidth: 1)
                                            )
                                            .animation(.spring(response: 0.8, dampingFraction: 0.7), value: dayData.progress)
                                        
                                        // Day label
                                        Text(dayData.dayName)
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                                        
                                        // Task count
                                        Text("\(dayData.completedTasks)/\(dayData.totalTasks)")
                                            .font(.system(size: 10, weight: .regular, design: .rounded))
                                            .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.6))
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(yourCode: "#3B4C63").opacity(0.6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(yourCode: "#FFD93D").opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Achievement Section
                        VStack(spacing: 16) {
                            Text("Achievements")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                                // Perfect Day Achievement
                                AchievementCard(
                                    title: "Perfect Day",
                                    description: "Complete all tasks",
                                    icon: "star.fill",
                                    isUnlocked: viewModel.weeklyProgress.contains { $0.progress >= 1.0 },
                                    progress: viewModel.weeklyProgress.filter { $0.progress >= 1.0 }.count
                                )
                                
                                // Consistency Achievement
                                AchievementCard(
                                    title: "Consistent",
                                    description: "7 days streak",
                                    icon: "flame.fill",
                                    isUnlocked: viewModel.weeklyProgress.allSatisfy { $0.totalTasks > 0 },
                                    progress: viewModel.weeklyProgress.filter { $0.totalTasks > 0 }.count
                                )
                                
                                // Productive Week
                                AchievementCard(
                                    title: "Productive",
                                    description: "20+ tasks done",
                                    icon: "bolt.fill",
                                    isUnlocked: viewModel.completedWeeklyTasks >= 20,
                                    progress: viewModel.completedWeeklyTasks
                                )
                                
                                // Goal Setter
                                AchievementCard(
                                    title: "Goal Setter",
                                    description: "Plan every day",
                                    icon: "scope",
                                    isUnlocked: viewModel.weeklyProgress.filter { $0.totalTasks > 0 }.count >= 5,
                                    progress: viewModel.weeklyProgress.filter { $0.totalTasks > 0 }.count
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadWeeklyProgress()
        }
    }
}

struct AchievementCard: View {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let progress: Int
    
    @State private var glowOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isUnlocked ? Color(yourCode: "#FFD93D") : Color(yourCode: "#3B4C63"))
                .scaleEffect(isUnlocked ? 1.2 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isUnlocked)
                .frame(height: 30)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(isUnlocked ? Color(yourCode: "#FFFFFF") : Color(yourCode: "#FFFACD").opacity(0.6))
                    .lineLimit(1)
                
                Text(description)
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 32)
                
                if !isUnlocked && progress > 0 {
                    Text("\(progress)")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color(yourCode: "#FFA500"))
                } else {
                    Text(" ")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                }
            }
            .frame(height: 60)
        }
        .frame(width: 140, height: 120)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#3B4C63").opacity(isUnlocked ? 0.9 : 0.6),
                            Color(yourCode: "#2C3E50").opacity(isUnlocked ? 0.7 : 0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isUnlocked ? 
                            Color(yourCode: "#FFD93D").opacity(0.6) : 
                            Color(yourCode: "#FFD93D").opacity(0.2),
                            lineWidth: isUnlocked ? 2 : 1
                        )
                )
                .overlay(
                    // Glow effect for unlocked achievements
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(yourCode: "#FFD93D"))
                        .blur(radius: 8)
                        .opacity(isUnlocked ? glowOpacity : 0)
                )
        )
        .onAppear {
            if isUnlocked {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    glowOpacity = 0.3
                }
            }
        }
    }
}
