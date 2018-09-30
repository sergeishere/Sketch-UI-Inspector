//
//  InspectorWindowController+NSTableViewDelegate.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

extension InspectorWindowController: NSTableViewDelegate {
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PropertiesCell"), owner: self) as? NSTableCellView else { return nil }
        switch tableColumn?.identifier {
        case NSUserInterfaceItemIdentifier(rawValue:"KeyColumn"):
            cell.textField?.stringValue =  properties[row].name
        case NSUserInterfaceItemIdentifier(rawValue:"TypeColumn"):
            cell.textField?.stringValue = properties[row].type
        case NSUserInterfaceItemIdentifier(rawValue:"ValueColumn"):
            cell.textField?.stringValue = properties[row].value
            
        default:
            return NSView()
        }
        return cell
    }
}
