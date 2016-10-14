//
//  WelcomeViewController.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/31.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit
import SDWebImage

private let ScreenH = UIScreen.mainScreen().bounds.height
class WelcomeViewController: UIViewController {

    // MARK:- 拖线的属性
    
   
    @IBOutlet weak var iconView_bottom_con: NSLayoutConstraint!
    @IBOutlet weak var userIconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 填充图片
        let iconString = UserAccountViewModel.shareInstan.account?.avatar_large
        // ?? : 如果？？前面的可选类型有值，那么对前面的可选类型进行解包并赋值
        // 如果？？前面的可选类型为nil，那么直接使用？？后面的值
        let iconUrl = NSURL(string: iconString ?? "")
        self.userIconView.sd_setImageWithURL(iconUrl, placeholderImage: UIImage(named: "radar_card_head_occupying"))
        /// 1.改变约束的值
    
        
        /// 2.执行动画
        // Damping:阻力系数，阻力系数越大，弹懂得效果越不明显 0~1
        UIView.animateWithDuration(5.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0, options: [], animations: { () -> Void in
            
            var rect = self.userIconView.frame
            rect.origin.y = 50
            self.userIconView.frame = rect
            self.iconView_bottom_con.constant = ScreenH - 200;
        }) { (_) -> Void in
                //动画结束后显示主界面
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}
