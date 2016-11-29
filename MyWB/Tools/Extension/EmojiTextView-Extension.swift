//
//  EmojiTextView-Extension.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/24.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

extension UITextView {
    func getEmojiString() -> String {
        //创建属性字符串
        let attMStr = NSMutableAttributedString(attributedString: attributedText)
        //设置属性字符串的遍历范围(从头到尾)
        let range = NSMakeRange(0, attMStr.length)
        attMStr.enumerateAttributesInRange(range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmojiTextAttachment {
                attMStr.replaceCharactersInRange(range, withString: attachment.chs!)
            }
        }
        return attMStr.string
    }
    
    func insertEmojiToTextView(emoji : Emojis) {
        //如果为空白表情，不插入
        if emoji.isEmpty {
            return
        }
        //如果为删除表情，不插入且做删除操作
        if emoji.isRemove {
            deleteBackward()
            return
        }
        //如果为emoji表情
        if emoji.emojiCode != nil {
            //1.获取光标位置
            let range = selectedTextRange
            replaceRange(range!, withText: emoji.emojiCode!)
            return
        }
        //如果为图片表情:图文混排
        if emoji.pngPath != nil {
            insertImageEmotion(emoji)
        }
    }
    private func insertImageEmotion(emoji : Emojis) {

        //创建属性字符串
        let attImage = EmojiTextAttachment()
        attImage.chs = emoji.chs
        //设置插入的图片
        attImage.image = UIImage(contentsOfFile: emoji.pngPath!)
        //设置插入图片大小
        let font = self.font!
        attImage.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attStr = NSAttributedString(attachment: attImage)
        //创建可变的属性字符串
        let attMStr = NSMutableAttributedString(attributedString: attributedText)
        //获取光标位置
        let range = selectedRange
        attMStr.replaceCharactersInRange(range, withAttributedString: attStr)
        
        //设置textView的属性字符串
        attributedText = attMStr
        //重置textView的字体，不然会变小
        self.font = font
        //将光标恢复到原来位置(会自动跑到最后位置)
        selectedRange = NSMakeRange(range.location + 1, 0)
    }

}
