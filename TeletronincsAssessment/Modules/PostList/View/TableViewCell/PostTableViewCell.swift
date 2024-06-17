//
//  PostTableViewCell.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine

// Custom `UICollectionView` subclass to adjust `intrinsicContentSize` based on `contentSize` changes
class ContentSizeCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            // Invalidate intrinsic content size whenever content size changes
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        // Return the intrinsic content size based on current contentSize
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var collectionView: ContentSizeCollectionView!
    
    // Subjects to communicate cell events to the outside
    var showMoreSubject: (([PictureModel]?) -> ())?
    private var initialCollectionViewWidth: CGFloat?
    let photoTapSubject = PassthroughSubject<PictureModel?, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var pictureList: [PictureModel]?
    
    func configure(with pictureList: [PictureModel]) {
        // Configure the cell with post data
        let user = pictureList.first?.user
        self.pictureList = pictureList
        self.titleLabel.text = user?.name
        self.bodyLabel.text = "@\(user?.username ?? ""), \(user?.location ?? "")"
        setupViews()
        self.loadImage(user)
        setupCollectionView()
        collectionView.reloadData()// Reload the collection view
    }
    
    func loadImage(_ user: User?) {
        // Load image from URL using `ImageManager`
        guard let imageUrl = URL.init(string: user?.profile_image?.medium ?? "") else { return }  // Ensure `imageUrl` is not nil
        ImageManager.shared.loadImage(from: imageUrl)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.profilePicture.image = image  // Set the loaded image to `postImage`
            }
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.image = nil  // Reset the image
        cancellables.removeAll()  // Cancel any ongoing image load operations
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set accessibility identifier for the collection view
        collectionView.accessibilityIdentifier = "postCollectionView"
        
    }
    
    private func setupViews() {
        // Configure `postImage` UI attributes
        self.profilePicture.clipsToBounds = true
        self.profilePicture.addCornerRadius(20)
        
        // Apply styling to `containerView`
        self.containerView.addShadowAndCorner(radius: 12)
    }
    
    private func setupCollectionView() {
        // Configure `collectionView` properties and register cell nib
        collectionView.layer.cornerRadius = 8
        collectionView.register(UINib(nibName: "PostImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostImageCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PostTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Limit to maximum 8 photos or the available number of photos
        return (pictureList?.count ?? 0) >= 8 ? 8 : (pictureList?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure each cell in collectionView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        cell.accessibilityIdentifier = "PostImageCollectionViewCell_\(indexPath.row)"
        cell.setupShowMoreButton(indexPath, (self.pictureList?.count ?? 0) - 8)
        cell.imageUrl = URL(string: self.pictureList?[indexPath.row].urls?.regular ?? "")
        cell.loadImage()
        
        // Handle button tap to trigger `showMoreSubject`
        cell.buttonTapSubject = { [weak self] in
            self?.showMoreSubject?(self?.pictureList)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust item size based on the number of items per row
        let item = indexPath.item
        let padding: CGFloat = 5
        var width: CGFloat = 0
        // To maintain the `collectionViewLayout`
        if self.initialCollectionViewWidth == nil {
            self.initialCollectionViewWidth = collectionView.bounds.size.width
            width = collectionView.bounds.size.width
        } else {
            width = self.initialCollectionViewWidth ?? 0
        }
        
        if item < 2 {
            // Two items per row
            let itemWidth: CGFloat = (width - padding) / 2.0
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            // Three items per row
            let itemWidth: CGFloat = floor((width - 2 * padding) / 3.0)
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Trigger `photoTapSubject` when a photo is tapped (excluding the last item if it's the 'Show More' button)
        if indexPath.row != 7 {
            self.photoTapSubject.send(self.pictureList?[indexPath.row])
        }
    }
}
