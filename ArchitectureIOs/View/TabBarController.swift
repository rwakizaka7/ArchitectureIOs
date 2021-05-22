//
//  TabBarController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/11.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: LinkTabBarController<TabBarControllerModel> {
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
