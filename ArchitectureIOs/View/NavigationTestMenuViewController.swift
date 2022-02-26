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

class NavigationTestMenuVCMenuCollectionViewCell: UICollectionViewCell,
                                                  PVCellCornerViewHighlight {
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cornerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cornerViewWidthConstraint: NSLayoutConstraint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateBackground(highlighted: true, animated: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let count = touches.filter {
            touch in
            let location = touch.location(in: cornerView)
            return location.x >= 0 && location.x <= cornerView.frame.width
                && location.y >= 0 && location.y <= cornerView.frame.height
        }.count
        if count == 0 {
            updateBackground(highlighted: false, animated: false)
        }
    }
}

class NavigationTestMenuViewController: LinkViewController<NavigationTestMenuVCModel> {
    typealias S = NavigationTestMenuVCMenuTableSection
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var sections: [S] = []
    
    var selectionIndexPath: IndexPath!
    
    let sectionHeaderHeight: CGFloat = 45
    let lastSectionFooterHeight: CGFloat = 45
    let sectionInsetsOnHorizontalAxis: CGFloat = 16
    let menuCollectionViewColNum = 3
    let cellPadding: CGFloat = 3
    
    override func receiveAction(_ action: ActionFromModel, params: [String : Any]) {
        super.receiveAction(action, params: params)
        
        switch action {
        case .dataSetting:
            sections = params["sections"] as? [S] ?? []
        default:
            break
        }
    }
    
    override func loadView() {
        super.loadView()
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = selectionIndexPath {
            let cell = menuCollectionView.cellForItem(at: indexPath) as! NavigationTestMenuVCMenuCollectionViewCell
            cell.updateBackground(highlighted: false, animated: true)
        }
    }
    
    override func dismissalCompletion() {
        super.dismissalCompletion()
        
        if let indexPath = selectionIndexPath {
            let cell = menuCollectionView.cellForItem(at: indexPath) as! NavigationTestMenuVCMenuCollectionViewCell
            cell.updateBackground(highlighted: false, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
        let cell = collectionView.cellForItem(at: indexPath) as! NavigationTestMenuVCMenuCollectionViewCell
        cell.updateBackground(highlighted: true, animated: false)
        
        selectionIndexPath = indexPath
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "NavigationTestMenuVcMenuCollectionViewHeader",
                for: indexPath) as! NavigationTestMenuVcMenuCollectionViewHeader
            
            header.textLabel.text = sections[indexPath.section].title
            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier:
                "NavigationTestMenuVcMenuCollectionViewFooter", for: indexPath)
        }
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
        
        let size = getMenuCollectionViewCellWidth(
            overallSize: collectionView.frame.size, indexPath: indexPath)
        cell.cornerViewWidthConstraint.constant = size.width - cellPadding * 2
        cell.cornerViewHeightConstraint.constant = size.height - cellPadding * 2
        return cell
    }
    
    func getMenuCollectionViewCellWidth(overallSize: CGSize, indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        let colCount = menuCollectionViewColNum

        let width = overallSize.width - sectionInsetsOnHorizontalAxis * 2
        size.width = floor(width / CGFloat(colCount))
        let widthRemainder = Int(width) % colCount
        let colIdx = indexPath.item % colCount
        if colIdx < widthRemainder - 1 {
            size.width = size.width + 1
        }
        size.height = floor(size.width * 100 / 144)
        return size
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
        return CGSize(width: collectionView.frame.width, height: sectionHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let height: CGFloat
        if section < sections.count - 1 {
            height = 0
        } else {
            height = lastSectionFooterHeight
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return getMenuCollectionViewCellWidth(overallSize: collectionView.frame.size,
                                              indexPath: indexPath)
    }
}
