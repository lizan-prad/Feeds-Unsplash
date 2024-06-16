//
//  ImagePreviewViewController.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var cancellables = Set<AnyCancellable>()  // Stores cancellables for Combine subscriptions
    
    var photo: Photo?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.accessibilityIdentifier = "FullPreviewImageView"
        self.setupViews()  // Setup initial views
        self.loadImage(URL(string: photo?.url ?? ""))  // Load image from the provided URL
    }
    
    private func setupViews() {
        self.photoTitle.text = photo?.title  // Set the photo title label
    }
    
    private func loadImage(_ imageUrl: URL?) {
        // Retrieve image from the URL using ImageManager shared instance
        guard let imageUrl = imageUrl else { return }
        
        ImageManager.shared.loadImage(from: imageUrl)  // Load image using ImageManager
            .sink { [weak self] image in
                guard let self = self else { return }
                self.imageView.image = image  // Set the loaded image to the imageView
            }
            .store(in: &cancellables)
    }

    // Dismiss the view controller
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
