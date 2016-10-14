//
//  TitleButton.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/8.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame : frame)
        
        setTitle("coderwhy", forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.maxX + 5
    }
    // swift中规定：重写控件的init(frame: CGRect)方法或init()方法，必须重写init?(coder aDecoder:NSCoder)方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
