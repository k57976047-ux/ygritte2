import SwiftUI

struct MysticOnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    let pages = [
        OnboardingPage(
            title: "Welcome to ChirkRoute",
            subtitle: "Plan your day, track your progress, and reach your goals",
            imageName: "location.north.circle.fill",
            description: "Your personal compass to navigate through daily tasks and achieve success"
        ),
        OnboardingPage(
            title: "Compass Navigation",
            subtitle: "Watch your progress come alive",
            imageName: "location.north.line",
            description: "Each completed task moves your arrow closer to the goal with beautiful animations"
        ),
        OnboardingPage(
            title: "Collect Progress Rays",
            subtitle: "Gamified task completion",
            imageName: "rays",
            description: "Complete tasks to collect rays of progress and build momentum for success"
        ),
        OnboardingPage(
            title: "Start Your Journey",
            subtitle: "Ready to transform your productivity?",
            imageName: "star.fill",
            description: "Begin planning your tasks and watch your daily compass guide you to achievement"
        )
    ]
    
    var body: some View {
        if showMainApp {
            QuantumTabView()
                .transition(.opacity.combined(with: .scale))
        } else {
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
                        // Page content
                        TabView(selection: $currentPage) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                OnboardingPageView(page: pages[index])
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .animation(.easeInOut, value: currentPage)
                        
                        // Bottom section
                        VStack(spacing: 24) {
                            // Page indicators
                            HStack(spacing: 8) {
                                ForEach(0..<pages.count, id: \.self) { index in
                                    Circle()
                                        .fill(currentPage == index ? 
                                              Color(yourCode: "#FFD93D") : 
                                              Color(yourCode: "#FFFACD").opacity(0.3))
                                        .frame(width: currentPage == index ? 12 : 8, 
                                               height: currentPage == index ? 12 : 8)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
                                }
                            }
                            
                            // Navigation buttons
                            HStack(spacing: 16) {
                                if currentPage > 0 {
                                    Button("Back") {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            currentPage -= 1
                                        }
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
                                } else {
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                Button(currentPage == pages.count - 1 ? "Start Journey" : "Next") {
                                    if currentPage == pages.count - 1 {
                                        hasSeenOnboarding = true
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            showMainApp = true
                                        }
                                    } else {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            currentPage += 1
                                        }
                                    }
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
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    @State private var imageScale: CGFloat = 0.8
    @State private var imageOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 50
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Image/Icon
            VStack(spacing: 20) {
                if page.imageName == "rays" {
                    // Custom rays animation for the gamification page
                    ZStack {
                        ForEach(0..<8, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(yourCode: "#FFD93D"),
                                            Color(yourCode: "#FFA500").opacity(0.3)
                                        ]),
                                        startPoint: .center,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 40, height: 4)
                                .offset(x: 50)
                                .rotationEffect(.degrees(Double(index) * 45))
                        }
                    }
                    .scaleEffect(imageScale)
                    .opacity(imageOpacity)
                } else {
                    Image(systemName: page.imageName)
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(Color(yourCode: "#FFD93D"))
                        .scaleEffect(imageScale)
                        .opacity(imageOpacity)
                }
            }
            .frame(height: 120)
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(yourCode: "#FFFFFF"))
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color(yourCode: "#FFD93D"))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color(yourCode: "#FFFACD").opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineLimit(nil)
            }
            .offset(y: textOffset)
            .opacity(textOpacity)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                imageScale = 1.0
                imageOpacity = 1.0
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
                textOffset = 0
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    MysticOnboardingView()
}
