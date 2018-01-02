//
//  ViewController.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/2/26.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit
//import CoreMotion
var aryDevices = [DFBlunoDevice]()


class ViewController: UIViewController,DFBlunoDelegate,UITextFieldDelegate{

    @IBOutlet weak var lbReady: UILabel!
    @IBOutlet weak var txtSendMsg: UITextField!
    @IBOutlet weak var lbReceivedMsg: UILabel!
    @IBOutlet weak var ledImageView: UIImageView!
    @IBOutlet weak var bothStopBtn: UIButton!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var sendBotton: UIButton!
  
    var toneView:ToneView! = nil
    var timer:Timer! = nil
    
    @IBOutlet weak var leftRight: UISlider!
    @IBOutlet weak var goBack: SilderClass!

    
    var popover:UIPopoverPresentationController! = nil
    var blunoManager:DFBlunoManager! = nil
    var blunoDev:DFBlunoDevice! = nil
    
    @IBOutlet weak var `switch`: UISwitch!
  //  var circle:UIView! = nil
    var speedX:UIAccelerationValue = 0
    var speedY:UIAccelerationValue = 0
  //  var motionManager = CMMotionManager()

    var carInformationView: CarInformationView! = nil
    var carClass:CarClass! = nil
    var square:SquareClass!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        blunoManager = DFBlunoManager.sharedInstance()
        blunoManager.delegate = self
        txtSendMsg.delegate = self
        blunoManager.scan()
       
        self.lbReady.text = "Not Ready!"
        
      
        carInformationView = CarInformationView(frame: CGRect(x: self.view.frame.size.width/2-500, y: 117, width: 1000, height: 375))
        carInformationView.backgroundColor = UIColor.gray
        self.view.addSubview(carInformationView)
        
        toneView = ToneView(frame: CGRect(x: self.view.frame.size.width/2 - 130, y: self.view.frame.size.height/2 + 120, width: 260, height: 260))
        
       
        self.view.insertSubview(toneView, at: 0)
        
