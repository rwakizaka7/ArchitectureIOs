//
//  TableViewCellTest1ViewController.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/19.
//

import Foundation
import UIKit

class TableViewCellTest1VCFilteringTableViewCell:
    TableViewCell<TableViewCellTest1ViewController>,
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

class TableViewCellTest1ViewController: LinkViewController<TableViewCellTest1VCModel> {
    typealias S = TableViewCellTest1VCMenuTableSection
    
    @IBOutlet weak var filteringTableView: UITableView!
    
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
                let cell = filteringTableView.cellForRow(at: indexPath)
                    as! TableViewCellTest1VCFilteringTableViewCell
                cell.updateBackground(highlighted: false, animated: animated)
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let frame = navigationController?.navigationBar.bounds {
            let searchBar = { () -> UISearchBar in
                let searchBar = UISearchBar(frame: frame)
                searchBar.placeholder = "タイトルで探す"
                searchBar.tintColor = UIColor.gray
                searchBar.keyboardType = UIKeyboardType.default
                return searchBar
            }()
            
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = frame
        }
        
        filteringTableView.delegate = self
        filteringTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = selectionIndexPath {
            selectionIndexPath = nil
            filteringTableView.deselectRow(at: indexPath, animated: true)
        }
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
            withIdentifier: "TableViewCellTest1VCFilteringTableViewCell", for: indexPath)
            as! TableViewCellTest1VCFilteringTableViewCell
        cell._textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
}
