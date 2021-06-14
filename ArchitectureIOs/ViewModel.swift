//
//  ViewModel.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2020/07/23.
//  Copyright © 2020 脇坂亮汰. All rights reserved.
//

import Foundation

enum ActionFromView: Hashable {
    case selfAction(ActionFromModel)
    case navigationStructure
    case tabBarStructure
    case inputParams
    case loadView
    case viewDidLoad
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case touchUpInside
    case presentingCompletion
    case dismissalStating
    case dismissalCancel
    case dismissalCompletion
    case scrollViewDidScroll
    case scrollViewWillBeginDragging
    case scrollViewDidEndDragging
    case scrollViewDidEndDecelerating
    case tableViewDisplaying
    case tableViewReleasing
    case tableViewSelection
    case collectionViewDisplaying
    case collectionViewReleasing
    case collectionViewSelection
    case calendarFunc(CalendarFunctionActionFromView)
    case defaultCalendarVc(DefaultCalendarVcActionFromView)
}

indirect enum ActionFromModel: Hashable {
    case parentAction(ActionFromModel)
    case presentingVCAction(ActionFromModel)
    case tabBarAction(ActionFromModel)
    case navigationAction(ActionFromModel)
    case childAction(VCStructureIndex, ActionFromModel)
    case replaceRootViewController
    case definesPresentationContext
    case present
    case dismiss
    case pushNavigation
    case popNavigation
    case pushParentNavigation
    case popParentNavigation
    case dataSetting
    case reloadData
    case calendarFunc(CalendarFunctionActionFromModel)
}

enum CalendarFunctionActionFromView {
    case screenInfoRequesting
    case dayCellBeginTouch
}

enum CalendarFunctionActionFromModel {
    case screensOverwriting
    case eventsOverwriting
    case screenResponsing
    case screenPositionSettingAdding
    case eventCellColCountSharing
}

enum DefaultCalendarVcActionFromView {
    case configButtonTapping
}

class ViewModel<T: BaseModel>: NSObject, EClass {
    private(set) var model: BaseModel!
    
    override init() {
        super.init()
        print("init \(className)!!")
        
        model = T()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(notificationFromView(_:)),
            name: .actionFromView, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(notificationFromModel(_:)),
            name: .actionFromModel, object: nil)
    }
    
    deinit {
        print("deinit \(className)!!")
    }
    
    @objc func notificationFromView(_ notification: Notification) {
        guard let values = notification.object as? (
                ViewModel?, [ActionFromView:Any]),
              values.0 == self || values.0 == nil else {
            return
        }
        
        let action = values.1.keys.first!
        let params = values.1.values.first! as! [String:Any]

        let log = params["log"] as? Bool ?? false
        if log {
            print("\(className) ActionFromView action=\(action) params=\(params)")
        }
        
        sendAction(action, params: params)
    }
    
    @objc func notificationFromModel(_ notification: Notification) {
        guard let values = notification.object as? (
                BaseModel?, [ActionFromModel:Any]),
              values.0 == model || values.0 == nil else {
            return
        }
        
        let action = values.1.keys.first!
        let params = values.1.values.first! as! [String:Any]

        let log = params["log"] as? Bool ?? false
        if log {
            print("\(className) ActionFromModel action=\(action) params=\(params)")
        }

        sendAction(action, params: params)
    }
    
    func sendAction(_ action: ActionFromModel, params: [String:Any]) {
        var object: (ViewModel<T>, [ActionFromModel:Any])
        object.0 = self
        object.1 = [action:params]
        NotificationCenter.default.post(name: .actionFromModel, object: object)
    }
    
    func sendAction(_ action: ActionFromView, params: [String:Any]) {
        var object: (BaseModel, [ActionFromView:Any])
        object.0 = model
        object.1 = [action:params]
        NotificationCenter.default.post(name: .actionFromView, object: object)
    }
}
