//
//  PostDetailsViewController.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var pictureList: [PictureModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the view when loaded
        self.setupTableView()  // Set up the table view to display images
        setupViews()  // Set up other views like title and description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "PostDetails"
    }
    
    @IBAction func popBackAction(_ sender: Any) {
        // Navigate back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        // Set the title and description of the post
        let user = pictureList?.first?.user
        self.usernameLabel.text = "@\(user?.username ?? "") ♥ Likes: \(user?.total_likes ?? 0)"
        self.postTitle.text = user?.name
        self.postDescription.text = user?.bio
        
        // Apply shadow and corner radius to the title container view
        titleContainer.addShadowAndCorner(radius: 8)
    }
    
    private func setupTableView() {
        // Register the custom table view cell for displaying post images
        tableView.accessibilityIdentifier = "PostDetailsViewController.tableView"
        tableView.register(UINib.init(nibName: "PostImagesTableViewCell", bundle: nil), forCellReuseIdentifier: "PostImagesTableViewCell")
        // Set the data source and delegate to self
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of photos in the album; if album or photos are nil, return 0
        return pictureList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and configure the cell for displaying post images
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImagesTableViewCell", for: indexPath) as! PostImagesTableViewCell
        cell.accessibilityIdentifier = "PostImagesTableViewCell_\(indexPath.row)"
        cell.configureCell(pictureList?[indexPath.row], indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection of a row (image) in the table view
        let coordinator = ImagePreviewCoordinator.init(navigationController: self.navigationController, pictureModel: self.pictureList?[indexPath.row])
        coordinator.start()
    }
}
