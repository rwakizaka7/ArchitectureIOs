//
//  BaseModel.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2020/07/23.
//  Copyright © 2020 脇坂亮汰. All rights reserved.
//

import Foundation

class BaseModel: NSObject, EClass {
    var firstViewDidAppear = true
    
    required override init() {
        super.init()
        print("init \(className)!!")
    }
    
    deinit {
        print("deinit \(className)!!")
    }
    
    func sendAction(_ action: ActionFromModel, params: [String:Any],
                    broadcast: Bool = false) {}
    
    func receiveAction(_ action: ActionFromView, params: [String:Any]) {
        switch action {
        case .selfAction(let action):
            sendAction(action, params: params)
        case .viewDidAppear:
            sendAction(.selectionResetting, params: ["animated":true])
            firstViewDidAppear = false
        case .scrollViewDidScroll:
            if !firstViewDidAppear {
                sendAction(.selectionResetting, params: ["animated":false])
            }
        case .dismissalCompletion:
            sendAction(.selectionResetting, params: ["animated":true])
        default:
            break
        }
    }
}
