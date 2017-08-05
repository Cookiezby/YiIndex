//
//  ViewController.swift
//  YiIndex
//
//  Created by cookie on 19/07/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()

        var names = [String]()
        for _ in 0 ... 100 {
            names.append(ChineseNameGen.randomName())
        }
        let tableView = YiView(frame: view.bounds, names: names, level:2)
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
