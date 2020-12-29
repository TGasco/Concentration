//
//  CollectionViewCell.swift
//  Concentration
//
//  Created by Thomas Gascoyne on 25/11/2020.
//


import UIKit
//Class creates custom Collection View Cell for re-use
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImage: UIImageView!
    
    static let identifier = "cell"

    //Dequeues cell without having to access imageView directly
    public func configure(with image: UIImage) {
        cardImage.image = image
    }
    
}


