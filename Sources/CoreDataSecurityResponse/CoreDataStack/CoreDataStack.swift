//
//  CoreDataStack.swift
//  
//
//  Created by 张雄 on 2023/4/14.
//

import Foundation
import CoreData

/// CoreData堆栈协议
public protocol CoreDataStackProtocol {
    
    /// 视图上下文
    var viewContext: NSManagedObjectContext { get }
    
    /// 保存
    /// - Parameter viewContext: 视图上下文
    /// - Returns: 结果
    @discardableResult func save(viewContext: NSManagedObjectContext) -> Result<Bool, Error>
    
    /// 删除
    /// - Parameters:
    ///   - id: 标识符
    ///   - viewContext: 视图上下文
    func deleteObject(id: WrappedID, viewContext: NSManagedObjectContext) throws
    
    /// 执行后台任务
    /// - Parameter block: 闭包
    func performBackgroundTask<T>(block: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T
    
}
