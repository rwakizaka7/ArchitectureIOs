//
//  LinkModel.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/10.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation

class LinkModel: BaseModel {
    required init() {
        super.init()

        NotificationCenter.default.addObserver(
            self, selector: #selector(notificationFromView(_:)),
            name: .actionFromView, object: nil)
    }
    
    @objc func notificationFromView(_ notification: Notification) {
        guard let values = notification.object as? (
                BaseModel, [ActionFromView:Any]),
              values.0 == self else {
            return
        }
        
        let action = values.1.keys.first!
        let params = values.1.values.first! as! [String:Any]
        
        let log = params["log"] as? Bool ?? false
        if log {
            print("\(className) ActionFromView action=\(action) params=\(params)")
        }

        receiveAction(action, params: params)
    }
    
    override func sendAction(_ action: ActionFromModel, params: [String:Any] = [:],
                             broadcast: Bool = false) {
        var object: (BaseModel?, [ActionFromModel:Any])
        object.0 = broadcast ? nil : self
        object.1 = [action:params]
        NotificationCenter.default.post(name: .actionFromModel, object: object)
    }
    
    override func receiveAction(_ action: ActionFromView, params: [String:Any]) {
        super.receiveAction(action, params: params)
    }
}
