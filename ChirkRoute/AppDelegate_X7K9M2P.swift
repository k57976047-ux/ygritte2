import Foundation
import UIKit
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
                
        AppsFlyerThunderboltManager.shared.start() { _ in

        }
        return true
    }
}

class AppsFlyerThunderboltManager: NSObject, AppsFlyerLibDelegate {
    private var currentDefaultURL: String?
    private(set) var trackingAuthorizationStatus: ATTrackingManager.AuthorizationStatus = .notDetermined
    private var trackingCompletion: ((ATTrackingManager.AuthorizationStatus) -> Void)?
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("LOG: \(conversionInfo)")
        if let url = currentDefaultURL {
            print("LOG: \(url)")
        }
    }
    
    func onConversionDataFail(_ error: any Error) {}
    
    static let shared = AppsFlyerThunderboltManager()
    
    private override init() {
        super.init()
        setupAppsFlyer()
    }
    
    func setCurrentDefaultURL(_ url: String?) {
        currentDefaultURL = url
    }
    
    private func setupAppsFlyer() {
        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = "qx4GrMep5uQygtSnxmVd8f"
        appsFlyer.appleAppID = "6755323559"
        appsFlyer.waitForATTUserAuthorization(timeoutInterval: 60)
        appsFlyer.delegate = self
    }
    
    func start(completion: ((ATTrackingManager.AuthorizationStatus) -> Void)? = nil) {
        trackingCompletion = completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                guard let self = self else { return }
                self.trackingAuthorizationStatus = status
                AppsFlyerLib.shared().start()
                self.trackingCompletion?(status)
                self.trackingCompletion = nil
            }
        }
    }
    
    func waitForTrackingAuthorization() async -> ATTrackingManager.AuthorizationStatus {
        if trackingAuthorizationStatus != .notDetermined {
            return trackingAuthorizationStatus
        }
        
        return await withCheckedContinuation { continuation in
            if trackingAuthorizationStatus != .notDetermined {
                continuation.resume(returning: trackingAuthorizationStatus)
            } else {
                trackingCompletion = { status in
                    continuation.resume(returning: status)
                }
            }
        }
    }
    
    func logEvent() {
        AppsFlyerLib.shared().logEvent("myTestEvent", withValues: nil)
    }
    
    func logEventWithParams(params: [String: Any]) {
        AppsFlyerLib.shared().logEvent("myTestEvent", withValues: params)
    }
    
    func getAppsFlyerUID() -> String? {
        return AppsFlyerLib.shared().getAppsFlyerUID()
    }
    
    func getAdvertisingIdentifier() -> String? {
        let trackingStatus = ATTrackingManager.trackingAuthorizationStatus
        print("LOG: trackingAuthorizationStatus = \(trackingStatus.rawValue)")
        
        if trackingStatus == .authorized {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("LOG: IDFA from ASIdentifierManager = \(idfa)")
            return idfa
        }
        
        let appsFlyerIdfa = AppsFlyerLib.shared().advertisingIdentifier
        print("LOG: IDFA from AppsFlyer = \(appsFlyerIdfa ?? "nil")")
        return appsFlyerIdfa
    }
}

