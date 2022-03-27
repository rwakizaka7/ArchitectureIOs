//
//  WebApiCallingTestViewController.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/01/13.
//

import Foundation
import UIKit

class WebApiCallingTestVCApiTableViewCell:
    TableViewCell<WebApiCallingTestViewController>,
    PVCellCornerViewHighlight {
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var cornerViewButton: UIButton!
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
            vc.tableView(tableView, didSelectItemOfRowAt: indexPath)
            updateBackground(highlighted: false, animated: true)
        default:
            break
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}

class WebApiCallingTestViewController: LinkViewController<WebApiCallingTestVCModel> {
    typealias S = WebApiCallingTestVCMenuTableSection
    
    @IBOutlet weak var apiTableView: UITableView!
    
    var sections: [S] = []
    
    var selectionIndexPath: IndexPath!
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            sections = params["sections"] as? [S] ?? []
        case .selectionResetting:
            let animated = params["animated"] as? Bool ?? false
            
            if let indexPath = selectionIndexPath {
                selectionIndexPath = nil
                let cell = apiTableView.cellForRow(at: indexPath)
                    as! WebApiCallingTestVCApiTableViewCell
                cell.updateBackground(highlighted: false, animated: animated)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectItemOfRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
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
            withIdentifier: "WebApiCallingTestVCApiTableViewCell", for: indexPath)
            as! WebApiCallingTestVCApiTableViewCell
        cell._textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
}
