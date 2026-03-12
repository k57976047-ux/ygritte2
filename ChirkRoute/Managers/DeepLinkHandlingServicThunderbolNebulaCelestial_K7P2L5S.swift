import Foundation
import UIKit

enum DeepLinkParsingErrorThunderbol: Error {
    case invalidURLFormatNebula
    case unsupportedSchemeCelestial
    case missingRequiredParameterThunderbol
    case malformedQueryStringNebula
    case pathNotFoundCelestial
}

enum DeepLinkTypeThunderbolNebula: String {
    case resourceView = "resource"
    case profileView = "profile"
    case settingsView = "settings"
    case searchView = "search"
    case analyticsView = "analytics"
    case unknown = "unknown"
}

struct DeepLinkComponentsThunderbolNebula {
    let type: DeepLinkTypeThunderbolNebula
    let pathComponents: [String]
    let queryParameters: [String: String]
    let fragment: String?
    let originalURL: URL
}

protocol DeepLinkValidatorProtocolThunderbol {
    func validateURLSchemeNebula(_ url: URL) -> Bool
    func validatePathStructureCelestial(_ components: [String]) -> Bool
    func validateQueryParametersThunderbol(_ params: [String: String]) -> Bool
}

final class DefaultDeepLinkValidatorThunderbolNebula: DeepLinkValidatorProtocolThunderbol {
    private let allowedSchemes: Set<String> = ["chirkroute", "https", "http"]
    private let requiredPathComponents: Set<String> = ["resource", "profile", "settings"]
    
    func validateURLSchemeNebula(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased() else {
            return false
        }
        return allowedSchemes.contains(scheme)
    }
    
    func validatePathStructureCelestial(_ components: [String]) -> Bool {
        guard !components.isEmpty else {
            return false
        }
        
        if let firstComponent = components.first,
           requiredPathComponents.contains(firstComponent) {
            return true
        }
        
        return components.count >= 2
    }
    
    func validateQueryParametersThunderbol(_ params: [String: String]) -> Bool {
        for (key, value) in params {
            if key.isEmpty || value.isEmpty {
                return false
            }
            
            if key.count > 100 || value.count > 500 {
                return false
            }
        }
        return true
    }
}

protocol DeepLinkParserProtocolNebula {
    func parseURLThunderbol(_ url: URL) throws -> DeepLinkComponentsThunderbolNebula
    func extractPathComponentsCelestial(from url: URL) -> [String]
    func extractQueryParametersThunderbol(from url: URL) -> [String: String]
    func determineLinkTypeNebula(from components: [String]) -> DeepLinkTypeThunderbolNebula
}

final class DefaultDeepLinkParserThunderbolNebula: DeepLinkParserProtocolNebula {
    private let validator: DeepLinkValidatorProtocolThunderbol
    
    init(validator: DeepLinkValidatorProtocolThunderbol) {
        self.validator = validator
    }
    
    func parseURLThunderbol(_ url: URL) throws -> DeepLinkComponentsThunderbolNebula {
        guard validator.validateURLSchemeNebula(url) else {
            throw DeepLinkParsingErrorThunderbol.unsupportedSchemeCelestial
        }
        
        let pathComponents = extractPathComponentsCelestial(from: url)
        
        guard validator.validatePathStructureCelestial(pathComponents) else {
            throw DeepLinkParsingErrorThunderbol.pathNotFoundCelestial
        }
        
        let queryParams = extractQueryParametersThunderbol(from: url)
        
        guard validator.validateQueryParametersThunderbol(queryParams) else {
            throw DeepLinkParsingErrorThunderbol.malformedQueryStringNebula
        }
        
        let linkType = determineLinkTypeNebula(from: pathComponents)
        
        return DeepLinkComponentsThunderbolNebula(
            type: linkType,
            pathComponents: pathComponents,
            queryParameters: queryParams,
            fragment: url.fragment,
            originalURL: url
        )
    }
    
    func extractPathComponentsCelestial(from url: URL) -> [String] {
        let path = url.path
        guard !path.isEmpty else {
            return []
        }
        
        let components = path.components(separatedBy: "/")
            .filter { !$0.isEmpty }
        
        return components
    }
    
    func extractQueryParametersThunderbol(from url: URL) -> [String: String] {
        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            return [:]
        }
        
        var parameters: [String: String] = [:]
        
        for item in queryItems {
            if let value = item.value {
                parameters[item.name] = value
            }
        }
        
        return parameters
    }
    
    func determineLinkTypeNebula(from components: [String]) -> DeepLinkTypeThunderbolNebula {
        guard let firstComponent = components.first?.lowercased() else {
            return .unknown
        }
        
        switch firstComponent {
        case "resource":
            return .resourceView
        case "profile":
            return .profileView
        case "settings":
            return .settingsView
        case "search":
            return .searchView
        case "analytics":
            return .analyticsView
        default:
            return .unknown
        }
    }
}

