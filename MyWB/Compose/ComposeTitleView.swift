//
//  ComposeTitleView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/12.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class ComposeTitleView: UIView {

    //自定义属性
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var nickNameLabel : UILabel = UILabel()
    
    //重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension ComposeTitleView {
    private func setupTitleView() {
        //添加到父视图
        addSubview(titleLabel)
        addSubview(nickNameLabel)
        //设置frame
        titleLabel.frame = CGRectMake(0, 0, 150, 16)
        nickNameLabel.frame = CGRectMake(0, titleLabel.bounds.height + 5, titleLabel.bounds.width, 14)
        //设置字体大小
        titleLabel.font = UIFont.systemFontOfSize(16)
        nickNameLabel.font = UIFont.systemFontOfSize(14)
        //设置字体颜色
        titleLabel.textColor = UIColor.darkGrayColor()
        nickNameLabel.textColor = UIColor.lightGrayColor()
        //设置居中
        titleLabel.textAlignment = NSTextAlignment.Center
        nickNameLabel.textAlignment = NSTextAlignment.Center
        //设置内容
        titleLabel.text = "发微博"
        nickNameLabel.text = UserAccountViewModel.shareInstan.account?.screen_name
    }
}
