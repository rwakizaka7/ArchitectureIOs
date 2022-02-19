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
    
    let sections: [S] = [S(title: "Mac OS X", cells:
                            [C(title: "Mac OS X Public Beta (Siam)"),
                             C(title: "Mac OS X 10.0 (Cheetah)"),
                             C(title: "Mac OS X 10.1 (Puma)"),
                             C(title: "Mac OS X 10.2 (Jaguar)"),
                             C(title: "Mac OS X 10.3 (Panther)"),
                             C(title: "Mac OS X 10.4 (Tiger)"),
                             C(title: "Mac OS X 10.5 (Leopard)"),
                             C(title: "Mac OS X 10.6 (Snow Leopard)"),
                             C(title: "Mac OS X 10.7 (Lion)")
                            ]),
                         S(title: "OS X 10", cells:
                            [C(title: "OS X 10.8 Mountain Lion"),
                             C(title: "OS X 10.9 Mavericks"),
                             C(title: "OS X 10.10 Yosemite"),
                             C(title: "OS X 10.11 El Capitan")
                             ]),
                         S(title: "macOS", cells:
                            [C(title: "macOS Sierra 10.12"),
                             C(title: "macOS High Sierra 10.13"),
                             C(title: "macOS Mojave 10.14"),
                             C(title: "macOS Catalina 10.15"),
                             C(title: "macOS Big Sur 11"),
                             C(title: "macOS Monterey 12")
                             ])
                            ]
    
    override func receiveAction(_ action: ActionFromView, params: [String:Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .viewDidLoad:
            sendAction(.dataSetting, params: ["sections":sections])
        case .tableViewSelection:
            break
        default:
            break
        }
    }
}
