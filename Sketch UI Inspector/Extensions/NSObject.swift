//
//  NSObject.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 29/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import ObjectiveC.runtime

extension NSObject {
    
    //
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    //
    func properties() -> [String] {
        var result:[String] = []
        var count = UInt32()
        guard let properties : UnsafeMutablePointer <objc_property_t> = class_copyPropertyList(self.classForCoder, &count) else { return result }

        for i in 0..<Int(count) {
            let property : objc_property_t = properties[i]
            
            guard let propertyName = NSString(utf8String: property_getName(property)) as String? else {
                debugPrint("Couldn't unwrap property name for \(property)")
                break
            }
            
            result.append(propertyName)
        }
        
        free(properties)
        
        return result
    }
    
    func getNameOf(property: objc_property_t) -> String? {
        guard
            let name: NSString = NSString(utf8String: property_getName(property))
            else { return nil }
        return name as String
    }
    
}
