import XCTest
@testable import ChirkRoute
import CoreData

final class NebulProgressViewModelTests: XCTestCase {
    
    var viewModel: NebulProgressViewModel!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let persistenceController = PersistenceQuantumController(inMemory: true)
        testContext = persistenceController.container.viewContext
        viewModel = NebulProgressViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        testContext = nil
        super.tearDown()
    }
    
    func testLoadWeeklyProgress() {
        viewModel.loadWeeklyProgress()
        XCTAssertNotNil(viewModel.weeklyProgress)
    }
    
    func testWeeklyProgressCount() {
        viewModel.loadWeeklyProgress()
        XCTAssertEqual(viewModel.weeklyProgress.count, 7)
    }
    
    func testCurrentWeekProgressInitial() {
        viewModel.loadWeeklyProgress()
        XCTAssertGreaterThanOrEqual(viewModel.currentWeekProgress, 0.0)
        XCTAssertLessThanOrEqual(viewModel.currentWeekProgress, 1.0)
    }
    
    func testTotalWeeklyTasks() {
        viewModel.loadWeeklyProgress()
        XCTAssertGreaterThanOrEqual(viewModel.totalWeeklyTasks, 0)
    }
    
    func testCompletedWeeklyTasks() {
        viewModel.loadWeeklyProgress()
        XCTAssertGreaterThanOrEqual(viewModel.completedWeeklyTasks, 0)
    }
    
    func testGetProgressColorForZero() {
        let color = viewModel.getProgressColor(for: 0.0)
        XCTAssertNotNil(color)
    }
    
    func testGetProgressColorForHalf() {
        let color = viewModel.getProgressColor(for: 0.5)
        XCTAssertNotNil(color)
    }
    
    func testGetProgressColorForOne() {
        let color = viewModel.getProgressColor(for: 1.0)
        XCTAssertNotNil(color)
    }
    
    func testGetProgressColorForOverOne() {
        let color = viewModel.getProgressColor(for: 1.5)
        XCTAssertNotNil(color)
    }
    
    func testGetProgressGradient() {
        let gradient = viewModel.getProgressGradient()
        XCTAssertNotNil(gradient)
    }
    
    func testLoadWeeklyProgressMultipleTimes() {
        viewModel.loadWeeklyProgress()
        let firstProgress = viewModel.currentWeekProgress
        
        viewModel.loadWeeklyProgress()
        let secondProgress = viewModel.currentWeekProgress
        
        XCTAssertEqual(firstProgress, secondProgress)
    }
    
    func testDayProgressDataStructure() {
        viewModel.loadWeeklyProgress()
        
        for dayData in viewModel.weeklyProgress {
            XCTAssertNotNil(dayData.date)
            XCTAssertGreaterThanOrEqual(dayData.completedTasks, 0)
            XCTAssertGreaterThanOrEqual(dayData.totalTasks, 0)
            XCTAssertGreaterThanOrEqual(dayData.progress, 0.0)
            XCTAssertLessThanOrEqual(dayData.progress, 1.0)
            XCTAssertFalse(dayData.dayName.isEmpty)
        }
    }
    
    func testSelectedDayInitialValue() {
        XCTAssertNotNil(viewModel.selectedDay)
    }
    
    func testProgressCalculation() {
        viewModel.loadWeeklyProgress()
        
        if viewModel.totalWeeklyTasks > 0 {
            let expectedProgress = Float(viewModel.completedWeeklyTasks) / Float(viewModel.totalWeeklyTasks)
            XCTAssertEqual(viewModel.currentWeekProgress, expectedProgress, accuracy: 0.01)
        }
    }
}

final class ZephyrTaskViewModelTests: XCTestCase {
    
