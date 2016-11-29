//
//  EmojiPackge.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/19.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class EmojiPackge: NSObject {
    
    // MARK:- 自定义呢属性
    var emojis : [Emojis] = [Emojis]()
    
    // MARK:- 重写构造函数
    init(id : String) {
        super.init()
        if id == "" {
            addEmptyEmotion(true)
            return
        }
        //拼接路径
        guard let path = NSBundle.mainBundle().pathForResource("\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle") else {
            return
        }
        guard let pics = NSArray(contentsOfFile: path) as? [[String : String]] else {
            return
        }
        
        var index = 0
        for var emoji in pics {
            if let png = emoji["png"] {
                emoji["png"] = id + "/" + png
            }
            emojis.append(Emojis(dict: emoji))
            index += 1
            
            if index == 20 {
                emojis.append(Emojis(isRemove : true))
                index = 0
            }
        }
        //添加空白表情和删除表情
        addEmptyEmotion(false)
    }
    
    private func addEmptyEmotion(isRecently : Bool) {
        let count = emojis.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20 {
            //添加空白表情
            emojis.append(Emojis(isEmpty: true))
        }
        //添加删除表情
        emojis.append(Emojis(isRemove: true))
    }
}


