//
//  IndexUtil.swift
//  YiIndex
//
//  Created by cookie on 23/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//
import Foundation
import UIKit

class TreeNode {
    var value: Character
    var uniValue: UInt32
    weak var partent: TreeNode?
    var children: [TreeNode] = []
    // if it is leaf
    var sameCount = 0
    var totalCount = 0
    
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
                child.addTotalCount()
                return result
            }
            return nil
        }else{
            for i in 0 ..< children.count {
                if (child.uniValue == children[i].uniValue) {
                    if (isLeaf) {
                        let result = children[i].sameCount
                        children[i].sameCount += 1
                        children[i].addTotalCount()
                        return result
                    }
                    break
                }else if (child.uniValue < children[i].uniValue) {
                    children.insert(child, at: i)
                    child.partent = self
                    break
                }else if (i == children.count - 1) {
                    children.append(child)
                    child.partent = self
                    break
                }
            }
            return nil
        }
    }
    
    func addTotalCount() {
        if partent == nil {
            return
        }
        partent?.totalCount += 1
        partent?.addTotalCount()
    }
}

class IndexUtil {
    // TotalCount is the amount of all leaf before current node
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
        updateTotalCount(tree: root)
        return (root, sameIndex)
    }
    
    static func updateTotalCount(tree: TreeNode) {
        if (tree.children.count < 2) {
            return
        }
        for i in  1 ..< tree.children.count {
            tree.children[i].totalCount += tree.children[i-1].totalCount
        }
        
        for child in tree.children {
            updateTotalCount(tree: child)
        }
    }
    
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
                        if childIndex > 0 {
                            row += tree.children[childIndex - 1].totalCount
                        }
                    }
                    root = root.children[childIndex]
                    break
                }
            }
        }
        row += sameIndex
        return IndexPath(row: row, section: section)
    }
    
    static func mapStrToIndex(str: [String], level: Int) -> [IndexPath]? {
        var indexList = [IndexPath]()
        let transferedStr = StringUtil.strListToUppercaseLetters(data: str, level: level)
        let (tree, sameIndexList) = createTree(data: transferedStr)
        guard tree != nil && sameIndexList != nil else{
            return nil
        }
        for i in 0 ..< str.count {
            indexList.append(createIndex(tree: tree!, str: transferedStr[i], sameIndex: sameIndexList![i]))
        }
        return indexList
    }
}
