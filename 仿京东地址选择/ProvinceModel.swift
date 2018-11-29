//
//  ProvinceModel.swift
//  AmazedBox
//
//  Created by 张海峰 on 2017/12/11.
//  Copyright © 2017年 张海峰. All rights reserved.
/*
 这个对应的分别是省，市，县，乡镇把属性改成自己的就可以了。
 */

import UIKit
import ObjectMapper
struct ProvinceModel: Mappable {
    var id :NSInteger = 0 //
    var province_name :String? //
    mutating func mapping(map: Map) {
        id    <- map["id"]
        province_name    <- map["province_name"]
    }
    init?(map: Map) {
    }
}
struct CityModel: Mappable {
    var city_name :String? //
    var id :NSInteger = 0 //
    var province_id :NSInteger = 0 //
    mutating func mapping(map: Map) {
        id    <- map["id"]
        city_name    <- map["city_name"]
        province_id    <- map["province_id"]
    }
    init?(map: Map) {
    }
}
struct CountyModel: Mappable {
    var city_id :NSInteger = 0 //
    var county_name :String? //
    var id :NSInteger = 0 //
    mutating func mapping(map: Map) {
        id    <- map["id"]
        county_name    <- map["county_name"]
        city_id    <- map["city_id"]
    }
    init?(map: Map) {
    }
}
struct TownModel: Mappable {
    var county_id :NSInteger = 0 //
    var town_name :String? //
    var id :NSInteger = 0 //
    mutating func mapping(map: Map) {
        id    <- map["id"]
        town_name    <- map["town_name"]
        county_id    <- map["county_id"]
    }
    init?(map: Map) {
    }
}
