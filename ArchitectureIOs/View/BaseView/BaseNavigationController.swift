//
//  BaseNavigationController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/04/12.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController, PVBase {
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
// タブバーなどで、ナビゲーションバーが入れ子になる場合、
// 上のナビゲーションのpushViewControllerをanimated=trueで呼ぶと、
// iOS14では下の階層のナビゲーションバーのハンドリングが、
// didShow(animated=false),didShow(animated=true)と複数呼ばれてしまう。

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        viewController.transitionCoordinator?.notifyWhenInteractionChanges {
            /*[weak self] */context in
//            guard let self = self else {
//                return
//            }
            
            if context.isCancelled {
//                let sourceVc = context.viewController(forKey: .from) as! PVBase
//                let destinationVc = context.viewController(forKey: .to) as! PVBase
//
//                print("BaseNavigationController willShow cancelled \(self.vCIndex!) "
//                      + "\(sourceVc.vCIndex!) \(destinationVc.vCIndex!)")
            }
        }
        
//        let destinationIndex = (viewController as! PVBase).vCIndex!
//        print("BaseNavigationController willShow \(vCIndex!) \(destinationIndex)")
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
//        let destinationIndex = (viewController as! PVBase).vCIndex!
//        print("BaseNavigationController didShow \(vCIndex!) \(destinationIndex) \(animated)")
    }
}

extension BaseNavigationController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        presentationControllerDismissalStating()
        return true
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDismissalCompletion()
    }
}
