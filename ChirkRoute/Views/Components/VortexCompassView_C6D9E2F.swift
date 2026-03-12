import SwiftUI

struct VortexCompassView: View {
    @Binding var progress: Float
    @State private var arrowRotation: Double = 0
    @State private var glowOpacity: Double = 0.3
    @State private var bounceOffset: CGFloat = 0
    
    let rayAnimations: [UUID]
    
    var body: some View {
        ZStack {
            // Compass background circle
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#3B4C63").opacity(0.8),
                            Color(yourCode: "#2C3E50")
                        ]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(yourCode: "#FFD93D").opacity(0.6),
                                    Color(yourCode: "#FFA500").opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
            
            // Progress arc
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#FFD93D"),
                            Color(yourCode: "#FFA500")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 140, height: 140)
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: progress)
            
            // Compass arrow
            VStack {
                // Arrow body
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(yourCode: "#FFD93D"),
                                Color(yourCode: "#E0A800")
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 8, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(yourCode: "#C68C00"), lineWidth: 1)
                    )
                
                // Arrow tip
                Triangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(yourCode: "#FFD93D"),
                                Color(yourCode: "#FFA500")
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 16, height: 20)
                    .overlay(
                        Triangle()
                            .stroke(Color(yourCode: "#C68C00"), lineWidth: 1)
                    )
            }
            .offset(y: bounceOffset)
            .rotationEffect(.degrees(arrowRotation))
            .shadow(color: Color(yourCode: "#C68C00").opacity(0.6), radius: 4, x: 2, y: 2)
            .overlay(
                // Glow effect
                VStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(yourCode: "#FFFACD"))
                        .frame(width: 8, height: 50)
                        .blur(radius: 4)
                        .opacity(glowOpacity)
                    
                    Triangle()
                        .fill(Color(yourCode: "#FFFACD"))
                        .frame(width: 16, height: 20)
                        .blur(radius: 4)
                        .opacity(glowOpacity)
                }
                .offset(y: bounceOffset)
                .rotationEffect(.degrees(arrowRotation))
            )
            
            // Ray animations
            ForEach(rayAnimations, id: \.self) { _ in
                RayBurstView()
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                arrowRotation = Double(newProgress * 360)
                bounceOffset = -10
                glowOpacity = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    bounceOffset = 0
                    glowOpacity = 0.3
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowOpacity = 0.6
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct RayBurstView: View {
    @State private var rayOpacity: Double = 0
    @State private var rayScale: CGFloat = 0.5
    @State private var rayRotation: Double = 0
    
    var body: some View {
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
                    .frame(width: 30, height: 4)
                    .offset(x: 40)
                    .rotationEffect(.degrees(Double(index) * 45 + rayRotation))
            }
        }
        .scaleEffect(rayScale)
        .opacity(rayOpacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                rayOpacity = 1.0
                rayScale = 1.2
                rayRotation = 360
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: 0.4)) {
                    rayOpacity = 0
                    rayScale = 1.5
                }
            }
        }
    }
}
