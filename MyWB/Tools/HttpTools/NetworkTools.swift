//
//  NetworkTools.swift
//  MyWB
//
//  Created by 澳蜗科技 on 16/8/9.
//  Copyright © 2016年 澳蜗科技. All rights reserved.
//

import AFNetworking

// swift中枚举写法
enum  RequestType : String {
    case GET  = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {

    // swift中单例写法
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        //设置序列化格式
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
    
    func request(methodType : RequestType, urlString : String , parameters : [String : AnyObject] ,finished : ((result : AnyObject? , error : NSError?)->())) {
        
        //定义请求成功的闭包
        let successCallBack = { (task:NSURLSessionDataTask, result : AnyObject?) -> Void in
            finished(result: result, error: nil) }
        //定义请求失败的闭包
        let failureCallBack = { (task : NSURLSessionDataTask?, error : NSError) -> Void in
            finished(result : nil ,error: error) }

       if methodType == RequestType.GET
       {
            //GET请求方法
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure : failureCallBack )
       }else if methodType == RequestType.POST {
            ///  POST请求方法
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure : failureCallBack )
        }
    }
}

// MARK:- 请求accessToken方法
extension NetworkTools {
    func requestAccessToken(code : String,finished : (result : [String : AnyObject]?,error : NSError?)->()){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id" : app_Key,"client_secret" : app_Secret,"grant_type" : "authorization_code","code" : code,"redirect_uri" : app_redirect_uri]
        
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result: result as? [String : AnyObject], error: error)
        }
    }
}
// MARK:- 请求用户信息
extension NetworkTools {
    func requestUserInfo(access_token : String , uid : String , finished : (result : [String : AnyObject]?,error : NSError?)->()){
        //获取URL
        let urlString = "https://api.weibo.com/2/users/show.json"
        //获取请求参数
        let parameters = ["access_token" : access_token,"uid" : uid]
        
        self.request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            
            finished(result : result as? [String : AnyObject],error : error)
        }
    }
}
