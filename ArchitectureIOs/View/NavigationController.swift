//
//  NavigationController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/12.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: LinkNavigationController<NavigationControllerModel> {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func receiveAction(_ action: ActionFromModel, params: [String:Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        default:
            break
        }
    }
}
