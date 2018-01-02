//
//  ToneView.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/4/6.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit

class ToneView: UIControl {
    var value:CGFloat = 0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var toneColor:CGColor = UIColor.gray.cgColor{
        didSet{
            self.setNeedsDisplay()
        }
    }
    let  lineWidth:CGFloat = 2
    let radius:CGFloat = 120
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    func degreesToRadians(degress:CGFloat)->CGFloat{
        return CGFloat(Double.pi)*degress/180
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
       // super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        //绘制灰色的背景
        context?.addArc(center: CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: true)
        UIColor.gray.setStroke()
        context?.setLineWidth(lineWidth)
        context?.setLineCap(CGLineCap.round)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        //绘制进度
        context?.addArc(center: CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: radius, startAngle: 0, endAngle: degreesToRadians(degress: value), clockwise: false)
        UIColor.red.setStroke()
        context?.setLineWidth(lineWidth)
        context?.setLineCap(CGLineCap.round)
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
        //绘制拖动小块
        let handleCenter = self.pointFromAngle(angleInt: Int(self.value))
        context?.setShadow(offset: CGSize.init(width: 2, height: 2), blur: 3, color: UIColor.black.cgColor)
        context?.setStrokeColor(toneColor)
        context?.setLineWidth(lineWidth*4)
        context?.addEllipse(in: CGRect(x: handleCenter.x, y: handleCenter.y, width: lineWidth*4, height: lineWidth*4))
        context?.drawPath(using: CGPathDrawingMode.stroke)
        
    }
    func pointFromAngle(angleInt:Int)->CGPoint{
        //中心点
        let centerPoint = CGPoint.init(x: self.frame.size.width/2-lineWidth*2, y: self.frame.size.height/2-lineWidth*2)
        //根据角度得到圆环上的坐标
        var results = CGPoint()
        results.y = round(centerPoint.y + radius*sin(degreesToRadians(degress: CGFloat(angleInt))))
        results.x = round(centerPoint.x+radius*cos(degreesToRadians(degress: CGFloat(angleInt))))
        return  results
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        return true
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        //获取触摸点
        let lastPoint = touch.location(in: self)
        //使用触摸点来移动小块
        self.movehandle(lastPoint: lastPoint)
        //发送值改变事件
        self.sendActions(for: UIControlEvents.valueChanged)
        return true
    }
    //更新滑块手柄的位置
    func movehandle(lastPoint:CGPoint){
        //获取中心点
        let centerPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        //计算中心到任一点的角度
        let currentAngle = AngleFromNorth(p1: centerPoint, p2: lastPoint, flipped: false)
        let  angleInt = floor(currentAngle)
        //保存新角度
        self.value = CGFloat(angleInt)
        self.setNeedsDisplay()
    }
    func toDeg(rad:CGFloat)->CGFloat{
       return (180.0 * (rad)) / CGFloat(Double.pi)
    }
    func AngleFromNorth(p1:CGPoint,p2:CGPoint,flipped:Bool)->CGFloat{
        var v = CGPoint(x: p2.x-p1.x, y: p2.y-p1.y)
        let vmag = sqrt(v.x*v.x+v.y*v.y)
        var result:CGFloat = 0
        v.x /= vmag
        v.y /= vmag
        
        let radians = atan2(v.y, v.x)
        result = toDeg(rad: radians)
        return (result >= 0 ? result : result + 360.0)
    }
}
