//
//  TableView.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/27.
//

import Foundation
import UIKit

class TableView: UITableView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
//            if let cell = ViewUtils.getParentTableViewCell(view: view)
//                as? PVCellCornerViewHighlight {
//                cell.updateBackground(highlighted: false, animated: false)
//            }

            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
