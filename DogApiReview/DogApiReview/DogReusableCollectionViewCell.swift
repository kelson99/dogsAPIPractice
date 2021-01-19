//
//  DogReusableCollectionViewCell.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/18/21.
//

import UIKit

class DogReusableCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
        imageView.image = #imageLiteral(resourceName: "Skull")
        
        super.prepareForReuse()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
}
