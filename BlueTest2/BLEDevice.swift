//
//  BLEDevice.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/2/26.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEDevice: NSObject {
    var peripheral:CBPeripheral!
    var centralManager:CBCentralManager!
    var dicSetupData:NSMutableDictionary!
    var aryResources:NSMutableArray!
}
