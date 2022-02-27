//
//  BaseViewController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2020/07/12.
//  Copyright © 2020 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, PVViewController {
    var vCIndex: VCStructureIndex!
    var modalPresenting = false
    
    var keyboardUpping = false
    var keyboardFrame: CGRect!
    
    lazy var tapGestureViews: [UIView] = [self.view]
    var tapGestureRecognizers: [UIView: UITapGestureRecognizer] = [:]
    
    var panGestureViews: [UIView] = []
    var panGestureRecognizers: [UIView: UIPanGestureRecognizer] = [:]
    
    var textFields: [UITextField] { [] }
    var testFieldShouldChangeCharacters: [UITextField: (String) -> Bool] { [:] }
    var textFieldFocusChangeList: [UITextField] { [] }
    
    lazy var subscriptions: [String: (viewWillAppear: ()->(),
                                      viewWillDisappear: ()->())] = [
        "tap_gesture_recognizer": ({
            [weak self] in
            guard let self = self else {
                return
            }

            self.tapGestureRecognizers = self.tapGestureViews.reduce(
                into: [UIView:UITapGestureRecognizer]()) {
                tapGestureRecognizers, view in
                
                let gesture = UITapGestureRecognizer(
                target: self, action: #selector(self.tapGestureRecognizer(_:)))
                gesture.cancelsTouchesInView = false
                view.addGestureRecognizer(gesture)
                tapGestureRecognizers[view] = gesture
            }
        }, {
            [weak self] in
            guard let self = self else {
                return
            }
            
            self.tapGestureRecognizers.forEach {
                tapGestureRecognizer in
                tapGestureRecognizer.key.removeGestureRecognizer(tapGestureRecognizer.value)
            }
        }),
        "pan_gesture_recognizer": ({
            [weak self] in
            guard let self = self else {
                return
            }

            self.panGestureRecognizers = self.panGestureViews.reduce(
                into: [UIView:UIPanGestureRecognizer]()) {
                panGestureRecognizers, view in
                
                let gesture = UIPanGestureRecognizer(
                target: self, action: #selector(self.panGestureRecognizer(_:)))
                gesture.delegate = self
                gesture.cancelsTouchesInView = false
                view.addGestureRecognizer(gesture)
                panGestureRecognizers[view] = gesture
            }
        }, {
            [weak self] in
            guard let self = self else {
                return
            }
            
            self.panGestureRecognizers.forEach {
                panGestureRecognizer in
                panGestureRecognizer.key.removeGestureRecognizer(panGestureRecognizer.value)
            }
        }),
        "keyboard_will_show": ({
            [weak self] in
            guard let self = self else {
                return
            }

            NotificationCenter.default.addObserver(
                self, selector: #selector(self.keyboardWillShow(_:)),
                name: UIResponder.keyboardWillShowNotification, object: nil)
        }, {
            [weak self] in
            guard let self = self else {
                return
            }
            
            NotificationCenter.default.removeObserver(
                self, name: UIResponder.keyboardWillShowNotification,
                object: nil)
        }),
        "keyboard_will_hide": ({
            [weak self] in
            guard let self = self else {
                return
            }

            NotificationCenter.default.addObserver(
                self, selector: #selector(self.keyboardWillHide(_:)),
                name: UIResponder.keyboardWillHideNotification, object: nil)
        }, {
            [weak self] in
            guard let self = self else {
                return
            }
            
            NotificationCenter.default.removeObserver(
                self, name: UIResponder.keyboardWillHideNotification,
                object: nil)
        }),
        "text_field_editing_changed": ({
            [weak self] in
            guard let self = self else {
                return
            }

            self.textFields.forEach {
                $0.addTarget(self, action: #selector(
                    self.editingChanged(textField:)), for: .editingChanged)
            }
        }, {
            [weak self] in
            guard let self = self else {
                return
            }
            
            self.textFields.forEach {
                $0.removeTarget(self, action: #selector(
                    self.editingChanged(textField:)), for: .editingChanged)
            }
        }),
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init \(className)!!")
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
        
        view.endEditing(true)
        
        subscriptions.values.forEach {
            subscription in
            subscription.viewWillDisappear()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sendAction(.viewDidDisappear)
    }
    
    @objc func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case view:
            view.endEditing(true)
        default:
            break
        }
    }
    
    @objc func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        switch sender.view {
        default:
            break
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardFrame = (notification.userInfo?[UIResponder
            .keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue!
        
        defer {
            keyboardUpping = true
        }
        
        guard let self = self as? PVScrollPositonAdjustable else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.scrollByKeyboardWillShow(keyboardFrame: self.keyboardFrame!)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardFrame = nil
        
        defer {
            keyboardUpping = false
        }
        
        guard let self = self as? PVScrollPositonAdjustable else {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            self.scrollBykeyboardWillHide()
        }
    }
    
    @objc func editingChanged(textField: UITextField) {
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

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer.view is UIScrollView {
            return true
        } else {
            return false
        }
    }
}

extension BaseViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        presentationControllerDismissalStating()
        return true
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        presentationControllerDismissalCompletion()
    }
}

extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sendActionWithScrollInfo(.scrollViewDidScroll, scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        sendActionWithScrollInfo(.scrollViewWillBeginDragging,
                                 scrollView: scrollView)
        
        if !(scrollView is UITextView) {
            view.endEditing(true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        sendActionWithScrollInfo(.scrollViewDidEndDragging, scrollView: scrollView,
                                 addingParams: ["decelerate":decelerate])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        sendActionWithScrollInfo(.scrollViewDidEndDecelerating, scrollView: scrollView)
    }
}

extension BaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendAction(.tableViewSelection, scrollView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        sendAction(.tableViewReleasing, scrollView: tableView, indexPath: indexPath)
    }
}

extension BaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        defer {
            sendAction(.tableViewDisplaying, scrollView: tableView, indexPath: indexPath)
        }
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}

extension BaseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sendAction(.collectionViewSelection, scrollView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sendAction(.collectionViewReleasing, scrollView: collectionView, indexPath: indexPath)
    }
}

extension BaseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        defer {
            sendAction(.collectionViewDisplaying, scrollView: collectionView, indexPath: indexPath)
        }
        return UICollectionViewCell()
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn
        range: NSRange, replacementString string: String) -> Bool {
        let text: String = (textField.text! as NSString).replacingCharacters(
            in: range, with: string)
        
        return testFieldShouldChangeCharacters[textField]?(text) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let i = textFieldFocusChangeList.enumerated()
            .filter({ $1 == textField }).first?.offset
        if let i = i, i != textFieldFocusChangeList.count - 1 {
            textFieldFocusChangeList[i + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let self = self as? PVScrollPositonAdjustable,
              let keyboardFrame = keyboardFrame else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.scrollByKeyboardWillShow(keyboardFrame: keyboardFrame)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
