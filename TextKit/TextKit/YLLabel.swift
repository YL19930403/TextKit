//
//  YLLabel.swift
//  TextKit
//
//  Created by 余亮 on 16/6/20.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class YLLabel: UILabel {
    override var text : String? {
        didSet{
            //1.修改textStorage存储的内容
            textStorage.setAttributedString(NSAttributedString(string: text!))
            //2.设置textStorege属性
            textStorage.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(20), range: NSMakeRange(0, text!.characters.count))
            //3.处理URL 
            self.URLRegex()
            
            //layoutManager重新布局
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupSystem()
    }
    
    func setupSystem(){
        //1.将layoutManager添加到textStorage
        textStorage.addLayoutManager(layoutManager)
        //2.将textContainer添加到layoutManager
        layoutManager.addTextContainer(textContainer)
    }
    
    //UILabel调用setNeedsDisplay方法, 系统会促发drawTextInRect
    override func drawTextInRect(rect: CGRect) {
        layoutManager.drawGlyphsForGlyphRange(NSMakeRange(0, text!.characters.count), atPoint: CGPointZero)
    }
    
    override func layoutSubviews() {
        //指定区域‘
        textContainer.size = bounds.size
    }
    
    

     /**
        只要textStorage中的内容发生变化, 就可以通知layoutManager重新布局
        layoutManager重新布局需要知道绘制到什么地方, 所以layoutManager就会文textContainer绘制的区域
     */
    
    // textStorage 中有 layoutManager
    private lazy var textStorage = NSTextStorage()
    
    // layoutManager(用于管理布局) 中有 textContainer
    private lazy var layoutManager = NSLayoutManager()
    
    //NSTextContainer  专门用于指定绘制的区域
    private lazy var textContainer = NSTextContainer()
    
    func URLRegex(){
        // 1.创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:NSTextCheckingTypes(NSTextCheckingType.Link.rawValue))
            let res = dataDetector.matchesInString(textStorage.string, options: NSMatchingOptions(rawValue:0), range: NSMakeRange(0, textStorage.string.characters.count))
            //2.取出结果
            for checkingRes in res {
                let str = (textStorage.string as NSString).substringWithRange(checkingRes.range)
                let tempStr = NSMutableAttributedString(string: str)
                tempStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(20), NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(0, str.characters.count))
                textStorage.replaceCharactersInRange(checkingRes.range, withAttributedString: tempStr)
            }
        }catch{
            print(error)
        }
    }
    
}



































