//
//  PostDetailsCoordinator.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit

class PostDetailsCoordinator {
    private var navigationController: UINavigationController?
    private var postModel: Post?
    
    init(navigationController: UINavigationController?, postModel: Post?) {
        self.navigationController = navigationController
        self.postModel = postModel
    }
    
    func start() {
        // Instantiate `PostDetailsViewController` from storyboard
        let postDetailsViewController = UIStoryboard(name: "PostDetails", bundle: nil)
            .instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        
        // Pass the postModel to the `PostDetailsViewController`
        postDetailsViewController.post = self.postModel
        
        // Hide the navigation bar for this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Push the `PostDetailsViewController` onto the navigation stack
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
}
