//
//  ViewController.swift
//  sidebar
//
//  Created by norly on 2/22/15.
//  Copyright (c) 2015 norly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sidebar = Sidebar(originView: view, menuItems: ["Profile", "Settings", "Logout"])
        sidebar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: SidebarDelegate{
    func sidebarDidSelect(indexPath: NSIndexPath){
        println("did select")
    }
    
    func sidebarDidShow(){
        println("DidShow")
    }
    
    func sidebarDidHide() {
        println("DidHide")
    }
}

