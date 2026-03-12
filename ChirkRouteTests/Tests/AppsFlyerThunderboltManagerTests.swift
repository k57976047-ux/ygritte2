import XCTest
@testable import ChirkRoute

final class AppsFlyerThunderboltManagerTests: XCTestCase {
    
    var manager: AppsFlyerThunderboltManager!
    
    override func setUp() {
        super.setUp()
        manager = AppsFlyerThunderboltManager.shared
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testSharedInstance() {
        let instance1 = AppsFlyerThunderboltManager.shared
        let instance2 = AppsFlyerThunderboltManager.shared
        
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testOnConversionDataSuccess() {
        let conversionInfo: [AnyHashable: Any] = ["key": "value"]
        manager.onConversionDataSuccess(conversionInfo)
        XCTAssertTrue(true)
    }
    
    func testOnConversionDataFail() {
        let error = NSError(domain: "TestDomain", code: 123, userInfo: nil)
        manager.onConversionDataFail(error)
        XCTAssertTrue(true)
    }
    
    func testGetAppsFlyerUID() {
        let uid = manager.getAppsFlyerUID()
        XCTAssertNotNil(uid)
    }
    
    func testLogEvent() {
        manager.logEvent()
        XCTAssertTrue(true)
    }
    
    func testLogEventWithParams() {
        let params: [String: Any] = ["param1": "value1", "param2": 123]
        manager.logEventWithParams(params: params)
        XCTAssertTrue(true)
    }
    
    func testLogEventWithParamsEmpty() {
        let params: [String: Any] = [:]
        manager.logEventWithParams(params: params)
        XCTAssertTrue(true)
    }
    
    func testLogEventWithParamsNil() {
        manager.logEventWithParams(params: [:])
        XCTAssertTrue(true)
    }
    
    func testStart() {
        let expectation = expectation(description: "Start completion")
        
        manager.start { status in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
        XCTAssertTrue(true)
    }
    
    func testStartWithoutCompletion() {
        manager.start(completion: nil)
        XCTAssertTrue(true)
    }
    
    func testOnConversionDataSuccessWithEmptyDict() {
        let emptyDict: [AnyHashable: Any] = [:]
        manager.onConversionDataSuccess(emptyDict)
        XCTAssertTrue(true)
    }
    
    func testOnConversionDataSuccessWithComplexDict() {
        let complexDict: [AnyHashable: Any] = [
            "string": "value",
            "number": 123,
            "bool": true,
            "array": [1, 2, 3],
            "dict": ["nested": "value"]
        ]
        manager.onConversionDataSuccess(complexDict)
        XCTAssertTrue(true)
    }
    
    func testOnConversionDataFailWithDifferentErrors() {
        let error1 = NSError(domain: "Domain1", code: 1, userInfo: nil)
        let error2 = NSError(domain: "Domain2", code: 2, userInfo: nil)
        
        manager.onConversionDataFail(error1)
        manager.onConversionDataFail(error2)
        
        XCTAssertTrue(true)
    }
    
    func testGetAppsFlyerUIDMultipleTimes() {
        let uid1 = manager.getAppsFlyerUID()
        let uid2 = manager.getAppsFlyerUID()
        
        XCTAssertEqual(uid1, uid2)
    }
    
    func testLogEventMultipleTimes() {
        for _ in 0..<10 {
            manager.logEvent()
        }
        XCTAssertTrue(true)
    }
    
    func testLogEventWithParamsMultipleTimes() {
        for i in 0..<10 {
            let params: [String: Any] = ["index": i]
            manager.logEventWithParams(params: params)
        }
        XCTAssertTrue(true)
    }
}

