//
//  InspectorWindowController+NSOutlineViewDelegate.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

extension InspectorWindowController: NSOutlineViewDelegate {
    
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let cell = inspectorOutlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CommonCell"), owner: self) as? NSTableCellView else { return nil}
        cell.textField?.stringValue = String(describing: item)
        return cell
    }
    
    public func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let selectedItem = inspectorOutlineView.item(atRow: inspectorOutlineView.selectedRow) as? NSObject else { return }
        
        if let selectedView = selectedItem as? NSView {
            plugin_log("%@", String(describing: selectedView.frame))
            if let previousRow = self.previousSelectedRow,
                let previousView = inspectorOutlineView.item(atRow: previousRow) as? NSView,
                let temporaryLayer = self.temporaryLayer {
                previousView.layer = temporaryLayer
            }
            selectedView.wantsLayer = true
            self.temporaryLayer = selectedView.layer?.copy() as? CALayer
            selectedView.layer?.borderColor = NSColor.red.cgColor
            selectedView.layer?.borderWidth = 2.0
            self.previousSelectedRow = inspectorOutlineView.selectedRow
        }
        
        self.properties = [String:Any?]()
        for property in selectedItem.properties() {
            guard let value = selectedItem.value(forKey: property) else { continue }
            properties[property] = value
        }
        
        
        
        inspectorTableView.reloadData()
    }
    
}
