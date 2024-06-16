//
//  PostImagesTableViewCell.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine

class PostImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var containerVIew: UIView!
    
    private var cancellables = Set<AnyCancellable>()
    
    // Configure the views and data for the cell
    func configureCell(_ album: Album?,_ index: Int) {
        self.albumTitle.text = album?.title
        self.postTitle.text = album?.photos?[index].title
        self.loadImage(URL.init(string: album?.photos?[index].url ?? ""))
        setupViews()
    }
    
    private func setupViews() {
        self.containerVIew.addShadowAndCorner(radius: 12)
    }
    
    func loadImage(_ imageUrl: URL?) {
        // Setting up `postImage` UI attributes
        self.postImageView.clipsToBounds = true
        self.postImageView.layer.cornerRadius = 5
        
        // Retriving image from `URL` or `cache`
        guard let imageUrl = imageUrl else { return }
        
        ImageManager.shared.loadImage(from: imageUrl)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.postImageView.image = image
            }
            .store(in: &cancellables)
    }
}
