//
//  Emojis.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/19.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class Emojis: NSObject {
    // MARK:- 自定义属性
    var chs : String?   //普通表情对应的文字
    var code : String?{  //emoji的code
        didSet{
            guard let code = code else {
                return
            }
            //1.创建扫描器
            let scanner = NSScanner(string: code)
            //2.调用方法，扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt(&value)
            //3.将value转成字符
            let char = Character(UnicodeScalar(value))
            //4.将字符转成字符串
            emojiCode = String(char)
        }
    }
    var png : String?{  //普通表情对应的图片名称
        didSet{
            guard let png = png else {
                return
            }
            pngPath = NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png
        }
    }
    
    // MARK:- 数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false  //是否是删除按钮
    var isEmpty : Bool = false  //是否是空白表情
    
    init(isRemove : Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    
    //自定义构造函数
    init(dict : [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String){
    }
    
    override var description: String {
        return dictionaryWithValuesForKeys(["emojiCode","chs","pngPath"]).description
    }
}
