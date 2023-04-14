//
//  WrappedID.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine
import CoreData

public enum WrappedID: Equatable, Identifiable, Sendable, Hashable {
    case string(String)
    case integer(Int)
    case uuid(UUID)
    case objectID(NSManagedObjectID)
    
    public var id: Self {
        self
    }
    
    public var objectID: NSManagedObjectID? {
        guard case .objectID(let objectID) = self else {
            return nil
        }
        return objectID
    }
    
    public var string: String? {
        guard case .string(let string) = self else {
            return nil
        }
        return string
    }
    
    public var integer: Int? {
        guard case .integer(let integer) = self else {
            return nil
        }
        return integer
    }
    
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
