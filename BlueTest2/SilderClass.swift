//
//  SilderClass.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/3/25.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit

class SilderClass: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var rotation:CGFloat = 0{
        didSet{
            self.transform = CGAffineTransform(rotationAngle: rotation)
       
        }
    }
}
