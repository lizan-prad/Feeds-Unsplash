//
//  PostImageCollectionViewCell.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine

class PostImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shownMoreBtn: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    
    private var cancellables = Set<AnyCancellable>()
    var buttonTapSubject: (() -> ())?  // Subject to handle button tap events
    var imageUrl: URL?
    
    func setupShowMoreButton(_ indexPath: IndexPath, _ count: Int) {
        // Setup 'Show More' button based on indexPath and count
        self.shownMoreBtn.isHidden = indexPath.row != 7
        self.shownMoreBtn.accessibilityIdentifier = "showMoreButton"
        self.shownMoreBtn.addCornerRadius(5)
        self.shownMoreBtn.setTitle("+\(count)", for: .normal)  // Set title to display count
    }
    
    func loadImage() {
        // Configure `postImage` UI attributes
        self.postImage.clipsToBounds = true
        self.postImage.layer.cornerRadius = 5
        
        // Load image from URL using `ImageManager`
        guard let imageUrl = imageUrl else { return }  // Ensure `imageUrl` is not nil
        
        ImageManager.shared.loadImage(from: imageUrl)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.postImage.image = image  // Set the loaded image to `postImage`
            }
            .store(in: &cancellables)
    }
    
    @IBAction func showMoreAction(_ sender: Any) {
        // Handle 'Show More' button tap
        self.buttonTapSubject?()  // Send event to the subject
    }
}
