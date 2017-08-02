//
//  YiIndexView.swift
//  YiIndex
//
//  Created by cookie on 19/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

let BLOCK_SIZE: CGFloat =  18

protocol YiIndexProtocol {
    var hudView: YiHUDView { get }
    func indexChanged(newIndex: Int)
    func indexConfirmed()
}

extension YiIndexProtocol  {
    func indexChanged(newIndex: Int) {
        hudView.isHidden = false
        hudView.updateLabel(text: String(UnicodeScalar(UInt8(64 + newIndex))))
    }
    
    func indexConfirmed() {
        hudView.insertLabel()
    }
}

class YiIndexView: UIView {
    
    class YiBlock: UIView {
        var label: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
        }
        
        override func layoutSubviews() {
            label.frame = self.bounds
            super.layoutSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // paramaters
    var sideBlocks = [YiBlock]()
    var curIndex: Int = -1
    var curIndexList: [Int] = [0, 0, 0, 0]
    var delegate: YiIndexProtocol!
    
    //  forceFeedBack for iPhone7 & iPhone7 Plus
    let forceFeedBack: UISelectionFeedbackGenerator = {
        let feedBack = UISelectionFeedbackGenerator()
        feedBack.prepare()
        return feedBack
    }()
    
    // size
    let topPadding: CGFloat!
    let indexHeight: CGFloat = 26 * BLOCK_SIZE
    
    // check for long press
    var longPressTimeInterval: CGFloat = 0.8
    var checkLongPress: DispatchWorkItem?
    
    override init(frame: CGRect) {
        topPadding = (frame.height - indexHeight) / 2
        super.init(frame: frame)
        initBlocks()
    }
    
    func initBlocks() {
        let originY =  topPadding
        for i in 0...25 {
            let block = YiBlock(frame: CGRect(x: frame.width - BLOCK_SIZE, y: originY! + CGFloat(i) * BLOCK_SIZE, width: BLOCK_SIZE, height: BLOCK_SIZE))
            block.label.text = String(UnicodeScalar(UInt8(65 + i)))
            sideBlocks.append(block)
            addSubview(block)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        let index = Int(( (point?.y)! - topPadding) / BLOCK_SIZE)
        updateIndex(index)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        let index = Int(( (point?.y)! - topPadding ) / BLOCK_SIZE)
        updateIndex(index)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.hudView.isHidden = true
        delegate.hudView.resetHud()
        cancelLongPressCheck()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate.hudView.isHidden = true
        delegate.hudView.resetHud()
        cancelLongPressCheck()
    }
    
    func updateIndex(_ index: Int) {
        if (index != curIndex && index <= 26 && index >= 1) {
            curIndex =  index
            forceFeedBack.selectionChanged()
            delegate.indexChanged(newIndex: index)
            
            cancelLongPressCheck()
            checkLongPress = DispatchWorkItem { [weak self] _ in
                self?.confimCurIndex(index)
            }
            let when = DispatchTime.now()  + TimeInterval(longPressTimeInterval)
            DispatchQueue.main.asyncAfter(deadline: when, execute: checkLongPress!)
        }
    }
    
    func cancelLongPressCheck() {
        if checkLongPress != nil {
            if !checkLongPress!.isCancelled {
                checkLongPress!.cancel()
            }
        }
    }
    
    func confimCurIndex(_ index: Int) {
        if(index == curIndex) {
            delegate.indexConfirmed()
        }
    }
    
    func generateLevelIndex(data: [String]) {
        
    }
}
