//
//  EmojiManager.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/19.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class EmojiManager{
    // MARK:- 自定义属性
    var emojiPackges : [EmojiPackge] = [EmojiPackge]()
    
    // MARK:- 自定义构造函数
    init() {
        //最近
        emojiPackges.append(EmojiPackge(id: ""))
        //默认
        emojiPackges.append(EmojiPackge(id: "com.sina.default"))
        //emoji
        emojiPackges.append(EmojiPackge(id: "com.apple.emoji"))
        //浪小花
        emojiPackges.append(EmojiPackge(id: "com.sina.lxh"))
    }
    

}
