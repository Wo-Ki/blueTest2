//
//  DFBlunoManager.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/2/26.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import Foundation
import CoreBluetooth

let kBlunoService = "dfb0"
let kBlunoDataCharacteristic = "dfb1"

protocol DFBlunoDelegate{
    func bleDidUpdateState(bleSupported:Bool)
    
    func didDiscoverDevice(dev:DFBlunoDevice)
    
    func readyToCommunicate(dev:DFBlunoDevice)
    
    func didDisconnectDevice(dev:DFBlunoDevice)
    
    func didWriteData(dev:DFBlunoDevice)
    
    func didReceiveData(data:Data,dev:DFBlunoDevice)
    
    func didReadRSSI(rssi:NSNumber)
}

class DFBlunoManager:NSObject,CBCentralManagerDelegate,CBPeripheralDelegate{
    /*!
     *  @method centralManagerDidUpdateState:
     *
     *  @param central  The central manager whose state has changed.
     *
     *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
     *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
     *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
     *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
     *                  manager become invalid and must be retrieved or discovered again.
     *
     *  @see            state
     *
     */
  
    var delegate:DFBlunoDelegate!
    var bSupported = Bool()
    
    var centralManager:CBCentralManager!
    var dicBleDevices:NSMutableDictionary!
    var dicBlunoDevices:NSMutableDictionary!
   class  func sharedInstance()->DFBlunoManager{
     
          let this = DFBlunoManager()
        this.dicBleDevices = NSMutableDictionary()
        this.dicBlunoDevices = NSMutableDictionary()
        this.bSupported = false
        this.centralManager = CBCentralManager(delegate: this, queue: nil)
        
        return this
        
    }
    

    func configureSensorTag(peripheral:CBPeripheral){

        print("configure")
        let sUUID = CBUUID(string: kBlunoService)
        let cUUID = CBUUID(string: kBlunoDataCharacteristic)
        
        BLEUtility.setNotificationForCharacteristic(peripheral: peripheral, sCBUIUD: sUUID, cCBUUID: cUUID, enable: true)
        
        let key = peripheral.identifier.uuidString
        let blunoDev:DFBlunoDevice = self.dicBlunoDevices.object(forKey: key) as! DFBlunoDevice
        blunoDev.bReadyToWrite = true
        
        delegate.readyToCommunicate(dev: blunoDev)
        
    }
    
    func deConfigureSensorTag(peripheral:CBPeripheral){
        let sUUID = CBUUID(string: kBlunoService)
        let cUUID = CBUUID(string: kBlunoDataCharacteristic)
        
        BLEUtility.setNotificationForCharacteristic(peripheral: peripheral, sCBUIUD: sUUID, cCBUUID: cUUID, enable: false)
    }
    
    func scan(){
        self.centralManager.stopScan()
        
        if bSupported {
            self.centralManager.scanForPeripherals(withServices: [CBUUID.init(string: kBlunoService)], options: nil)
        }
    }
    
    func stop(){
        self.centralManager.stopScan()
    }
    
    func clear(){
        self.dicBlunoDevices.removeAllObjects()
        self.dicBleDevices.removeAllObjects()
    }
    
    func connectToDevice(dev:DFBlunoDevice){
        let bleDev:BLEDevice = self.dicBleDevices.object(forKey: dev.identifier) as! BLEDevice
       bleDev.centralManager.connect(bleDev.peripheral, options: nil)
        
    }
    
    func disconnectToDevice(dev:DFBlunoDevice){
        let bleDev:BLEDevice = self.dicBleDevices.object(forKey: dev.identifier) as! BLEDevice
        self.deConfigureSensorTag(peripheral: bleDev.peripheral)
        bleDev.centralManager.cancelPeripheralConnection(bleDev.peripheral)
        
        
    }
    
    func writeDataToDevice(data:Data?,dev:DFBlunoDevice){

        
        if !bSupported || data == nil{
            return
        }else if !dev.bReadyToWrite{
            return
        }
        print("writeData :\(String(describing: String.init(data: data!, encoding: String.Encoding.utf8)))")
        let bleDev = self.dicBleDevices.object(forKey: dev.identifier) as! BLEDevice
        BLEUtility.writeCharacteristic(peripheral: bleDev.peripheral, sUUID: kBlunoService, cUUID: kBlunoDataCharacteristic, data: data!)
        
  
    }
    @available(iOS 5.0, *)
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != CBManagerState.poweredOn{
            bSupported = false
            let aryDeviceKeys = self.dicBleDevices.allKeys as! [String]
            for strKey:String in aryDeviceKeys{
                let blunoDev = self.dicBlunoDevices.object(forKey: strKey) as! DFBlunoDevice
                blunoDev.bReadyToWrite = false
            }
        }else{
            bSupported = true
        }
        
        delegate.bleDidUpdateState(bleSupported: bSupported)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let key = peripheral.identifier.uuidString
        let dev:BLEDevice? = self.dicBleDevices.object(forKey: key) as? BLEDevice
        if dev != nil{
            dev!.peripheral = peripheral
            let blunoDev:DFBlunoDevice = self.dicBlunoDevices.object(forKey: key) as! DFBlunoDevice
             delegate.didDisconnectDevice(dev: blunoDev)
        }else{
           // print("****????")
            let bleDev = BLEDevice()
            bleDev.peripheral = peripheral
            bleDev.centralManager = self.centralManager
            self.dicBleDevices.setObject(bleDev, forKey: key as NSCopying)
            
            let blunoDev = DFBlunoDevice()
            blunoDev.identifier = key
            blunoDev.name = peripheral.name
            self.dicBlunoDevices.setObject(blunoDev, forKey: key as NSCopying)
            
            delegate.didDiscoverDevice(dev: blunoDev)
//            print(peripheral.identifier.uuidString)
//              print(dicBleDevices)
//            print(dicBlunoDevices)
    
          
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
    
    func readRssi(_ dev:DFBlunoDevice){
        let key = dev.identifier
        let per:BLEDevice? = self.dicBleDevices.object(forKey: key as Any) as? BLEDevice
        per?.peripheral.readRSSI()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let key = peripheral.identifier.uuidString
        let blunoDev = self.dicBlunoDevices.object(forKey: key) as! DFBlunoDevice
        blunoDev.bReadyToWrite = false
        
        delegate.didDisconnectDevice(dev: blunoDev)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for s in peripheral.services!{
            peripheral.discoverCharacteristics(nil, for: s)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if service.uuid.isEqual(CBUUID.init(string: kBlunoService)){
            self.configureSensorTag(peripheral: peripheral)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        let key = peripheral.identifier.uuidString
        let blunoDev = self.dicBlunoDevices.object(forKey: key) as! DFBlunoDevice
        
        print(String(data: characteristic.value!, encoding: String.Encoding.utf8) ?? "nonenone")
        delegate.didReceiveData(data: characteristic.value!, dev: blunoDev)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("didWriteValueFor")
        let key = peripheral.identifier.uuidString
        let blunoDev = self.dicBlunoDevices.object(forKey: key) as! DFBlunoDevice
        delegate.didWriteData(dev: blunoDev)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        delegate.didReadRSSI(rssi: RSSI)
        print("RSSI:\(RSSI.intValue)")
    }
    
    
}
