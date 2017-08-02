//
//  YiHUDView.swift
//  YiIndex
//
//  Created by cookie on 22/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

class YiHUDView: UIImageView {
    
    let dot: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 3
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    var labelList:[UILabel]!
    var labelSize:CGSize!
    var max: Int = 3
    var index = 0
    
    var currLabel: String {
        get{
            var str = ""
            for label in labelList {
                if (label.text == "-"){
                    break
                }else{
                   str.append(label.text!)
                }
            }
            return str
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelSize = frame.size
        clipsToBounds = true
        backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        layer.cornerRadius =  5
        labelList = [UILabel]()
        
        for i in 0 ..< max {
            let label = createLabel()
            addSubview(label)
            label.frame = CGRect(x: CGFloat(i) * labelSize.width, y: 0, width: labelSize.width, height: labelSize.height)
            labelList.append(label)
        }
        
        layer.addSublayer(dot)
        dot.frame = CGRect(x: labelSize.width / 2 - 3, y: labelSize.height - 10, width: 6, height: 6)
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }
    
    func insertLabel() {
        guard (index + 1) < max else {
            return
        }
        index += 1
        labelList[index].text = labelList[index-1].text
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: 0, y: 0, width: self.labelSize.width * CGFloat(self.index + 1), height: self.frame.height)
            self.center = self.superview!.center
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                self.dot.frame = self.dot.frame.offsetBy(dx: self.labelSize.width, dy: 0)
            })
        }
    }
    
    func updateLabel(text: String){
        labelList[index].text = text
    }
    
    func resetHud() {
        for label in labelList {
            label.text = "-"
        }
        frame = CGRect(x: 0, y:0, width: labelSize.width, height: labelSize.height)
        center = superview!.center
        dot.frame = CGRect(x: labelSize.width / 2 - 3, y: labelSize.height - 10, width: 6, height: 6)
        index = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
