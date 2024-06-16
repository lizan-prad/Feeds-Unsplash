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
        let posts = [Post(id: 1, userId: 1, title: "Test Post 1", body: "Body of Test Post 1", album: nil)]
        mockService.posts = posts
        
        // Trigger fetch from remote
        viewModel.fetchPostsWithAlbums(page: 1)
        
        // Expect isLoading to be true initially
        XCTAssertTrue(viewModel.isLoading)
        
        // Simulate successful fetch completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Expect isLoading to be false after completion
            XCTAssertFalse(self.viewModel.isLoading)
            
            // Expect postList to contain fetched posts
            XCTAssertEqual(self.viewModel.postList.count, posts.count)
            XCTAssertEqual(self.viewModel.postList.first?.title, posts.first?.title)
        }
    }

    func testFetchPostsWithAlbumsFromCoreData() throws {
        // Setup mock data manager response
        let posts = [Post(id: 1, userId: 1, title: "Test Post 1", body: "Body of Test Post 1")]
        mockDataManager.posts = posts
        
        // Trigger fetch from Core Data
        viewModel.fetchPostsWithAlbums(page: 1)
        
        // Expect isLoading to be true initially
        XCTAssertTrue(viewModel.isLoading)
        
        // Simulate successful fetch completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Expect isLoading to be false after completion
            XCTAssertFalse(self.viewModel.isLoading)
            
            // Expect postList to contain mapped posts
            XCTAssertEqual(self.viewModel.postList.count, posts.count)
            XCTAssertEqual(self.viewModel.postList.first?.title, posts.first?.title)
        }
    }

    // MARK: - Mock Classes

    class MockPostListService: PostListService {

        var posts: [Post] = []
        var albums: [Album] = []
        var photos: [Photo] = []

        func fetchPosts(page: Int) -> AnyPublisher<[Post], ErrorHandler> {
            return Just(posts)
                .setFailureType(to: ErrorHandler.self)
                .eraseToAnyPublisher()
        }

        func fetchAlbums(userId: String) -> AnyPublisher<[Album], ErrorHandler> {
            return Just(albums)
                .setFailureType(to: ErrorHandler.self)
                .eraseToAnyPublisher()
        }

        func fetchPhotos(albumId: String) -> AnyPublisher<[Photo], ErrorHandler> {
            return Just(photos)
                .setFailureType(to: ErrorHandler.self)
                .eraseToAnyPublisher()
        }
    }

    class MockCoreDataStack: CoreDataStack {

        var posts: [Post] = []

        override func saveContext() {
            // Mock saving context
        }
    }
}
