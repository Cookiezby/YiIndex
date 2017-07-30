//
//  CNNameIndex.swift
//  YiIndex
//
//  Created by cookie on 31/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation

class CNNameIndex {
    var names: [String]!
    var indexs: [String: [String]] = [String: [String]]()
    init(names: [String]) {
        self.names = names
        for name in names {
            let firstName =  StringUtil.strToUppercaseLetters(str: name, level: 1)
            let keyExists = (indexs[firstName] != nil)
            if (keyExists) {
                var namesWithFirstName = indexs[firstName]!
                for i in 0 ..< namesWithFirstName.count {
                    let uniValue = firstName.unicodeScalars.first
                    if (uniValue == namesWithFirstName[i].unicodeScalars.first){
                        namesWithFirstName.insert(name, at: i)
                        break
                    }else if(i == namesWithFirstName.count - 1){
                        namesWithFirstName.append(name)
                        break
                    }
                }
            }else{
                var namesWithFirstName = [String]()
                namesWithFirstName.append(name)
                indexs[firstName] = namesWithFirstName
            }
        }
    }
}
