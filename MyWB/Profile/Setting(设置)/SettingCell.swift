//
//  SettingCell.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/28.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    //自定义属性
    private lazy var moreImgView : UIImageView = UIImageView()
    private lazy var line : UIView = UIView()
    lazy var deputyTextLabel = UILabel()
    lazy var mainTextLabel : UILabel = UILabel()
    
    var mainText : String? {
        didSet{
            guard let text = mainText else {
                return
            }
            mainTextLabel.text = text
            setupSettingCell()
        }
    }
    
    private func setupSettingCell() {
        //添加子控件
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(moreImgView)
        contentView.addSubview(deputyTextLabel)
        contentView.addSubview(line)
        //设置属性
        mainTextLabel.font = UIFont.systemFontOfSize(16)
        mainTextLabel.textColor = UIColor.darkTextColor()
        deputyTextLabel.font = UIFont.systemFontOfSize(13)
        deputyTextLabel.textColor = UIColor.lightGrayColor()
        moreImgView.image = UIImage(named: "mine_icon_membership_arrow")
        line.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        //关闭自动布局
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        moreImgView.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        deputyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        //添加约束
        let views = ["mainTextLabel" : mainTextLabel,"moreImgView" : moreImgView,"line" : line, "deputyTextLabel" : deputyTextLabel]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[mainTextLabel]-15-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[deputyTextLabel]-5-[moreImgView(12)]-10-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[line]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[mainTextLabel(14)]", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-16-[moreImgView(12)]", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[line(0.5)]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-16-[deputyTextLabel(12)]", options: [], metrics: nil, views: views)
        contentView.addConstraints(cons)
    }
}
