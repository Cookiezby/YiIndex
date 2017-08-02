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
    var indexDict: [String: IndexPath]!
    var dataSource:[[String]] = {
        var data = [[String]]()
        for i in 0 ..< 26 {
            data.append([String]())
        }
        return data
    }()
    
    var sectionHeader = [String]()
    
    init(originalStr: [String], level:Int) {
        self.originalStr = originalStr
        self.processedStr = StringUtil.strListToUppercaseLetters(data: originalStr, level: level)
        self.level = level
        let (tempTree, tempList) = YiIndexUtil.createTree(data: self.processedStr)
        self.tree = tempTree
        YiIndexUtil.update(tree: tree)
        self.sameCountList = tempList!
        createIndexPath()
        createDataSource()
    }
    
    func insert(str: String) {
        let proStr = StringUtil.strToUppercaseLetters(str: str, level: level)
        let sameCount = YiIndexUtil.insertStr(root: tree, str: proStr)
        originalStr.append(str)
        processedStr.append(proStr)
        sameCountList.append(sameCount)
        YiIndexUtil.update(tree: tree)
        createIndexPath()
    }
    
    func createDataSource() {
        for i in 0 ..< indexList.count {
            let index = indexList[i]
            let section = index.section
            let row = index.row
            dataSource[section][row] = originalStr[i]
        }
        
        dataSource = dataSource.filter({ (value) -> Bool in
            return value.count != 0
        })
        
        for section in dataSource {
            let first = section[0]
            let header = StringUtil.strToUppercaseLetters(str: first, level: 1)
            sectionHeader.append(header)
        }
    }
    
    func delete(index: Int) {
        guard index < originalStr.count else{
            return
        }
        let proStr = processedStr[index]
        originalStr.remove(at: index)
        processedStr.remove(at: index)
        sameCountList.removeAll()
        YiIndexUtil.deleteStr(tree: tree, str: proStr)
        tree.removeEmptyBarnch()
        YiIndexUtil.update(tree: tree)
        
        
        for i in 0 ..< processedStr.count {
            sameCountList.append(YiIndexUtil.updateSameCount(tree: tree, str: processedStr[i]))
        }
        createIndexPath()
    }
    
    func createIndexPath(){
        indexList = [IndexPath]()
        indexDict = [String: IndexPath]()
        for i in 0 ..< originalStr.count {
            let index = YiIndexUtil.createIndex(tree: tree, str: processedStr[i], sameCount: sameCountList[i])
            indexList.append(index)
            let section = index.section
            dataSource[section].append("")
            indexDict[processedStr[i]] = index
            for j in 0 ..< level {
                let startIndex = processedStr[i].startIndex
                let endIndex = processedStr[i].index(startIndex, offsetBy: j)
                let str = processedStr[i][startIndex ... endIndex]
                if let currIndex = indexDict[str] {
                    if (currIndex.row < index.row){
                        indexDict[str] = currIndex
                    }
                }else{
                    indexDict[str] = index
                }
            }
        }
    }
}

class TreeNode {
    var value: Character
    var uniValue: UInt32
    weak var parent: TreeNode?
    var children: [TreeNode] = []
    var isLeaf: Bool = false
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
            child.parent = self
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
                        children[i].childLeafCount += 1
                        children[i].updateChildLeafCount(1)
                        return result
                    }
                    break
                }else if (child.uniValue < children[i].uniValue) {
                    children.insert(child, at: i)
                    child.parent = self
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
                    child.parent = self
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
                    for j in i+1 ..< children.count {
                        children[j].preChildLeafCount -= 1
                    }
                    if (children[i].isLeaf) {
                        children[i].updateChildLeafCount(-1)
                        if (children[i].sameCount > 1) {
                            children[i].sameCount -= 1
                            children[i].childLeafCount -= 1
                        }
                    }
                    break
                }
            }
        }else if(children.count == 1){
            if (children[0].isLeaf) {
                children[0].updateChildLeafCount(-1)
                if (children[0].sameCount > 1){
                    children[0].sameCount -= 1
                    children[0].childLeafCount -= 1
                }
            }
        }else{
            // will never happen
        }
    }
    
    func removeEmptyBarnch() {
        for i in 0 ..< children.count {
            if (children[i].childLeafCount == 0) {
                children.remove(at: i)
                return
            }else{
                children[i].removeEmptyBarnch()
            }
        }
    }
    
    // from the child node, update the childLeafCount until the root of tree
    func updateChildLeafCount(_ value: Int) {
        guard parent != nil else{
            return
        }
        parent?.childLeafCount += value
        parent?.updateChildLeafCount(value)
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
                    node.isLeaf = true
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
                node.isLeaf = true
                let count = parent.addChild(node, isLeaf: true)!
                sameCount = count
            }
        }
        return sameCount
    }
    
    static func deleteStr(tree: TreeNode, str: String) {
        let level = str.characters.count
        // sarch for parent node
        var root = tree
        for i in 0 ..< level {
            let char = str[str.index(str.startIndex, offsetBy: i)]
            
            for child in root.children {
                if child.value == char {
                    root = child
                }
            }
            if (i == level - 1){
                let node = TreeNode(value: char)
                root.parent?.removeChild(node)
            }
        }
    }
    
    
    // update the childLeafCount for the tree
    // the childLeafCount means how many leafs do this node have
    static func update(tree: TreeNode) {
        if (tree.children.count < 1) {
            return
        }
        tree.children[0].preChildLeafCount = 0
        for i in  1 ..< tree.children.count {
            tree.children[i].preChildLeafCount = tree.children[i-1].childLeafCount + tree.children[i-1].preChildLeafCount
        }
        for child in tree.children {
            update(tree: child)
        }
    }
    
    
    // through the childLeafCount, we can transfer the tree to IndexPath
    static func createIndex(tree: TreeNode, str: String, sameCount: Int) -> IndexPath {
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
        row += sameCount
        return IndexPath(row: row, section: section)
    }
    
    static func updateSameCount(tree: TreeNode, str: String) -> Int {
        var sameCount = 0
        var root = tree
        let level = str.characters.count
        for i in 0 ..< level {
            let char = str[str.index(str.startIndex, offsetBy: i)]
            for child in root.children {
                if child.value == char{
                    root = child
                }
            }
            if (i == (level - 1)) {
                sameCount = root.sameCount - 1
            }
        }
        return sameCount
    }
}
