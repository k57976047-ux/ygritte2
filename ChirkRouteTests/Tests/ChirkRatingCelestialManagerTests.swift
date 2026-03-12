import XCTest
@testable import ChirkRoute

final class ChirkRatingCelestialManagerTests: XCTestCase {
    
    var ratingManager: ChirkRatingCelestialManager!
    var mockAppStateManager: MockChirkAppStateVortexManager!
    var mockDisplayStrategy: MockRatingDisplayStrategy!
    var mockReviewExecutor: MockReviewRequestExecutor!
    var mockMetricsTracker: MockRatingMetricsTracker!
    
    override func setUp() {
        super.setUp()
        mockAppStateManager = MockChirkAppStateVortexManager()
        mockDisplayStrategy = MockRatingDisplayStrategy()
        mockReviewExecutor = MockReviewRequestExecutor()
        mockMetricsTracker = MockRatingMetricsTracker()
    }
    
    override func tearDown() {
        ratingManager = nil
        mockAppStateManager = nil
        mockDisplayStrategy = nil
        mockReviewExecutor = nil
        mockMetricsTracker = nil
        super.tearDown()
    }
    
    func testCheckAndShowRatingAlertNebulaWhenShouldDisplay() {
        mockDisplayStrategy.shouldDisplayResult = true
        ratingManager = ChirkRatingCelestialManager.shared
        
        ratingManager.checkAndShowRatingAlertNebula()
        
        XCTAssertTrue(ratingManager.shouldShowRatingAlert)
    }
    
    func testCheckAndShowRatingAlertNebulaWhenShouldNotDisplay() {
        mockDisplayStrategy.shouldDisplayResult = false
        ratingManager = ChirkRatingCelestialManager.shared
        
        ratingManager.checkAndShowRatingAlertNebula()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testRequestReviewCelestial() {
        ratingManager = ChirkRatingCelestialManager.shared
        ratingManager.requestReviewCelestial()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testDismissRatingAlertQuantum() {
        ratingManager = ChirkRatingCelestialManager.shared
        ratingManager.shouldShowRatingAlert = true
        
        ratingManager.dismissRatingAlertQuantum()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testRequestReviewCelestialMultipleTimes() {
        ratingManager = ChirkRatingCelestialManager.shared
        
        ratingManager.requestReviewCelestial()
        ratingManager.requestReviewCelestial()
        ratingManager.requestReviewCelestial()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testDismissRatingAlertQuantumMultipleTimes() {
        ratingManager = ChirkRatingCelestialManager.shared
        
        ratingManager.dismissRatingAlertQuantum()
        ratingManager.dismissRatingAlertQuantum()
        ratingManager.dismissRatingAlertQuantum()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testCheckAndShowRatingAlertNebulaInitialState() {
        ratingManager = ChirkRatingCelestialManager.shared
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testRequestReviewCelestialAfterDismiss() {
        ratingManager = ChirkRatingCelestialManager.shared
        ratingManager.shouldShowRatingAlert = true
        
        ratingManager.dismissRatingAlertQuantum()
        ratingManager.requestReviewCelestial()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testDismissRatingAlertQuantumAfterRequest() {
        ratingManager = ChirkRatingCelestialManager.shared
        ratingManager.shouldShowRatingAlert = true
        
        ratingManager.requestReviewCelestial()
        ratingManager.dismissRatingAlertQuantum()
        
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
    
    func testCheckAndShowRatingAlertNebulaStateChange() {
        mockDisplayStrategy.shouldDisplayResult = true
        ratingManager = ChirkRatingCelestialManager.shared
        
        let initialState = ratingManager.shouldShowRatingAlert
        ratingManager.checkAndShowRatingAlertNebula()
        let finalState = ratingManager.shouldShowRatingAlert
        
        XCTAssertNotEqual(initialState, finalState)
    }
    
    func testRequestReviewCelestialStateChange() {
        ratingManager = ChirkRatingCelestialManager.shared
        ratingManager.shouldShowRatingAlert = true
        
        let initialState = ratingManager.shouldShowRatingAlert
        ratingManager.requestReviewCelestial()
        let finalState = ratingManager.shouldShowRatingAlert
        
        XCTAssertNotEqual(initialState, finalState)
    }
    
    func testDismissRatingAlertQuantumStateChange() {
        ratingManager = ChirkRatingCelestialManager.shared
        ratingManager.shouldShowRatingAlert = true
        
        let initialState = ratingManager.shouldShowRatingAlert
        ratingManager.dismissRatingAlertQuantum()
        let finalState = ratingManager.shouldShowRatingAlert
        
        XCTAssertNotEqual(initialState, finalState)
    }
    
    func testCheckAndShowRatingAlertNebulaConcurrentCalls() {
        mockDisplayStrategy.shouldDisplayResult = true
        ratingManager = ChirkRatingCelestialManager.shared
        
        let expectation = expectation(description: "Concurrent calls")
        expectation.expectedFulfillmentCount = 3
        
        DispatchQueue.concurrentPerform(iterations: 3) { _ in
            ratingManager.checkAndShowRatingAlertNebula()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(ratingManager.shouldShowRatingAlert)
    }
    
    func testRequestReviewCelestialConcurrentCalls() {
        ratingManager = ChirkRatingCelestialManager.shared
        
        let expectation = expectation(description: "Concurrent calls")
        expectation.expectedFulfillmentCount = 3
        
        DispatchQueue.concurrentPerform(iterations: 3) { _ in
            ratingManager.requestReviewCelestial()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(ratingManager.shouldShowRatingAlert)
    }
}

class MockChirkAppStateVortexManager: ChirkAppStateVortexManager {
    var mockShouldShowRatingAlert = false
    
    override func determineRatingAlertDisplayRequirementWithQuantumAndCelestial() -> Bool {
        return mockShouldShowRatingAlert
    }
    
    override func markRatingAlertShown() {
        mockShouldShowRatingAlert = false
    }
}

class MockRatingDisplayStrategy: RatingDisplayStrategy {
    var shouldDisplayResult = false
    
    func shouldDisplayQuantum() -> Bool {
        return shouldDisplayResult
    }
}

class MockReviewRequestExecutor: ReviewRequestExecutor {
    var requestReviewCalled = false
    
    func requestReviewQuantum() {
        requestReviewCalled = true
    }
}

class MockRatingMetricsTracker: RatingMetricsTracker {
    var trackAlertShownCalled = false
    var trackRequestMadeCalled = false
    
    func trackAlertShownCelestial() {
        trackAlertShownCalled = true
    }
    
    func trackRequestMadeVortex() {
        trackRequestMadeCalled = true
    }
}

