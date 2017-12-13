//
//  NetworkTools.swift
//  AFNetworking 封装
//
//  Created by 张海峰 on 2017/7/24.
//  Copyright © 2017年 张海峰. All rights reserved.
//

import AFNetworking
var rep:URLSessionDataTask =  URLSessionDataTask()//在进行网络请求时可以通过rep.cancel()这个方法取消网络请求
enum RequestType {
    case GET
    case POST
}
class NetworkTools: AFHTTPSessionManager {
    // let 是线程安全的，即使多线程调用，也只保证创建一次
    static  let shareInstance : NetworkTools = {
    let tools = NetworkTools()
     tools.responseSerializer.acceptableContentTypes?.insert("text/html")
     tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}
//MARK:-   封装请求方法
extension NetworkTools{
    func request(methodType: RequestType, urlString : String , parameters :[String : AnyObject], finished :@escaping ( _ result : Any?,_ error : Error?) -> ())
    {
        //定义成功的回调闭包
        let successCallBack = {(task:URLSessionDataTask,result : Any?) in
            finished(result, nil)
        }
        //定义失败的回调闭包
        let failureCallBack = {(task:URLSessionDataTask?,error : Error?) in
            finished(nil, error)
        }
        if methodType == .GET {
         
           rep  = get(urlString, parameters: parameters, progress: nil,
                success:successCallBack,
                failure: failureCallBack
            )!
        }
        else{
           rep = post(urlString, parameters: parameters, progress: nil,  success:successCallBack,
                 failure: failureCallBack
            )!
            
        }
        
    }
}
