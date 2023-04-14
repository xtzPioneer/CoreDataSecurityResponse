//
//  TestableConvertibleValueObservableObject.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine

/// 可测试可转换可观察对象协议
@dynamicMemberLookup public protocol TestableConvertibleValueObservableObject<WrappedValue>: ConvertibleValueObservableObject {
    
    /// 包装值
    associatedtype WrappedValue where WrappedValue: FoundationValueProtocol
    
    /// 包装值
    var _wrappedValue: WrappedValue { get set }
    
    /// 初始化
    /// - Parameter wrappedValue: 包装值
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
