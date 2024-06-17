//
//  PostListViewModelTests.swift
//  TeletronincsAssessmentTests
//
//  Created by Lizan on 16/06/2024.
//

import XCTest
import Combine
import Network

class PostListViewModelTests: XCTestCase {

    var viewModel: PostListViewModel!
    var mockService: MockPostListService!
    var mockDataManager: MockCoreDataStack!
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Initialize dependencies
        
        mockService = MockPostListService()
        // Use in-memory store for testing, use the `persistantContainer2` for testing
        mockDataManager = MockCoreDataStack()
        
        viewModel = PostListViewModel()
        viewModel.dataManager = mockDataManager
        
        // Inject mock dependencies
        viewModel.fetchPostsWithAlbums(page: 1)  // Trigger setupNetworkMonitor
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        mockDataManager = nil
        cancellables.removeAll()
        try super.tearDownWithError()
    }

    // MARK: - Test Fetching Posts

    func testFetchPostsWithAlbumsFromRemote() throws {
        // Setup mock service response
        var picture = PictureModel()
        picture.id = "1"
        var user = User()
        user.username = "test user"
        picture.user = user
        let posts = [picture]
        mockService.posts = posts
        
        // Trigger fetch from remote
        viewModel.fetchPostsWithAlbums(page: 1)

        // Simulate successful fetch completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            // Expect postList to contain fetched posts
            XCTAssertEqual(self.viewModel.pictureList.count, posts.count)
            XCTAssertEqual(self.viewModel.pictureList.first?.first?.id, posts.first?.id)
        }
    }

    func testFetchPostsWithAlbumsFromCoreData() throws {
        // Setup mock data manager response
        var picture = PictureModel()
        picture.id = "1"
        var user = User()
        user.username = "test user"
        picture.user = user
        let posts = [picture]
        mockDataManager.posts = posts
        
        // Trigger fetch from Core Data
        viewModel.fetchPostsWithAlbums(page: 1)
        
        // Expect isLoading to be true initially
        XCTAssertNotNil(viewModel.isLoading)
        
        // Simulate successful fetch completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Expect postList to contain mapped posts
            XCTAssertEqual(self.viewModel.pictureList.count, posts.count)
            XCTAssertEqual(self.viewModel.pictureList.first?.first?.id, posts.first?.id)
        }
    }

    // MARK: - Mock Classes

    class MockPostListService: PostListService {

        var posts: [PictureModel] = []
        
        func fetchPhotos(page: Int) -> AnyPublisher<[PictureModel], ErrorHandler> {
            return Just([PictureModel]())
                .setFailureType(to: ErrorHandler.self)
                .eraseToAnyPublisher()
        }
        
        // Function to fetch posts for a given username
        func fetchPhotosWith(username: String) -> AnyPublisher<[PictureModel], ErrorHandler> {
            return Just([PictureModel]())
                .setFailureType(to: ErrorHandler.self)
                .eraseToAnyPublisher()
        }
    }

    class MockCoreDataStack: CoreDataStack {

        var posts: [PictureModel] = []

        override func saveContext() {
            // Mock saving context
        }
    }
}
