//
//  VCManager.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/08.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

enum VCStructureIndex {
    case verificationMenuViewNavigation
    case verificationMenuView
    case navigationTestMenuViewNavigation
    case navigationTestMenuView
    case navigationTestTabBar
    case navigationTestTabBarItem1ViewNavigation
    case navigationTestTabBarItem1View
    case navigationTestTabBarItem2ViewNavigation
    case navigationTestTabBarItem2View
    case navigationTestTabBarItem3ViewNavigation
    case navigationTestTabBarItem3View
    case navigationTestTabBarItem4ViewNavigation
    case navigationTestTabBarItem4View
    case navigationTestTabBarItem5ViewNavigation
    case navigationTestTabBarItem5View
    
    struct VCStructure {
        enum ControllerType {
            case navigation
            case tabBar
            case view
        }
        
        init(type: ControllerType, storyboardName: String, storyboardId: String! = nil) {
            self.type = type
            self.storyboardName = storyboardName
            self.storyboardId = storyboardId
        }
        
        var type: ControllerType
        var storyboardName: String
        var storyboardId: String!
    }

    struct TabBarStructure {
        var iconImage: UIImage!
        var title: String
    }

    struct NavigationStructure {
        var hidden: Bool
        var title: String!
    }
    
    var vCStructure: VCStructure {
        typealias S = VCStructure
        
        switch self {
        case .verificationMenuViewNavigation:
            return S(type: .navigation, storyboardName: "NavigationController",
                     storyboardId: "_NavigationController")
        case .verificationMenuView:
            return S(type: .view, storyboardName: "VerificationMenuViewController")
        case .navigationTestMenuViewNavigation:
            return S(type: .navigation, storyboardName: "NavigationController",
                     storyboardId: "_NavigationController")
        case .navigationTestMenuView:
            return S(type: .view, storyboardName: "NavigationTestMenuViewController")
        case .navigationTestTabBar:
            return S(type: .tabBar, storyboardName: "TabBarController")
        case .navigationTestTabBarItem1ViewNavigation, .navigationTestTabBarItem2ViewNavigation,
             .navigationTestTabBarItem3ViewNavigation, .navigationTestTabBarItem4ViewNavigation,
             .navigationTestTabBarItem5ViewNavigation:
            return S(type: .navigation, storyboardName: "NavigationController",
                     storyboardId: "_NavigationController")
        case .navigationTestTabBarItem1View, .navigationTestTabBarItem2View,
             .navigationTestTabBarItem3View, .navigationTestTabBarItem4View,
             .navigationTestTabBarItem5View:
            return S(type: .view, storyboardName: "NavigationTestMenuViewController")
        }
    }
    
    var tabBarStructure: TabBarStructure {
        typealias S = TabBarStructure
        switch self {
        
        case .navigationTestTabBarItem1ViewNavigation:
            return S(iconImage: UIImage(systemName: "cloud"), title: "タブ1")
        case .navigationTestTabBarItem2ViewNavigation:
            return S(iconImage: UIImage(systemName: "cloud"), title: "タブ2")
        default:
            return S(iconImage: UIImage(systemName: "icloud.and.arrow.down"), title: "タイトル")
        }
    }
    
    var navigationStructure: NavigationStructure {
        typealias S = NavigationStructure
        switch self {
        case .verificationMenuView:
            return S(hidden: false, title: "検証メニュー")
        case .navigationTestMenuView:
            return S(hidden: false, title: "ナビゲーションテスト")
        case .navigationTestTabBarItem1View:
            return S(hidden: false, title: "タブバー(タブ1)")
        case .navigationTestTabBarItem2View:
            return S(hidden: false, title: "タブバー(タブ2)")
        default:
            return S(hidden: true, title: nil)
        }
    }
    
