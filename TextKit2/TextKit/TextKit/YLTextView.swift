//
//  YLTextView.swift
//  TextKit
//
//  Created by 余亮 on 16/6/21.
//  Copyright © 2016年 余亮. All rights reserved.
//

import UIKit

class YLTextView: UITextView {
    var rangArrs = [NSRange]()
    var urlArrs = [NSURL]()
    
    override var text: String!{
        didSet{
            textStorage.setAttributedString(NSAttributedString(string:
            text!))
            textStorage.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(20), range: NSMakeRange(0, text!.characters.count))
            self.URLRegex()
            setNeedsDisplay()
            
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSystem()
    }
    
    
    func setupSystem(){
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }
    
//    override func drawRect(rect: CGRect) {
//        layoutManager.drawGlyphsForGlyphRange(NSMakeRange(0, text!.characters.count), atPoint: CGPointZero)
//        
//    }
    
    override func layoutSubviews() {
        textContainer.size = bounds.size
    }
    
    /**
     只要textStorage中的内容发生变化, 就可以通知layoutManager重新布局
     layoutManager重新布局需要知道绘制到什么地方, 所以layoutManager就会文textContainer绘制的区域
     */
    func URLRegex(){
        // 1.创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:NSTextCheckingTypes(NSTextCheckingType.Link.rawValue))
            let res = dataDetector.matchesInString(textStorage.string, options: NSMatchingOptions(rawValue:0), range: NSMakeRange(0, textStorage.string.characters.count))
            
            //2.取出结果
            for checkingRes in res {
//                print(checkingRes.URL)
                let str = (textStorage.string as NSString).substringWithRange(checkingRes.range)
                let tempStr = NSMutableAttributedString(string: str)
                tempStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(20), NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(0, str.characters.count))
                textStorage.replaceCharactersInRange(checkingRes.range, withAttributedString: tempStr)
                print(checkingRes.range)
                rangArrs.append(checkingRes.range)
                if urlArrs.contains(checkingRes.URL!){
                    return
                }else {
                    urlArrs.append(checkingRes.URL!)
                }
            }
        }catch{
            print(error)
        }
    }
    
    ///重写点击方法
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //1.获取手指点击的位置
        let touch = (touches as NSSet).anyObject()!
        let point = touch.locationInView(touch.view)
        
        ///遍历rangArrs
        for i in 0..<rangArrs.count {
            let tempRange = rangArrs[i]
            
        
        //2.获取URL的区域
          //注意: 没有办法直接设置UITextRange的范围
        let range1 = tempRange //NSMakeRange(9, 37)
            print("range1 = \(range1)")
//        let range2 = NSMakeRange(56, 21)
        // 只要设置selectedRange, 那么就相当于设置了selectedTextRange
        selectedRange = range1
        // 给定指定的range, 返回range对应的字符串的rect
        // 返回数组的原因是因为文字可能换行
        let arr = selectionRectsForRange(selectedTextRange!)
        
        for selectionRect in arr {
//            let tempView = UIView(frame: selectionRect.rect)
//            tempView.backgroundColor = UIColor.blueColor()
//            addSubview(tempView)
            
            if CGRectContainsPoint(selectionRect.rect, point){
                print("点击了URL")
                //拿到点击的url
                let url = urlArrs[i]
                let info = [clickURL:url]
                NSNotificationCenter.defaultCenter().postNotificationName(DidClickURLNotification, object:self , userInfo: info)
                
                }
            }
        }
    }

}
































