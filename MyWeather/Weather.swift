//
//  Weather.swift
//  MyWeather
//
//  Created by iLarry on 15/7/1.
//  Copyright (c) 2015年 iLarry. All rights reserved.
//

import Foundation

//这个累用来
class Weather {
    var week:String?                //星期几
    var citynm:String?              //城市名
    var temp_high:String?           //最高气温
    var temp_low:String?            //最低气温
    var weather:String?             //天气状况
    var temperature_curr:String?    //当前气温
    
    init(week:String, citynm:String, temp_high:String, temp_low:String, temperature_curr:String, weather:String) {
        self.week = week
        self.citynm = citynm
        self.temp_high = temp_high
        self.temp_low = temp_low
        self.temperature_curr = temperature_curr
        self.weather = weather
    }
}