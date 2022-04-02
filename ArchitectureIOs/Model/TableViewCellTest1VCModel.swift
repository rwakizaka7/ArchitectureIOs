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
                            [C(status: .normal, title: "Mac OS X Public Beta (Siam)"),
                             C(status: .normal, title: "Mac OS X 10.0 (Cheetah)"),
                             C(status: .normal, title: "Mac OS X 10.1 (Puma)"),
                             C(status: .normal, title: "Mac OS X 10.2 (Jaguar)"),
                             C(status: .normal, title: "Mac OS X 10.3 (Panther)"),
                             C(status: .normal, title: "Mac OS X 10.4 (Tiger)"),
                             C(status: .normal, title: "Mac OS X 10.5 (Leopard)"),
                             C(status: .normal, title: "Mac OS X 10.6 (Snow Leopard)"),
                             C(status: .normal, title: "Mac OS X 10.7 (Lion)")
                            ]),
                         S(title: "OS X 10", cells:
                            [C(status: .normal, title: "OS X 10.8 Mountain Lion"),
                             C(status: .normal, title: "OS X 10.9 Mavericks"),
                             C(status: .normal, title: "OS X 10.10 Yosemite"),
                             C(status: .normal, title: "OS X 10.11 El Capitan")
                             ]),
                         S(title: "macOS", cells:
                            [C(status: .normal, title: "macOS Sierra 10.12"),
                             C(status: .normal, title: "macOS High Sierra 10.13"),
                             C(status: .normal, title: "macOS Mojave 10.14"),
                             C(status: .normal, title: "macOS Catalina 10.15"),
                             C(status: .normal, title: "macOS Big Sur 11"),
                             C(status: .normal, title: "macOS Monterey 12")
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
            default:
                break
            }
        case .tableViewSelection:
            guard let indexPath = params["index_path"] as? IndexPath else {
                return
            }
            
            sections[indexPath.section].cells[indexPath.row].status = .editing
            displayingSections = extractSection(sections: sections, word: searchText)
            sendAction(.dataSetting, params: ["sections":displayingSections])
            sendAction(.reloadRows, params: ["index_paths":[indexPath],
                                             "row_animation":RowAnimation.fade])
        default:
            break
        }
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
