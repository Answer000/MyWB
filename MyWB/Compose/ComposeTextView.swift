//
//  ComposeTextView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/12.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    // MARK:- 自定义属性
    lazy var placeHolderLabel = UILabel()
    
    // MARK:- 重写系统方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPlaceHolderLabel()
    }
}

// MARK:- 设置UI界面
extension ComposeTextView {
    private func setupPlaceHolderLabel() {
        //添加子控件
        addSubview(placeHolderLabel)
        //设置frame
        placeHolderLabel.frame = CGRect(x: 11, y: 5, width: 200, height: 16)
        //设置placeHolderLabel的属性
        placeHolderLabel.font = font
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        placeHolderLabel.text = "分享新鲜事..."
        
        //设置textView的内边距
        textContainerInset = UIEdgeInsetsMake(5, 7, 0, 7)
    }
}
