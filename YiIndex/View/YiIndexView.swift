//
//  YiIndexView.swift
//  YiIndex
//
//  Created by cookie on 19/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

let BLOCK_SIZE: CGFloat =  15

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
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class YiIndicateView: UIView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class IndicateView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "blockBG"))
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 35)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(label)
        label.frame =  CGRect(x: -5, y: 0, width: frame.width, height: frame.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol YiIndexDelegate {
    var indicateView: IndicateView { get }
    func indexChanged(newIndex: Int)
}

class YiIndexView: UIView {
    
    var sideBlocks = [YiBlock]()
    var curIndex: Int = 0
    var curIndexList: [Int] = [0, 0, 0, 0]
    var delegate: YiIndexDelegate!
    
    //  ForceFeedBack For iPhone7 & iPhone7 Plus
    let forceFeedBack: UISelectionFeedbackGenerator = {
        let feedBack = UISelectionFeedbackGenerator()
        feedBack.prepare()
        return feedBack
    }()
    
    // size
    let topPadding: CGFloat!
    let indexHeight: CGFloat = 26 * BLOCK_SIZE
    
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate.indicateView.isHidden = true
    }
    
    func updateIndex(_ index: Int) {
        if (index != curIndex && index <= 26 && index >= 1) {
            self.delegate.indicateView.isHidden = false
            curIndex =  index
            forceFeedBack.selectionChanged()
            delegate.indexChanged(newIndex: index)
        }
    }
    
}
