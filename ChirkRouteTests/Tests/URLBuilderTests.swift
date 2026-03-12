import XCTest
@testable import ChirkRoute

final class URLBuilderTests: XCTestCase {
    
    var urlBuilder: PathIdURLBuilder!
    
    override func setUp() {
        super.setUp()
        urlBuilder = PathIdURLBuilder()
    }
    
    override func tearDown() {
        urlBuilder = nil
        super.tearDown()
    }
    
    func testBuildURLQuantumWithPathId() {
        let baseURL = "https://example.com"
        let pathId = "test123"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertTrue(result.contains("pathid=test123"))
        XCTAssertTrue(result.contains(baseURL))
    }
    
    func testBuildURLQuantumWithoutPathId() {
        let baseURL = "https://example.com"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: nil)
        
        XCTAssertEqual(result, baseURL)
    }
    
    func testBuildURLQuantumWithEmptyPathId() {
        let baseURL = "https://example.com"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: "")
        
        XCTAssertEqual(result, baseURL)
    }
    
    func testBuildURLQuantumWithExistingQueryParams() {
        let baseURL = "https://example.com?existing=param"
        let pathId = "test456"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertTrue(result.contains("pathid=test456"))
        XCTAssertTrue(result.contains("existing=param"))
    }
    
    func testBuildURLQuantumReplacesExistingPathId() {
        let baseURL = "https://example.com?pathid=old123"
        let pathId = "new789"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertTrue(result.contains("pathid=new789"))
        XCTAssertFalse(result.contains("pathid=old123"))
    }
    
    func testBuildURLQuantumWithSpecialCharactersInPathId() {
        let baseURL = "https://example.com"
        let pathId = "test@123#special"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertTrue(result.contains("pathid="))
    }
    
    func testBuildURLQuantumWithLongPathId() {
        let baseURL = "https://example.com"
        let pathId = String(repeating: "a", count: 100)
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertTrue(result.contains("pathid="))
    }
    
    func testBuildURLQuantumWithInvalidBaseURL() {
        let baseURL = "not a valid url"
        let pathId = "test123"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertEqual(result, baseURL)
    }
    
    func testBuildURLQuantumWithFragment() {
        let baseURL = "https://example.com#fragment"
        let pathId = "test123"
        let result = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId)
        
        XCTAssertTrue(result.contains("pathid=test123"))
    }
    
    func testBuildURLQuantumMultipleCalls() {
        let baseURL = "https://example.com"
        let pathId1 = "first"
        let pathId2 = "second"
        
        let result1 = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId1)
        let result2 = urlBuilder.buildURLQuantum(baseURL: baseURL, pathId: pathId2)
        
        XCTAssertTrue(result1.contains("pathid=first"))
        XCTAssertTrue(result2.contains("pathid=second"))
    }
}

final class QueryParameterPathExtractorTests: XCTestCase {
    
    var extractor: QueryParameterPathExtractor!
    
    override func setUp() {
        super.setUp()
        extractor = QueryParameterPathExtractor()
    }
    
    override func tearDown() {
        extractor = nil
        super.tearDown()
    }
    
    func testExtractPathIdNebulaWithPathId() {
        let urlString = "https://example.com?pathid=test123"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertEqual(result, "test123")
    }
    
    func testExtractPathIdNebulaWithoutPathId() {
        let urlString = "https://example.com?other=param"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertNil(result)
    }
    
    func testExtractPathIdNebulaWithMultipleParams() {
        let urlString = "https://example.com?param1=value1&pathid=test456&param2=value2"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertEqual(result, "test456")
    }
    
    func testExtractPathIdNebulaWithEmptyPathId() {
        let urlString = "https://example.com?pathid="
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertEqual(result, "")
    }
    
    func testExtractPathIdNebulaWithInvalidURL() {
        let urlString = "not a valid url"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertNil(result)
    }
    
    func testExtractPathIdNebulaWithNoQueryParams() {
        let urlString = "https://example.com"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertNil(result)
    }
    
    func testExtractPathIdNebulaWithSpecialCharacters() {
        let urlString = "https://example.com?pathid=test@123#special"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertNotNil(result)
    }
    
    func testExtractPathIdNebulaCaseSensitive() {
        let urlString = "https://example.com?PathId=test123"
        let result = extractor.extractPathIdNebula(from: urlString)
        
        XCTAssertNil(result)
    }
}

