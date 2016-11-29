//
//  ProgressView.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/25.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress : CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    // MARK:- 重写系统函数
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let arcCenter = CGPoint(x: rect.width * 0.5, y:rect.height * 0.5)
        let radius = rect.width * 0.5
        let startAngle = CGFloat(-M_PI)
        let endAngle = CGFloat(2*M_PI) * progress + startAngle
        //创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制一条道中心点的线
        path.addLineToPoint(arcCenter)
        path.closePath()
        //设置填充颜色
        UIColor(white: 1, alpha: 0.8).setFill()
        //开始绘制
        path.fill()
    }
}
