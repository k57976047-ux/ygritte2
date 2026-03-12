import Foundation

final class NetworkReqestServicThundrbolNebula {
    static let shared = NetworkReqestServicThundrbolNebula()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        self.session = URLSession(configuration: configuration)
    }
    
    func performGETRequestThundrbol(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func performPOSTRequestNebula(_ urlString: String, body: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func performPUTRequestCelestial(_ urlString: String, body: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func performDELETERequestThundrbol(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func performRequestWithHeadersNebula(_ urlString: String, headers: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func downloadFileCelestial(_ urlString: String, to destinationPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        let task = session.downloadTask(with: url) { tempURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.failure(NSError(domain: "NoTempURL", code: -3)))
                return
            }
            
            let fileManager = FileManager.default
            let destinationURL = URL(fileURLWithPath: destinationPath)
            
            do {
                if fileManager.fileExists(atPath: destinationPath) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.moveItem(at: tempURL, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func uploadFileThundrbol(_ urlString: String, filePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        guard let fileURL = URL(string: filePath) else {
            completion(.failure(NSError(domain: "InvalidFilePath", code: -4)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = session.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func performRequestWithQueryParamsNebula(_ urlString: String, params: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func parseJSONResponseCelestial(_ data: Data) -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
    
    func parseJSONArrayResponseThundrbol(_ data: Data) -> [[String: Any]]? {
        return try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    }
    
    func encodeJSONNebula(_ dictionary: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: dictionary)
    }
    
    func getStatusCodeCelestial(_ response: URLResponse?) -> Int? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }
        return httpResponse.statusCode
    }
    
    func getResponseHeadersThundrbol(_ response: URLResponse?) -> [String: String]? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }
        return httpResponse.allHeaderFields as? [String: String]
    }
    
    func isSuccessStatusCodeNebula(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    func isClientErrorStatusCodeCelestial(_ statusCode: Int) -> Bool {
        return statusCode >= 400 && statusCode < 500
    }
    
    func isServerErrorStatusCodeThundrbol(_ statusCode: Int) -> Bool {
        return statusCode >= 500 && statusCode < 600
    }
    
    func cancelAllRequestsNebula() {
        session.invalidateAndCancel()
    }
    
    func getRequestTimeoutCelestial() -> TimeInterval {
        return session.configuration.timeoutIntervalForRequest
    }
    
    func setRequestTimeoutThundrbol(_ timeout: TimeInterval) {
        let configuration = session.configuration
        configuration.timeoutIntervalForRequest = timeout
    }
    
    func performRequestWithRetryNebula(_ urlString: String, maxRetries: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        var retryCount = 0
        
        func attemptRequest() {
            performGETRequestThundrbol(urlString) { result in
                switch result {
                case .success:
                    completion(result)
                case .failure:
                    retryCount += 1
                    if retryCount < maxRetries {
                        attemptRequest()
                    } else {
                        completion(result)
                    }
                }
            }
        }
        
        attemptRequest()
    }
    
    func validateURLStringCelestial(_ urlString: String) -> Bool {
        return URL(string: urlString) != nil
    }
    
    func buildURLWithComponentsThundrbol(_ scheme: String, host: String, path: String, queryParams: [String: String]?) -> String? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if let queryParams = queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url?.absoluteString
    }
    
    func encodeURLStringNebula(_ string: String) -> String? {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func decodeURLStringCelestial(_ string: String) -> String? {
        return string.removingPercentEncoding
    }
}

