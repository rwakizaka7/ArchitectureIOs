//
//  VerificationMenuVCModel.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/05/15.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation

class VerificationMenuVCModel: LinkModel  {
    typealias S = VerificationMenuVCMenuTableSection
    typealias C = VerificationMenuVCMenuTableCell
    
    let sections: [S] = [S(title: "画面遷移", cells:
                            [C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest),
                             C(title: "ナビゲーションテスト", actionId: .navigationTest)])]
    
    override func receiveAction(_ action: ActionFromView, params: [String:Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .viewDidLoad:
            sendAction(.dataSetting, params: ["sections":sections])
        case .tableViewSelection:
            guard let indexPath = params["index_path"] as? IndexPath,
                  let actionId = sections[indexPath.section].cells[indexPath.row].actionId else {
                return
            }
            
            switch actionId {
            case .navigationTest:
                sendAction(.parentAction(.pushNavigation),
                           params: ["vc_index": VCStructureIndex.navigationTestMenuView,
                                    "input_params": ["previous_vc_index_path":indexPath,
                                                     "pushed_navigation":true]])
            }
        default:
            break
        }
    }
}
