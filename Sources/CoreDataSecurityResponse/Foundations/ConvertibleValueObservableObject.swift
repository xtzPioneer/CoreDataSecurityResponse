//
//  ConvertibleValueObservableObject.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation

/// 可转换可观察对象协议
public protocol ConvertibleValueObservableObject<Value>: ObservableObject, Equatable, Identifiable where ID == WrappedID {
    
    /// 值
    associatedtype Value: FoundationValueProtocol
    
    /// 转换到值
    /// - Returns: 值
    func convertToValue() -> Value?
    
}

public extension ConvertibleValueObservableObject {
    
    /// 擦除到任意
    /// - Returns: 任意可转换可观察对象
    func eraseToAny() -> AnyConvertibleValueObservableObject<Value> {
        AnyConvertibleValueObservableObject(object: self)
    }
    
}

public extension Equatable where Self: ConvertibleValueObservableObject {
    
    /// 对比
    /// - Parameter other: 其他可转换可观察对象
    /// - Returns: 结果
    func isEquatable(other: any ConvertibleValueObservableObject) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self.id == other.id
    }
    
}

