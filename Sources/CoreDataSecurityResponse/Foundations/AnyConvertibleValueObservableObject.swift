//
//  AnyConvertibleValueObservableObject.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine

public class AnyConvertibleValueObservableObject<Value>: ObservableObject, Identifiable where Value: FoundationValueProtocol {
    public var _object: any ConvertibleValueObservableObject<Value>
    
    public var id: WrappedID {
        _object.id
    }
    
    public var wrappedValue: Value? {
        _object.convertToValue()
    }
    
    init(object: some ConvertibleValueObservableObject<Value>) {
        self._object = object
    }
    
    public var objectWillChange: ObjectWillChangePublisher {
        _object.objectWillChange as! ObservableObjectPublisher
    }
}

extension AnyConvertibleValueObservableObject: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AnyConvertibleValueObservableObject: Equatable {
    public static func == (lhs: AnyConvertibleValueObservableObject<Value>, rhs: AnyConvertibleValueObservableObject<Value>) -> Bool {
        lhs._object.isEquatable(other: rhs._object)
    }
}
