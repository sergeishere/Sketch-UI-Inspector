//
//  InspectorWindowController.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 28/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import Cocoa

class InspectorWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var inspectorOutlineView: NSOutlineView!
    @IBOutlet weak var inspectorTableView: NSTableView!
    
    @IBOutlet weak var classNameLabel: NSTextField!
    @IBOutlet weak var controllerNameLabel: NSTextField!
    
    var properties = [Property]()
    
    var highlightingView: NSView = NSView()
    
    // MARK: - Lifecycle
    override func windowDidLoad() {
        super.windowDidLoad()
        self.inspectorOutlineView.dataSource = self
        self.inspectorOutlineView.delegate = self
        
        self.inspectorTableView.dataSource = self
        self.inspectorTableView.delegate = self
        
        self.highlightingView.wantsLayer = true
        self.highlightingView.layer?.borderWidth = 2.0
        self.highlightingView.layer?.borderColor = NSColor.clear.cgColor
        
        self.window?.level = .normal
        
        self.reloadData(nil)
    }
    
    override func showWindow(_ sender: Any?) {
        self.attachHighlighingView()
        super.showWindow(sender)
    }
    
    func windowWillClose(_ notification: Notification) {
         self.deattachHighlightingView()
    }
    
    // MARK: - Public methods
    
    func attachHighlighingView() {
        guard highlightingView.superview == nil else { return }
        if let contentView = NSApp.mainWindow?.contentView {
            contentView.addSubview(highlightingView)
        }
    }
    
    func deattachHighlightingView() {
        guard highlightingView.superview != nil else { return }
        highlightingView.removeFromSuperview()
    }
    
    func inspect(_ item: Any?) {
        
        self.properties = []
        self.removeHighlighting()
        
        guard let item = item else { return }

        if let objectClass = (item as AnyObject).classForCoder,
            let superclass = (item as AnyObject).classForCoder.superclass() {
            self.classNameLabel.stringValue = "\(String(describing: objectClass)) (\(String(describing: superclass)))"
        }
        
        if let object = item as? NSObject {
            if let properties = getTypesOfProperties(for: object) {
                self.properties = properties.sorted(by: { $0.name < $1.name })
            }
            
        }
        
        if let window = item as? NSWindow,
            let controller = window.contentViewController {
            self.controllerNameLabel.stringValue = String(describing: controller)
        }
        
        if let view = item as? NSView {
            self.highlight(view)
        }
        
        
        inspectorTableView.reloadData()
    }
    
    func highlight(_ view: NSView) {
        if #available(OSX 10.14, *) {
            self.highlightingView.layer?.borderColor = NSColor.controlAccentColor.cgColor
        } else {
            self.highlightingView.layer?.borderColor = NSColor.alternateSelectedControlColor.cgColor
        }
        let frameInWindow = view.convert(view.bounds, to: nil)
        self.highlightingView.frame = frameInWindow
    }
    
    func removeHighlighting() {
        self.highlightingView.layer?.borderColor = NSColor.clear.cgColor
    }
    
    // MARK: - IBActions
    
    @IBAction func reloadData(_ sender: Any?) {
        self.inspectorOutlineView.reloadData()
        self.inspectorOutlineView.expandItem(nil, expandChildren: true)
    }
    
}







