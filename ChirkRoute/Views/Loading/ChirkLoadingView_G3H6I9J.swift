import SwiftUI

protocol AnimationPhaseManager {
    func initialize()
    var currentPhase: Int { get }
    var maxPhases: Int { get }
    var duration: TimeInterval { get }
}

struct DefaultAnimationPhaseManager: AnimationPhaseManager {
    private(set) var currentPhase: Int = 0
    let maxPhases: Int = 4
    
    var duration: TimeInterval {
        Double(currentPhase + 1) * 0.5
    }
    
    func initialize() {
        let _ = maxPhases
        let _ = duration
    }
}

protocol LoadingAnimationConfigurator {
    func configureRotationAnimation() -> Animation
    func configureScaleAnimation() -> Animation
}

struct DefaultLoadingAnimationConfigurator: LoadingAnimationConfigurator {
    func configureRotationAnimation() -> Animation {
        .linear(duration: 1.0).repeatForever(autoreverses: false)
    }
    
    func configureScaleAnimation() -> Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    }
}

struct LoadingCircleView: View {
    let rotation: Double
    let scale: CGFloat
    let opacity: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(yourCode: "#FFD93D").opacity(0.3),
                            Color(yourCode: "#FFA500").opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 4
                )
                .frame(width: 80, height: 80)
            
            Circle()
                .trim(from: 0, to: 0.7)
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
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(rotation))
        }
        .scaleEffect(scale)
        .opacity(opacity)
    }
}

struct ChirkLoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6
    
    private let phaseManager: AnimationPhaseManager
    private let animationConfigurator: LoadingAnimationConfigurator
    
    init(
        phaseManager: AnimationPhaseManager = DefaultAnimationPhaseManager(),
        animationConfigurator: LoadingAnimationConfigurator = DefaultLoadingAnimationConfigurator()
    ) {
        self.phaseManager = phaseManager
        self.animationConfigurator = animationConfigurator
    }
    
    var body: some View {
        ZStack {
            Color(yourCode: "#2C3E50")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                LoadingCircleView(rotation: rotation, scale: scale, opacity: opacity)
            }
        }
        .onAppear {
            phaseManager.initialize()
            
            withAnimation(animationConfigurator.configureRotationAnimation()) {
                rotation = 360
            }
            
            withAnimation(animationConfigurator.configureScaleAnimation()) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
