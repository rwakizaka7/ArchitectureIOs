//
//  TableViewCellTest1ViewController.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/19.
//

import Foundation
import UIKit

class TableViewCellTest1VCApiTableViewCell: UITableViewCell, PVCellCornerViewHighlight {
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var _textLabel: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        updateBackground(highlighted: highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        updateBackground(highlighted: selected, animated: animated)
    }
}

class TableViewCellTest1ViewController: LinkViewController<TableViewCellTest1VCModel> {
    typealias S = TableViewCellTest1VCMenuTableSection
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections: [S] = []
    
    var selectionIndexPath: IndexPath!
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            sections = params["sections"] as? [S] ?? []
        case .cellUnselection:
            if let indexPath = selectionIndexPath {
                selectionIndexPath = nil
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = selectionIndexPath {
            selectionIndexPath = nil
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionIndexPath = indexPath
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
            withIdentifier: "TableViewCellTest1VCApiTableViewCell", for: indexPath)
            as! TableViewCellTest1VCApiTableViewCell
        cell._textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
}
