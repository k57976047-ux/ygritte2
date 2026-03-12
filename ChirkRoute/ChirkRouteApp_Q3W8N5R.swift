import SwiftUI

@main
struct ChirkRouteApp: App {
    @StateObject private var coreDataStack = PersistenceQuantumController.shared
    @StateObject private var appStateManager = ChirkAppStateVortexManager.shared
    @StateObject private var ratingManager = ChirkRatingCelestialManager.shared
    @State private var isInitialLoading = true
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                mainContentView
                ChirkRatingAlertView()
            }
        }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        if isInitialLoading {
            loadingView
        } else {
            appContentView
        }
    }
    
    private var loadingView: some View {
        ChirkLoadingView()
            .onAppear {
                firrtskjhasldkjhaAppear()
            }
    }
    
    @ViewBuilder
    private var appContentView: some View {
        if appStateManager.shouldShowContainerView {
            portalContentView
        } else {
            mainMenuContent
        }
    }
    
    @ViewBuilder
    private var portalContentView: some View {
        if let urlString = appStateManager.savedResourceURL,
           let url = URL(string: urlString) {
            ChirkPortalView(initialURL: url)
                .onAppear {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.forEach { window in
                            window.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                        }
                    }
                    managePortalViewAppearanceWithCelestialAndNebula()
                }
        } 
    }
    
    private var mainMenuContent: some View {
        ChirkMainMenuView()
            .environment(\.managedObjectContext, coreDataStack.container.viewContext)
            .onAppear {
                appStateManager.markHjhasgdlkaOpened()
            }
    }
    
    private func firrtskjhasldkjhaAppear() {
        _Concurrency.Task {
            _ = await AppsFlyerThunderboltManager.shared.waitForTrackingAuthorization()
            await appStateManager.determineAppFlowQuantum()
            await executeLoadingCompletionSchedulingWithThunderboltAndQuantum()
        }
    }
    
    private func executeLoadingCompletionSchedulingWithThunderboltAndQuantum() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isInitialLoading = false
            }
        }
    }
    
    private func managePortalViewAppearanceWithCelestialAndNebula() {
        appStateManager.markUaghsdIUUyasdOpened()
        appStateManager.isLkjhViewOpened()
        ratingManager.checkAndShowRatingAlertNebula()
    }
}
