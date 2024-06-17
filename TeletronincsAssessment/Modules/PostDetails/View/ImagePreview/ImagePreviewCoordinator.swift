//
//  ImagePreviewCoordinator.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit

class ImagePreviewCoordinator {
    private var navigationController: UINavigationController?
    private var pictureModel: PictureModel?
    
    init(navigationController: UINavigationController?, pictureModel: PictureModel?) {
        self.navigationController = navigationController  // Initialize with the provided navigation controller
        self.pictureModel = pictureModel  // Initialize with the provided photo model
    }
    
    func start() {
        // Instantiate the ImagePreviewViewController from the storyboard
        let imagePreviewViewController = UIStoryboard.init(name: "ImagePreview", bundle: nil).instantiateViewController(withIdentifier: "ImagePreviewViewController") as! ImagePreviewViewController
        
        imagePreviewViewController.pictureModel = self.pictureModel  // Pass the photo model to the image preview view controller
        
        // Present the image preview view controller modally
        self.navigationController?.present(imagePreviewViewController, animated: true)
    }
}
