//
//  NavigationTestMenuViewController.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2021/05/15.
//  Copyright © 2021 脇坂亮汰. All rights reserved.
//

import Foundation
import UIKit

class NavigationTestMenuVcMenuCollectionViewHeader: UICollectionReusableView {
    @IBOutlet weak var textLabel: UILabel!
}

class NavigationTestMenuVCMenuCollectionViewCell:
    CollectionViewCell<NavigationTestMenuViewController>,
    PVCellCornerViewHighlight {
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var cornerViewButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func touchDown(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button {
        case cornerViewButton:
            updateBackground(highlighted: true, animated: false)
            vc.selectionIndexPath = indexPath
        default:
            break
        }
    }
    
    @IBAction func touchDragExit(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button {
        case cornerViewButton:
            updateBackground(highlighted: false, animated: false)
            vc.selectionIndexPath = nil
        default:
            break
        }
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button {
        case cornerViewButton:
            vc.collectionView(collectionView, didSelectItemOfItemAt: indexPath)
        default:
            break
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        updateBackground(highlighted: true, animated: false)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//
//        let count = touches.filter {
//            touch in
//            let location = touch.location(in: cornerView)
//            return location.x >= 0 && location.x <= cornerView.frame.width
//                && location.y >= 0 && location.y <= cornerView.frame.height
//        }.count
//        if count == 0 {
//            updateBackground(highlighted: false, animated: false)
//        }
//    }
}

class NavigationTestMenuViewController: LinkViewController<NavigationTestMenuVCModel> {
    typealias S = NavigationTestMenuVCMenuTableSection
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var sections: [S] = []
    
    var selectionIndexPath: IndexPath!
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            sections = params["sections"] as? [S] ?? []
        case .selectionResetting:
            let animated = params["animated"] as? Bool ?? false
            
            if let indexPath = selectionIndexPath {
                selectionIndexPath = nil
                let cell = menuCollectionView.cellForItem(at: indexPath)
                    as! NavigationTestMenuVCMenuCollectionViewCell
                cell.updateBackground(highlighted: false, animated: animated)
            }
        default:
            break
        }
    }
    
    override func loadView() {
        super.loadView()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width: CGFloat = view.bounds.size.width
        print("width=\(view.frame.width) \(view.bounds.size)")
        let colCount: CGFloat = 3
        let cellAreaMargin: CGFloat = 20
        let cellMargin: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellAreaMargin, left: cellAreaMargin,
                                           bottom: cellAreaMargin, right: cellAreaMargin)
        var size = CGSize()
        let areaMargin = cellAreaMargin * 2
        let allCellSpace = cellMargin * (colCount - 1)
        size.width = floor((width - areaMargin - allCellSpace) / colCount)
        size.height = floor(size.width * 100 / 144)
        layout.itemSize = size
        layout.minimumInteritemSpacing = cellMargin
        layout.minimumLineSpacing = cellMargin
        menuCollectionView.collectionViewLayout = layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemOfItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "NavigationTestMenuVcMenuCollectionViewHeader",
            for: indexPath) as! NavigationTestMenuVcMenuCollectionViewHeader
        
        header.textLabel.text = sections[indexPath.section].title
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "NavigationTestMenuVCMenuCollectionViewCell", for: indexPath)
            as! NavigationTestMenuVCMenuCollectionViewCell
        cell.textLabel?.text = sections[indexPath.section].cells[indexPath.row].title
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        menuCollectionView.visibleCells.forEach {
            cell in
            guard let cell = cell as? NavigationTestMenuVCMenuCollectionViewCell else {
                return
            }
            
            cell.updateBackground(highlighted: false, animated: false)
        }
    }
}

extension NavigationTestMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 32)
    }
}
