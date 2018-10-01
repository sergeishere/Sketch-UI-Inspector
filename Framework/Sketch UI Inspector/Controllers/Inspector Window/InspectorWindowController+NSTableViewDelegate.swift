//
//  InspectorWindowController+NSTableViewDelegate.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

extension InspectorWindowController: NSTableViewDelegate {
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cell: NSTableCellView
        switch tableColumn?.identifier {
        case NSUserInterfaceItemIdentifier(rawValue:"KeyColumn"):
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PropertiesCell"), owner: self) as! NSTableCellView
            cell.textField?.stringValue =  properties[row].name
        case NSUserInterfaceItemIdentifier(rawValue:"TypeColumn"):
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TypeCell"), owner: self) as! NSTableCellView
            cell.textField?.stringValue = properties[row].type
        case NSUserInterfaceItemIdentifier(rawValue:"ValueColumn"):
            cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as! NSTableCellView
            cell.textField?.stringValue = properties[row].valueString
        default:
            return NSView()
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return defaultRowHeight * CGFloat(properties[row].valueLinesCount)
    }
    
}
