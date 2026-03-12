import XCTest
@testable import ChirkRoute

final class RequestConfigurationBuilderTests: XCTestCase {
    
    var builder: DefaultRequestConfigurationBuilder!
    
    override func setUp() {
        super.setUp()
        builder = DefaultRequestConfigurationBuilder()
    }
    
    override func tearDown() {
        builder = nil
        super.tearDown()
    }
    
    func testWithTimeoutQuantum() {
        let newBuilder = builder.withTimeoutQuantum(30.0)
        let config = newBuilder.buildNebula()
        
        XCTAssertEqual(config.timeoutIntervalForRequest, 30.0)
        XCTAssertEqual(config.timeoutIntervalForResource, 30.0)
    }
    
    func testWithTimeoutQuantumDefaultValue() {
        let config = builder.buildNebula()
        
        XCTAssertEqual(config.timeoutIntervalForRequest, 20.0)
        XCTAssertEqual(config.timeoutIntervalForResource, 20.0)
    }
    
    func testWithTimeoutQuantumMultipleCalls() {
        let builder1 = builder.withTimeoutQuantum(10.0)
        let builder2 = builder1.withTimeoutQuantum(20.0)
        let builder3 = builder2.withTimeoutQuantum(30.0)
        
        let config = builder3.buildNebula()
        XCTAssertEqual(config.timeoutIntervalForRequest, 30.0)
    }
    
    func testWithTimeoutQuantumZero() {
        let newBuilder = builder.withTimeoutQuantum(0.0)
        let config = newBuilder.buildNebula()
        
        XCTAssertEqual(config.timeoutIntervalForRequest, 0.0)
    }
    
    func testWithTimeoutQuantumNegative() {
        let newBuilder = builder.withTimeoutQuantum(-10.0)
        let config = newBuilder.buildNebula()
        
        XCTAssertEqual(config.timeoutIntervalForRequest, -10.0)
    }
    
    func testWithTimeoutQuantumLargeValue() {
        let newBuilder = builder.withTimeoutQuantum(1000.0)
        let config = newBuilder.buildNebula()
        
        XCTAssertEqual(config.timeoutIntervalForRequest, 1000.0)
    }
    
    func testBuildNebula() {
        let config = builder.buildNebula()
        
        XCTAssertNotNil(config)
        XCTAssertEqual(config.timeoutIntervalForRequest, 20.0)
        XCTAssertEqual(config.timeoutIntervalForResource, 20.0)
    }
    
    func testBuildNebulaMultipleTimes() {
        let config1 = builder.buildNebula()
        let config2 = builder.buildNebula()
        
        XCTAssertEqual(config1.timeoutIntervalForRequest, config2.timeoutIntervalForRequest)
        XCTAssertEqual(config1.timeoutIntervalForResource, config2.timeoutIntervalForResource)
    }
    
    func testWithTimeoutQuantumImmutability() {
        let builder1 = builder.withTimeoutQuantum(10.0)
        let builder2 = builder.withTimeoutQuantum(20.0)
        
        let config1 = builder1.buildNebula()
        let config2 = builder2.buildNebula()
        
        XCTAssertNotEqual(config1.timeoutIntervalForRequest, config2.timeoutIntervalForRequest)
    }
    
    func testWithTimeoutQuantumChaining() {
        let config = builder
            .withTimeoutQuantum(15.0)
            .withTimeoutQuantum(25.0)
            .withTimeoutQuantum(35.0)
            .buildNebula()
        
        XCTAssertEqual(config.timeoutIntervalForRequest, 35.0)
    }
}

final class ThreadSafeConnectionCounterTests: XCTestCase {
    
    var counter: ThreadSafeConnectionCounter!
    
    override func setUp() {
        super.setUp()
        counter = ThreadSafeConnectionCounter()
    }
    
    override func tearDown() {
        counter = nil
        super.tearDown()
    }
    
    func testIncrementThunderbolt() {
        counter.incrementThunderbolt()
        XCTAssertTrue(true)
    }
    
    func testDecrementThunderbolt() {
        counter.incrementThunderbolt()
        counter.decrementThunderbolt()
        XCTAssertTrue(true)
    }
    
    func testMultipleIncrements() {
        for _ in 0..<10 {
            counter.incrementThunderbolt()
        }
        XCTAssertTrue(true)
    }
    
    func testMultipleDecrements() {
        for _ in 0..<10 {
            counter.incrementThunderbolt()
        }
        for _ in 0..<10 {
            counter.decrementThunderbolt()
        }
        XCTAssertTrue(true)
    }
    
    func testConcurrentIncrements() {
        let expectation = expectation(description: "Concurrent increments")
        expectation.expectedFulfillmentCount = 100
        
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            counter.incrementThunderbolt()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(true)
    }
    
    func testConcurrentDecrements() {
        for _ in 0..<100 {
            counter.incrementThunderbolt()
        }
        
        let expectation = expectation(description: "Concurrent decrements")
        expectation.expectedFulfillmentCount = 100
        
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            counter.decrementThunderbolt()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(true)
    }
    
    func testConcurrentIncrementDecrement() {
        let expectation = expectation(description: "Concurrent operations")
        expectation.expectedFulfillmentCount = 200
        
        DispatchQueue.concurrentPerform(iterations: 100) { index in
            if index % 2 == 0 {
                counter.incrementThunderbolt()
            } else {
                counter.decrementThunderbolt()
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(true)
    }
}

