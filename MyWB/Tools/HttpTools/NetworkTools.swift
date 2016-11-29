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

// MARK:- 发送微博
extension NetworkTools {
    func sendStatus(statusText : String , isSuccess : (isSuccess : Bool)->()){
        //获取发送请求你参数
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        let params = ["access_token" : UserAccountViewModel.shareInstan.account?.access_token ?? "",
                      "status" : statusText]
        NetworkTools.shareInstance.request(.POST, urlString: urlStr, parameters: params) { (result, error) in
            if error != nil {
                isSuccess(isSuccess: false)
                return
            }
            isSuccess(isSuccess: true)
        }
    }
}

// MARK:- 发送微博且附带图片
extension NetworkTools {
    func sendStatus(statusText : String , image : UIImage , isSuccess : (isSuccess : Bool)->()) {
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
        let params = ["access_token" : UserAccountViewModel.shareInstan.account?.access_token ?? "",
            "status" : statusText]
        
        POST(urlStr, parameters: params, constructingBodyWithBlock: { (formData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.7) {
                formData.appendPartWithFileData(imageData, name: "pic", fileName: "image_1.png", mimeType: "image/png")
            }
            }, progress: nil, success: { (dataTask : NSURLSessionDataTask, anyObject : AnyObject?) in
                isSuccess(isSuccess: true)
        }) { (dataTask : NSURLSessionDataTask?, error : NSError) in
            isSuccess(isSuccess: false)
        }
    }
}

