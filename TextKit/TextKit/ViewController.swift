//
//  ViewController.swift
//  TextKit
//
//  Created by 余亮 on 16/6/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = "欢迎来到魔都上海:https://github.com/YL19930403/TextKit , 迪士尼欢迎你:https://www.baidu.com"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

