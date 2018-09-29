//
//  InspectorWindowController+NSTableViewDelegate.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

extension InspectorWindowController: NSTableViewDelegate {
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        switch tableColumn?.identifier {
        case NSUserInterfaceItemIdentifier(rawValue:"KeyColumn"):
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "KeyCell"), owner: self) as? NSTableCellView else { return nil }
            cell.textField?.stringValue =  String(describing: Array(properties.keys)[row])
            return cell
        case NSUserInterfaceItemIdentifier(rawValue:"ValueColumn"):
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView else { return nil }
            cell.textField?.stringValue = String(describing: Array(properties.values)[row])
            return cell
        default:
            return NSView()
        }
    }
}
