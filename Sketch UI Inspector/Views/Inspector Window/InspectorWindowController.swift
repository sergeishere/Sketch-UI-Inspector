//
//  InspectorWindowController.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 28/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import Cocoa

public class InspectorWindowController: NSWindowController {
    
    @IBOutlet weak var inspectorOutlineView: NSOutlineView!
    @IBOutlet weak var inspectorTableView: NSTableView!
    
    var properties = [String: Any?]()
    
    var temporaryLayer: CALayer?
    var previousSelectedRow: Int?
    
    override public func windowDidLoad() {
        super.windowDidLoad()
        inspectorOutlineView.dataSource = self
        inspectorOutlineView.delegate = self
        
        inspectorTableView.dataSource = self
        inspectorTableView.delegate = self
    }

}







