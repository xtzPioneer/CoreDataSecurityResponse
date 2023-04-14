//
//  WrappedID.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine
import CoreData

/// 包装标识符
public enum WrappedID: Equatable, Identifiable, Sendable, Hashable {
    
    /// 字符串
    case string(String)
    
    /// 整数
    case integer(Int)
    
    /// UUID
    case uuid(UUID)
    
    /// 对象标识符
    case objectID(NSManagedObjectID)
    
    /// 标识符
    public var id: Self {
        self
    }
    
    /// 对象标识符
    public var objectID: NSManagedObjectID? {
        guard case .objectID(let objectID) = self else {
            return nil
        }
        return objectID
    }
    
    /// 字符串
    public var string: String? {
        guard case .string(let string) = self else {
            return nil
        }
        return string
    }
    
    /// 整数
    public var integer: Int? {
        guard case .integer(let integer) = self else {
            return nil
        }
        return integer
    }
    
    /// UUID
    public var uuid: UUID? {
        guard case .uuid(let uuid) = self else {
            return nil
        }
        return uuid
    }
    
}

extension WrappedID: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        switch self {
        case .string(let string):
            return string
        case .integer(let integer):
            return String(integer)
        case .uuid(let uuid):
            return uuid.uuidString
        case .objectID(let objectID):
            return objectID.description
        }
    }
    
    public var debugDescription: String {
        description
    }
    
}

extension NSManagedObjectID: @unchecked Sendable {}
