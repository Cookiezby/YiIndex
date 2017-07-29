//
//  ViewController.swift
//  YiIndex
//
//  Created by cookie on 19/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import UIKit

class CustomSectionHeader: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
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
        label.frame = CGRect(x: 15, y:frame.size.height / 2 - 7.5, width: 20, height: 15)
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YiIndexProtocol{
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    var indexTitle:[String] = {
        var strList = [String]()
        for i in 0...25 {
            strList.append(String(UnicodeScalar(UInt8(65 + i))))
        }
        return strList
    }()
    
    var hudView: YiHUDView = {
        let view = YiHUDView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        view.isHidden = true
        return view
    }()
    
    var sideBar: YiIndexView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        sideBar = YiIndexView(frame: CGRect(x: view.frame.width - 15.0, y: 64, width: 15, height: view.frame.height - 64))
        sideBar.delegate = self
        view.addSubview(sideBar)
     
        view.addSubview(hudView)
        hudView.center = view.center
        
        let data = ["B磊","Cdfad","Asdfa", "ADgh", "Argy", "A","A","A", "BLF"]
        let methodStart = Date()
        
        
        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
        
        let yiIndex = YiIndex(originalStr: data, level: 3)
        yiIndex.insert(str: "EF")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = CustomSectionHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height:25))
        sectionHeader.setLabel(text: indexTitle[section])
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

