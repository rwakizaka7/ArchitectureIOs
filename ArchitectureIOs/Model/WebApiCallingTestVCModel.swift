//
//  WebApiCallingTestVCModel.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/01/13.
//

import Foundation
import Alamofire

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

                /*
                sendAction(.messageBox, params: ["message_box_id": "api1_response",
                                                 "title":"タイトル",
                                                 "message":"メッセージ",
                                                 "preferred_style": AlertStyle.alert,
                                                 "selection_actions": [("OK", AlertActionStyle.default),
                                                                       ("キャンセル", AlertActionStyle.cancel)]])
                 */
                
                let url = "https://xxxxx"
                let params = ["xxxxx": "xxxxx"]//0986756
                AFR.request(url, method: .get, parameters: params) {
                        [weak self] response in
                        guard let self = self else {
                            return
                        }
                        
                        switch response.result {
                        case .success(let data):
                            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                            print("keys=\(json.keys)")
                            let results = json["xxxxx"] as! [[String:Any]]
                            let xxxxx = results.first!["xxxxx"] as! String
                            print("xxxxx=\(xxxxx)")
                            
                            self.sendAction(.messageBox, params: [
                                "message_box_id": "api1_response",
                                "message":"API呼び出し成功 \(url) \(params)",
                                "selection_actions": [("OK", AlertActionStyle.default)]])
                        case .failure(_):
                            self.sendAction(.cellUnselection)
                        }
                    }
                
            }
        case .messageBoxSelection:
            
            /*
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
             */
            
            let messageBoxId = params["message_box_id"] as! String
            
            switch messageBoxId {
            case "api1_response":
                sendAction(.cellUnselection)
            default:
                break
            }
        default:
            break
        }
    }
}