        leftRight.isEnabled = false
        goBack.isEnabled = false
        self.switch.isOn = false
        self.switch.isEnabled = false
        self.bothStopBtn.isEnabled = false
        self.toneView.isEnabled = false
        self.sendBotton.isEnabled = false
        self.txtSendMsg.isEnabled = false
    }
    

       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

       @IBAction func actionDidEnd(_ sender: UITextField) {
    
        self.txtSendMsg.resignFirstResponder()
        
    }


    @IBAction func lightSwitch(_ sender: UISwitch) {
      if self.blunoDev == nil || !self.blunoDev.bReadyToWrite{
            let alert = UIAlertController(title: "错误", message: "蓝牙尚未连接", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
//                let v = BluDevicesTableViewController()
//                self.navigationController?.pushViewController(v, animated: true)
                self.switch.setOn(false, animated: true)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if self.blunoDev.bReadyToWrite{
            if sender.isOn{
                
                ledImageView.image = #imageLiteral(resourceName: "ledOn.jpeg")
                carClass.writeLed(isOn: true)
//                //motionManager.startDeviceMotionUpdates()
//                let winRect = UIScreen.main.bounds
//               circle = UIView(frame: CGRect(x: winRect.size.width/2, y: winRect.size.height/2, width: 50, height: 50))
//                circle.backgroundColor = UIColor.yellow
//                circle.center = CGPoint(x: winRect.size.width/2, y: winRect.size.height/2)
//                
//                circle.layer.cornerRadius = 25
//                circle.layer.shadowColor = UIColor.black.cgColor
//                circle.layer.shadowOffset = CGSize(width: 5, height: 5)
//                circle.layer.shadowRadius = 3
//                circle.layer.shadowOpacity = 0.5
//                
//                self.view.addSubview(circle)
//                accelerationAction()
                
                
            }
            else{
                ledImageView.image  = #imageLiteral(resourceName: "ledOff.png")
                carClass.writeLed(isOn: false)
//                self.blunoManager.writeDataToDevice(data: "K".data(using: String.Encoding.utf8), dev: self.blunoDev)
              //self.circle.removeFromSuperview()
//                motionManager.stopMagnetometerUpdates()
//                motionManager.stopAccelerometerUpdates()
//                motionManager.stopGyroUpdates()
//                motionManager.stopDeviceMotionUpdates()
               
            
        
            }
        }
    }
    
  

  
  
//    var valueFirst = Data()
//    var valueSecond = Data()
//    func accelerationAction(){
//       
//       // motionManager.startDeviceMotionUpdates()
//        motionManager.accelerometerUpdateInterval = 1/60
//        let queue = OperationQueue.current
//        motionManager.startAccelerometerUpdates(to: queue!) { (accelerationData, error) in
//            
//          
//            
//            self.speedX += accelerationData!.acceleration.y
//            self.speedY += accelerationData!.acceleration.x
//            var posX = self.circle.center.x - CGFloat(self.speedX)
//            var posY = self.circle.center.y - CGFloat(self.speedY)
//            
//            self.valueFirst = "K".data(using: String.Encoding.utf8)!
//            //碰撞后反弹
//            if posX<0{
//                posX = 0
//                self.speedX *= 0
//              
//                let left  = "L".data(using: String.Encoding.utf8)
//                self.valueFirst = left!
//                //self.blunoManager.writeDataToDevice(data: left, dev: self.blunoDev)
//                
//            }else if posX > self.view.frame.size.width{
//                self.speedX *= 0
//                posX = self.view.frame.size.width
//               
//                let right  = "R".data(using: String.Encoding.utf8)
//                self.valueFirst = right!
//                //self.blunoManager.writeDataToDevice(data: right, dev: self.blunoDev)
//                
//            }
//            
//             if posY < 0{
//                posY = 0
//                self.speedY *= 0
//                let top  = "T".data(using: String.Encoding.utf8)
//                self.valueFirst = top!
//                //self.blunoManager.writeDataToDevice(data: top, dev: self.blunoDev)
//                
//            }else if posY > self.view.frame.size.height{
//                posY = self.view.frame.size.height
//                self.speedY *= 0
//               
//                let bottom  = "B".data(using: String.Encoding.utf8)
//                self.valueFirst = bottom!
//                //self.blunoManager.writeDataToDevice(data: bottom, dev: self.blunoDev)
//                
//            }
//            
//            if posX == 0 && posY == 0{
//                self.valueFirst = "O".data(using: String.Encoding.utf8)!
//            }else if posX == self.view.frame.size.width && posY == 0{
//                self.valueFirst = "P".data(using: String.Encoding.utf8)!
//            }else if posX == 0 && posY == self.view.frame.size.height{
//                self.valueFirst = "Q".data(using: String.Encoding.utf8)!
//            }else if posX == self.view.frame.size.width && posY == self.view.frame.size.height{
//                self.valueFirst = "S".data(using: String.Encoding.utf8)!
//            }
//            
//            self.circle.center = CGPoint(x: posX, y: posY)
//            
//           
//            if self.valueFirst != self.valueSecond{
//                self.valueSecond = self.valueFirst
//                self.blunoManager.writeDataToDevice(data: self.valueFirst, dev: self.blunoDev)
//            }
//         
//            
//        }
//    }
    @IBAction func acitonSend(_ sender: UIButton) {
        self.txtSendMsg.resignFirstResponder()
        if self.blunoDev.bReadyToWrite{
            let strTemp = self.txtSendMsg.text
            let data = strTemp?.data(using: String.Encoding.utf8)
            self.blunoManager.writeDataToDevice(data: data, dev: self.blunoDev)
        }
    }
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSendMsg.resignFirstResponder()
        if self.blunoDev.bReadyToWrite{
            let strTemp = self.txtSendMsg.text
            let data = strTemp?.data(using: String.Encoding.utf8)
            self.blunoManager.writeDataToDevice(data: data, dev: self.blunoDev)
        }
        return true
    }
    func bleDidUpdateState(bleSupported: Bool) {
        if bleSupported{
            self.blunoManager.scan()
        }
    }
    func didDiscoverDevice(dev: DFBlunoDevice) {
        print("**")
        var bRepeat = false
        for bleDevice in aryDevices{
            if bleDevice.isEqual(dev){
            
            bRepeat = true
            break
            }
        }
        if !bRepeat{
            aryDevices.append(dev)
           // print(aryDevices)
        }
        
    
    }
    func didReadRSSI(rssi: NSNumber) {
        
        self.rssiLabel.text = "\(rssi.intValue)"
    }
    func readyToCommunicate(dev: DFBlunoDevice) {
        self.blunoDev = dev
        self.lbReady.text = "Ready!"
        //square.hide = false
        carClass = CarClass(blunoManager: blunoManager, blunoDev: blunoDev, carInformationView: carInformationView,toneView:toneView)
        leftRight.isEnabled = true
        goBack.isEnabled = true
        self.switch.isEnabled = true
        self.bothStopBtn.isEnabled = true
        self.toneView.isEnabled = true
        self.sendBotton.isEnabled = true
        self.txtSendMsg.isEnabled = true
        toneView.toneColor = UIColor.red.cgColor
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.readR), userInfo: nil, repeats: true)
        //blunoManager.readRssi(dev: dev)
        
    }
    func readR(){
        blunoManager.readRssi(blunoDev)
    }
    func didDisconnectDevice(dev: DFBlunoDevice) {
        self.lbReady.text = "Not Ready!"
        //self.timer.invalidate()
        self.rssiLabel.text = "0"
        self.switch.setOn(false, animated: true)
        leftRight.isEnabled = false
        goBack.isEnabled = false
        self.switch.isEnabled = false
        self.bothStopBtn.isEnabled = false
        self.toneView.isEnabled = false
        self.sendBotton.isEnabled = false
        self.ledImageView.image = #imageLiteral(resourceName: "ledOff.png")
        self.txtSendMsg.isEnabled = false
        toneView.toneColor = UIColor.gray.cgColor
        
        carInformationView.updateLevelCircle(mpudata: ["AX":0,"AY":0])
        carInformationView.updateSpeed(speed: 0)
        carInformationView.updateTem(tem: 0)
        carInformationView.updateHum(hum: 0)
        carClass.bothStop()
        carInformationView.updateGyroscope(data: ["GX":0,"GY":0,"GZ":0])
        carInformationView.updateCommpass(value: 0)
        toneView.value = 0
        carInformationView.updateSr04(length: 0, degress: 0)
        
    
    }
    func didWriteData(dev: DFBlunoDevice) {
        
    }
    func didReceiveData(data: Data, dev: DFBlunoDevice) {
        lbReceivedMsg.text = String(data: data, encoding: String.Encoding.utf8)
        print(String(data: data, encoding: String.Encoding.utf8) ?? "none")
        
        carClass.receiveData(data: data)
        
       
    }
    var lastLeftRight:Float = 0
    
    var lastGoBack:Float = 0
    @IBAction func leftRightChanging(_ sender: UISlider) {
        
        if abs(lastLeftRight-leftRight.value)>=10.0{
            lastLeftRight = leftRight.value
            if leftRight.value == 0.0{
                   carClass.leftRightStop()
            }else{
                print("leftRight:\(leftRight.value)")
                carClass.leftRight(value: leftRight.value)
            
            }
        }
  
    }
    @IBAction func leftRightChanged(_ sender: UISlider) {
        leftRight.setValue(0, animated: true)
        carClass.leftRightStop()
        carClass.leftRightStop()
        lastLeftRight = 0
    }
    
    @IBAction func goBackChanging(_ sender: SilderClass) {
        if fabs(goBack.value-lastGoBack) >= 10.0{
            lastGoBack = goBack.value
        
            if goBack.value == 0.0{
                carClass.goBackStop()

            }else{
                carClass.goBack(value: goBack.value)
                print("goBack:\(goBack.value)")
                
            }
            
        }
    }
   
    @IBAction func goBackChanged(_ sender: SilderClass) {
        goBack.setValue(0, animated: true)
        carClass.goBackStop()
        carClass.goBackStop()
        lastGoBack = 0

    }
    @IBAction func bothStop(_ sender: UIButton) {
        leftRight.setValue(0, animated: true)
        goBack.setValue(0, animated: true)
        lastGoBack = 0
        lastLeftRight = 0
        carClass.bothStop()

    }
    
}

