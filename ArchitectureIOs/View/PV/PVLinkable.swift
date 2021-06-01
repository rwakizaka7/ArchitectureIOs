//
//  PVLinkable.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/06/01.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

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
