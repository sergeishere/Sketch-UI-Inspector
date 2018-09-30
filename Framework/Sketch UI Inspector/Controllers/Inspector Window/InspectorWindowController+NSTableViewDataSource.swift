//
//  InspectorWindowController+NSTableViewDataSource.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

extension InspectorWindowController: NSTableViewDataSource {
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return properties.count
    }
    
}
