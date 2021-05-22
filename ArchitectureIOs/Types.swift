//
//  Types.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/09.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation

enum ModalPresentationStyle {
    case pageSheet
    case formSheet
    case currentContext
    case fullScreen
    case overCurrentContext
    case overFullScreen
}

enum ModalTransitionStyle {
    case coverVertical
    case crossDissolve
    case flipHorizontal
    case partialCurl
}

enum VerificationMenuVCActionId {
    case navigationTest
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

struct NavigationTestMenuVCMenuTableSection {
    var title: String!
    var cells: [NavigationTestMenuVCMenuTableCell] = []
}

struct NavigationTestMenuVCMenuTableCell {
    var title: String!
    var actionId: NavigationTestMenuVCMenuVCActionId!
}
