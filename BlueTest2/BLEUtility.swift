//
//  BLEUtility.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/2/26.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEUtility: NSObject {
 class   func writeCharacteristic(peripheral:CBPeripheral,sUUID:String,cUUID:String,data:Data){
        for service in peripheral.services!{
            if service.uuid.isEqual(CBUUID.init(string: sUUID)){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(CBUUID(string: cUUID)){
                        peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                        
                    }
                }
            }
        }
        print(String(data: data, encoding: String.Encoding.utf8) ?? "???")
    }
    
   class func writeCharacteristic(peripheral:CBPeripheral,sCBUUID:CBUUID,cCBUUID:CBUUID,data:Data){
        for service in peripheral.services!{
            if service.uuid.isEqual(sCBUUID){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(cCBUUID){
                        peripheral.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    }
                }
            }
        }
    }
    
   class func readCharacteristic(peripheral:CBPeripheral,sUUID:String,cUUID:String){
        for service in peripheral.services!{
            if service.uuid.isEqual(CBUUID(string: sUUID)){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(CBUUID(string: cUUID)){
                        peripheral.readValue(for: characteristic)
                    }
                }
            }
        }
    }
    
   class func readCharacteristic(peripheral:CBPeripheral,sCBUUID:CBUUID,cCBUUID:CBUUID){
        for service in peripheral.services!{
            if service.uuid.isEqual(sCBUUID){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(cCBUUID){
                        peripheral.readValue(for: characteristic)
                    }
                }
            }
        }
    }
    
   class func setNotificationForCharacteristic(peripheral:CBPeripheral,sUUID:String,cUUID:String,enable:Bool){
        for service in peripheral.services!{
            if service.uuid.isEqual(CBUUID.init(string: sUUID)){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(CBUUID(string: cUUID)){
                        peripheral.setNotifyValue(enable, for: characteristic)
                    }
                }
            }
        }
    }
    
  class  func setNotificationForCharacteristic(peripheral:CBPeripheral,sCBUIUD:CBUUID,cCBUUID:CBUUID,enable:Bool){
        for service in peripheral.services!{
            if service.uuid.isEqual(sCBUIUD){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(cCBUUID){
                        peripheral.setNotifyValue(enable, for: characteristic)
                    }
                }
            }
        }
    }
    
  class  func isCharacteristicNotifiable(peripheral:CBPeripheral,sCBUUID:CBUUID,cCBUUID:CBUUID)->Bool{
        for service in peripheral.services!{
            if service.uuid.isEqual(sCBUUID){
                for characteristic in service.characteristics!{
                    if characteristic.uuid.isEqual(cCBUUID){
                        if characteristic.properties.rawValue & CBCharacteristicProperties.notify.rawValue != 0{
                            return true
                        }else{
                            return false
                        }
                    }
                }
            }
        }
        return false
    }
}
