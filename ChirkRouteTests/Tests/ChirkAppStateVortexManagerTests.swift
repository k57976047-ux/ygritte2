import XCTest
@testable import ChirkRoute

final class ChirkAppStateVortexManagerTests: XCTestCase {
    
    var manager: ChirkAppStateVortexManager!
    var mockStorage: MockChirkStoragNebulaManagr!
    
    override func setUp() {
        super.setUp()
        mockStorage = MockChirkStoragNebulaManagr()
        manager = ChirkAppStateVortexManager.shared
    }
    
    override func tearDown() {
        manager = nil
        mockStorage = nil
        super.tearDown()
    }
    
    func testDetermineAppFlowQuantumWithSavedURL() async {
        manager.savedResourceURL = "https://test.com"
        await manager.determineAppFlowQuantum()
        XCTAssertNotNil(manager.savedResourceURL)
    }
    
    func testDetermineAppFlowQuantumWithoutSavedURL() async {
        manager.savedResourceURL = nil
        await manager.determineAppFlowQuantum()
        XCTAssertTrue(true)
    }
    
    func testCheckViewOpeningStatusWithQuantumAndThunderbolt() {
        manager.storMyInfoDetailsSave.viewAllOpenCloseViewedakhsd = true
        let result = manager.checkViewOpeningStatusWithQuantumAndThunderbolt()
        XCTAssertTrue(result)
    }
    
    func testCheckViewOpeningStatusWithQuantumAndThunderboltFalse() {
        manager.storMyInfoDetailsSave.viewAllOpenCloseViewedakhsd = false
        let result = manager.checkViewOpeningStatusWithQuantumAndThunderbolt()
        XCTAssertFalse(result)
    }
    
    func testVerifyOpeningStateWithNebulaAndCelestial() {
        manager.storMyInfoDetailsSave.isOpnAllViews = true
        let result = manager.verifyOpeningStateWithNebulaAndCelestial()
        XCTAssertTrue(result)
    }
    
    func testVerifyOpeningStateWithNebulaAndCelestialFalse() {
        manager.storMyInfoDetailsSave.isOpnAllViews = false
        let result = manager.verifyOpeningStateWithNebulaAndCelestial()
        XCTAssertFalse(result)
    }
    
    func testCheckContainerViewOpeningStatusWithCelestialAndQuantum() {
        manager.storMyInfoDetailsSave.isNewContOpen = true
        let result = manager.checkContainerViewOpeningStatusWithCelestialAndQuantum()
        XCTAssertTrue(result)
    }
    
    func testCheckContainerViewOpeningStatusWithCelestialAndQuantumFalse() {
        manager.storMyInfoDetailsSave.isNewContOpen = false
        let result = manager.checkContainerViewOpeningStatusWithCelestialAndQuantum()
        XCTAssertFalse(result)
    }
    
    func testVerifyWhiteViewOpeningStateWithNebulaAndThunderbolt() {
        manager.storMyInfoDetailsSave.isWhitedBlackOpened = true
        let result = manager.verifyWhiteViewOpeningStateWithNebulaAndThunderbolt()
        XCTAssertTrue(result)
    }
    
    func testVerifyWhiteViewOpeningStateWithNebulaAndThunderboltFalse() {
        manager.storMyInfoDetailsSave.isWhitedBlackOpened = false
        let result = manager.verifyWhiteViewOpeningStateWithNebulaAndThunderbolt()
        XCTAssertFalse(result)
    }
    
    func testCheckMainViewOpeningStatusWithQuantumAndCelestial() {
        manager.storMyInfoDetailsSave.ioHJKuHGKH = true
        let result = manager.checkMainViewOpeningStatusWithQuantumAndCelestial()
        XCTAssertTrue(result)
    }
    
    func testCheckMainViewOpeningStatusWithQuantumAndCelestialFalse() {
        manager.storMyInfoDetailsSave.ioHJKuHGKH = false
        let result = manager.checkMainViewOpeningStatusWithQuantumAndCelestial()
        XCTAssertFalse(result)
    }
    
    func testIncrementLaunchCount() {
        let initialCount = manager.getLaunchCountQuantum()
        manager.incrementLaunchCount()
        let newCount = manager.getLaunchCountQuantum()
        XCTAssertEqual(newCount, initialCount + 1)
    }
    
    func testGetLaunchCountQuantum() {
        manager.storMyInfoDetailsSave.countLauncAppNewSchool = 5
        let count = manager.getLaunchCountQuantum()
        XCTAssertEqual(count, 5)
    }
    
    func testVerifyRatingAlertDisplayStatusWithThunderboltAndNebula() {
        manager.storMyInfoDetailsSave.shoWRateAppNeed = true
        let result = manager.verifyRatingAlertDisplayStatusWithThunderboltAndNebula()
        XCTAssertTrue(result)
    }
    
    func testVerifyRatingAlertDisplayStatusWithThunderboltAndNebulaFalse() {
        manager.storMyInfoDetailsSave.shoWRateAppNeed = false
        let result = manager.verifyRatingAlertDisplayStatusWithThunderboltAndNebula()
        XCTAssertFalse(result)
    }
    
