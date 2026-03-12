import XCTest
@testable import ChirkRoute

final class ChirkStoragNebulaManagrTests: XCTestCase {
    
    var storage: ChirkStoragNebulaManagr!
    
    override func setUp() {
        super.setUp()
        storage = ChirkStoragNebulaManagr.share
    }
    
    override func tearDown() {
        storage.dataClearedGhjasd()
        storage = nil
        super.tearDown()
    }
    
    func testReppllacjkNewValyeGetSet() {
        let testURL = "https://example.com"
        storage.reppllacjkNewValye = testURL
        XCTAssertEqual(storage.reppllacjkNewValye, testURL)
    }
    
    func testReppllacjkNewValyeNil() {
        storage.reppllacjkNewValye = nil
        XCTAssertNil(storage.reppllacjkNewValye)
    }
    
    func testNewSaveLoadFileNeedGetSet() {
        let testPathId = "testPath123"
        storage.newSaveLoadFileNeed = testPathId
        XCTAssertEqual(storage.newSaveLoadFileNeed, testPathId)
    }
    
    func testNewSaveLoadFileNeedNil() {
        storage.newSaveLoadFileNeed = nil
        XCTAssertNil(storage.newSaveLoadFileNeed)
    }
    
    func testViewAllOpenCloseViewedakhsdGetSet() {
        storage.viewAllOpenCloseViewedakhsd = true
        XCTAssertTrue(storage.viewAllOpenCloseViewedakhsd)
        
        storage.viewAllOpenCloseViewedakhsd = false
        XCTAssertFalse(storage.viewAllOpenCloseViewedakhsd)
    }
    
    func testIsOpnAllViewsGetSet() {
        storage.isOpnAllViews = true
        XCTAssertTrue(storage.isOpnAllViews)
        
        storage.isOpnAllViews = false
        XCTAssertFalse(storage.isOpnAllViews)
    }
    
    func testIsNewContOpenGetSet() {
        storage.isNewContOpen = true
        XCTAssertTrue(storage.isNewContOpen)
        
        storage.isNewContOpen = false
        XCTAssertFalse(storage.isNewContOpen)
    }
    
    func testIsWhitedBlackOpenedGetSet() {
        storage.isWhitedBlackOpened = true
        XCTAssertTrue(storage.isWhitedBlackOpened)
        
        storage.isWhitedBlackOpened = false
        XCTAssertFalse(storage.isWhitedBlackOpened)
    }
    
    func testIoHJKuHGKHGetSet() {
        storage.ioHJKuHGKH = true
        XCTAssertTrue(storage.ioHJKuHGKH)
        
        storage.ioHJKuHGKH = false
        XCTAssertFalse(storage.ioHJKuHGKH)
    }
    
    func testCountLauncAppNewSchoolGetSet() {
        storage.countLauncAppNewSchool = 5
        XCTAssertEqual(storage.countLauncAppNewSchool, 5)
        
        storage.countLauncAppNewSchool = 10
        XCTAssertEqual(storage.countLauncAppNewSchool, 10)
    }
    
    func testCountLauncAppNewSchoolIncrement() {
        storage.countLauncAppNewSchool = 0
        storage.countLauncAppNewSchool += 1
        XCTAssertEqual(storage.countLauncAppNewSchool, 1)
    }
    
    func testShoWRateAppNeedGetSet() {
        storage.shoWRateAppNeed = true
        XCTAssertTrue(storage.shoWRateAppNeed)
        
        storage.shoWRateAppNeed = false
        XCTAssertFalse(storage.shoWRateAppNeed)
    }
    
    func testNewValuyrhbBayKay() {
        let testKey = "testKey"
        let testValue = "testValue"
        storage.oldValueStayTonight(testValue, key: testKey)
        
        let retrievedValue = storage.newValuyrhbBayKay(key: testKey)
        XCTAssertEqual(retrievedValue, testValue)
    }
    
    func testOldValueStayTonight() {
        let testKey = "testKey"
        let testValue = "testValue"
        
        storage.oldValueStayTonight(testValue, key: testKey)
        let retrievedValue = storage.newValuyrhbBayKay(key: testKey)
        
        XCTAssertEqual(retrievedValue, testValue)
    }
    
    func testOldValueStayTonightWithNil() {
        let testKey = "testKey"
        storage.oldValueStayTonight("initial", key: testKey)
        storage.oldValueStayTonight(nil, key: testKey)
        
        let retrievedValue = storage.newValuyrhbBayKay(key: testKey)
        XCTAssertNil(retrievedValue)
    }
    
    func testBoolGameValyueKey() {
        let testKey = "boolKey"
        storage.kloseKnightKayValye(true, key: testKey)
        
        let retrievedValue = storage.boolGameValyueKey(key: testKey)
        XCTAssertTrue(retrievedValue)
    }
    
    func testBoolGameValyueKeyDefaultFalse() {
        let testKey = "nonExistentKey"
        let retrievedValue = storage.boolGameValyueKey(key: testKey)
        XCTAssertFalse(retrievedValue)
    }
    
