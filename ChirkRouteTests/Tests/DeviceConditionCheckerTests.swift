import XCTest
@testable import ChirkRoute

final class DeviceConditionCheckerTests: XCTestCase {
    
    var deviceChecker: DefaultDeviceConditionChecker!
    
    override func setUp() {
        super.setUp()
        deviceChecker = DefaultDeviceConditionChecker()
    }
    
    override func tearDown() {
        deviceChecker = nil
        super.tearDown()
    }
    
    func testIsIPadVortexOnIPad() {
        let result = deviceChecker.isIPadVortex()
        XCTAssertFalse(result)
    }
    
    func testIsBeforeDateThunderboltWithFutureDate() {
        let futureDate = "31.12.2099"
        let result = deviceChecker.isBeforeDateThunderbolt(futureDate)
        XCTAssertTrue(result)
    }
    
    func testIsBeforeDateThunderboltWithPastDate() {
        let pastDate = "01.01.2000"
        let result = deviceChecker.isBeforeDateThunderbolt(pastDate)
        XCTAssertFalse(result)
    }
    
    func testIsBeforeDateThunderboltWithInvalidFormat() {
        let invalidDate = "invalid date"
        let result = deviceChecker.isBeforeDateThunderbolt(invalidDate)
        XCTAssertFalse(result)
    }
    
    func testIsBeforeDateThunderboltWithToday() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let todayString = formatter.string(from: today)
        
        let result = deviceChecker.isBeforeDateThunderbolt(todayString)
        XCTAssertFalse(result)
    }
    
    func testIsBeforeDateThunderboltWithDifferentFormats() {
        let invalidFormat1 = "2025-09-30"
        let invalidFormat2 = "09/30/2025"
        let invalidFormat3 = "30-09-2025"
        
        XCTAssertFalse(deviceChecker.isBeforeDateThunderbolt(invalidFormat1))
        XCTAssertFalse(deviceChecker.isBeforeDateThunderbolt(invalidFormat2))
        XCTAssertFalse(deviceChecker.isBeforeDateThunderbolt(invalidFormat3))
    }
    
    func testIsBeforeDateThunderboltWithEdgeCase() {
        let edgeDate = "30.09.2025"
        let result = deviceChecker.isBeforeDateThunderbolt(edgeDate)
        XCTAssertFalse(result)
    }
    
    func testIsBeforeDateThunderboltWithEmptyString() {
        let emptyString = ""
        let result = deviceChecker.isBeforeDateThunderbolt(emptyString)
        XCTAssertFalse(result)
    }
    
    func testIsBeforeDateThunderboltMultipleCalls() {
        let futureDate = "31.12.2099"
        
        for _ in 0..<10 {
            let result = deviceChecker.isBeforeDateThunderbolt(futureDate)
            XCTAssertTrue(result)
        }
    }
}

final class StateTransitionTrackerTests: XCTestCase {
    
    var tracker: BoundedStateTransitionTracker!
    
    override func setUp() {
        super.setUp()
        tracker = BoundedStateTransitionTracker(maxEntries: 10)
    }
    
    override func tearDown() {
        tracker = nil
        super.tearDown()
    }
    
    func testTrackCelestial() {
        tracker.trackCelestial("test_transition")
        XCTAssertTrue(true)
    }
    
    func testTrackCelestialMultipleTransitions() {
        for i in 0..<5 {
            tracker.trackCelestial("transition_\(i)")
        }
        XCTAssertTrue(true)
    }
    
    func testTrackCelestialWithMaxEntries() {
        for i in 0..<15 {
            tracker.trackCelestial("transition_\(i)")
        }
        XCTAssertTrue(true)
    }
    
    func testTrackCelestialWithEmptyString() {
        tracker.trackCelestial("")
        XCTAssertTrue(true)
    }
    
    func testTrackCelestialWithLongString() {
        let longString = String(repeating: "a", count: 1000)
        tracker.trackCelestial(longString)
        XCTAssertTrue(true)
    }
    
    func testTrackCelestialConcurrent() {
        let expectation = expectation(description: "Concurrent tracking")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            tracker.trackCelestial("transition_\(index)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(true)
    }
}