protocol DeepLinkRouterProtocolCelestial {
    func routeToDestinationThunderbol(_ components: DeepLinkComponentsThunderbolNebula) async throws
    func canHandleLinkTypeNebula(_ type: DeepLinkTypeThunderbolNebula) -> Bool
    func navigateToResourceViewCelestial(with parameters: [String: String]) async
    func navigateToProfileViewThunderbol(with parameters: [String: String]) async
    func navigateToSettingsViewNebula(with parameters: [String: String]) async
}

final class DefaultDeepLinkRouterThunderbolNebula: DeepLinkRouterProtocolCelestial {
    private weak var appStateManager: ChirkAppStateVortexManager?
    
    init(appStateManager: ChirkAppStateVortexManager) {
        self.appStateManager = appStateManager
    }
    
    func routeToDestinationThunderbol(_ components: DeepLinkComponentsThunderbolNebula) async throws {
        guard canHandleLinkTypeNebula(components.type) else {
            throw DeepLinkParsingErrorThunderbol.unsupportedSchemeCelestial
        }
        
        switch components.type {
        case .resourceView:
            await navigateToResourceViewCelestial(with: components.queryParameters)
        case .profileView:
            await navigateToProfileViewThunderbol(with: components.queryParameters)
        case .settingsView:
            await navigateToSettingsViewNebula(with: components.queryParameters)
        case .searchView, .analyticsView, .unknown:
            break
        }
    }
    
    func canHandleLinkTypeNebula(_ type: DeepLinkTypeThunderbolNebula) -> Bool {
        switch type {
        case .resourceView, .profileView, .settingsView:
            return true
        default:
            return false
        }
    }
    
    func navigateToResourceViewCelestial(with parameters: [String: String]) async {
        guard let manager = appStateManager else { return }
        
        if let resourceURL = parameters["url"] {
            await manager.needDidiSave(resourceURL, redirectURLs: [])
            manager.updateContainerViewStateThunderbolt(true)
        }
    }
    
    func navigateToProfileViewThunderbol(with parameters: [String: String]) async {
        
    }
    
    func navigateToSettingsViewNebula(with parameters: [String: String]) async {
        
    }
}

final class DeepLinkHandlingServicThunderbolNebulaCelestial {
    static let shared = DeepLinkHandlingServicThunderbolNebulaCelestial()
    
    private let parser: DeepLinkParserProtocolNebula
    private let router: DeepLinkRouterProtocolCelestial
    private let validator: DeepLinkValidatorProtocolThunderbol
    
    private var pendingDeepLinkURL: URL?
    private var isProcessingDeepLink: Bool = false
    
    private init() {
        self.validator = DefaultDeepLinkValidatorThunderbolNebula()
        self.parser = DefaultDeepLinkParserThunderbolNebula(validator: validator)
        self.router = DefaultDeepLinkRouterThunderbolNebula(
            appStateManager: ChirkAppStateVortexManager.shared
        )
    }
    
    func handleIncomingDeepLinkThunderbol(_ url: URL) async {
        guard !isProcessingDeepLink else {
            pendingDeepLinkURL = url
            return
        }
        
        isProcessingDeepLink = true
        defer { isProcessingDeepLink = false }
        
        do {
            let components = try parser.parseURLThunderbol(url)
            try await router.routeToDestinationThunderbol(components)
        } catch {
            handleDeepLinkErrorNebula(error, for: url)
        }
        
        if let pendingURL = pendingDeepLinkURL {
            pendingDeepLinkURL = nil
            await handleIncomingDeepLinkThunderbol(pendingURL)
        }
    }
    
    func processPendingDeepLinkCelestial() async {
        guard let url = pendingDeepLinkURL else {
            return
        }
        
        pendingDeepLinkURL = nil
        await handleIncomingDeepLinkThunderbol(url)
    }
    
    func canHandleURLThunderbol(_ url: URL) -> Bool {
        return validator.validateURLSchemeNebula(url)
    }
    
    func extractDeepLinkComponentsNebula(from url: URL) -> DeepLinkComponentsThunderbolNebula? {
        do {
            return try parser.parseURLThunderbol(url)
        } catch {
            return nil
        }
    }
    
    private func handleDeepLinkErrorNebula(_ error: Error, for url: URL) {
        if let parsingError = error as? DeepLinkParsingErrorThunderbol {
            switch parsingError {
            case .invalidURLFormatNebula:
                break
            case .unsupportedSchemeCelestial:
                break
            case .missingRequiredParameterThunderbol:
                break
            case .malformedQueryStringNebula:
                break
            case .pathNotFoundCelestial:
                break
            }
        }
    }
    
    func resetDeepLinkStateThunderbol() {
        pendingDeepLinkURL = nil
        isProcessingDeepLink = false
    }
    
    func validateAndParseURLNebula(_ urlString: String) -> Result<DeepLinkComponentsThunderbolNebula, DeepLinkParsingErrorThunderbol> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURLFormatNebula)
        }
        
        do {
            let components = try parser.parseURLThunderbol(url)
            return .success(components)
        } catch {
            if let parsingError = error as? DeepLinkParsingErrorThunderbol {
                return .failure(parsingError)
            }
            return .failure(.invalidURLFormatNebula)
        }
    }
}

