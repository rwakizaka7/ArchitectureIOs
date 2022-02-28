//
//  VerificationMenuViewController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/05/15.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class VerificationMenuVCMenuTableViewCell: TableViewCell<VerificationMenuViewController>,
    PVCellCornerViewHighlight {
    
    @IBOutlet weak var cornerViewButton: UIButton!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var _textLabel: UILabel!
    
    @IBAction func touchDown(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button {
        case cornerViewButton:
            updateBackground(highlighted: true, animated: false)
            vc.selectionIndexPath = indexPath
        default:
            break
        }
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button {
        case cornerViewButton:
            vc.tableView(tableView, didSelectRowItemAt: indexPath)
        default:
            break
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        //updateBackground(highlighted: highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //updateBackground(highlighted: selected, animated: animated)
    }
}

class VerificationMenuViewController: LinkViewController<VerificationMenuVCModel> {
    typealias S = VerificationMenuVCMenuTableSection
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var sections: [S] = []
    
    var selectionIndexPath: IndexPath!
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            sections = params["sections"] as? [S] ?? []
        case .viewResetting:
            let animated = params["animated"] as? Bool ?? false
            
            if let indexPath = selectionIndexPath {
                selectionIndexPath = nil
                let cell = menuTableView.cellForRow(at: indexPath)
                    as! VerificationMenuVCMenuTableViewCell
                cell.updateBackground(highlighted: false, animated: animated)
                //menuTableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowItemAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section].title
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.textLabel?.text = sections[section].title
        //view.contentView.backgroundColor = .orange
        return view
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "VerificationMenuVCMenuTableViewCell", for: indexPath)
            as! VerificationMenuVCMenuTableViewCell
        cell._textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
}
