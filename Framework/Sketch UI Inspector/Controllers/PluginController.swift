//
//  SketchUIInspector.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 28/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

@objc(SketchUIInspector) class PluginController: NSObject {
    
    // MARK: - Singletone instance
    @objc static let shared = PluginController()
    
    // MARK: - Private Properties
    private let inspectorWindowController: InspectorWindowController
    
    // MARK: - Plugin Lifecycle
    private override init() {
        self.inspectorWindowController = InspectorWindowController(windowNibName: .inspectorNibName)
        super.init()
    }
    
    @objc public func configure() {
    }
    
    @objc public func openInspector() {
        self.inspectorWindowController.showWindow(nil)
    }
}
