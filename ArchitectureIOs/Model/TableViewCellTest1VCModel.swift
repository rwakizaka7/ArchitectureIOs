//
//  TableViewCellTest1VCModel.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/20.
//

import Foundation

class TableViewCellTest1VCModel: LinkModel {
    typealias S = TableViewCellTest1VCMenuTableSection
    typealias C = TableViewCellTest1VCMenuTableCell
    
    var sections: [S] = [S(title: "Mac OS X", cells:
                            [C(id: 1, status: .normal, title: "Mac OS X Public Beta (Siam)"),
                             C(id: 2, status: .normal, title: "Mac OS X 10.0 (Cheetah)"),
                             C(id: 3, status: .normal, title: "Mac OS X 10.1 (Puma)"),
                             C(id: 4, status: .normal, title: "Mac OS X 10.2 (Jaguar)"),
                             C(id: 5, status: .normal, title: "Mac OS X 10.3 (Panther)"),
                             C(id: 6, status: .normal, title: "Mac OS X 10.4 (Tiger)"),
                             C(id: 7, status: .normal, title: "Mac OS X 10.5 (Leopard)"),
                             C(id: 8, status: .normal, title: "Mac OS X 10.6 (Snow Leopard)"),
                             C(id: 9, status: .normal, title: "Mac OS X 10.7 (Lion)")
                            ]),
                         S(title: "OS X 10", cells:
                            [C(id: 10, status: .normal, title: "OS X 10.8 Mountain Lion"),
                             C(id: 11, status: .normal, title: "OS X 10.9 Mavericks"),
                             C(id: 12, status: .normal, title: "OS X 10.10 Yosemite"),
                             C(id: 13, status: .normal, title: "OS X 10.11 El Capitan")
                             ]),
                         S(title: "macOS", cells:
                            [C(id: 14, status: .normal, title: "macOS Sierra 10.12"),
                             C(id: 15, status: .normal, title: "macOS High Sierra 10.13"),
                             C(id: 16, status: .normal, title: "macOS Mojave 10.14"),
                             C(id: 17, status: .normal, title: "macOS Catalina 10.15"),
                             C(id: 18, status: .normal, title: "macOS Big Sur 11"),
                             C(id: 19, status: .normal, title: "macOS Monterey 12")
                             ])
                            ]
    
    lazy var displayingSections: [S] = sections
    
    var searchText: String = ""
    
    override func receiveAction(_ action: ActionFromView, params: [String:Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .viewDidLoad:
            sendAction(.dataSetting, params: ["search_text_field":searchText])
            sendAction(.dataSetting, params: ["sections":displayingSections])
        case .touchUpInside:
            guard let buttonId = params["button_id"] as? String else {
                return
            }
            switch buttonId {
            case "search_clearing_button":
                searchText = ""
                sendAction(.dataSetting, params: ["search_text_field":searchText])
                sendAction(.resignFirstResponder, params: ["search_text_field":""])
                
                displayingSections = extractSection(sections: sections, word: searchText)
                sendAction(.dataSetting, params: ["sections":displayingSections])
                sendAction(.reloadData, params: ["filtering_table_view":""])
            case "filtering_table_view_cell_return_button":
                guard let indexPath = params["index_path"] as? IndexPath else {
                    return
                }
                
                let _indexPath = getIndexPathBeforeExtraction(indexPath)
                sections[_indexPath.section].cells[_indexPath.row].status = .normal
                displayingSections = extractSection(sections: sections, word: searchText)
                sendAction(.dataSetting, params: ["sections":displayingSections])
                sendAction(.reloadRows, params: ["index_paths":[indexPath],
                                                 "row_animation":RowAnimation.fade])
            case "filtering_table_view_cell_close_button":
                guard let indexPath = params["index_path"] as? IndexPath else {
                    return
                }
                
                let _indexPath = getIndexPathBeforeExtraction(indexPath)
                sections[_indexPath.section].cells[_indexPath.row].status = .normal
                sections[_indexPath.section].cells[_indexPath.row].title
                    = sections[_indexPath.section].cells[_indexPath.row].editingTitle
                displayingSections = extractSection(sections: sections, word: searchText)
                sendAction(.dataSetting, params: ["sections":displayingSections])
                sendAction(.reloadRows, params: ["index_paths":[indexPath],
                                                 "row_animation":RowAnimation.fade])
            default:
                break
            }
        case .textFieldEditing:
            guard let textId = params["text_id"] as? String,
                let text = params["text"] as? String else {
                return
            }
            switch textId {
            case "search_text_field":
                searchText = text
                displayingSections = extractSection(sections: sections, word: searchText)
                sendAction(.dataSetting, params: ["sections":displayingSections])
                sendAction(.reloadData, params: ["filtering_table_view":""])
            case "filtering_table_view_cell_title_text_field":
                guard let indexPath = params["index_path"] as? IndexPath else {
                    return
                }
                let _indexPath = getIndexPathBeforeExtraction(indexPath)
                sections[_indexPath.section].cells[_indexPath.row].editingTitle
                    = text
                displayingSections = extractSection(sections: sections, word: searchText)
                sendAction(.dataSetting, params: ["sections":displayingSections])
            default:
                break
            }
        case .tableViewSelection:
            guard let indexPath = params["index_path"] as? IndexPath else {
                return
            }
            
            let _indexPath = getIndexPathBeforeExtraction(indexPath)
            sections[_indexPath.section].cells[_indexPath.row].status = .editing
            sections[_indexPath.section].cells[_indexPath.row].editingTitle
                = sections[_indexPath.section].cells[_indexPath.row].title
            displayingSections = extractSection(sections: sections, word: searchText)
            sendAction(.dataSetting, params: ["sections":displayingSections])
            sendAction(.reloadRows, params: ["index_paths":[indexPath],
                                             "row_animation":RowAnimation.fade])
        default:
            break
        }
    }
    
    /// 抽出後のIndexPathを抽出前のIndexPathに変換する
    func getIndexPathBeforeExtraction(_ indexPath: IndexPath) -> IndexPath {
        let id = displayingSections[indexPath.section].cells[indexPath.row].id
        let indexPaths: [Int:IndexPath] = sections.enumerated().compactMap({
            section -> (sectionId: Int, cells: [C])? in
            guard section.element.cells.count > 0 else {
                return nil
            }
            return (section.offset, section.element.cells)
        }).reduce(into: [(sectionId: Int, rowId: Int, id: Int)](), {
            rows, section in
            rows.append(contentsOf: section.cells.enumerated().map({
                cell -> (sectionId: Int, rowId: Int, id: Int) in
                return (section.sectionId, cell.offset, cell.element.id)
            }))
        }).reduce(into: [Int:IndexPath](), {
            indexPaths, row in
            indexPaths[row.id] = IndexPath(row: row.rowId, section: row.sectionId)
        })
        return indexPaths[id]!
    }
    
    func extractSection(sections: [S], word: String) -> [S] {
        guard !word.isEmpty else {
            return sections
        }
        return sections.reduce(into: [S]()) {
            sections, section in
            var section = section
            section.cells = section.cells.filter {
                $0.title.contains(word)
            }
            sections.append(section)
        }
    }
}
