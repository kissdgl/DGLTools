//
//  LocationTools.swift
//  12-定位封装(工具类)
//
//  Created by 丁贵林 on 16/8/9.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTools: NSObject {
    
    //单例
    static let shareInstance : LocationTools = LocationTools()
    
    //MARK: - 属性列表
    var resultCallback : ((location : CLLocation?) -> ())?
    var isCallback : Bool = false
    
    //MARK: - 懒加载属性
    private lazy var mgr : CLLocationManager = {
        let mgr = CLLocationManager()
        
        mgr.requestWhenInUseAuthorization()
        
        mgr.delegate = self
        
        return mgr
    }()

}

extension LocationTools {
    
    func getCurrentLocation(resultCallback : (location : CLLocation?) -> ()) {
        
        mgr.startUpdatingLocation()
        
        self.resultCallback = resultCallback
        
        isCallback = false
        
    }
    
}


extension LocationTools : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        print(location)
        if let resultCallback = resultCallback {
            if !isCallback {
                resultCallback(location: location)
                isCallback = true
            }
        }
        
        //停止定位
        mgr.stopUpdatingLocation()
        
    }
}
