import SwiftUI

struct EtherealAboutView: View {
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
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 8) {
                            Text("About ChirkRoute")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            Text("Your Daily Compass to Success")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                        }
                        .padding(.top, 20)
                        
                        // App Icon & Version
                        VStack(spacing: 20) {
                            // App Icon Placeholder
                            ZStack {
                                Circle()
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
                                    .frame(width: 120, height: 120)
                                    .shadow(color: Color(yourCode: "#C68C00").opacity(0.4), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "location.north.circle.fill")
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(Color(yourCode: "#2C3E50"))
                            }
                            
                            VStack(spacing: 8) {
                                Text("ChirkRoute")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFFFFF"))
                                
                                Text("Version 1.0.0")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
                            }
                        }
                        
                        // Description
                        VStack(spacing: 16) {
                            Text("Transform your daily productivity with an engaging compass-guided task management experience.")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                            
                            Text("Plan your tasks, watch your progress come alive with beautiful animations, and achieve your goals with gamified completion rewards.")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                        .padding(.horizontal, 32)
                        
                        // Features
                        VStack(spacing: 20) {
                            Text("Features")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFFFF"))
                            
                            VStack(spacing: 16) {
                                FeatureRow(
                                    icon: "location.north.circle.fill",
                                    title: "Animated Compass",
                                    description: "Watch your progress move the compass arrow"
                                )
                                
                                FeatureRow(
                                    icon: "sparkles",
                                    title: "Gamified Experience",
                                    description: "Collect rays of progress with each completed task"
                                )
                                
                                FeatureRow(
                                    icon: "chart.line.uptrend.xyaxis",
                                    title: "Progress Tracking",
                                    description: "Visualize your daily and weekly achievements"
                                )
                                
                                FeatureRow(
                                    icon: "clock.arrow.circlepath",
                                    title: "History Review",
                                    description: "Look back at your completed journeys"
                                )
                                
                                FeatureRow(
                                    icon: "iphone",
                                    title: "Local Storage",
                                    description: "All your data stays private on your device"
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        
                        // Footer
                        VStack(spacing: 8) {
                            Text("Made with ❤️ for productivity enthusiasts")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                                .multilineTextAlignment(.center)
                            
                            Text("© 2024 ChirkRoute")
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.6))
                        }
                        .padding(.bottom, 40)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(Color(yourCode: "#FFD93D"))
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(yourCode: "#FFFFFF"))
                
                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(yourCode: "#3B4C63").opacity(0.4))
        )
    }
}


#Preview {
    EtherealAboutView()
}
