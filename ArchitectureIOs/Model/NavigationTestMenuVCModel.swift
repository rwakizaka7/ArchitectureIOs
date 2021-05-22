//
//  NavigationTestMenuVCModel.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/05/15.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation

class NavigationTestMenuVCModel: LinkModel {
    typealias S = NavigationTestMenuVCMenuTableSection
    typealias C = NavigationTestMenuVCMenuTableCell

    var sections: [S] = []
    
    var navigationIndex: Int!
    var tabBarIndex: Int!
    
    var previousVcIndexPath: IndexPath!
    var parentNavigationIndex: Int!
    var pushedNavigation = false
    var presentedView = false
    var tabBar = false
    
    override func receiveAction(_ action: ActionFromView, params: [String:Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .navigationStructure:
            navigationIndex = params["navigation_index"] as? Int
        case .tabBarStructure:
            tabBarIndex = params["tab_bar_index"] as? Int
        case .inputParams:
            previousVcIndexPath = params["previous_vc_index_path"] as? IndexPath
            if let index = params["tab_bar_index"] as? Int {
                tabBarIndex = index
            }
            parentNavigationIndex = params["parent_navigation_index"] as? Int
            pushedNavigation = params["pushed_navigation"] as? Bool ?? false
            presentedView = params["presented_view"] as? Bool ?? false
            tabBar = params["tab_bar"] as? Bool ?? false
        case .viewDidLoad:
            let sectionTitles = ["親のナビゲーション(\((parentNavigationIndex ?? 0) + 1)階層)",
                                 "\(tabBar ? "タブ\(tabBarIndex + 1)":"自身")のナビゲーション(\(navigationIndex!)階層)",
                                 "対象を開く(Present)", "閉じる(Dismiss)", "置き換え"]
            sections = sectionTitles.enumerated().compactMap {
                (i, title) -> S? in
                
                switch i {
                case 0:
                    var section = S(title: title, cells: [])
                    
                    if tabBar {
                        section.cells.append(C(title: "Pop", actionId: .parentPopNavigation))
                        return section
                    }
                case 1:
                    var section = S(title: title, cells: [])
                    section.cells.append(C(title: "Push", actionId: .pushNavigation))
                    if pushedNavigation {
                        section.cells.append(C(title: "Pop", actionId: .popNavigation))
                    }
                    
                    if !tabBar {
                        section.cells.append(C(title: "Push(タブバーへ)", actionId: .pushNavigationTabBar))
                    }
                    
                    return section
                case 2:
                    var section = S(title: title, cells: [])
                    section.cells.append(C(title: "pageSheetで開く", actionId: .presentPageSheet))
                    section.cells.append(C(title: "overFullScreenで開く", actionId: .presentOverFullScreen))
                    return section
                case 3:
                    var section = S(title: title, cells: [])
                    
                    if presentedView {
                        section.cells.append(C(title: "閉じる", actionId: .dismiss))
                        return section
                    }
                case 4:
                    if navigationIndex != 1 || tabBar {
                        var section = S(title: title, cells: [])
                        section.cells.append(C(title: "リセット", actionId: .replaceRootViewController))
                        return section
                    }
                default:
                    break
                }
                return nil
            }
            
            sendAction(.dataSetting, params: ["sections":sections])
        case .collectionViewSelection:
            guard let indexPath = params["index_path"] as? IndexPath,
                  let actionId = sections[indexPath.section].cells[indexPath.row].actionId else {
                return
            }
                        
            switch actionId {
            case .parentPopNavigation:
                sendAction(.tabBarAction(.parentAction(.popNavigation)))
            case .pushNavigation:
                let index: VCStructureIndex
                if tabBarIndex == nil {
                    index = .navigationTestMenuView
                } else {
                    let indexList: [VCStructureIndex] = [
                        .navigationTestTabBarItem1View, .navigationTestTabBarItem2View,
                        .navigationTestTabBarItem3View, .navigationTestTabBarItem4View,
                        .navigationTestTabBarItem5View]
                    index = indexList[tabBarIndex]
                }
                let params = createParams(previousVcIndexPath: previousVcIndexPath,
                                          tabBarIndex: tabBarIndex,
                                          parentNavigationIndex: parentNavigationIndex,
                                          pushedNavigation: true,
                                          presentedView: presentedView,
                                          tabBar: tabBar)
                sendAction(.parentAction(.pushNavigation),
                           params: ["vc_index": index, "input_params": params])
            case .pushNavigationTabBar:
                let params = createParams(previousVcIndexPath: previousVcIndexPath,
                                          parentNavigationIndex: parentNavigationIndex ?? navigationIndex,
                                          pushedNavigation: false,
                                          presentedView: presentedView,
                                          tabBar: tabBar||true)
                sendAction(.parentAction(.pushNavigation),
                           params: ["vc_index": VCStructureIndex.navigationTestTabBar,
                                    "input_params": params])
            case .popNavigation:
                sendAction(.parentAction(.popNavigation))
            case .presentPageSheet:
                let params = createParams(previousVcIndexPath: previousVcIndexPath,
                                          pushedNavigation: false,
                                          presentedView: presentedView||true,
                                          tabBar: false)
                sendAction(.present,
                           params: ["vc_index": VCStructureIndex.navigationTestMenuViewNavigation,
                                    "input_params": params,
                                    "modal_presentation_style": ModalPresentationStyle.pageSheet])
            case .presentOverFullScreen:
                let params = createParams(previousVcIndexPath: previousVcIndexPath,
                                          pushedNavigation: false,
                                          presentedView: presentedView||true,
                                          tabBar: false)
                sendAction(.present,
                           params: ["vc_index": VCStructureIndex.navigationTestMenuViewNavigation,
                                    "input_params": params,
                                    "modal_presentation_style": ModalPresentationStyle.overFullScreen])
            case .dismiss:
                sendAction(.presentingVCAction(.dismiss))
            case .replaceRootViewController:
                let params = createParams(pushedNavigation: true,
                                          autoSelectionIndexPath: previousVcIndexPath)
                sendAction(.replaceRootViewController,
                           params: ["vc_index": VCStructureIndex.verificationMenuViewNavigation,
                                    "input_params": params])
            }
        
        default:
            break
        }
    }
    
    func createParams(previousVcIndexPath: IndexPath? = nil, tabBarIndex: Int? = nil,
                      parentNavigationIndex: Int? = nil, pushedNavigation: Bool,
                      presentedView: Bool? = nil, tabBar: Bool? = nil,
                      autoSelectionIndexPath: IndexPath? = nil) -> [String:Any] {
        var params: [String:Any] = [:]
        if let previousVcIndexPath = previousVcIndexPath {
            params["previous_vc_index_path"] = previousVcIndexPath
        }
        if let tabBarIndex = tabBarIndex {
            params["tab_bar_index"] = tabBarIndex
        }
        if let parentNavigationIndex = parentNavigationIndex {
            params["parent_navigation_index"] = parentNavigationIndex
        }
        params["pushed_navigation"] = pushedNavigation
        if let presentedView = presentedView {
            params["presented_view"] = presentedView
        }
        if let tabBar = tabBar {
            params["tab_bar"] = tabBar
        }
        if let autoSelectionIndexPath = autoSelectionIndexPath {
            params["auto_selection_index_path"] = autoSelectionIndexPath
        }
        return params
        
    }
}
