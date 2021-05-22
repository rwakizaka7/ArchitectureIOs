//
//  BaseViewController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2020/07/12.
//  Copyright © 2020 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, PVBase {
    var vCIndex: VCStructureIndex!
    var modalPresenting = false
    
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
