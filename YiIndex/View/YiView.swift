//
//  YiView.swift
//  YiIndex
//
//  Created by cookie on 05/08/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import UIKit

class YiSectionHeader: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(label)
    }
    
    func setLabel(text: String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        label.frame = bounds
        label.frame = label.frame.offsetBy(dx: 15, dy: 0)
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YiView: UIView, UITableViewDelegate, UITableViewDataSource, YiIndexProtocol{
    
    //  YiindexProtocol
    var tableView: UITableView
    var sideBar: YiIndexView!
    var yiIndex: YiIndex!
    var hudView: YiHudView
    
    //  original data
    var names: [String]!
    
    var indexTitle:[String] = {
        var strList = [String]()
        for i in 0...25 {
            strList.append(String(UnicodeScalar(UInt8(65 + i))))
        }
        return strList
    }()
    
    init(frame: CGRect, names:[String], level: Int) {
        self.names = names
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.hudView = YiHudView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), level: level)
        super.init(frame: frame)
        yiIndex = YiIndex(originalStr: names, level: level+1)
        tableView.frame = bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        
        sideBar = YiIndexView(frame: CGRect(x: frame.width - 15.0, y: 64, width: 15, height: frame.height - 64))
        sideBar.delegate = self
        addSubview(sideBar)
        
        hudView.center = center
        hudView.isHidden = true
        addSubview(hudView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YiView {
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return yiIndex.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yiIndex.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = yiIndex.dataSource[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = YiSectionHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height:25))
        sectionHeader.setLabel(text: yiIndex.sectionHeader[section])
        return sectionHeader
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
    }
}
