//
//  NetworkTools.swift
//  仿京东地址选择
//
//  Created by 张海峰 on 2018/11/30.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import Foundation
import Moya
//网络请求
struct ZHFNetwork {
    // 请求成功的回调
    typealias successCallback = (_ result: Any) -> Void
    // 请求错误的回调
    typealias errorCallback = (_ statusCode: Int) -> Void
    // 请求失败的回调
    typealias failureCallback = (_ error: MoyaError) -> Void
    // 单例
    static let provider = MoyaProvider<ZHFService>()
    // 发送网络请求
    static func request(
        target: ZHFService,
        success: @escaping successCallback,
        error1: @escaping errorCallback,
        failure: @escaping failureCallback
        ) {
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try success(moyaResponse.mapJSON())
                } catch let error{
                    //服务器报错等问题 (常见问题404 ，地址错误)
                    error1((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //没有网络等问题 （网络超时，没有网）（必要时还可以将尝试重新发起请求）
                failure(error)
            }
        }
    }
}
// 定义请求方法
enum ZHFService {
    //没有参数
    case NoParameters(pathStr:String)
    //有参数
    case HaveParameters(pathStr:String,parameters: [String : Any])
}

extension ZHFService: TargetType {
    
    // 请求服务器的根路径
    var baseURL: URL { return URL.init(string: "BaseURL")!}
    
    // 每个API对应的具体路径
    var path: String {
        switch self {
        case .NoParameters(let pathStr):
            return pathStr
        case .HaveParameters(let pathStr, _):
            return pathStr
        }
    }
    
    // 各个接口的请求方式，get或post
    var method: Moya.Method {
        switch self {
        case .NoParameters:
            return .get
        case .HaveParameters:
            return .post
        }
    }
    
    // 请求是否携带参数，
    var task: Task {
        switch self {
        case .NoParameters:
            return .requestPlain // 无参数
        case .HaveParameters(_ ,let parameters): // 带有参数,注意前面的let
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
     }
    }
    // 单元测试使用
    var sampleData: Data {
        switch self {
        case .NoParameters:
            return "just for test".utf8Encoded
        case .HaveParameters(_ ,let parameters):
            return "{\"parameters\": \(parameters)\"}".utf8Encoded
        }
    }
    // 请求头
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
}
// 扩展方法
private extension String {
    var utf8Encoded: Data {
        return data(using: String.Encoding.utf8)!
    }
}