    func testKloseKnightKayValye() {
        let testKey = "boolKey"
        storage.kloseKnightKayValye(true, key: testKey)
        
        let retrievedValue = storage.boolGameValyueKey(key: testKey)
        XCTAssertTrue(retrievedValue)
    }
    
    func testGretMyNewaValeu() {
        let testKey = "intKey"
        storage.needMoreRenameigNowKey(42, key: testKey)
        
        let retrievedValue = storage.gretMyNewaValeu(key: testKey)
        XCTAssertEqual(retrievedValue, 42)
    }
    
    func testGretMyNewaValeuDefaultZero() {
        let testKey = "nonExistentKey"
        let retrievedValue = storage.gretMyNewaValeu(key: testKey)
        XCTAssertEqual(retrievedValue, 0)
    }
    
    func testNeedMoreRenameigNowKey() {
        let testKey = "intKey"
        storage.needMoreRenameigNowKey(100, key: testKey)
        
        let retrievedValue = storage.gretMyNewaValeu(key: testKey)
        XCTAssertEqual(retrievedValue, 100)
    }
    
    func testWhyNeddkhasdIop() {
        let testKey = "testKey"
        storage.oldValueStayTonight("testValue", key: testKey)
        
        storage.whyNeddkhasdIop(key: testKey)
        
        let retrievedValue = storage.newValuyrhbBayKay(key: testKey)
        XCTAssertNil(retrievedValue)
    }
    
    func testDataClearedGhjasd() {
        storage.reppllacjkNewValye = "test"
        storage.newSaveLoadFileNeed = "path"
        storage.viewAllOpenCloseViewedakhsd = true
        storage.isOpnAllViews = true
        storage.isNewContOpen = true
        storage.isWhitedBlackOpened = true
        storage.ioHJKuHGKH = true
        storage.countLauncAppNewSchool = 5
        storage.shoWRateAppNeed = true
        
        storage.dataClearedGhjasd()
        
        XCTAssertNil(storage.reppllacjkNewValye)
        XCTAssertNil(storage.newSaveLoadFileNeed)
        XCTAssertFalse(storage.viewAllOpenCloseViewedakhsd)
        XCTAssertFalse(storage.isOpnAllViews)
        XCTAssertFalse(storage.isNewContOpen)
        XCTAssertFalse(storage.isWhitedBlackOpened)
        XCTAssertFalse(storage.ioHJKuHGKH)
        XCTAssertEqual(storage.countLauncAppNewSchool, 0)
        XCTAssertFalse(storage.shoWRateAppNeed)
    }
    
    func testMultiplePropertiesSet() {
        storage.reppllacjkNewValye = "url1"
        storage.newSaveLoadFileNeed = "path1"
        storage.viewAllOpenCloseViewedakhsd = true
        storage.isOpnAllViews = true
        storage.isNewContOpen = true
        storage.isWhitedBlackOpened = true
        storage.ioHJKuHGKH = true
        storage.countLauncAppNewSchool = 7
        storage.shoWRateAppNeed = true
        
        XCTAssertEqual(storage.reppllacjkNewValye, "url1")
        XCTAssertEqual(storage.newSaveLoadFileNeed, "path1")
        XCTAssertTrue(storage.viewAllOpenCloseViewedakhsd)
        XCTAssertTrue(storage.isOpnAllViews)
        XCTAssertTrue(storage.isNewContOpen)
        XCTAssertTrue(storage.isWhitedBlackOpened)
        XCTAssertTrue(storage.ioHJKuHGKH)
        XCTAssertEqual(storage.countLauncAppNewSchool, 7)
        XCTAssertTrue(storage.shoWRateAppNeed)
    }
    
    func testConcurrentAccess() {
        let expectation = expectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            storage.countLauncAppNewSchool = index
            storage.viewAllOpenCloseViewedakhsd = index % 2 == 0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(true)
    }
    
    func testLongStringValues() {
        let longString = String(repeating: "a", count: 1000)
        storage.reppllacjkNewValye = longString
        
        XCTAssertEqual(storage.reppllacjkNewValye, longString)
    }
    
    func testSpecialCharactersInValues() {
        let specialString = "test!@#$%^&*()_+-=[]{}|;':\",./<>?"
        storage.reppllacjkNewValye = specialString
        
        XCTAssertEqual(storage.reppllacjkNewValye, specialString)
    }
    
    func testUnicodeCharactersInValues() {
        let unicodeString = "测试🚀🎉中文"
        storage.reppllacjkNewValye = unicodeString
        
        XCTAssertEqual(storage.reppllacjkNewValye, unicodeString)
    }
    
    func testCountLauncAppNewSchoolLargeValue() {
        storage.countLauncAppNewSchool = Int.max
        XCTAssertEqual(storage.countLauncAppNewSchool, Int.max)
    }
    
    func testCountLauncAppNewSchoolNegativeValue() {
        storage.countLauncAppNewSchool = -1
        XCTAssertEqual(storage.countLauncAppNewSchool, -1)
    }
}

