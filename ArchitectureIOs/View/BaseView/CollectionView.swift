//
//  CollectionView.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/03/30.
//

import Foundation
import UIKit

class CollectionView: UICollectionView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
