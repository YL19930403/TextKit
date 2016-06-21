//
//  ViewController.swift
//  TextKit
//
//  Created by 余亮 on 16/6/21.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

let DidClickURLNotification = "DidClickURLNotification"
let clickURL = "clickURL"
class ViewController: UIViewController {

    
    @IBOutlet weak var textV: YLTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textV.text = "欢迎来到魔都上海:https://github.com/YL19930403/TextKit , 迪士尼欢迎你:https://www.baidu.com"
        textV.editable = false
        NSNotificationCenter.defaultCenter().addObserver(self , selector: #selector(ViewController.urlClickAction(_:)), name: DidClickURLNotification, object: nil )
        
    }

    func urlClickAction(info : NSNotification){
        let url = info.userInfo![clickURL] as! NSURL
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
   
}

