//
//  Property.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 30/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import Foundation

struct Property {
    let name: String
    let type: String
    let value: AnyObject
    
    var valueString: String  {
        if self.type == "NSArray",
            let arrayValue = self.value as? NSArray,
            arrayValue.count > 0 {
            return arrayValue.componentsJoined(by: "\n")
        } else {
            return self.value.description ?? String(describing: self.value)
        }
    }
    
    var valueLinesCount: Int {
        guard !self.valueString.isEmpty else { return 1 }
        var numberOfLines = 0
        self.valueString.enumerateLines(invoking: { (_, _) in
            numberOfLines += 1
        })
        return numberOfLines
    }
}
