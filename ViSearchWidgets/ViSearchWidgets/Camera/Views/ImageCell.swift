//
//  ImageCell.swift
import UIKit
import Photos

/// photo cell when loading images from photo library
class ImageCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = ViIcon.placeholder
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = ViIcon.placeholder
    }
    
    func configureWithModel(_ model: PHAsset) {
        
        if tag != 0 {
            PHImageManager.default().cancelImageRequest(PHImageRequestID(tag))
        }
        
        tag = Int(PHImageManager.default().requestImage(for: model, targetSize: contentView.bounds.size, contentMode: .aspectFill, options: nil) { image, info in
            self.imageView.image = image
        })
    }
}
