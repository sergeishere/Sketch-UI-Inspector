//
//  Utils.swift
//  Sketch UI Inspector
//
//  Created by Sergey Dmitriev on 30/09/2018.
//  Copyright © 2018 Sergey Dmitriev. All rights reserved.
//

import ObjectiveC.runtime

let valueTypesMap: Dictionary<Character, Any> = [
    "c" : Int8.self,
    "s" : Int16.self,
    "i" : Int32.self,
    "q" : Int.self, //also: Int64, NSInteger, only true on 64 bit platforms
    "S" : UInt16.self,
    "I" : UInt32.self,
    "Q" : UInt.self, //also UInt64, only true on 64 bit platforms
    "B" : Bool.self,
    "d" : Double.self,
    "f" : Float.self,
    "{" : Decimal.self
]

func getTypesOfProperties(for object: Any) -> [Property]? {
    var properties:[Property]? = []
    var count = UInt32()
    guard let properties_list = class_copyPropertyList(object_getClass(object), &count) else { return nil }
    
    for i in 0..<Int(count) {
        guard
            let property_t: objc_property_t = properties_list[i],
            let name = getNameOf(property: property_t),
            let value = (object as AnyObject).value(forKey: name)
            else { continue }
        let type = getTypeOf(property: property_t)
        let property = Property(name: name, type: String(describing: type), value: String(describing: value))
        properties?.append(property)
    }
    free(properties_list)
    return properties
}

func getNameOf(property: objc_property_t) -> String? {
    guard
        let name: NSString = NSString(utf8String: property_getName(property))
        else { return nil }
    return name as String
}

func getTypeOf(property: objc_property_t) -> Any {
    plugin_log("%@", String(describing: property))
    guard let attr = property_getAttributes(property),
        let attributesAsNSString: NSString = NSString(utf8String: attr) else { return Any.self }
    let attributes = attributesAsNSString as String
    let slices = attributes.components(separatedBy: "\"")
    guard slices.count > 1 else { return valueType(withAttributes: attributes) }
    let objectClassName = slices[1]
    guard let objectClass = NSClassFromString(objectClassName) as? NSObject.Type else { return Any.self }
    return objectClass
}

func valueType(withAttributes attributes: String) -> Any {
    let index = attributes.index(attributes.startIndex, offsetBy: 1)
    guard let type = valueTypesMap[attributes[index]] else { return Any.self }
    return type
}
