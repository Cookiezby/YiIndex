//
//  YiIndex.swift
//  YiIndex
//
//  Created by cookie on 23/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//
import Foundation
import UIKit

class YiIndex {
    
    var originalStr: [String]!
    var processedStr: [String]!
    var level: Int = 0
    var tree: TreeNode!
    var sameCountList: [Int]!
    var indexList: [IndexPath]!

    
    init(originalStr: [String], level:Int) {
        self.originalStr = originalStr
        self.processedStr = StringUtil.strListToUppercaseLetters(data: originalStr, level: level)
        self.level = level
        let (tempTree, tempList) = YiIndexUtil.createTree(data: self.processedStr)
        self.tree = tempTree
        YiIndexUtil.update(tree: tree)
        self.sameCountList = tempList!
        createIndexPath()
    }
    
    func insert(str: String) {
        let sameCount = YiIndexUtil.insertStr(root: tree, str: str)
        originalStr.append(str)
        processedStr.append(StringUtil.strToUppercaseLetters(str: str, level: level))
        sameCountList.append(sameCount)
        YiIndexUtil.update(tree: tree)
        createIndexPath()
    }
    
    func delete(index: Int) {
        
    }
    
    func createIndexPath(){
        self.indexList = [IndexPath]()
        for i in 0 ..< originalStr.count {
            indexList.append(YiIndexUtil.createIndex(tree: tree, str: processedStr[i], sameIndex: sameCountList[i]))
        }
    }
}

class TreeNode {
    var value: Character
    var uniValue: UInt32
    weak var partent: TreeNode?
    var children: [TreeNode] = []
    
    var sameCount = 0
    var childLeafCount = 0 // the amount of leaf under this node
    var preChildLeafCount = 0 // the amount of node on the left
    
    init(value: Character) {
        self.value = value
        let uni = String(value).unicodeScalars
        self.uniValue = uni[uni.startIndex].value
    }
    
    func addChild(_ child: TreeNode, isLeaf: Bool) -> Int? {
        if children.count == 0 {
            children.append(child)
            child.partent = self
            if (isLeaf) {
                let result = child.sameCount
                child.sameCount += 1
                child.updateChildLeafCount(1)
                child.childLeafCount += 1
                return result
            }
            return nil
        }else{
            for i in 0 ..< children.count {
                if (child.uniValue == children[i].uniValue) {
                    if (isLeaf) {
                        let result = children[i].sameCount
                        children[i].sameCount += 1
                        children[i].updateChildLeafCount(1)
                        child.childLeafCount += 1
                        return result
                    }
                    break
                }else if (child.uniValue < children[i].uniValue) {
                    children.insert(child, at: i)
                    child.partent = self
                    if (isLeaf) {
                        let result = child.sameCount
                        child.sameCount += 1
                        child.updateChildLeafCount(1)
                        child.childLeafCount += 1
                        return result
                    }
                    break
                }else if (i == children.count - 1) {
                    children.append(child)
                    child.partent = self
                    if (isLeaf){
                        let result = child.sameCount
                        child.sameCount += 1
                        child.updateChildLeafCount(1)
                        child.childLeafCount += 1
                        return result
                    }
                    break
                }
            }
            return nil
        }
    }
    
    
    // FIXME: need to check
    func removeChild(_ child: TreeNode) {
        if (children.count > 1) {
            for i in 0 ..< children.count {
                if (child.uniValue == children[i].uniValue) {
                    children[i].updateChildLeafCount(-1)
                    children.remove(at: i)
                    break
                }
            }
        }else{
            removeBranch(child)
        }
    }
    
    func removeBranch(_ child: TreeNode) {
        guard partent != nil else{
            return
        }
        children.removeAll()
        partent?.removeBranch(self)
    }
    
    
    // from the child node, update the childLeafCount until the root of tree
    func updateChildLeafCount(_ value: Int) {
        guard partent != nil else{
            return
        }
        partent?.childLeafCount += value
        partent?.updateChildLeafCount(value)
    }
}

class YiIndexUtil {
    // childLeafCount is the amount of all leaf before current node
    static func createTree(data: [String]) -> (tree: TreeNode?, sameIndex: [Int]?) {
        guard data.count > 0 else {
            return (nil, nil)
        }
        let level = data[0].characters.count
        let root = TreeNode(value: Character("0"))
        var sameIndex = [Int]()
        for i in 0 ..< level {
            for str in data {
                let char = str[str.index(str.startIndex, offsetBy: i)]
                let node = TreeNode(value: char)
                var parent:TreeNode!
                // sarch for parent node
                if (i == 0) {
                     parent = root
                }else{
                    parent = root
                    for j in 0 ..< i {
                        for child in parent.children {
                            if child.value == str[str.index(str.startIndex, offsetBy: j)] {
                                parent = child
                            }
                        }
                    }
                }

                
                if (i < level - 1) {
                    _ = parent.addChild(node, isLeaf: false)
                }else if ( i == level - 1) {
                    let count = parent.addChild(node, isLeaf: true)!
                    sameIndex.append(count)
                }
            }
        }
        return (root, sameIndex)
    }
    
    // insert a str to the IndexTree
    // return the sameCount for this str
    static func insertStr(root: TreeNode, str: String) -> Int{
        let level = str.characters.count
        var sameCount = 0
        for i in 0 ..< level {
            let char = str[str.index(str.startIndex, offsetBy: i)]
            let node = TreeNode(value: char)
            var parent:TreeNode!
            // sarch for parent node
            if (i == 0) {
                parent = root
            }else{
                parent = root
                for j in 0 ..< i {
                    for child in parent.children {
                        if child.value == str[str.index(str.startIndex, offsetBy: j)] {
                            parent = child
                        }
                    }
                }
            }
            if (i < level - 1) {
                _ = parent.addChild(node, isLeaf: false)
            }else if ( i == level - 1) {
                let count = parent.addChild(node, isLeaf: true)!
                sameCount = count
            }
        }
        return sameCount
    }
    
//    static func deleteStr(root: TreeNode, str: String) {
//        let level = str.characters.count
//        for i in 0 ..< level {
//            var parent:TreeNode!
//            // sarch for parent node
//            if (i == 0) {
//                parent = root
//            }else{
//                parent = root
//                for j in 0 ..< i {
//                    for child in parent.children {
//                        if child.value == str[str.index(str.startIndex, offsetBy: j)] {
//                            parent = child
//                        }
//                    }
//                }
//            }
//            if ( i == level - 1) {
//            }
//        }
//    }
    
    
    // update the childLeafCount for the tree
    // the childLeafCount means how many leafs do this node have
    static func update(tree: TreeNode) {
        if (tree.children.count < 1) {
            return
        }
        for i in  1 ..< tree.children.count {
            tree.children[i].preChildLeafCount = tree.children[i-1].childLeafCount + tree.children[i-1].preChildLeafCount
        }
        for child in tree.children {
            update(tree: child)
        }
    }
    
    
    // through the childLeafCount, we can transfer the tree to IndexPath
    static func createIndex(tree: TreeNode, str: String, sameIndex: Int) -> IndexPath {
        var section = 0
        var row = 0
        var root = tree
        for i in 0 ..< str.characters.count {
            let char = str[str.index(str.startIndex, offsetBy: i)]
            for childIndex in 0 ..< root.children.count {
                if (char == root.children[childIndex].value) {
                    if i == 0 {
                        section = childIndex
                    }else {
                        row += root.children[childIndex].preChildLeafCount
                    }
                    root = root.children[childIndex]
                    break
                }
            }
        }
        row += sameIndex
        return IndexPath(row: row, section: section)
    }
}
