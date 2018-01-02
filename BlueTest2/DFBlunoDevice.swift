//
//  DFBlunoDevice.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/2/26.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit

class DFBlunoDevice: NSObject {
     var bReadyToWrite:Bool = false
    
    var identifier:String!
    var name:String!
    
    
    override init() {
        super.init()
        //self.bReadyToWrite = false
    }
    
}
