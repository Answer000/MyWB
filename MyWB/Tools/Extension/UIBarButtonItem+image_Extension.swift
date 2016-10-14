//
//  UIBarButtonItem+image_Extension.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/8.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName : String) {
        
        let barButton = UIButton()
        barButton.setImage(UIImage(named: imageName), forState: .Normal)
        barButton.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        barButton.sizeToFit()
        self.init(customView : barButton)
    }
}