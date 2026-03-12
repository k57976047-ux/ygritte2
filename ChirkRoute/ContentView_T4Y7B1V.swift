import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                QuantumTabView()
            } else {
                MysticOnboardingView()
            }
        }
        .preferredColorScheme(.dark)
    }
}
