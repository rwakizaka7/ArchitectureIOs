//
//  PVCellCornerViewHighlight.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/05/16.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

protocol PVCellCornerViewHighlight {
    var cornerView: UIView! { get }
}

extension PVCellCornerViewHighlight {
    func updateBackground(highlighted: Bool, animated: Bool) {
        let highlightedAlpha: CGFloat = 0.3
        
        let animations = {
            if !highlighted  {
                self.cornerView.backgroundColor = .secondarySystemBackground
            } else {
                self.cornerView.backgroundColor = .secondarySystemBackground
                    .withAlphaComponent(highlightedAlpha)
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: animations)
        } else {
            animations()
        }
    }
}
