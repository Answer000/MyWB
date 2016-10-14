//
//  VisitorView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/5.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class VisitorView: UITableView {
    
    @IBOutlet weak var smallIconImageVeiw: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var profile_bgImageViw: UIImageView!
    
    class func initVisitorView() ->VisitorView {
        let visitorView : VisitorView = NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil)!.first as! VisitorView
        visitorView.separatorStyle = UITableViewCellSeparatorStyle.None
        visitorView.scrollEnabled = false
        return visitorView
    }
}

// MARK:-  属性设置
extension VisitorView {
    ///  设置访客视图显示信息
    func setupVisitorViewInfo(iconName iconName: String ,tip: String ,isHide_bgImgView: Bool = true){
        smallIconImageVeiw.hidden = true
        tipLabel.text = tip
        iconImageView.image = UIImage(named: iconName)
        profile_bgImageViw.hidden = isHide_bgImgView
    }
    
    ///  添加首页视图旋转动画
    func addRotationAnimation(){
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = M_PI * 2
        rotation.duration = 10
        rotation.repeatCount = MAXFLOAT
        rotation.removedOnCompletion = false
        smallIconImageVeiw.layer.addAnimation(rotation, forKey: nil)
    }
}


// MARK:-  滚动代理UITableViewDelegate
extension VisitorView:UITableViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}
