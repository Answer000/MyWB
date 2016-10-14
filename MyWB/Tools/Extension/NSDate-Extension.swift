//
//  NSDate-Extension.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/10/9.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import Foundation


extension NSDate {
    
    class func creatDate(creatAt : String) -> String{
       
        //1.创建dateFamt对时间进行格式化
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en")
        //2.将字符串转成时间
        guard let creatDate = fmt.dateFromString(creatAt) else {
            return ""
        }
        //3.获取当前时间
        let nowDate = NSDate()
        //4.比较两个时间差
        let interval = Int(nowDate.timeIntervalSinceDate(creatDate))
        
        //5.根据时间差，计算要显示的字符串
        //5.1 显示“刚刚”
        if interval < 60 {
            return "刚刚"
        }
        //5.2 显示多少分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        //5.3 显示多少个小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / 60 / 60)小时前"
        }
        //5.4 显示昨天几时几分
        //创建日历对象
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInYesterday(creatDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.stringFromDate(creatDate)
            return timeStr
        }
        //5.5 处理一年之内：02-22 12:22
        let cmps = calendar.components(.Year, fromDate: creatDate, toDate: nowDate, options: [])
        if cmps.year < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.stringFromDate(creatDate)
            return timeStr
        }
        //5.6 超过一年:2014-02-12 13:22
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.stringFromDate(creatDate)
        return timeStr
    }
}
