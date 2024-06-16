//
//  PostListViewControllerUITests.swift
//  TeletronincsAssessmentUITests
//
//  Created by Lizan on 16/06/2024.
//

import XCTest

// `PostListViewModel` self.savePostsWithAlbumsAndPhotos(posts: posts)  // comment when performing `UITests`
final class PostListViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    var viewController: PostListViewController!
    var mockViewModel: PostListViewModel!
    var mockCoreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        // Ensure the storyboard is loaded from the correct bundle
        let storyboard = UIStoryboard(name: "PostList", bundle: Bundle(for: PostListViewController.self))
        
        // Instantiate the view controller from the storyboard
        viewController = storyboard.instantiateViewController(withIdentifier: "PostListViewController") as? PostListViewController
        // Initialize the mock Core Data stack
        mockCoreDataStack = CoreDataStack.shared
        
        // Inject the mock Core Data stack into the view model
        mockViewModel = PostListViewModel()
        mockViewModel.dataManager = mockCoreDataStack
        viewController.viewModel = mockViewModel
        // Load the view hierarchy
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockCoreDataStack = nil
        super.tearDown()
    }

    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testViewExists() throws {
        // Check if the table view exists
        XCTAssertNotNil(viewController.tableView)
        
        // Check if the loading view is initially hidden
        XCTAssertNotNil(viewController.loadingView)
    }
    
    func testPostListFlow() throws {
        // Assuming we land on the PostListViewController first upon launch
        
        // Check if the table view exists
        let postListTableView = app.tables["PostListViewController.tableView"]
        XCTAssertTrue(postListTableView.exists)
        
        // Check if the loading view is initially waiting
        let loadingView = app.otherElements["PostListViewController.loadingView"]
        XCTAssertTrue(loadingView.exists)
        
        // Test tapping on a post cell to navigate to details
        let firstPostCell = postListTableView.cells.element(matching: .cell, identifier: "PostTableViewCell_0")
        XCTAssertTrue(firstPostCell.waitForExistence(timeout: 30))  // fetch api call
        firstPostCell.tap()
        
        // Wait for the details view controller to appear
        let imagePreviewView = app.images["FullPreviewImageView"]
        XCTAssertTrue(imagePreviewView.waitForExistence(timeout: 5))
        
        // Navigate back to the list
        app.buttons.element(boundBy: 0).tap()
    
    }
    
    func testPostDetailsFlow() throws {
        // Assuming we land on the PostListViewController first upon launch
        
        // Check if the table view exists
        let postListTableView = app.tables["PostListViewController.tableView"]
        XCTAssertTrue(postListTableView.exists)
        
        let firstPostCell = postListTableView.cells.element(matching: .cell, identifier: "PostTableViewCell_0")
        XCTAssertTrue(firstPostCell.waitForExistence(timeout: 20))
        
        // Test tapping on a post cell to navigate to details
        let showMoreButton = firstPostCell.descendants(matching: .button)["showMoreButton"]
        XCTAssertTrue(showMoreButton.waitForExistence(timeout: 5))
        
        showMoreButton.tap()
        
        let postDetailsTableView = app.tables["PostDetailsViewController.tableView"]
        XCTAssertTrue(postDetailsTableView.exists)
        
        let firstPostDetailsCell = postDetailsTableView.cells.element(matching: .cell, identifier: "PostImagesTableViewCell_0")
        XCTAssertTrue(firstPostDetailsCell.waitForExistence(timeout: 5))
        
        firstPostDetailsCell.tap()
    }
    
}
