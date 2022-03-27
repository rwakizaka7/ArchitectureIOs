//
//  CollectionViewCell.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/03/27.
//

import Foundation
import UIKit

class CollectionViewCell<VC>: UICollectionViewCell {
    var collectionView: UICollectionView {
        get {
            return superview as! UICollectionView
        }
    }
    
    var vc: VC {
        get {
            return collectionView.superview!.next as! VC
        }
    }
    
    var indexPath: IndexPath {
        get {
            return collectionView.indexPath(for: self)!
        }
    }
}
