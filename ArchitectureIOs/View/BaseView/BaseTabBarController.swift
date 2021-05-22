//
//  BaseTabBarController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/10.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController, PVBase {
    var vCIndex: VCStructureIndex!
    var modalPresenting = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init \(className)!!")
        
        delegate = self
    }
    
    deinit {
        print("deinit \(className)!!")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func loadView() {
        super.loadView()
        sendAction(.loadView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendAction(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendAction(.viewWillAppear)
        setNavigationStructure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendAction(.viewDidAppear)
        
        presentingViewControllerDismissalCancel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendAction(.viewWillDisappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sendAction(.viewDidDisappear)
    }
    
    func presentingCompletion() {}
    
    func dismissalStating() {}
    
    func dismissalCancel() {}
    
    func dismissalCompletion() {}
    
    func sendAction(_ action: ActionFromView, params: [String:Any] = [:],
                    broadcast: Bool = false) {}
    
    func receiveAction(_ action: ActionFromModel, params: [String:Any]) {
        doAction(action, params: params)
    }
}

// 検証不十分
// tabBarItemが6個以上だとタブバーを編集できるようになるが、
// tabBar編集機能とUIカスタマイズを検証する必要がある。

extension BaseTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let moreNavigation = viewController == moreNavigationController

        print("\(className) moreNavigation=\(moreNavigation) "
              + "\(moreNavigation ? "" : "selectedIndex=\(selectedIndex)")")
    }
}

extension BaseTabBarController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        presentationControllerDismissalStating()
        return true
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDismissalCompletion()
    }
}