    var viewModel: ZephyrTaskViewModel!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let persistenceController = PersistenceQuantumController(inMemory: true)
        testContext = persistenceController.container.viewContext
        viewModel = ZephyrTaskViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        testContext = nil
        super.tearDown()
    }
    
    func testFetchTodayTasks() {
        viewModel.fetchTodayTasks()
        XCTAssertNotNil(viewModel.todayTasks)
    }
    
    func testTodayTasksInitialState() {
        XCTAssertTrue(viewModel.todayTasks.isEmpty)
    }
    
    func testShowingAddTaskInitialState() {
        XCTAssertFalse(viewModel.showingAddTask)
    }
    
    func testNewTaskTitleInitialState() {
        XCTAssertTrue(viewModel.newTaskTitle.isEmpty)
    }
    
    func testNewTaskPriorityInitialState() {
        XCTAssertEqual(viewModel.newTaskPriority, 1)
    }
    
    func testDailyProgressInitialState() {
        XCTAssertEqual(viewModel.dailyProgress, 0.0)
    }
    
    func testCompletedTasksCountInitialState() {
        XCTAssertEqual(viewModel.completedTasksCount, 0)
    }
    
    func testTotalTasksCountInitialState() {
        XCTAssertEqual(viewModel.totalTasksCount, 0)
    }
    
    func testRayAnimationsInitialState() {
        XCTAssertTrue(viewModel.rayAnimations.isEmpty)
    }
    
    func testGetPriorityColorForLow() {
        let color = viewModel.getPriorityColor(0)
        XCTAssertNotNil(color)
    }
    
    func testGetPriorityColorForMedium() {
        let color = viewModel.getPriorityColor(1)
        XCTAssertNotNil(color)
    }
    
    func testGetPriorityColorForHigh() {
        let color = viewModel.getPriorityColor(2)
        XCTAssertNotNil(color)
    }
    
    func testGetPriorityColorForInvalid() {
        let color = viewModel.getPriorityColor(999)
        XCTAssertNotNil(color)
    }
    
    func testGetPriorityTextForLow() {
        let text = viewModel.getPriorityText(0)
        XCTAssertEqual(text, "Low")
    }
    
    func testGetPriorityTextForMedium() {
        let text = viewModel.getPriorityText(1)
        XCTAssertEqual(text, "Medium")
    }
    
    func testGetPriorityTextForHigh() {
        let text = viewModel.getPriorityText(2)
        XCTAssertEqual(text, "High")
    }
    
    func testGetPriorityTextForInvalid() {
        let text = viewModel.getPriorityText(999)
        XCTAssertEqual(text, "Medium")
    }
    
    func testAddNewTaskWithEmptyTitle() {
        viewModel.newTaskTitle = ""
        viewModel.addNewTask()
        XCTAssertTrue(viewModel.todayTasks.isEmpty)
    }
    
    func testAddNewTaskWithWhitespaceOnly() {
        viewModel.newTaskTitle = "   "
        viewModel.addNewTask()
        XCTAssertTrue(viewModel.todayTasks.isEmpty)
    }
    
    func testUpdateDailyProgress() {
        viewModel.updateDailyProgress()
        XCTAssertGreaterThanOrEqual(viewModel.dailyProgress, 0.0)
        XCTAssertLessThanOrEqual(viewModel.dailyProgress, 1.0)
    }
    
    func testDailyProgressCalculation() {
        viewModel.fetchTodayTasks()
        
        if viewModel.totalTasksCount > 0 {
            let expectedProgress = Float(viewModel.completedTasksCount) / Float(viewModel.totalTasksCount)
            XCTAssertEqual(viewModel.dailyProgress, expectedProgress, accuracy: 0.01)
        } else {
            XCTAssertEqual(viewModel.dailyProgress, 0.0)
        }
    }
    
    func testFetchTodayTasksMultipleTimes() {
        viewModel.fetchTodayTasks()
        let firstCount = viewModel.todayTasks.count
        
        viewModel.fetchTodayTasks()
        let secondCount = viewModel.todayTasks.count
        
        XCTAssertEqual(firstCount, secondCount)
    }
}

