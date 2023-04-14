//
//  AnyConvertibleValueObservableObject.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine

/// 任意可转换可观察对象
public class AnyConvertibleValueObservableObject<Value>: ObservableObject, Identifiable where Value: FoundationValueProtocol {
    
    /// 可转换对象
    public var _object: any ConvertibleValueObservableObject<Value>
    
    /// 标识符
    public var id: WrappedID {
        _object.id
    }
    
    /// 包装值
    public var wrappedValue: Value? {
        _object.convertToValue()
    }
    
    /// 初始化
    /// - Parameter object: 可转换对象
    init(object: some ConvertibleValueObservableObject<Value>) {
        self._object = object
    }
    
    /// 对象将更改发布者
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
