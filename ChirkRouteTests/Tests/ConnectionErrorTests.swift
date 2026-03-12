import XCTest
@testable import ChirkRoute

final class ConnectionErrorTests: XCTestCase {
    
    func testNoConnectionErrorDescription() {
        let error = ConnectionError.noConnection
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "No internet connection")
    }
    
    func testInvalidURLErrorDescription() {
        let error = ConnectionError.invalidURL
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "Invalid URL")
    }
    
    func testInvalidResponseErrorDescription() {
        let error = ConnectionError.invalidResponse
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "Invalid response")
    }
    
    func testInvalidDataErrorDescription() {
        let error = ConnectionError.invalidData
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "Invalid data")
    }
    
    func testForbiddenErrorDescription() {
        let error = ConnectionError.forbidden
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "Access forbidden")
    }
    
    func testNotFoundErrorDescription() {
        let error = ConnectionError.notFound
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "Resource not found")
    }
    
    func testServerErrorDescription() {
        let error = ConnectionError.serverError(500)
        XCTAssertNotNil(error.errorDescription)
        XCTAssertEqual(error.errorDescription, "Server error: 500")
    }
    
    func testServerErrorWithDifferentCodes() {
        let error404 = ConnectionError.serverError(404)
        let error500 = ConnectionError.serverError(500)
        let error503 = ConnectionError.serverError(503)
        
        XCTAssertNotNil(error404.errorDescription)
        XCTAssertNotNil(error500.errorDescription)
        XCTAssertNotNil(error503.errorDescription)
    }
    
    func testRequestFailedErrorDescription() {
        let nsError = NSError(domain: "TestDomain", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let error = ConnectionError.requestFailed(nsError)
        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription?.contains("Test error") ?? false)
    }
    
    func testRequestFailedWithDifferentErrors() {
        let error1 = NSError(domain: "Domain1", code: 1, userInfo: nil)
        let error2 = NSError(domain: "Domain2", code: 2, userInfo: nil)
        
        let connectionError1 = ConnectionError.requestFailed(error1)
        let connectionError2 = ConnectionError.requestFailed(error2)
        
        XCTAssertNotNil(connectionError1.errorDescription)
        XCTAssertNotNil(connectionError2.errorDescription)
    }
    
    func testErrorEquality() {
        let error1 = ConnectionError.invalidURL
        let error2 = ConnectionError.invalidURL
        XCTAssertTrue(error1 == error2)
    }
    
    func testErrorInequality() {
        let error1 = ConnectionError.invalidURL
        let error2 = ConnectionError.invalidResponse
        XCTAssertFalse(error1 == error2)
    }
    
    func testServerErrorEquality() {
        let error1 = ConnectionError.serverError(500)
        let error2 = ConnectionError.serverError(500)
        XCTAssertTrue(error1 == error2)
    }
    
    func testServerErrorInequality() {
        let error1 = ConnectionError.serverError(404)
        let error2 = ConnectionError.serverError(500)
        XCTAssertFalse(error1 == error2)
    }
}

final class NavigationChainResultTests: XCTestCase {
    
    func testNavigationChainResultInitialization() {
        let destination = "https://destination.com"
        let intermediate = ["https://intermediate1.com", "https://intermediate2.com"]
        let result = NavigationChainResult(destinationAddress: destination, intermediateAddresses: intermediate)
        
        XCTAssertEqual(result.destinationAddress, destination)
        XCTAssertEqual(result.intermediateAddresses, intermediate)
    }
    
    func testNavigationChainResultWithEmptyIntermediate() {
        let destination = "https://destination.com"
        let result = NavigationChainResult(destinationAddress: destination, intermediateAddresses: [])
        
        XCTAssertEqual(result.destinationAddress, destination)
        XCTAssertTrue(result.intermediateAddresses.isEmpty)
    }
    
    func testNavigationChainResultWithMultipleIntermediate() {
        let destination = "https://destination.com"
        let intermediate = (0..<10).map { "https://intermediate\($0).com" }
        let result = NavigationChainResult(destinationAddress: destination, intermediateAddresses: intermediate)
        
        XCTAssertEqual(result.destinationAddress, destination)
        XCTAssertEqual(result.intermediateAddresses.count, 10)
    }
    
    func testNavigationChainResultWithLongURLs() {
        let destination = "https://destination.com/" + String(repeating: "a", count: 1000)
        let intermediate = ["https://intermediate.com/" + String(repeating: "b", count: 1000)]
        let result = NavigationChainResult(destinationAddress: destination, intermediateAddresses: intermediate)
        
        XCTAssertEqual(result.destinationAddress, destination)
        XCTAssertEqual(result.intermediateAddresses.count, 1)
    }
}

