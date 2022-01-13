//
//  WebApiCallingTestVCModel.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/01/13.
//

import Foundation

class WebApiCallingTestVCModel: LinkModel {
    typealias S = WebApiCallingTestVCMenuTableSection
    typealias C = WebApiCallingTestVCMenuTableCell
    
    let sections: [S] = [S(title: "API呼び出し", cells:
                            [C(title: "API1の呼び出し", actionId: .api1Calling)])]
    
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
            case .api1Calling:
                sendAction(.messageBox, params: ["message_box_id": "api1_response",
                                                 "title":"タイトル",
                                                 "message":"メッセージ",
                                                 "preferred_style": AlertStyle.alert,
                                                 "selection_actions": [("OK", AlertActionStyle.default),
                                                                       ("キャンセル", AlertActionStyle.cancel)]])
            }
        case .messageBoxSelection:
            let messageBoxId = params["message_box_id"] as! String
            let alertAction = params["alert_action_style"] as! AlertActionStyle
            
            switch messageBoxId {
            case "api1_response":
                switch alertAction {
                case .default:
                    print("OK押下!!")
                default:
                    break
                }
            default:
                break
            }
            
            sendAction(.cellUnselection)
        default:
            break
        }
    }
}
