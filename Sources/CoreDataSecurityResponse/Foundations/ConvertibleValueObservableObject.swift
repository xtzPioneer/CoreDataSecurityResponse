//
//  ConvertibleValueObservableObject.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation

public protocol ConvertibleValueObservableObject<Value>: ObservableObject, Equatable, Identifiable where ID == WrappedID {
    associatedtype Value: FoundationValueProtocol
    
    func convertToValue() -> Value?
}

public extension ConvertibleValueObservableObject {
    func eraseToAny() -> AnyConvertibleValueObservableObject<Value> {
        AnyConvertibleValueObservableObject(object: self)
    }
}

public extension Equatable where Self: ConvertibleValueObservableObject {
    func isEquatable(other: any ConvertibleValueObservableObject) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self.id == other.id
    }
}