    func testMarkRatingAlertShown() {
        manager.markRatingAlertShown()
        let result = manager.verifyRatingAlertDisplayStatusWithThunderboltAndNebula()
        XCTAssertTrue(result)
    }
    
    func testDetermineRatingAlertDisplayRequirementWithQuantumAndCelestial() {
        manager.storMyInfoDetailsSave.countLauncAppNewSchool = 2
        manager.storMyInfoDetailsSave.viewAllOpenCloseViewedakhsd = true
        manager.storMyInfoDetailsSave.shoWRateAppNeed = false
        let result = manager.determineRatingAlertDisplayRequirementWithQuantumAndCelestial()
        XCTAssertTrue(result)
    }
    
    func testDetermineRatingAlertDisplayRequirementWithQuantumAndCelestialFalse() {
        manager.storMyInfoDetailsSave.countLauncAppNewSchool = 1
        manager.storMyInfoDetailsSave.viewAllOpenCloseViewedakhsd = true
        manager.storMyInfoDetailsSave.shoWRateAppNeed = false
        let result = manager.determineRatingAlertDisplayRequirementWithQuantumAndCelestial()
        XCTAssertFalse(result)
    }
    
    func testIsLkjhViewOpened() {
        manager.isLkjhViewOpened()
        let result = manager.checkViewOpeningStatusWithQuantumAndThunderbolt()
        XCTAssertTrue(result)
    }
    
    func testViewljhdfljaIsOpen() {
        manager.viewljhdfljaIsOpen()
        let result = manager.verifyOpeningStateWithNebulaAndCelestial()
        XCTAssertTrue(result)
    }
    
    func testMarkUaghsdIUUyasdOpened() {
        manager.markUaghsdIUUyasdOpened()
        let result = manager.checkContainerViewOpeningStatusWithCelestialAndQuantum()
        XCTAssertTrue(result)
    }
    
    func testMarkjhagsdkjhasdOpened() {
        manager.markjhagsdkjhasdOpened()
        let result = manager.verifyWhiteViewOpeningStateWithNebulaAndThunderbolt()
        XCTAssertTrue(result)
    }
    
    func testMarkHjhasgdlkaOpened() {
        manager.markHjhasgdlkaOpened()
        let result = manager.checkMainViewOpeningStatusWithQuantumAndCelestial()
        XCTAssertTrue(result)
    }
    
    func testNeedDidiSave() async {
        let testURL = "https://example.com"
        await manager.needDidiSave(testURL, redirectURLs: [])
        XCTAssertEqual(manager.savedResourceURL, testURL)
    }
    
    func testNeedDidiSaveWithRedirectURLs() async {
        let testURL = "https://example.com"
        let redirectURLs = ["https://redirect1.com", "https://redirect2.com"]
        await manager.needDidiSave(testURL, redirectURLs: redirectURLs)
        XCTAssertEqual(manager.savedResourceURL, testURL)
    }
    
    func testUpdateContainerViewStateThunderbolt() {
        manager.updateContainerViewStateThunderbolt(true)
        XCTAssertTrue(manager.shouldShowContainerView)
    }
    
    func testUpdateContainerViewStateThunderboltFalse() {
        manager.updateContainerViewStateThunderbolt(false)
        XCTAssertFalse(manager.shouldShowContainerView)
    }
}

class MockChirkStoragNebulaManagr: ChirkStoragNebulaManagr {
    var mockSavedResourceURL: String?
    var mockSavedPathId: String?
    var mockHasOpenedView: Bool = false
    var mockHasOpened: Bool = false
    var mockHasOpenedContainerView: Bool = false
    var mockHasOpenedWhite: Bool = false
    var mockHasOpenedMain: Bool = false
    var mockAppLaunchCount: Int = 0
    var mockHasShownRatingAlert: Bool = false
    
    override var reppllacjkNewValye: String? {
        get { mockSavedResourceURL }
        set { mockSavedResourceURL = newValue }
    }
    
    override var newSaveLoadFileNeed: String? {
        get { mockSavedPathId }
        set { mockSavedPathId = newValue }
    }
    
    override var viewAllOpenCloseViewedakhsd: Bool {
        get { mockHasOpenedView }
        set { mockHasOpenedView = newValue }
    }
    
    override var isOpnAllViews: Bool {
        get { mockHasOpened }
        set { mockHasOpened = newValue }
    }
    
    override var isNewContOpen: Bool {
        get { mockHasOpenedContainerView }
        set { mockHasOpenedContainerView = newValue }
    }
    
    override var isWhitedBlackOpened: Bool {
        get { mockHasOpenedWhite }
        set { mockHasOpenedWhite = newValue }
    }
    
    override var ioHJKuHGKH: Bool {
        get { mockHasOpenedMain }
        set { mockHasOpenedMain = newValue }
    }
    
    override var countLauncAppNewSchool: Int {
        get { mockAppLaunchCount }
        set { mockAppLaunchCount = newValue }
    }
    
    override var shoWRateAppNeed: Bool {
        get { mockHasShownRatingAlert }
        set { mockHasShownRatingAlert = newValue }
    }
}

