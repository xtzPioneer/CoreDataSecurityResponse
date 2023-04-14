//
//  TestableConvertibleValueObservableObject.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine

@dynamicMemberLookup public protocol TestableConvertibleValueObservableObject<WrappedValue>: ConvertibleValueObservableObject {
    associatedtype WrappedValue where WrappedValue: FoundationValueProtocol
    
    var _wrappedValue: WrappedValue { get set }
    
    init(_ wrappedValue: WrappedValue)
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<WrappedValue, Value>) -> Value { get set }
}

public extension TestableConvertibleValueObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<WrappedValue, Value>) -> Value {
        get {
            _wrappedValue[keyPath: keyPath]
        }
        set {
            self.objectWillChange.send()
            _wrappedValue[keyPath: keyPath] = newValue
        }
    }
    
    func update(_ wrappedValue: WrappedValue) {
        self.objectWillChange.send()
        _wrappedValue = wrappedValue
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._wrappedValue == rhs._wrappedValue
    }
    
    func convertToValueType() -> WrappedValue? {
        _wrappedValue
    }
    
    var id: WrappedValue.ID {
        _wrappedValue.id
    }
}
