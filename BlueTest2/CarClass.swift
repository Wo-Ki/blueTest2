//
//  CarClass.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/3/29.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import Foundation
import  UIKit
import  CoreBluetooth
class CarClass:NSObject{
    var blunoManager:DFBlunoManager! = nil
    var blunoDev:DFBlunoDevice! = nil
    var carInformationView:CarInformationView! = nil
    var toneView:ToneView! = nil
    
    init(blunoManager:DFBlunoManager,blunoDev:DFBlunoDevice, carInformationView:CarInformationView,toneView:ToneView) {
        super.init()
        self.blunoManager = blunoManager
        self.blunoDev = blunoDev
        self.carInformationView = carInformationView
        self.toneView = toneView
        
        toneView.addTarget(self, action: #selector(CarClass.toneNewValue(_:)), for: UIControlEvents.valueChanged)
        toneView.addTarget(self, action: #selector(CarClass.toneNewValueChanged(_:)), for: UIControlEvents.touchUpInside)
        toneView.addTarget(self, action: #selector(CarClass.toneNewValueChanged(_:)), for: UIControlEvents.touchUpOutside)
    }
    func toneNewValue(_ tone:ToneView){
        print("tone:\(tone.value)")
        let string = "TONE*\(String.init(format: "%.2f", tone.value/8))"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
     
        
    }
    func toneNewValueChanged(_ tone:ToneView){
        toneView.value = 0
        let string = "TONE*\(String.init(format: "%.2f", 0))"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
    }

    func leftRight(value:Float){
        let string = "LEFTRIGHT*\(String.init(format: "%.2f", value))"
       blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        if value<0 {
            carInformationView.updataLeftRightBackLight(direction: 11)
            carInformationView.updataLeftRightBackLight(direction: 20)
        }
        if value > 0 {
            carInformationView.updataLeftRightBackLight(direction: 21)
            carInformationView.updataLeftRightBackLight(direction: 10)
        }
        
    }
   
    func goBack(value:Float){
        let string = "GOBACK*\(String.init(format: "%.2f", value))"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        //carInformationView.uadateSpeed(speed: value/255.0*100.0)
        if value > 0{
            carInformationView.updataLeftRightBackLight(direction: 31)
        }
    }
    
    
    func leftRightStop(){
          let string = "LEFTRIGHT*\(String.init(format: "%.2f", 0.0))"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        carInformationView.updataLeftRightBackLight(direction: 10)
        carInformationView.updataLeftRightBackLight(direction: 20)
    }
    func goBackStop(){
        let string = "GOBACK*\(String.init(format: "%.2f", 0.0))"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        carInformationView.updataLeftRightBackLight(direction: 30)
    }
    func bothStop(){
        let string = "BOTHSTOP*"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        carInformationView.updataLeftRightBackLight(direction: 10)
        carInformationView.updataLeftRightBackLight(direction: 20)
        carInformationView.updataLeftRightBackLight(direction: 30)
    }
    func writeLed(isOn:Bool){
        if isOn == true{
        let string = "WLEDON*"
        blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        }else {
            let string = "WLEDOFF*"
            blunoManager.writeDataToDevice(data: string.data(using: String.Encoding.utf8), dev: blunoDev)
        }
    }
    func receiveData(data:Data){
        let string = String(data: data, encoding: String.Encoding.utf8)
        if let string = string{
            print("Receice:\(string)")
            if string.hasPrefix("MPUA:"){
                let subString = (string as NSString).substring(from: 5)
                //subString = subString.substring(to: subString.endIndex)
                let arr = subString.components(separatedBy: ",")
                print(arr)
                if arr.count == 2 {
                    if !arr[0].isEmpty && !arr[1].isEmpty{
                        if arr[0] != "-" && arr[1] != "-"{
                            let mpuaData = ["AX":-Int(arr[0])!,"AY":Int(arr[1])!]
                            print(arr)
                            //update
                            carInformationView.updateLevelCircle(mpudata: mpuaData)
                        }
                    }
              
                }
               
                
            } 	
            
                if string.hasPrefix("A:") && string.hasSuffix("!"){
                     var subString = (string as NSString).substring(from: 2)
                    
                     subString.remove(at: subString.index(before: subString.endIndex))
//                    if (subString as NSString).contains("H"){
//                        return
//                    }
                    let arr = subString.components(separatedBy: ",")
                    print(arr)
                    if arr.count == 6{
                        if !arr[0].isEmpty && !arr[1].isEmpty && !arr[2].isEmpty && !arr[3].isEmpty && !arr[4].isEmpty {
                            if arr[0] != "-" && arr[1] != "-" && arr[2] != "-" && arr[3] != "-" && arr[4] != "-" {
                                
                                
                                //update
                                
                                let mpugData = ["GX":-Int(arr[0])!,"GY":Int(arr[1])!,"GZ":-Int(arr[2])!]
                                print(mpugData)
                                carInformationView.updateGyroscope(data: mpugData)
                                let mpuaData = ["AY":Int(arr[3])!,"AX":Int(arr[4])!]
                                print(mpuaData)
                                //update
                                carInformationView.updateLevelCircle(mpudata: mpuaData)
                                carInformationView.updateCommpass(value: CGFloat(Int(arr[5])!))
                            }
                        }
                    }
                }
            
                if string.hasPrefix("HUM:") && string.hasSuffix("!"){
                var subString = (string as NSString).substring(from: 4)
                 subString.remove(at: subString.index(before: subString.endIndex))
//                    if (subString as NSString).contains("M:"){
//                        return
//                    }
                let arr = subString.components(separatedBy: ",")
                if arr.count == 2{
                    let dht11Data = ["HUM":Float(arr[0])!,"TEM":Float(arr[1])!]
                    
                    //udate
                    carInformationView.updateHum(hum: dht11Data["HUM"]!)
                    carInformationView.updateTem(tem: dht11Data["TEM"]!)
                }
              
            }
            if string.hasPrefix("S:") && string.hasSuffix("!"){
                var subString = (string as NSString).substring(from: 2)
                subString.remove(at: subString.index(before: subString.endIndex))
                carInformationView.updateSpeed(speed: Float(subString)!/8.17*100.0)
            }
            if string.hasPrefix("P:") && string.hasSuffix("@"){
                var subString = (string as NSString).substring(from: 2)
                subString.remove(at: subString.index(before: subString.endIndex))
                let arr = subString.components(separatedBy: ",")
                if arr.count == 2{
                     let sr04Data = ["POS":CGFloat(Int(arr[0])!),"DIS":CGFloat(Int(arr[1])!)]
                    carInformationView.updateSr04(length: sr04Data["DIS"]!, degress: 100-sr04Data["POS"]!/180.0*100.0)
                    
                  
                }

            }
        }
        
    }
}
