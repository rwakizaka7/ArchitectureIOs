//
//  PVViewController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/05/02.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

protocol PVViewController: PVLinkable, EClass, UIAdaptivePresentationControllerDelegate {
    var modalPresenting: Bool { get set }
    func presentingCompletion()
    func dismissalStating()
    func dismissalCancel()
    func dismissalCompletion()
}

extension PVViewController {
    // viewWillAppear
    func setNavigationStructure() {
        let ns = vCIndex.navigationStructure
        navigationController?.setNavigationBarHidden(ns.hidden, animated: true)
        navigationItem.title = ns.title
    }
    
    // viewDidAppear
    func presentingViewControllerDismissalCancel() {
        if var modalPresenting = (presentingViewController as? PVViewController)?.modalPresenting,
           modalPresenting {
            modalPresenting = false
            sendAction(.dismissalCancel, params: [:], broadcast: false)
            dismissalCancel()
            print("\(className) pageSheet viewDidAppear modalPresenting=\(modalPresenting)")
            (presentingViewController as? PVViewController)?.modalPresenting = modalPresenting
        }
    }
    
    // receiveAction
    func doAction(_ action: ActionFromModel, params: [String:Any]) {
        let pushNavigation: (_ nc: UINavigationController, _ params: [String:Any]) -> () = {
            nc, params in
            
            let vCIndex = params["vc_index"] as! VCStructureIndex
            let inputParams = params["input_params"] as? [String:Any] ?? [:]
            let animated = params["animated"] as? Bool ?? true
            let vc = VCManager.generateVC(vCIndex)
            vc.sendAction(.navigationStructure, params: ["navigation_index": nc.children.count], broadcast: false)
            vc.sendActionChildren(.inputParams, params: inputParams)
            nc.pushViewController(vc, animated: animated)
        }
        
        switch action {
        case .parentAction(let action):
            let parent = self.parent as? PVLinkable
            parent?.sendAction(.selfAction(action), params: params, broadcast: false)
        case .presentingVCAction(let action):
            let vc = presentingViewController as? PVLinkable
            vc?.sendAction(.selfAction(action), params: params, broadcast: false)
        case .tabBarAction(let action):
            let tabBar = tabBarController as? PVLinkable
            tabBar?.sendAction(.selfAction(action), params: params, broadcast: false)
        case .navigationAction(let action):
            let navigation = navigationController as? PVLinkable
            navigation?.sendAction(.selfAction(action), params: params, broadcast: false)
        case .childAction(let index, let action):
            if let child = children.compactMap({
                return $0 as? PVLinkable
            }).filter ({
                return $0.vCIndex == index
            }).first {
                child.sendAction(.selfAction(action), params: params, broadcast: false)
            }
        case .replaceRootViewController:
            let vCIndex = params["vc_index"] as! VCStructureIndex
            let inputParams = params["input_params"] as? [String:Any] ?? [:]
            
            guard let window = (
                    UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate)?.window else {
                return
            }
            
            let completion = {
                [weak window] in
                guard let window = window else {
                    return
                }
                
                let vc = VCManager.generateVC(vCIndex)
                vc.sendActionChildren(.inputParams, params: inputParams)
                window.rootViewController = vc
            }
            completion()
        case .definesPresentationContext:
            definesPresentationContext = params["defines_presentation_context"] as? Bool ?? false
        case .present:
            let vCIndex = params["vc_index"] as! VCStructureIndex
            let inputParams = params["input_params"] as? [String:Any] ?? [:]
            let animated = params["animated"] as? Bool ?? true
            let modalPresentationStyle = params["modal_presentation_style"] as? ModalPresentationStyle
                ?? .formSheet
            let modalTransitionStyle = params["modal_transition_style"] as? ModalTransitionStyle
                ?? .coverVertical
            
            let vc = VCManager.generateVC(vCIndex)
            vc.modalPresentationStyle = modalPresentationStyle
            vc.modalTransitionStyle = modalTransitionStyle
            if modalPresentationStyle == .pageSheet
                || modalPresentationStyle == .formSheet {
                vc.presentationController?.delegate = self
            }
            
            let completion = {
                [weak self] in
                guard let self = self else {
                    return
                }
                self.sendAction(.presentingCompletion, params: [:], broadcast: false)
                self.presentingCompletion()
            }
            
            vc.sendActionChildren(.inputParams, params: inputParams)
            present(vc, animated: animated, completion: completion)
        case .dismiss:
            let animated = params["animated"] as? Bool ?? true
            
            let completion = {
                [weak self] in
                guard let self = self else {
                    return
                }
                
                self.getChildren([self]).forEach {
                    guard let vc = ($0 as? PVViewController) else {
                        return
                    }
                    vc.sendAction(.dismissalCompletion, params: [:], broadcast: false)
                    vc.dismissalCompletion()
                }
            }
            
            dismiss(animated: animated, completion: completion)
        case .pushNavigation:
            if let nc = self as? BaseNavigationController {
                pushNavigation(nc, params)
            }
        case .popNavigation:
            if let nc = self as? BaseNavigationController {
                let animated = params["animated"] as? Bool ?? true
                nc.popViewController(animated: animated)
            }
        case .pushParentNavigation:
            // tabBarController?.moreNavigationControllerはTabBarControllerが自動生成する。
            // クラスの拡張ができないので、下の階層のViewControllerから制御する。
            if let nc = parent as? UINavigationController {
                pushNavigation(nc, params)
            }
        case .popParentNavigation:
            // tabBarController?.moreNavigationControllerはTabBarControllerが自動生成する。
            // クラスの拡張ができないので、下の階層のViewControllerから制御する。
            if let nc = parent as? UINavigationController {
                let animated = params["animated"] as? Bool ?? true
                nc.popViewController(animated: animated)
            }
        case .messageBox:
            let messageBoxId = params["message_box_id"] as! String
            let title = params["title"] as? String
            let message = params["message"] as? String
            let preferredStyle = params["preferred_style"] as! AlertStyle
            let selectionActions = params["selection_actions"] as? [(title: String?, style: AlertActionStyle)] ?? []
            let animated = params["animated"] as? Bool ?? true
            
            let alert = UIAlertController(title: title, message: message,
                                          preferredStyle: preferredStyle)
            selectionActions.forEach {
                selectionAction in
                alert.addAction(UIAlertAction(title: selectionAction.title, style: selectionAction.style) {
                    [weak self] alertAction in
                    guard let self = self else {
                        return
                    }
                    self.sendAction(.messageBoxSelection,
                        params: ["message_box_id": messageBoxId,
                                 "alert_action_style": alertAction.style], broadcast: false)
                })
            }
            
            present(alert, animated: animated)
        default:
            break
        }
    }
    
