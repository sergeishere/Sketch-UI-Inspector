//
//  InspectorWindowController.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 28/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import Cocoa

class InspectorWindowController: NSWindowController {
    
    @IBOutlet weak var inspectorOutlineView: NSOutlineView!
    @IBOutlet weak var inspectorTableView: NSTableView!
    
    @IBOutlet weak var classNameLabel: NSTextField!
    @IBOutlet weak var superclassNameLabel: NSTextField!
    
    var properties = [AnyHashable: Any]()

    var highlightingView: NSView?
    
    // MARK: - Lifecycle
    override func windowDidLoad() {
        super.windowDidLoad()
        inspectorOutlineView.dataSource = self
        inspectorOutlineView.delegate = self
        
        inspectorTableView.dataSource = self
        inspectorTableView.delegate = self
        
        if let contentView = NSApp.mainWindow?.contentView {
            plugin_log("Superview is %@", String(describing: contentView.superview?.superview))
            highlightingView = NSView()
            highlightingView?.wantsLayer = true
            highlightingView?.layer?.borderWidth = 2.0
            highlightingView?.layer?.borderColor = NSColor.clear.cgColor
            contentView.addSubview(highlightingView!)
        }
        
        self.reloadData(nil)
    }
    
    // MARK: - Public methods
    func inspect(_ item: AnyObject) {
        
        if let objectClass = item.classForCoder {
            self.classNameLabel.stringValue = String(describing: objectClass)
            
        }
        
        if let superclass = item.classForCoder.superclass() {
            self.superclassNameLabel.stringValue = String(describing: superclass)
        }
        
        if let object = item as? NSObject {
            self.properties = object.propertyList()
        }
        
        self.removeHighlighting()
        if let view = item as? NSView {
            self.highlight(view)
        }
        
       
        inspectorTableView.reloadData()
    }
    
    func resetInspector() {
        self.removeHighlighting()
        self.properties = [:]
        self.classNameLabel.stringValue = "-"
        self.superclassNameLabel.stringValue = "-"
        inspectorTableView.reloadData()
    }
    
    func highlight(_ view: NSView) {
        if #available(OSX 10.14, *) {
            self.highlightingView?.layer?.borderColor = NSColor.controlAccentColor.cgColor
        } else {
            self.highlightingView?.layer?.borderColor = NSColor.alternateSelectedControlColor.cgColor
        }
        let frameInWindow = view.convert(view.bounds, to: nil)
        self.highlightingView?.frame = frameInWindow
    }
    
    func removeHighlighting() {
        self.highlightingView?.layer?.borderColor = NSColor.clear.cgColor
    }
    
    // MARK: - IBActions
    
    @IBAction func reloadData(_ sender: Any?) {
        self.inspectorOutlineView.reloadData()
        self.inspectorOutlineView.deselectAll(nil)
        self.inspectorOutlineView.expandItem(nil, expandChildren: true)
        self.resetInspector()
    }

}







