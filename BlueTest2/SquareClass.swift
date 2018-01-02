//
//  SquareClass.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/3/23.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit
import CoreMotion
import GLKit

class SquareClass: UIView {
//    var hide:Bool = true{
//        didSet{
//            if self.hide == true{
//                mainLayer.isHidden = true
//            }else{
//                mainLayer.isHidden = false
//            }
//        }
//    }
    
    var mainLayer:CALayer! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mainLayer = CALayer()
       mainLayer.contentsScale = UIScreen.main.scale
        mainLayer.frame = UIScreen.main.bounds
        //前面
        self.addLayer(params: [0,0,100,0,0,0,0])
        //后面
        self.addLayer(params: [0,0,-100,CGFloat.pi,0,0,0])
        //左面
        self.addLayer(params: [-100,0,0,-CGFloat.pi/2,0,1,0])
        //右面
        self.addLayer(params: [100,0,0,CGFloat.pi/2,0,1,0])
        //上面
        self.addLayer(params: [0,-100,0,-CGFloat.pi/2,1,0,0])
        //下面
        self.addLayer(params: [0,100,0,CGFloat.pi/2,1,0,0])
        
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/700
        
        transform = CATransform3DRotate(transform, CGFloat.pi/9 ,1, 0, 0)
        self.mainLayer.sublayerTransform = transform
        self.layer.addSublayer(mainLayer)
        
        //动画
        let animation  = CABasicAnimation(keyPath: "sublayerTransform.rotation.y")
        //从0到360
        animation.toValue = 2*CGFloat.pi
        //间隔3秒
        animation.duration = 3
        //无限循环
        animation.repeatCount = HUGE
        //开始动画
        self.mainLayer.add(animation, forKey: "rotation")
    }
    

    func addLayer(params:[CGFloat]){
        let gradient = CAGradientLayer()
        
        gradient.contentsScale = UIScreen.main.scale
        gradient.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        gradient.position = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        gradient.colors = [UIColor.gray.cgColor,UIColor.black.cgColor]
        gradient.locations = [0,1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        var transform = CATransform3DMakeTranslation(params[0], params[1], params[2])
        transform = CATransform3DRotate(transform, params[3], params[4], params[5], params[6])
        
        gradient.transform = transform
        self.mainLayer.addSublayer(gradient)
    }
    
    func change(x:CGFloat,y:CGFloat,z:CGFloat){
        //把CATransform转换成GLKMatrix4
      
        
        //注意Y轴翻转
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
