//
//  StringUtil.swift
//  YiIndex
//
//  Created by cookie on 22/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation

class StringUtil {
    static func strListToUppercaseLetters(data: [String], level: Int) -> [String]{
        var result = [String]()
        for str in data {
            result.append(strToUppercaseLetters(str: str, level: level))
        }
        return result
    }
    static func strToUppercaseLetters(str: String, level: Int) -> String {
        var transferedStr = ""
        let upperStr = str.uppercased()
        let upperStrUni = upperStr.unicodeScalars
        let endIndex = upperStr.characters.count < level ? upperStr.characters.count : level
        for i in 0 ..< endIndex {
            let char = upperStr[upperStr.index(upperStr.startIndex, offsetBy: i)]
            let charUni = upperStrUni[upperStrUni.index(upperStrUni.startIndex, offsetBy: i)]
            if CharacterSet.uppercaseLetters.contains(charUni) {
                transferedStr.append(char)
            }else if ("\u{4E00}" <= char  && char <= "\u{9FA5}") {
                // deal with chinese here first transfer chinese to pinyin
                let py = NSMutableString(string: String(char))
                CFStringTransform(py, nil, kCFStringTransformMandarinLatin, false)
                CFStringTransform(py, nil, kCFStringTransformStripDiacritics, false)
                let pyStr = String(py)
                // get the first char
                transferedStr.append(pyStr.uppercased()[pyStr.startIndex])
            }else {
                transferedStr.append("Z")
            }
        }
        if endIndex < level {
            for _ in 0 ..< (level - endIndex) {
                transferedStr.append("A")
            }
            
        }
        return transferedStr
    }
    
    static func isLeftLarger(_ lhs: String, _ rhs: String) -> Bool {
        if (lhs.characters.count == 0 || rhs.characters.count == 0){
            if lhs.characters.count >= rhs.characters.count {
                return true
            }else{
                return false
            }
        }
        let lFirst = lhs.unicodeScalars.first!
        let rFirst = rhs.unicodeScalars.first!
        
        if (lFirst != rFirst) {
            let l = StringUtil.strToUppercaseLetters(str: lhs, level: 1)
            let r = StringUtil.strToUppercaseLetters(str: rhs, level: 1)
            return l.unicodeScalars.first! > r.unicodeScalars.first!
        }else{
            return isLeftLarger(lhs.substring(from: lhs.index(after: lhs.startIndex)), rhs.substring(from: rhs.index(after: rhs.startIndex)))
        }
    }
}

