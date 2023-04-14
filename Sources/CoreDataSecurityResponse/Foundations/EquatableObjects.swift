//
//  EquatableObjects.swift
//  
//
//  Created by 张雄 on 2023/4/11.
//

import Foundation

public struct EquatableObjects<Value>: Equatable where Value: FoundationValueProtocol {
    public var values: [AnyConvertibleValueObservableObject<Value>]
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.values.count == rhs.values.count else { return false }
        for index in lhs.values.indices {
            if !lhs.values[index]._object.isEquatable(other: rhs.values[index]._object) { return false }
        }
        return true
    }
    
    public init(_ values: [AnyConvertibleValueObservableObject<Value>]) {
        self.values = values
    }
}


