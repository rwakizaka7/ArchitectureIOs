//
//  PVScrollPositonAdjustable.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/02/28.
//

import Foundation
import UIKit

struct PVScrollPositionAdjustmentEntity {
    var scrollFocusTargets: [PVScrollFocusTargetEntity]
    var initialContentOffsetY: CGFloat!
    var previousContentHeight: CGFloat!
}

struct PVScrollFocusTargetEntity {
    var focusView: UIView!
    var cellFrameMaxY: CGFloat!
    var adjustment: CGFloat!
}

protocol PVScrollPositonAdjustable: BaseViewController {
    var adjustmentScrollView: UIScrollView { get }
    var positionAdjustmentState: PVScrollPositionAdjustmentEntity { get set }
}

extension PVScrollPositonAdjustable {
    func scrollByKeyboardWillShow(keyboardFrame: CGRect) {
        guard let target = positionAdjustmentState.scrollFocusTargets
                .filter({ $0.focusView.isFirstResponder }).first else {
            return
        }
        
        let focusViewFrameMaxY = target.cellFrameMaxY!
        let keyboardFrameMinY = adjustmentScrollView.convert(keyboardFrame, from: nil).minY
        let adjustment = focusViewFrameMaxY - keyboardFrameMinY + target.adjustment
        if adjustment <= 0 {
            return
        }
        
        if positionAdjustmentState.initialContentOffsetY == nil {
            positionAdjustmentState.initialContentOffsetY = adjustmentScrollView.contentOffset.y
        }
        positionAdjustmentState.previousContentHeight = adjustmentScrollView.contentSize.height
        
        let offsetY = adjustmentScrollView.contentOffset.y + adjustment
        // コンテンツ領域のスクロール下の場所で、reloadRowsを使用すると、
        // visibleCellsの更新が遅れる。
        adjustmentScrollView.contentInset.bottom = keyboardFrame.height
        adjustmentScrollView.contentOffset = CGPoint(x: 0, y: offsetY)
    }
    
    func scrollBykeyboardWillHide() {
        guard let offsetY = positionAdjustmentState.initialContentOffsetY,
              positionAdjustmentState.previousContentHeight
                == adjustmentScrollView.contentSize.height else {
            return
        }
        // コンテンツ領域のスクロール下の場所で、reloadRowsを使用すると、
        // visibleCellsの更新が遅れる。
        adjustmentScrollView.contentInset.bottom = 0
        adjustmentScrollView.contentOffset = CGPoint(x: 0, y: offsetY)
        
        positionAdjustmentState.initialContentOffsetY = nil
        positionAdjustmentState.previousContentHeight = nil
    }
}
