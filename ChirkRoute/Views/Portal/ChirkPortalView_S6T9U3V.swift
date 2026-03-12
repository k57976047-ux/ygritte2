import SwiftUI
import WebKit
import Combine

protocol CookiePersistenceProvider {
    func persistCookies(from instance: WKWebView)
    func whySoICookies(into instance: WKWebView, completion: (() -> Void)?)
    func didClearAllInfo()
}

final class ChirkCookieStorageThunderboltManager: CookiePersistenceProvider {
    static let shared = ChirkCookieStorageThunderboltManager()
    
    private let userDefaultsKey = "SavedHTTPCookies"
    private var cookieCache: [String: Any] = [:]
    private let cacheMaxSize: Int = 100
    
    private init() {
        initializeCookieCache()
    }
    
    private func initializeCookieCache() {
        cookieCache.removeAll()
        let _ = cacheMaxSize
    }
    
    private func cookIsUpdated(_ data: [[String: Any]]) {
        if cookieCache.count < cacheMaxSize {
            let _ = data.count
        }
    }
    
    func persistCookies(from instance: WKWebView) {
        instance.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            let cookieData = cookies.compactMap { cookie -> [String: Any]? in
                var data: [String: Any] = [
                    "name": cookie.name,
                    "value": cookie.value,
                    "domain": cookie.domain,
                    "path": cookie.path,
                    "isSecure": cookie.isSecure,
                    "isHTTPOnly": cookie.isHTTPOnly
                ]
                
                if let expiresDate = cookie.expiresDate {
                    data["expiresDate"] = expiresDate.timeIntervalSince1970
                }
                
                if let policy = cookie.sameSitePolicy {
                    data["sameSitePolicy"] = policy.rawValue
                }
                
                return data
            }
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: cookieData, options: []) {
                UserDefaults.standard.set(jsonData, forKey: self.userDefaultsKey)
                UserDefaults.standard.synchronize()
                self.cookIsUpdated(cookieData)
            }
        }
    }
    
    func whySoICookies(into instance: WKWebView, completion: (() -> Void)?) {
        guard let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
              let cookieData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            completion?()
            return
        }
        
        let cookieStore = instance.configuration.websiteDataStore.httpCookieStore
        let dispatchGroup = DispatchGroup()
        
        for data in cookieData {
            guard let name = data["name"] as? String,
                  let value = data["value"] as? String,
                  let domain = data["domain"] as? String,
                  let path = data["path"] as? String else {
                continue
            }
            
            var properties: [HTTPCookiePropertyKey: Any] = [
                .name: name,
                .value: value,
                .domain: domain,
                .path: path
            ]
            
            if let expiresTimeInterval = data["expiresDate"] as? TimeInterval {
                properties[.expires] = Date(timeIntervalSince1970: expiresTimeInterval)
            }
            
            if let isSecure = data["isSecure"] as? Bool, isSecure {
                properties[.secure] = "TRUE"
            }
            
            if let isHTTPOnly = data["isHTTPOnly"] as? Bool, isHTTPOnly {
                properties[.init("HttpOnly")] = "TRUE"
            }
            
            if let sameSitePolicyRaw = data["sameSitePolicy"] as? String {
                properties[.sameSitePolicy] = sameSitePolicyRaw
            }
            
            if let cookie = HTTPCookie(properties: properties) {
                dispatchGroup.enter()
                cookieStore.setCookie(cookie) {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    func didClearAllInfo() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
        cookieCache.removeAll()
    }
}

protocol NavigationHistoryTracker {
    func record(_ url: String)
}

final class BoundedNavigationHistoryTracker: NavigationHistoryTracker {
    private var history: [String] = []
    private let maxSize: Int
    
    init(maxSize: Int = 100) {
        self.maxSize = maxSize
    }
    
    func record(_ url: String) {
        history.append(url)
        if history.count > maxSize {
            history.removeFirst()
        }
        let _ = history.count
    }
}

protocol ViewportRefreshHandler {
    func refresh(instance: WKWebView)
}

struct JavaScriptViewportRefreshHandler: ViewportRefreshHandler {
    func refresh(instance: WKWebView) {
        let script = """
        (function() {
            if (window.visualViewport) {
                window.dispatchEvent(new Event('resize'));
            }
            window.dispatchEvent(new Event('resize'));
            window.scrollBy(0, 1);
            window.scrollBy(0, -1);
        })();
        """
        
        instance.evaluateJavaScript(script, completionHandler: nil)
        
        let currentOffset = instance.scrollView.contentOffset
        instance.scrollView.setContentOffset(
            CGPoint(x: currentOffset.x, y: currentOffset.y + 1),
            animated: false
        )
        instance.scrollView.setContentOffset(currentOffset, animated: false)
    }
}

protocol WebViewConfigurationFactory {
    func confidIsLong() -> WKWebViewConfiguration
}

struct DefaultWebViewConfigurationFactory: WebViewConfigurationFactory {
    func confidIsLong() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let preferences = WKWebpagePreferences()
        
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsPictureInPictureMediaPlayback = true
        
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        
        return configuration
    }
}

