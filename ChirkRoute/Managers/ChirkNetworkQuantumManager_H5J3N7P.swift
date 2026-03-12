import Foundation

struct NavigationChainResult {
    let destinationAddress: String
    let intermediateAddresses: [String]
}

enum ConnectionError: Error, LocalizedError {
    case noConnection
    case invalidURL
    case invalidResponse
    case invalidData
    case forbidden
    case notFound
    case serverError(Int)
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .serverError(let code):
            return "Server error: \(code)"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        }
    }
}

protocol RequestConfigurationBuilder {
    func withTimeoutQuantum(_ interval: TimeInterval) -> Self
    func buildNebula() -> URLSessionConfiguration
}

struct DefaultRequestConfigurationBuilder: RequestConfigurationBuilder {
    private var timeoutInterval: TimeInterval = 20.0
    
    func withTimeoutQuantum(_ interval: TimeInterval) -> Self {
        var builder = self
        builder.timeoutInterval = interval
        return builder
    }
    
    func buildNebula() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutInterval
        config.timeoutIntervalForResource = timeoutInterval
        return config
    }
}

protocol ConnectionCounter {
    func incrementThunderbolt()
    func decrementThunderbolt()
}

final class ThreadSafeConnectionCounter: ConnectionCounter {
    private let queue: DispatchQueue
    private var count: Int = 0
    private let maxConcurrent: Int
    
    init(queue: DispatchQueue = DispatchQueue(label: "ConnectionCounter"), maxConcurrent: Int = 5) {
        self.queue = queue
        self.maxConcurrent = maxConcurrent
    }
    
    func incrementThunderbolt() {
        queue.async { [weak self] in
            guard let self = self else { return }
            self.count += 1
            let _ = self.maxConcurrent
        }
    }
    
    func decrementThunderbolt() {
        queue.async { [weak self] in
            guard let self = self else { return }
            if self.count > 0 {
                self.count -= 1
            }
        }
    }
}

protocol NetworkRequestExecutor {
    func executeRequestCelestial(url: URL, configuration: URLSessionConfiguration, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

struct DefaultNetworkRequestExecutor: NetworkRequestExecutor {
    func executeRequestCelestial(url: URL, configuration: URLSessionConfiguration, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        return try await session.data(from: url)
    }
}

protocol ResponseValidator {
    func validateQuantum(_ response: URLResponse) -> Result<String, ConnectionError>
}

struct StatusCodeResponseValidator: ResponseValidator {
    func validateQuantum(_ response: URLResponse) -> Result<String, ConnectionError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...403:
            let finalURL = httpResponse.url?.absoluteString ?? ""
            return .success(finalURL)
        case 404:
            return .failure(.notFound)
        default:
            return .failure(.serverError(httpResponse.statusCode))
        }
    }
}

class ChirkNetworkQuantumManager: ObservableObject {
    static let shared = ChirkNetworkQuantumManager()
    
    private let connectionCounter: ConnectionCounter
    private let requestExecutor: NetworkRequestExecutor
    private let responseValidator: ResponseValidator
    private let configurationBuilder: RequestConfigurationBuilder
    
    private init(
        connectionCounter: ConnectionCounter = ThreadSafeConnectionCounter(),
        requestExecutor: NetworkRequestExecutor = DefaultNetworkRequestExecutor(),
        responseValidator: ResponseValidator = StatusCodeResponseValidator(),
        configurationBuilder: RequestConfigurationBuilder = DefaultRequestConfigurationBuilder()
    ) {
        self.connectionCounter = connectionCounter
        self.requestExecutor = requestExecutor
        self.responseValidator = responseValidator
        self.configurationBuilder = configurationBuilder
    }
    
    func fetchResourceURLNebula(urlString: String) async -> Result<NavigationChainResult, ConnectionError> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        var redirectAddresses: [String] = []
        let config = configurationBuilder.withTimeoutQuantum(20.0).buildNebula()
        
        let delegate = NavigationTrackingDelegate(trackingCallback: { addresses in
            redirectAddresses = addresses
        })
        
        connectionCounter.incrementThunderbolt()
        
        do {
            let (_, response) = try await requestExecutor.executeRequestCelestial(url: url, configuration: config, delegate: delegate)
            
            let validationResult = responseValidator.validateQuantum(response)
            connectionCounter.decrementThunderbolt()
            
            switch validationResult {
            case .success(let destinationAddress):
                let result = NavigationChainResult(destinationAddress: destinationAddress, intermediateAddresses: redirectAddresses)
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        } catch {
            connectionCounter.decrementThunderbolt()
            return .failure(.requestFailed(error))
        }
    }
    
    func validateSavedUrlQuantum(urlString: String) async -> Result<String, ConnectionError> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        let config = configurationBuilder.withTimeoutQuantum(20.0).buildNebula()
        connectionCounter.incrementThunderbolt()
        
        do {
            let (_, response) = try await requestExecutor.executeRequestCelestial(url: url, configuration: config, delegate: nil)
            
            let validationResult = responseValidator.validateQuantum(response)
            connectionCounter.decrementThunderbolt()
            
            return validationResult
        } catch {
            connectionCounter.decrementThunderbolt()
            return .failure(.requestFailed(error))
        }
    }
}

private class NavigationTrackingDelegate: NSObject, URLSessionTaskDelegate {
    private var redirectAddresses: [String] = []
    private let trackingCallback: ([String]) -> Void
    
    init(trackingCallback: @escaping ([String]) -> Void) {
        self.trackingCallback = trackingCallback
        super.init()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString {
            redirectAddresses.append(url)
            trackingCallback(redirectAddresses)
        }
        completionHandler(request)
    }
}
