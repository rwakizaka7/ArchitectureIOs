//
//  WebApiCallingTestViewController.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/01/13.
//

import Foundation
import UIKit

class WebApiCallingTestVCApiTableViewCell: UITableViewCell, PVCellCornerViewHighlight {
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var _textLabel: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        updateBackground(highlighted: highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        updateBackground(highlighted: selected, animated: animated)
    }
}

class WebApiCallingTestViewController: LinkViewController<WebApiCallingTestVCModel> {
    typealias S = WebApiCallingTestVCMenuTableSection
    
    @IBOutlet weak var apiTableView: UITableView!
    
    var sections: [S] = []
    
    var selectionIndexPath: IndexPath!
    
    let sectionHeaderHeight: CGFloat = 45
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            sections = params["sections"] as? [S] ?? []
        case .cellUnselection:
            if let indexPath = selectionIndexPath {
                selectionIndexPath = nil
                apiTableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiTableView.delegate = self
        apiTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = selectionIndexPath {
            selectionIndexPath = nil
            apiTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionIndexPath = indexPath
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "WebApiCallingTestVCApiTableViewCell", for: indexPath)
            as! WebApiCallingTestVCApiTableViewCell
        cell._textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
}
