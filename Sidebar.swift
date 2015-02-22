//
//  Sidebar.swift
//  sidebar
//
//  Created by norly on 2/22/15.
//  Copyright (c) 2015 norly. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SidebarDelegate{
    func sidebarDidSelect(indexPath: NSIndexPath)
    optional func sidebarDidShow()
    optional func sidebarDidHide()
}

class Sidebar: NSObject, SidebarTableViewControllerDelegate{
    let originView: UIView!
    let sidebarContainerView = UIView()
    let tableViewController =  SidebarTableViewController()
    let animator = UIDynamicAnimator()
    let sidebarPaddingTop: CGFloat = 50.0
    
    var isSidebarOpen = false
    var delegate: SidebarDelegate?
    var sidebarWidth: CGFloat = 150.0
    
    override init(){
        super.init()
    }
    
    init(originView: UIView, menuItems: [String]){
        super.init()
        self.originView = originView
        tableViewController.tableData = menuItems
        
        let showGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        
        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        
        originView.addGestureRecognizer(showGestureRecognizer)
        originView.addGestureRecognizer(hideGestureRecognizer)
        
        /** 
            Display sidebar within originView, with proper position,
        */
        
        tableViewController.delegate = self
        tableViewController.tableView.separatorStyle = .None
        tableViewController.tableView.backgroundColor = UIColor.clearColor()
        tableViewController.tableView.contentInset = UIEdgeInsets(top: sidebarPaddingTop, left: 0, bottom: 0, right: 0)
        
        sidebarContainerView.frame = CGRect(x: -sidebarWidth - 1, y: 0, width: sidebarWidth,
            height: originView.frame.height)
        
        sidebarContainerView.clipsToBounds = true
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.frame = sidebarContainerView.bounds
        
        sidebarContainerView.addSubview(blurView)
        sidebarContainerView.addSubview(tableViewController.tableView)
        
        originView.addSubview(sidebarContainerView)

    }
    
    func handleSwipe(swipeGestureRecognizer: UISwipeGestureRecognizer){
        if .Right == swipeGestureRecognizer.direction {
            toggleSidebar(true)
            delegate?.sidebarDidShow?()
        }else{
            toggleSidebar(false)
            delegate?.sidebarDidHide?()
        }
    }
    
    func toggleSidebar(shouldOpen: Bool){
        animator.removeAllBehaviors()
        isSidebarOpen = shouldOpen
        
        let gravityX:  CGFloat = shouldOpen ? 0.5 : -0.5
        let magnitude: CGFloat = shouldOpen ? 20  : -20
        let boundaryX: CGFloat = shouldOpen ? sidebarWidth : -sidebarWidth - 1
        
        let gravityBehavior: UIGravityBehavior = UIGravityBehavior(items: [ sidebarContainerView ])
        gravityBehavior.gravityDirection = CGVectorMake(gravityX, 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior: UICollisionBehavior = UICollisionBehavior(items: [ sidebarContainerView ])
        collisionBehavior.addBoundaryWithIdentifier("sideBarBoundary", fromPoint: CGPointMake(boundaryX, 20), toPoint: CGPointMake(boundaryX, originView.frame.size.height))
        
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior = UIPushBehavior(items: [ sidebarContainerView ], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideBarBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [ sidebarContainerView ])
        sideBarBehavior.elasticity = 0.3
        animator.addBehavior((sideBarBehavior))
    }
    
    func sidebarControlDidSelectRow(indexPath: NSIndexPath){
        delegate?.sidebarDidSelect(indexPath)
    }
}
