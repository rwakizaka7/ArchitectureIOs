//
//  TableViewCell.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/27.
//

import Foundation
import UIKit

class TableViewCell<VC>: UITableViewCell {
    var tableView: UITableView {
        get {
            return superview as! UITableView
        }
    }
    
    var vc: VC {
        get {
            return tableView.superview!.next as! VC
        }
    }
    
    var indexPath: IndexPath {
        get {
            return tableView.indexPath(for: self)!
        }
    }
}
