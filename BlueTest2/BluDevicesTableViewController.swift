//
//  BluDevicesTableViewController.swift
//  BlueTest2
//
//  Created by  WangKai on 2017/2/26.
//  Copyright © 2017年  WangKai. All rights reserved.
//

import UIKit


class BluDevicesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(aryDevices.count)
        return aryDevices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScanDeviceCell", for: indexPath)
   
        
        let lbName =  cell.viewWithTag(1) as! UILabel
        let lbUUID = cell.viewWithTag(2) as! UILabel
        
        let peripheral = aryDevices[indexPath.row]
    
        lbName.text = peripheral.name
        lbUUID.text = peripheral.identifier
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = aryDevices[indexPath.row]
        
        let viewController  = navigationController?.viewControllers[0] as! ViewController
        //let viewController = popoverPresentationController?.presentingViewController as! ViewController

       
        if viewController.blunoDev == nil{
            viewController.blunoDev = device
            viewController.blunoManager.connectToDevice(dev: viewController.blunoDev)
            
        }else if device == viewController.blunoDev{
            if !viewController.blunoDev.bReadyToWrite{
                viewController.blunoManager.connectToDevice(dev: viewController.blunoDev)
            }
        }else{
            if viewController.blunoDev.bReadyToWrite{
                viewController.blunoManager.disconnectToDevice(dev: viewController.blunoDev)
                viewController.blunoDev = nil
            }
            viewController.blunoManager.connectToDevice(dev: device)
        }
        self.navigationController!.popViewController(animated: true)
   }
}
