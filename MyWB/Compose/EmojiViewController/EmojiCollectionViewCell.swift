//
//  EmojiCollectionViewCell.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/19.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    var emoji : Emojis? {
        didSet{
            guard let emoji = emoji else {
                return
            }
            emojiBtn.setImage(UIImage(contentsOfFile: emoji.pngPath ?? ""), forState: .Normal)
            emojiBtn.setTitle(emoji.emojiCode, forState: .Normal)
            if emoji.isRemove {
                emojiBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
    private lazy var emojiBtn : UIButton = UIButton(type: UIButtonType.Custom)
    override init(frame : CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiCollectionViewCell {
    private func setupUI() {
        //设置emojiBtn的属性
        contentView.addSubview(emojiBtn)
        emojiBtn.frame = contentView.bounds
        emojiBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
        emojiBtn.userInteractionEnabled = false
    }
}
