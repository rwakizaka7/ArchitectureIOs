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

// VerificationMenuViewController

struct VerificationMenuVCMenuTableSection {
    var title: String!
    var cells: [VerificationMenuVCMenuTableCell] = []
}

struct VerificationMenuVCMenuTableCell {
    var title: String!
    var actionId: VerificationMenuVCActionId!
}

enum VerificationMenuVCActionId {
    case navigationTestTransition
    case webApiCallingTestTransition
    case tableViewCellTest1Transition
}

// WebApiCallingTestViewController

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

// NavigationTestMenuViewController

struct NavigationTestMenuVCMenuTableSection {
    var title: String!
    var cells: [NavigationTestMenuVCMenuTableCell] = []
}

struct NavigationTestMenuVCMenuTableCell {
    var title: String!
    var actionId: NavigationTestMenuVCMenuVCActionId!
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

// TableViewCellTest1ViewController

enum TableViewCellTest1VCMenuVCActionId {
    case action1
}

struct TableViewCellTest1VCMenuTableSection {
    var title: String!
    var cells: [TableViewCellTest1VCMenuTableCell] = []
}

struct TableViewCellTest1VCMenuTableCell {
    var title: String!
}