    func presentationControllerDismissalStating() {
        let modalPresenting = true
        (getTopVc(self) as? PVViewController)?.modalPresenting = modalPresenting
        
        sendAction(.dismissalStating, params: [:], broadcast: false)
        dismissalStating()
        print("\(className) pageSheet shouldDismiss=true modalPresenting=\(modalPresenting)")
    }
    
    func presentationControllerDismissalCompletion() {
        let modalPresenting = false
        (getTopVc(self) as? PVViewController)?.modalPresenting = modalPresenting
        
        sendAction(.dismissalCompletion, params: [:], broadcast: false)
        dismissalCompletion()
        print("\(className) pageSheet didDismiss modalPresenting=\(modalPresenting)")
    }
    
    func sendActionWithScrollInfo(_ action: ActionFromView, scrollView: UIScrollView,
                                  addingParams:[String:Any] = [:]) {
        let contentOffset = scrollView.contentOffset
        
        var scrollDirection = "none"
        if let layout = (scrollView as? UICollectionView)?.collectionViewLayout
            as? UICollectionViewFlowLayout {
            switch layout.scrollDirection {
            case .horizontal:
                scrollDirection = "horizontal"
            case .vertical:
                scrollDirection = "vertical"
            @unknown default:
                fatalError()
            }
        }
        
        var params: [String:Any] = ["tag": scrollView.tag,
                                    "scroll_direction":scrollDirection,
                                    "frame_width": Double(scrollView.frame.width),
                                    "frame_height": Double(scrollView.frame.height),
                                    "content_offset_x": Double(contentOffset.x),
                                    "content_offset_y": Double(contentOffset.y),
                                    "tracking": scrollView.isTracking,
                                    "dragging": scrollView.isDragging]
        
        addingParams.forEach { (param: (key: String, value: Any)) in
            params[param.key] = param.value
        }
        
        sendAction(action, params: params, broadcast: false)
    }
    
    func sendAction(_ action: ActionFromView, scrollView: UIScrollView,
                    indexPath: IndexPath) {
        let params: [String:Any] = ["tag": scrollView.tag, "index_path": indexPath]
        sendAction(action, params: params, broadcast: false)
    }
}
