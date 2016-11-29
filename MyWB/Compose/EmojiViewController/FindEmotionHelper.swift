//
//  FindEmotionHelper.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/24.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class FindEmotionHelper: NSObject {
    static var shareInstance : FindEmotionHelper = FindEmotionHelper()
    private lazy var manager : EmojiManager = EmojiManager()
    
    func findEmotion(string : String? ,font : UIFont) -> NSAttributedString?{
        guard let string = string else {
            return nil
        }
        //创建匹配规则
        let pattern = "\\[.*?\\]"
        //创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        //开始匹配
        let results = regex.matchesInString(string, options: [], range: NSRange(location: 0, length: string.characters.count))
        //获取结果
        let attMStr = NSMutableAttributedString(string: string)
        for var i = results.count - 1; i >= 0; i -= 1 {
            let result = results[i]
            let chs = (string as NSString).substringWithRange(result.range)
            guard let pngPath = findEmotionPngpath(chs) else {
                return nil
            }
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            attMStr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
        }
        return attMStr
    }
    //查找图片路径
    private func findEmotionPngpath(chs : String) -> String?{
        for packges in manager.emojiPackges {
            for emojis in packges.emojis {
                if emojis.chs == chs {
                    return emojis.pngPath
                }
            }
        }
        return nil
    }
}
