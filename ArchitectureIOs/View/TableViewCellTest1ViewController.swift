//
//  TableViewCellTest1ViewController.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/19.
//

import Foundation
import UIKit

class TableViewCellTest1VCFilteringTableViewCell1:
    TableViewCell<TableViewCellTest1ViewController>,
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

class TableViewCellTest1VCFilteringTableViewCell2:
    TableViewCell<TableViewCellTest1ViewController> {
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var _space1View: UIView!
    @IBOutlet weak var _titleLabelView: UIView!
    @IBOutlet weak var _space2View: UIView!
    @IBOutlet weak var _titleTextFieldView: UIView!
    @IBOutlet weak var _space3View: UIView!
    @IBOutlet weak var _buttonView: UIView!
    @IBOutlet weak var _space4View: UIView!
    
    var space1View: UIView!
    var titleLabelView: UIView!
    var space2View: UIView!
    var titleTextFieldView: UIView!
    var space3View: UIView!
    var buttonView: UIView!
    var space4View: UIView!
    
    var returnButton: UIButton!
    var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        space1View = _space1View
        titleLabelView = _titleLabelView
        space2View = _space2View
        titleTextFieldView = _titleTextFieldView
        space3View = _space3View
        buttonView = _buttonView
        space4View = _space4View
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button {
        case returnButton:
            vc.sendAction(.touchUpInside, params: [
                "button_id":"filtering_table_view_cell_return_button",
                "index_path":indexPath])
        case closeButton:
            vc.sendAction(.touchUpInside, params: [
                "button_id":"filtering_table_view_cell_close_button",
                "index_path":indexPath])
        default:
            break
        }
    }
}

