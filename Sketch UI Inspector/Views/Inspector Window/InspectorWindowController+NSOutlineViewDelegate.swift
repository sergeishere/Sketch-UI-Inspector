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
        cell.textField?.stringValue = (item as? NSObject)?.className ?? "Undefined"
        return cell
    }
    
    public func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let selectedItem = inspectorOutlineView.item(atRow: inspectorOutlineView.selectedRow) else {
            self.resetInspector()
            return
        }
        self.inspect(selectedItem as AnyObject)
    }
    
}
