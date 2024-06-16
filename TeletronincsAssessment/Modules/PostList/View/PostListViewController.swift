//
//  PostListViewController.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine

class PostListViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PostListViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostListViewModel()
        setupAccessibility()
        setupTableView()
        setupBindings()
        viewModel.fetchPostsWithAlbums(page: 1)
        setupViews()
    }
    
    private func setupAccessibility() {
        tableView.accessibilityIdentifier = "PostListViewController.tableView"
        loadingView.accessibilityIdentifier = "PostListViewController.loadingView"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show navigation bar and set title
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Feeds"
    }
    
    private func setupViews() {
        // Setup navigation bar for large titles and customize loading view
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        loadingView.addCornerRadius(8)
    }
    
    private func setupBindings() {
        // Bind `isLoading` to `loadingView.isHidden` to show/hide loading indicator
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loadingView.isHidden = !isLoading
            }
            .store(in: &cancellables)
        
        // Bind `postList` to `tableView.reloadData()` to update table view content
        viewModel.$postList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Bind `errorMessage` to `showError()` to display error alerts
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showError(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        // Register table view cell and set dataSource and delegate
        tableView.register(UINib.init(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func showError(message: String) {
        // Show alert with error message
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func openPostDetails(_ post: Post?) {
        // Navigate to post details view
        let coordinator = PostDetailsCoordinator(navigationController: self.navigationController, postModel: post)
        coordinator.start()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of posts in viewModel
        return viewModel.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure cell with post data
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        let post = viewModel.postList[indexPath.row]
        cell.accessibilityIdentifier = "PostTableViewCell_\(indexPath.row)"
        cell.configure(with: post)
        
        // Handle cell's `showMoreSubject` to open post details
        cell.showMoreSubject
            .sink { [weak self] post in
                self?.openPostDetails(post)
            }
            .store(in: &cancellables)
        
        // Handle cell's `photoTapSubject` to show image preview
        cell.photoTapSubject
            .sink { [weak self] photo in
                let coordinator = ImagePreviewCoordinator(navigationController: self?.navigationController, photoModel: photo)
                coordinator.start()
            }
            .store(in: &cancellables)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Fetch more posts when reaching the end of the table view
        if indexPath.row == viewModel.postList.count - 1 {
            viewModel.fetchPostsWithAlbums(page: (viewModel.postList.count / 10) + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open post details when a row is selected
        self.openPostDetails(self.viewModel.postList[indexPath.row])
    }
}
