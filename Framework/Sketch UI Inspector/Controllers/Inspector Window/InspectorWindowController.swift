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
    let overlayLayer = CAShapeLayer()
    
    var overlayPath = NSBezierPath()
    var maskPath = NSBezierPath()
    
    var rootView: NSView?
    
    let defaultRowHeight:CGFloat = 17
    
    // MARK: - Lifecycle
    override func windowDidLoad() {
        super.windowDidLoad()
        self.inspectorOutlineView.dataSource = self
        self.inspectorOutlineView.delegate = self
        
        self.inspectorTableView.dataSource = self
        self.inspectorTableView.delegate = self
        
        if let window = NSApp.mainWindow,
            let contentView = window.contentView {
            rootView = contentView
            self.highlightingView.frame = self.rootView!.bounds
            self.highlightingView.wantsLayer = true
            
            overlayPath = NSBezierPath(rect: self.rootView!.bounds.insetBy(dx: -1, dy: -1))
            maskPath = NSBezierPath(rect: self.rootView!.bounds)
            overlayPath.append(maskPath)
            overlayPath.windingRule = .evenOdd
            
            overlayLayer.path = overlayPath.cgPath
            overlayLayer.fillColor = NSColor.black.withAlphaComponent(0.5).cgColor
            overlayLayer.fillRule = .evenOdd

            self.highlightingView.layer?.addSublayer(overlayLayer)
            
            self.overlayLayer.lineWidth = 1.0
            if #available(OSX 10.14, *) {
                self.overlayLayer.strokeColor = NSColor.controlAccentColor.cgColor
            } else {
                self.overlayLayer.strokeColor = NSColor.alternateSelectedControlColor.cgColor
            }
        }
        
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
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.inspectorOutlineView.deselectRow(self.inspectorOutlineView.selectedRow)
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
        self.highlightingView.isHidden = false
        guard let rootView = self.rootView else { return }
        
        let frameInWindow = view.convert(view.bounds, to: nil)
        
        overlayPath = NSBezierPath(rect: rootView.bounds.insetBy(dx: -1, dy: -1))
        maskPath = NSBezierPath(rect: frameInWindow)
        overlayPath.append(maskPath)
        overlayLayer.path = overlayPath.cgPath
    }
    
    func removeHighlighting() {
        self.highlightingView.isHidden = true
    }
    
    // MARK: - IBActions
    
    @IBAction func reloadData(_ sender: Any?) {
        self.inspectorOutlineView.reloadData()
        self.inspectorOutlineView.expandItem(nil, expandChildren: true)
    }
    
}