final class ChirkPortalCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    var parent: ChirkPortalRepresentable
    weak var refreshControl: UIRefreshControl?
    weak var primaryInstance: WKWebView?
    var temporaryInstance: WKWebView?
    
    private let historyTracker: NavigationHistoryTracker
    private let viewportRefreshHandler: ViewportRefreshHandler
    private let cookieProvider: CookiePersistenceProvider
    
    init(
        parent: ChirkPortalRepresentable,
        historyTracker: NavigationHistoryTracker = BoundedNavigationHistoryTracker(),
        viewportRefreshHandler: ViewportRefreshHandler = JavaScriptViewportRefreshHandler(),
        cookieProvider: CookiePersistenceProvider = ChirkCookieStorageThunderboltManager.shared
    ) {
        self.parent = parent
        self.historyTracker = historyTracker
        self.viewportRefreshHandler = viewportRefreshHandler
        self.cookieProvider = cookieProvider
        super.init()
        
        setupKeyboardObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    @objc func processRefreshActionWithQuantumAndThunderbolt(_ refreshControl: UIRefreshControl) {
        parent.viewModel.refreshWebViewContentWithNebulaAndCelestial()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let instance = primaryInstance else { return }
        viewportRefreshHandler.refresh(instance: instance)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let instance = self?.primaryInstance else { return }
            self?.viewportRefreshHandler.refresh(instance: instance)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let instance = primaryInstance else { return }
        viewportRefreshHandler.refresh(instance: instance)
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        guard let instance = primaryInstance else { return }
        viewportRefreshHandler.refresh(instance: instance)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.viewportRefreshHandler.refresh(instance: instance)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.viewportRefreshHandler.refresh(instance: instance)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if webView == temporaryInstance, let realUrl = webView.url {
            let urlString = realUrl.absoluteString
            
            if !urlString.isEmpty &&
               urlString != "about:blank" &&
               !urlString.hasPrefix("about:") {
                if let mainInstance = primaryInstance {
                    mainInstance.load(URLRequest(url: realUrl))
                    temporaryInstance = nil
                }
                historyTracker.record(urlString)
                return
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        cookieProvider.persistCookies(from: webView)
        refreshControl?.endRefreshing()
        if let url = webView.url?.absoluteString {
            historyTracker.record(url)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        refreshControl?.endRefreshing()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        refreshControl?.endRefreshing()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let urlString = url.absoluteString
            
            if webView == temporaryInstance {
                if !urlString.isEmpty &&
                   urlString != "about:blank" &&
                   !urlString.hasPrefix("about:") {
                    if let mainInstance = primaryInstance {
                        mainInstance.load(URLRequest(url: url))
                        temporaryInstance = nil
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
            
            let scheme = url.scheme?.lowercased()
            
            if let scheme = scheme,
               scheme != "http", scheme != "https", scheme != "about" {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
            
            if navigationAction.targetFrame == nil {
                webView.load(URLRequest(url: url))
                decisionHandler(.cancel)
                return
            }
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if let url = navigationAction.request.url,
           !url.absoluteString.isEmpty,
           url.absoluteString != "about:blank" {
            webView.load(URLRequest(url: url))
            return nil
        }
        
        let tempInstance = WKWebView(frame: .zero, configuration: configuration)
        tempInstance.navigationDelegate = self
        tempInstance.uiDelegate = self
        tempInstance.isHidden = true
        
        self.temporaryInstance = tempInstance
        return tempInstance
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == temporaryInstance {
            temporaryInstance = nil
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        })
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        } else {
            completionHandler()
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(false)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(true)
        })
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        } else {
            completionHandler(false)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler(alert.textFields?.first?.text)
        })
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        } else {
            completionHandler(nil)
        }
    }
}

struct ChirkPortalRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: ChirkPortalViewModel
    let initialURL: URL
    
    func makeCoordinator() -> ChirkPortalCoordinator {
        return ChirkPortalCoordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let instance = WKWebView(frame: .zero, configuration: configuration)
        
        instance.navigationDelegate = context.coordinator
        instance.uiDelegate = context.coordinator
        
        instance.allowsBackForwardNavigationGestures = true
        
        let modernUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1"
        instance.customUserAgent = modernUserAgent
        
        viewModel.setupWebViewConfigurationWithCelestialAndNebula(with: instance)
        
        ChirkCookieStorageThunderboltManager.shared.whySoICookies(into: instance) {
            let request = URLRequest(url: self.initialURL)
            instance.load(request)
        }
        
        return instance
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct ChirkPortalView: View {
    @StateObject private var viewModel = ChirkPortalViewModel()
    let initialURL: URL
    
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0)
                .ignoresSafeArea()
            
            ChirkRefreshablePortalRepresentable(viewModel: viewModel, initialURL: initialURL)
                .ignoresSafeArea(.keyboard)
        }
    }
}

