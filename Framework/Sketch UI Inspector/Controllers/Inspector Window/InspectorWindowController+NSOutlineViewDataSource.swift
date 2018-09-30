//
//  InspectorWindowController+NSOutlineViewDataSource.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

extension InspectorWindowController: NSOutlineViewDataSource {
    
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let document = item as? NSDocument {
            return document.windowControllers.count
        }
        if let windowController = item as? NSWindowController,
            let _ = windowController.window {
            return 1
        }
        if let window = item as? NSWindow,
            let _ = window.contentView {
            return 1
        }
        if let view = item as? NSView {
            if let window = view.window,
                let contentView = window.contentView,
                view.isEqual(contentView),
                view.subviews.contains(self.highlightingView) {
                return view.subviews.count - 1
            }
            return view.subviews.count
        }
        return NSDocumentController.shared.documents.count
    }
    
    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let document = item as? NSDocument, !document.windowControllers.isEmpty {
            return true
        }
        if let windowController = item as? NSWindowController,
            let _ = windowController.window {
            return true
        }
        if let window = item as? NSWindow,
            let contentView = window.contentView {
            return !contentView.subviews.isEmpty
        }
        if let view = item as? NSView {
            return !view.subviews.isEmpty
        }
        return false
    }
    
    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let document = item as? NSDocument {
            return document.windowControllers[index]
        }
        if let windowController = item as? NSWindowController,
            let window = windowController.window {
            return window
        }
        if let window = item as? NSWindow,
            let contentView = window.contentView {
            return contentView
        }
        if let view = item as? NSView {
            let childView = view.subviews[index]
            if childView !== self.highlightingView {
                return childView
            }
        }
        return NSDocumentController.shared.documents[index]
    }
}
