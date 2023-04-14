//
//  FetchRequestProtocol.swift
//  
//
//  Created by 张雄 on 2023/4/13.
//

import Foundation
import CoreData

/// 获取请求协议
public protocol FetchRequestProtocol<Result> {
    
    /// 结果
    associatedtype Result: NSManagedObject

    /// 获取主体
    associatedtype Body: NSFetchRequest<Result>
    
    /// 主体
    var body: Self.Body { get }
    
}
