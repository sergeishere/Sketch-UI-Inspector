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
        plugin_log("Plugin initialized")
        super.init()
    }
    
    @objc public func configure() {
        plugin_log("Plugin configured")
    }
    
    @objc public func openInspector() {
        plugin_log("Will open inspector")
        self.inspectorWindowController.showWindow(nil)
    }
}