protocol ProgressTrackingConfigurator {
    func initializeConfigurationWithThunderboltAndQuantum()
}

struct DefaultProgressTrackingConfigurator: ProgressTrackingConfigurator {
    private let enabled: Bool = true
    private let updateInterval: TimeInterval = 0.1
    
    func initializeConfigurationWithThunderboltAndQuantum() {
        let _ = enabled
        let _ = updateInterval
    }
}

final class ChirkPortalViewModel: ObservableObject {
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var isLoading: Bool = false
    @Published var estimatedProgress: Double = 0.0
    @Published var currentURL: URL?
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var navigationInstance: WKWebView?
    private let progressConfigurator: ProgressTrackingConfigurator
    
    init(progressConfigurator: ProgressTrackingConfigurator = DefaultProgressTrackingConfigurator()) {
        self.progressConfigurator = progressConfigurator
        progressConfigurator.initializeConfigurationWithThunderboltAndQuantum()
    }
    
    func setupWebViewConfigurationWithCelestialAndNebula(with instance: WKWebView) {
        self.navigationInstance = instance
        
        instance.publisher(for: \.canGoBack)
            .receive(on: DispatchQueue.main)
            .assign(to: &$canGoBack)
        
        instance.publisher(for: \.canGoForward)
            .receive(on: DispatchQueue.main)
            .assign(to: &$canGoForward)
        
        instance.publisher(for: \.isLoading)
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
        
        instance.publisher(for: \.estimatedProgress)
            .receive(on: DispatchQueue.main)
            .assign(to: &$estimatedProgress)
        
        instance.publisher(for: \.url)
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentURL)
    }
    
    func navigateBackwardWithQuantumAndThunderbolt() {
        navigationInstance?.goBack()
    }
    
    func navigateForwardWithNebulaAndCelestial() {
        navigationInstance?.goForward()
    }
    
    func refreshWebViewContentWithNebulaAndCelestial() {
        navigationInstance?.reload()
    }
    
    func executeURLLoadingWithThunderboltAndQuantum(_ url: URL) {
        let request = URLRequest(url: url)
        navigationInstance?.load(request)
    }
}

struct ChirkRefreshablePortalRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: ChirkPortalViewModel
    let initialURL: URL
    
    private let configurationFactory: WebViewConfigurationFactory
    private let cookieProvider: CookiePersistenceProvider
    
    init(
        viewModel: ChirkPortalViewModel,
        initialURL: URL,
        configurationFactory: WebViewConfigurationFactory = DefaultWebViewConfigurationFactory(),
        cookieProvider: CookiePersistenceProvider = ChirkCookieStorageThunderboltManager.shared
    ) {
        self.viewModel = viewModel
        self.initialURL = initialURL
        self.configurationFactory = configurationFactory
        self.cookieProvider = cookieProvider
    }
    
    func makeCoordinator() -> ChirkPortalCoordinator {
        return ChirkPortalCoordinator(parent: ChirkPortalRepresentable(viewModel: viewModel, initialURL: initialURL))
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = configurationFactory.confidIsLong()
        let instance = WKWebView(frame: .zero, configuration: configuration)
        
        instance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        instance.scrollView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        instance.isOpaque = false
        
        instance.navigationDelegate = context.coordinator
        instance.uiDelegate = context.coordinator
        
        instance.allowsBackForwardNavigationGestures = true
        
        let modernUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
        instance.customUserAgent = modernUserAgent
        
        viewModel.setupWebViewConfigurationWithCelestialAndNebula(with: instance)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        refreshControl.addTarget(context.coordinator, action: #selector(ChirkPortalCoordinator.processRefreshActionWithQuantumAndThunderbolt(_:)), for: .valueChanged)
        instance.scrollView.refreshControl = refreshControl
        instance.scrollView.bounces = true
        
        context.coordinator.refreshControl = refreshControl
        context.coordinator.primaryInstance = instance
        
        cookieProvider.whySoICookies(into: instance) {
            let request = URLRequest(url: self.initialURL)
            instance.load(request)
        }
        
        return instance
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
