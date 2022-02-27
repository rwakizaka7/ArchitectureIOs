//
//  ViewUtils.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/27.
//

import Foundation
import UIKit

class ViewUtils {
    static func getParentTableViewCell(view: UIView) -> UITableViewCell! {
        var sv = view.superview
        
        while sv != nil && !(sv is UITableViewCell) {
            sv = sv!.superview
        }
        return sv as? UITableViewCell
    }
}