    var setViewControllers: [VCStructureIndex] {
        switch self {
        case .verificationMenuViewNavigation:
            return [.verificationMenuView]
        case .navigationTestMenuViewNavigation:
            return [.navigationTestMenuView]
        case .navigationTestTabBar:
            return [.navigationTestTabBarItem1ViewNavigation, .navigationTestTabBarItem2ViewNavigation,
                    .navigationTestTabBarItem3ViewNavigation, .navigationTestTabBarItem4ViewNavigation,
                    .navigationTestTabBarItem5ViewNavigation]
        case .navigationTestTabBarItem1ViewNavigation:
            return [.navigationTestTabBarItem1View]
        case .navigationTestTabBarItem2ViewNavigation:
            return [.navigationTestTabBarItem2View]
        case .navigationTestTabBarItem3ViewNavigation:
            return [.navigationTestTabBarItem3View]
        case .navigationTestTabBarItem4ViewNavigation:
            return [.navigationTestTabBarItem4View]
        case .navigationTestTabBarItem5ViewNavigation:
            return [.navigationTestTabBarItem5View]
        default:
            return []
        }
    }
}

protocol PVLinkable: UIViewController {
    var vCIndex: VCStructureIndex! { get set }
    func sendAction(_ action: ActionFromView, params: [String:Any], broadcast: Bool)
}

extension PVLinkable {
    func sendActionChildren(_ action: ActionFromView, params: [String:Any]) {
        getChildren([self]).forEach {
            ($0 as? PVLinkable)?.sendAction(action, params: params, broadcast: false)
        }
    }
    
    func getTopVc(_ vc: UIViewController) -> UIViewController? {
        return getParent(vc) ?? vc
    }
    
    func getParent(_ vc: UIViewController, recursion: Bool = true) -> UIViewController? {
        let vc = vc.parent
        if !recursion || vc?.parent == nil {
            return vc
        } else {
            return getParent(vc!)
        }
    }
    
    func getChildren(_ vCS: [UIViewController], totalVCS: [UIViewController]? = nil,
                     recursion: Bool = true) -> [UIViewController] {
        let _vCS = vCS.reduce(into: [UIViewController]()) {
            vCS, vc in
            vCS.append(contentsOf: vc.children)
        }
        var _totalVCS = totalVCS ?? vCS
        _totalVCS.append(contentsOf: _vCS)
        
        if !recursion || _vCS.count == 0 {
            return _totalVCS
        } else {
            return getChildren(_vCS, totalVCS: _totalVCS)
        }
    }
}

class VCManager {
    static func createVC(_ index: VCStructureIndex) -> PVLinkable {
        let structure = index.vCStructure
        let storyboardName = structure.storyboardName
        let storyboardId = structure.storyboardId ?? structure.storyboardName
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(
            withIdentifier: storyboardId) as! PVLinkable
        vc.vCIndex = index
        
        if index.vCStructure.type == .navigation
            && index.setViewControllers.count > 0 {
                (vc as! UINavigationController)
                    .setViewControllers(index.setViewControllers.enumerated().map({
                        (i, index) in
                        let vc = createVC(index)
                        vc.sendAction(.navigationStructure, params: ["navigation_index": i], broadcast: false)
                        return vc
                }), animated: false)
        }
        
        if index.vCStructure.type == .tabBar
            && index.setViewControllers.count > 0 {
            let vc = vc as! UITabBarController
            
            let vcs: [UIViewController] = index.setViewControllers.enumerated().map {
                (i, type) -> UIViewController in
                let tbs = type.tabBarStructure
                let innerVc = createVC(type)

                let image: UIImage! = tbs.iconImage == nil ? nil : tbs.iconImage
                innerVc.sendActionChildren(.tabBarStructure, params: ["tab_bar_index": i])
                innerVc.tabBarItem = UITabBarItem(title: tbs.title, image: image, selectedImage: nil)

                return innerVc
            }
            vc.setViewControllers(vcs, animated: false)
        }
        
        return vc
    }
}
