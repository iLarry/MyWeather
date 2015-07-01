//
//  ViewController.swift
//  MyWeather
//
//  Created by iLarry on 15/6/30.
//  Copyright (c) 2015年 iLarry. All rights reserved.
//

import UIKit
import CoreLocation


// 通过 地理位置反编码获得的省名和城市名获得K780查询的参数
var cityList = ["Shanghai": ["Shanghai": ["36"]]]

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManage = CLLocationManager()
    var geocoder = CLGeocoder()
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    
    //保存地理位置反编码获得的省名
    var proviceName:String?
    //保存地理位置反编码获得的市名
    var cityName:String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //设置代理为自身
        locationManage.delegate =  self
        
        //设置精度
        locationManage.desiredAccuracy = kCLLocationAccuracyBest
        
        if ios8() {
            //始终进行定位
            locationManage.requestAlwaysAuthorization()
        }
        
        locationManage.startUpdatingLocation()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //判断是否为iOS8及其以上的操作系统
    func ios8() -> Bool {
        var version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        return version>8.0 ? true : false
    }
    
    //成功获得地理位置信息
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        //检测是否成功获得
        if location.horizontalAccuracy>0 {
            
            println(location.coordinate.latitude)
            println(location.coordinate.longitude)
            
            //成功获得后，停止定位
            locationManage.stopUpdatingLocation()
            
            //成功获得经纬度之后开始地理位置信息反编码
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, err) -> Void in
                let pm = placemarks as! [CLPlacemark]
                if(pm.count > 0) {
                    println("反编码成功")
                    
                    //获得省名
                    self.proviceName = pm[0].administrativeArea
                    //获得城市名
                    self.cityName = pm[0].locality
                    
                    //通过获得的省名和市名来获得K780 Request需要的id
                    var id = cityList[self.proviceName!]?[self.cityName!]?[0]
                    
                    println(id!)
                    
                    //K780 Request的url
                    var url = "http://api.k780.com:88/?app=weather.today&weaid="+id!+"&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json"
                    
                    //Alamofire进行请求
                    Alamofire.manager.request(Method.GET, url).responseJSON(completionHandler: { (_, _, data, error) -> Void in
                        println(error)
                        var result = JSON(data!)["result"]
                        println(result)
                        var weather = Weather(week: result["week"].string!, citynm: result["citynm"].string!, temp_high: result["temp_high"].string!, temp_low: result["temp_low"].string!, temperature_curr: result["temperature_curr"].string!, weather: result["weather"].string!)
                        
                        self.update(weather)
                    })
                    

                    println(url)
                    
                    
                }
            })
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    //更新组件
    func update(weather:Weather) {
        var imageName:String = "sunny"
        
        if(weather.weather == "小雨") {
            imageName = "light_rain"
        } else if(weather.weather == "多云") {
            imageName = "overcast"
        } else if(weather.weather == "多云转晴") {
            imageName = "cloudy2"
        } else if(weather.weather == "多云转阴") {
            imageName = "overcast"
        } else if(weather.weather == "阴") {
            imageName = "overcast"
        } else if(weather.weather == "阴转雷阵雨") {
            imageName = "tstorm3"
        }
        
        
        //在主队咧进行更新UI
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.cityLabel.text = weather.citynm
            self.temperatureLabel.text = weather.temperature_curr
            self.weatherImage.image = UIImage(named: imageName)
        })
    }
    
    //更改状态栏
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

