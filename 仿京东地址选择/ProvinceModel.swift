//
//  ProvinceModel.swift
//  AmazedBox
//
//  Created by 张海峰 on 2017/12/11.
//  Copyright © 2017年 张海峰. All rights reserved.
/*
 这个对应的分别是省，市，县，乡镇把属性改成自己的就可以了。
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
@objcMembers class TownModel: NSObject {
    var county_id :NSInteger = 0 //
    var town_name :String? //
    var created_time :String? //
    var id :NSInteger = 0 //
    var is_enabled :NSInteger = 0 //
    var seq_no :NSInteger = 0 //
    var updated_time :String? //
    var updated_user :NSInteger = 0 //
}
