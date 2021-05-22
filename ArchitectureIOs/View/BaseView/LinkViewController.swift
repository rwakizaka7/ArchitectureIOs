//
//  LinkViewController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/10.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation

class LinkViewController<T: BaseModel>: BaseViewController {
    internal var viewModel: ViewModel<T>!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        viewModel = ViewModel<T>()

        NotificationCenter.default.addObserver(
            self, selector: #selector(notificationFromModel(_:)),
            name: .actionFromModel, object: nil)
    }
    
    @objc func notificationFromModel(_ notification: Notification) {
        guard let values = notification.object as? (
                ViewModel<T>, [ActionFromModel:Any]),
              values.0 == viewModel else {
            return
        }
        
        let action = values.1.keys.first!
        let params = values.1.values.first! as! [String:Any]
        
        let log = params["log"] as? Bool ?? false
        if log {
            print("\(className) ActionFromModel action=\(action) params=\(params)")
        }
        
        receiveAction(action, params: params)
    }
    
    override func sendAction(_ action: ActionFromView, params: [String:Any] = [:],
                             broadcast: Bool = false) {
        var object: (ViewModel<T>?, [ActionFromView:Any])
        object.0 = broadcast ? nil : viewModel
        object.1 = [action:params]
        NotificationCenter.default.post(name: .actionFromView, object: object)
    }
    
    override func receiveAction(_ action: ActionFromModel, params: [String:Any]) {
        super.receiveAction(action, params: params)
    }
}
