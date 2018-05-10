//
//  ProvinceModel.swift
//  AmazedBox
//
//  Created by 张海峰 on 2017/12/11.
//  Copyright © 2017年 张海峰. All rights reserved.
//这是一个自定义仿京东地址选择器。Swift版本，（保证集成成功，有不懂的地方可加QQ：991150443 进行讨论。）
OC版本地址：https://github.com/FighterLightning/ZHFJDAddressOC.git
/*该demo的使用须知:
 1.下载该demo。把ProvinceModel.swift（必须），ZHFAddTitleAddressView.swift(必须) NetworkTools.swift(可用自己封装的)拖进项目
 2.pod 'Chrysan', :git => 'https://github.com/Harley-xk/Chrysan.git' //第三方加载框（根据需求进行添加）
 pod 'AFNetworking'//网络请求
 pod 'YYModel' //字典转模型
 3.把以下代码添加进自己的控制器方可使用，网络请求看ZHFAddTitleAddressView.swift头部注释根据需求进行修改
 4.如果感觉有帮助，不要吝啬你的星星哦！
  该demo地址：https://github.com/FighterLightning/ZHFJDAddress.git
 */
/*
 这个对应的分别是省，市，县 把属性改成自己的就可以了。
 如果是自己定义的记得加 @objcMembers
 */

import UIKit

@objcMembers class ProvinceModel: NSObject {
    var created_time :String? //
    var id :NSInteger = 0 //
    var is_enabled :NSInteger = 0 //
    var province_name :String? //
    var seq_no :NSInteger = 0 //
    var updated_time :String? //
    var updated_user :NSInteger = 0 //
}
@objcMembers class CityModel: NSObject {
    var city_name :String? //
    var created_time :String? //
    var id :NSInteger = 0 //
    var is_cod :NSInteger = 0 //
    var is_enabled :NSInteger = 0 //
    var province_id :NSInteger = 0 //
    var seq_no :NSInteger = 0 //
    var updated_time :String? //
    var updated_user :NSInteger = 0 //
}
@objcMembers class CountyModel: NSObject {
    var city_id :NSInteger = 0 //
    var county_name :String? //
    var created_time :String? //
    var id :NSInteger = 0 //
    var is_enabled :NSInteger = 0 //
    var seq_no :NSInteger = 0 //
    var updated_time :String? //
    var updated_user :NSInteger = 0 //
}
