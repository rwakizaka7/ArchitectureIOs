//
//  Types.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/09.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

typealias ModalPresentationStyle = UIModalPresentationStyle
typealias ModalTransitionStyle = UIModalTransitionStyle
typealias AlertStyle = UIAlertController.Style
typealias AlertActionStyle = UIAlertAction.Style

enum VerificationMenuVCActionId {
    case navigationTestTransition
    case webApiCallingTestTransition
}

struct VerificationMenuVCMenuTableSection {
    var title: String!
    var cells: [VerificationMenuVCMenuTableCell] = []
}

struct VerificationMenuVCMenuTableCell {
    var title: String!
    var actionId: VerificationMenuVCActionId!
}

enum NavigationTestMenuVCMenuVCActionId {
    case parentPopNavigation
    case pushNavigation
    case pushNavigationTabBar
    case popNavigation
    case presentPageSheet
    case presentOverFullScreen
    case dismiss
    case replaceRootViewController
}

struct WebApiCallingTestVCMenuTableSection {
    var title: String!
    var cells: [WebApiCallingTestVCMenuTableCell] = []
}

struct WebApiCallingTestVCMenuTableCell {
    var title: String!
    var actionId: WebApiCallingTestVCMenuVCActionId!
}

enum WebApiCallingTestVCMenuVCActionId {
    case api1Calling
}

struct NavigationTestMenuVCMenuTableSection {
    var title: String!
    var cells: [NavigationTestMenuVCMenuTableCell] = []
}

struct NavigationTestMenuVCMenuTableCell {
    var title: String!
    var actionId: NavigationTestMenuVCMenuVCActionId!
}
