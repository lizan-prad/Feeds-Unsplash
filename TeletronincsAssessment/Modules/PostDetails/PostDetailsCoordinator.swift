//
//  PostDetailsCoordinator.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit

class PostDetailsCoordinator {
    private var navigationController: UINavigationController?
    private var pictureList: [PictureModel]?
    
    init(navigationController: UINavigationController?, pictureList: [PictureModel]?) {
        self.navigationController = navigationController
        self.pictureList = pictureList
    }
    
    func start() {
        // Instantiate `PostDetailsViewController` from storyboard
        let postDetailsViewController = UIStoryboard(name: "PostDetails", bundle: nil)
            .instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        
        // Pass the postModel to the `PostDetailsViewController`
        postDetailsViewController.pictureList = self.pictureList
        
        // Hide the navigation bar for this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Push the `PostDetailsViewController` onto the navigation stack
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
}