class TableViewCellTest1ViewController: LinkViewController<TableViewCellTest1VCModel>,
                                        PVScrollPositonAdjustable {
    typealias S = TableViewCellTest1VCMenuTableSection
    
    @IBOutlet weak var filteringTableView: UITableView!
    
    lazy var searchTextField: UITextField = {
        let frame = navigationController!.navigationBar.bounds
        let searchBar = { () -> UISearchBar in
            let searchBar = UISearchBar(frame: frame)
            searchBar.placeholder = "タイトルで探す"
            searchBar.tintColor = UIColor.gray
            searchBar.keyboardType = UIKeyboardType.default
            searchBar.returnKeyType = .done
            return searchBar
        }()
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = frame
        
        let textField = searchBar.searchTextField
        textField.delegate = self
        return textField
    }()
    
    var sections: [S] = []
    var selectionIndexPath: IndexPath!
    
    var adjustmentScrollView: UIScrollView {
        get {
            return filteringTableView
        }
    }
    
    var positionAdjustmentState: PVScrollPositionAdjustmentEntity {
        get {
            return PVScrollPositionAdjustmentEntity(
                scrollFocusTargets: scrollFocusTargets,
                initialContentOffsetY: initialContentOffsetY,
                previousContentHeight: previousContentHeight)
        }
        set(p) {
            initialContentOffsetY = p.initialContentOffsetY
            previousContentHeight = p.previousContentHeight
        }
    }
    
    var scrollFocusTargets: [PVScrollFocusTargetEntity] {
        return filteringTableView.visibleCells.compactMap {
            cell -> PVScrollFocusTargetEntity? in
            
            if let cell = cell as? TableViewCellTest1VCFilteringTableViewCell2 {
                let textField = getTextField(cell: cell, tableView: filteringTableView, indexPath: cell.indexPath)
                return PVScrollFocusTargetEntity(
                    focusView: textField, cellFrameMaxY: cell.frame.maxY, adjustment: 0)
            }
            
            return nil
        }
    }
    var initialContentOffsetY: CGFloat!
    var previousContentHeight: CGFloat!
    
    override var textFields: [UITextField] {
        var textFields = [searchTextField]
        textFields.append(contentsOf:filteringTableViewCellTextFields.keys.sorted().map ({
            return filteringTableViewCellTextFields[$0]!
        }))
        return textFields
    }
    
    var filteringTableViewCellTextFields: [IndexPath:UITextField] = [:]
    
    override var testFieldShouldChangeCharacters: [UITextField: (String, Bool) -> Bool] {
        var textFields: [UITextField: (String, Bool) -> Bool] = [searchTextField: {
            [weak self] (text, clearing) -> Bool in
            guard let self = self else {
                return false
            }

            if clearing {
                self.sendAction(.touchUpInside, params: ["button_id":"search_clearing_button"])
                return false
            }
            
            self.sendAction(.textFieldEditing, params: ["text_id":"search_text_field", "text":text])
            return true
        }]
        
        let shouldChangeCharacters = filteringTableViewCellTextFieldShouldChangeCharacters.values
        
        shouldChangeCharacters.forEach {
            e in
            textFields[e.textField] = e.scc
        }

        return textFields
    }
    
    var filteringTableViewCellTextFieldShouldChangeCharacters:
        [IndexPath:(textField: UITextField, scc: (String, Bool) -> Bool)] = [:]
    
    override var textFieldFocusChangeList: [UITextField] {
        return textFields
    }
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            if let _sections = params["sections"] as? [S] {
                sections = _sections
            }
            
            if let text = params["search_text_field"] as? String {
                searchTextField.text = text
            }
        case .resignFirstResponder:
            if let _ = params["search_text_field"] as? String {
                searchTextField.resignFirstResponder()
            }
        case .reloadData:
            if let _ = params["filtering_table_view"] as? String {
                filteringTableView.reloadData()
            }
        case .reloadRows:
            guard let indexPaths = params["index_paths"] as? [IndexPath],
                let rowAnimation = params["row_animation"] as? RowAnimation else {
                return
            }
            
            filteringTableView.reloadRows(at: indexPaths, with: rowAnimation)
        case .selectionResetting:
            let animated = params["animated"] as? Bool ?? false
            
            if let indexPath = selectionIndexPath,
               let cell = filteringTableView.cellForRow(at: indexPath)
                   as? TableViewCellTest1VCFilteringTableViewCell1 {
                selectionIndexPath = nil
                cell.updateBackground(highlighted: false, animated: animated)
            }
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteringTableView.delegate = self
        filteringTableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectItemOfRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)

        let cellInfo = sections[indexPath.section].cells[indexPath.row]
        if cellInfo.status == .editing {
            if let cell = cell as? TableViewCellTest1VCFilteringTableViewCell2 {
                let textField = getTextField(cell: cell, tableView: tableView, indexPath: indexPath)
                filteringTableViewCellTextFields[indexPath] = textField
                filteringTableViewCellTextFieldShouldChangeCharacters[indexPath] = (
                    textField: textField, scc: {
                        [weak self] (text, _) -> Bool in
                        guard let self = self else {
                            return false
                        }
                        self.sendAction(.textFieldEditing, params: [
                            "text_id":"filtering_table_view_cell_title_text_field",
                            "index_path":indexPath, "text":text])
                        return true
                })
            }
        }
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        
        if let cell = cell as? TableViewCellTest1VCFilteringTableViewCell2 {
            let textField = getTextField(cell: cell, tableView: tableView, indexPath: indexPath)
            
            // 抽出時に削除できるようにインスタンスで索引して削除する。
            filteringTableViewCellTextFields = filteringTableViewCellTextFields.filter({
                $0.value != textField
            })
            filteringTableViewCellTextFieldShouldChangeCharacters
                = filteringTableViewCellTextFieldShouldChangeCharacters.filter({
                    $0.value.textField != textField
                })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = sections[indexPath.section].cells[indexPath.row]
        switch cellInfo.status {
        case .normal:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TableViewCellTest1VCFilteringTableViewCell1", for: indexPath)
                as! TableViewCellTest1VCFilteringTableViewCell1
            cell.cornerView.layer.cornerRadius = 8
            cell.cornerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner]
            cell._textLabel?.text = cellInfo.title
            
            return cell
        case .editing:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TableViewCellTest1VCFilteringTableViewCell2", for: indexPath)
                as! TableViewCellTest1VCFilteringTableViewCell2
            
            cell.stackView.subviews.forEach {
                $0.removeFromSuperview()
            }

            cell.stackView.addArrangedSubview({
                let view = Utils.copy(cell.space1View)!
                view.tag = 1
                return view
            }())
            cell.stackView.addArrangedSubview({
                let titleLabelView = Utils.copy(cell.titleLabelView)!
                titleLabelView.tag = 2
                let titleLabel = titleLabelView.subviews.filter ({
                    $0.tag == 1
                }).first! as! UILabel
                titleLabel.text = cellInfo.title
                return titleLabelView
            }())
            cell.stackView.addArrangedSubview({
                let view = Utils.copy(cell.space2View)!
                view.tag = 3
                return view
            }())
            cell.stackView.addArrangedSubview({
                [weak self] in
                let titleTextFieldView = Utils.copy(cell.titleTextFieldView)!
                
                guard let self = self else {
                    return titleTextFieldView
                }
                
                titleTextFieldView.tag = 4
                let titleTextField = titleTextFieldView.subviews.filter ({
                    $0.tag == 1
                }).first! as! UITextField
                titleTextField.text = cellInfo.editingTitle
                titleTextField.delegate = self
                return titleTextFieldView
            }())
            cell.stackView.addArrangedSubview({
                let view = Utils.copy(cell.space3View)!
                view.tag = 5
                return view
            }())
            cell.stackView.addArrangedSubview({
                let buttonView = Utils.copy(cell.buttonView)!
                buttonView.tag = 6
                let stackView = buttonView.subviews.filter ({
                    $0.tag == 1
                }).first! as! UIStackView
                if let button = stackView.subviews.filter ({
                    $0.tag == 1
                }).first as? UIButton {
                    cell.returnButton = button
                    button.addTarget(cell, action: #selector(cell.touchUpInside(_:)), for: .touchUpInside)
                    button.titleLabel!.font = UIFont.systemFont(ofSize: 13)
                }
                if let button = stackView.subviews.filter ({
                    $0.tag == 2
                }).first as? UIButton {
                    cell.closeButton = button
                    button.addTarget(cell, action: #selector(cell.touchUpInside(_:)), for: .touchUpInside)
                    button.titleLabel!.font = UIFont.systemFont(ofSize: 13)
                }
                return buttonView
            }())
            cell.stackView.addArrangedSubview({
                let view = Utils.copy(cell.space4View)!
                view.tag = 7
                return view
            }())
            
            return cell
        }
    }
    
    func getTextField(cell: TableViewCellTest1VCFilteringTableViewCell2,
                      tableView: UITableView, indexPath: IndexPath) -> UITextField {
        return cell.stackView.subviews.filter({
            $0.tag == 4
        }).first!.subviews.filter({
            $0.tag == 1
        }).first! as! UITextField
    }
}
