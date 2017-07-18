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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, YiIndexDelegate{
    
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
    
    var indicateView: IndicateView = {
        let view = IndicateView(frame: CGRect(x: 0, y: 100, width: 60, height: 50))
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
        
        sideBar = YiIndexView(frame: CGRect(x: view.frame.width - 15.0, y: 0, width: 15, height: view.frame.height))
        sideBar.delegate = self
        view.addSubview(sideBar)
        view.addSubview(indicateView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indexChanged(newIndex: Int) {
        indicateView.label.text = String(UnicodeScalar(UInt8(64 + newIndex)))
        tableView.scrollToRow(at: IndexPath(row: 0, section: newIndex - 1), at: .top, animated: false)
        let y = sideBar.sideBlocks[newIndex - 1].frame.origin.y
        indicateView.frame = CGRect(x: view.frame.width - 100, y: y + 7.5 - indicateView.frame.height / 2, width: indicateView.frame.width, height: indicateView.frame.height)
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

