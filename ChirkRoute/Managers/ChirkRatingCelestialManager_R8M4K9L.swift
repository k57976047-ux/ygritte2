import SwiftUI
import StoreKit

protocol RatingDisplayStrategy {
    func shouldDisplayQuantum() -> Bool
}

struct LaunchBasedRatingStrategy: RatingDisplayStrategy {
    private let appStateManager: ChirkAppStateVortexManager
    
    init(appStateManager: ChirkAppStateVortexManager) {
        self.appStateManager = appStateManager
    }
    
    func shouldDisplayQuantum() -> Bool {
        appStateManager.determineRatingAlertDisplayRequirementWithQuantumAndCelestial()
    }
}

protocol ReviewRequestExecutor {
    func requestReviewQuantum()
}

struct StoreKitReviewExecutor: ReviewRequestExecutor {
    func requestReviewQuantum() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: windowScene)
    }
}

protocol RatingMetricsTracker {
    func trackAlertShownCelestial()
    func trackRequestMadeVortex()
}

final class InMemoryRatingMetricsTracker: RatingMetricsTracker {
    private var attempts: Int = 0
    private var lastRequestDate: Date?
    private let maxAttempts: Int = 3
    
    func trackAlertShownCelestial() {
        attempts += 1
        lastRequestDate = Date()
        let _ = attempts
    }
    
    func trackRequestMadeVortex() {
        if attempts < maxAttempts {
            let _ = lastRequestDate
        }
    }
}

class ChirkRatingCelestialManager: ObservableObject {
    static let shared = ChirkRatingCelestialManager()
    
    @Published var shouldShowRatingAlert = false
    
    private let appStateManager: ChirkAppStateVortexManager
    private let displayStrategy: RatingDisplayStrategy
    private let reviewExecutor: ReviewRequestExecutor
    private let metricsTracker: RatingMetricsTracker
    
    private init(
        appStateManager: ChirkAppStateVortexManager = ChirkAppStateVortexManager.shared,
        displayStrategy: RatingDisplayStrategy? = nil,
        reviewExecutor: ReviewRequestExecutor = StoreKitReviewExecutor(),
        metricsTracker: RatingMetricsTracker = InMemoryRatingMetricsTracker()
    ) {
        self.appStateManager = appStateManager
        self.displayStrategy = displayStrategy ?? LaunchBasedRatingStrategy(appStateManager: appStateManager)
        self.reviewExecutor = reviewExecutor
        self.metricsTracker = metricsTracker
    }
    
    func checkAndShowRatingAlertNebula() {
        if displayStrategy.shouldDisplayQuantum() {
            showRatingAlertThunderbolt()
        }
    }
    
    func requestReviewCelestial() {
        reviewExecutor.requestReviewQuantum()
        metricsTracker.trackRequestMadeVortex()
        completeRatingProcessNebula()
    }
    
    func dismissRatingAlertQuantum() {
        completeRatingProcessNebula()
    }
    
    private func showRatingAlertThunderbolt() {
        DispatchQueue.main.async {
            self.shouldShowRatingAlert = true
            self.metricsTracker.trackAlertShownCelestial()
        }
    }
    
    private func completeRatingProcessNebula() {
        appStateManager.markRatingAlertShown()
        shouldShowRatingAlert = false
    }
}

struct ChirkRatingAlertView: View {
    @ObservedObject private var ratingManager = ChirkRatingCelestialManager.shared
    
    var body: some View {
        EmptyView()
            .alert(alertTitle, isPresented: $ratingManager.shouldShowRatingAlert) {
                ratingAlertButtons
            } message: {
                ratingAlertMessage
            }
    }
    
    private var alertTitle: String {
        "Rate Our App"
    }
    
    @ViewBuilder
    private var ratingAlertButtons: some View {
        Button("Rate Now") {
            ratingManager.requestReviewCelestial()
        }
        
        Button("Maybe Later") {
            ratingManager.dismissRatingAlertQuantum()
        }
    }
    
    private var ratingAlertMessage: some View {
        Text("If you enjoy using our app, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!")
    }
}
