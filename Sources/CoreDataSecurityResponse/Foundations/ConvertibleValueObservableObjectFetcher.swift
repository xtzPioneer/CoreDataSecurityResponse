//
//  ConvertibleValueObservableObjectFetcher.swift
//  
//
//  Created by 张雄 on 2023/4/11.
//

import Foundation
import CoreData
import Combine

/// 可转换可观察对象提取器
final class ConvertibleValueObservableObjectFetcher<Value>: NSObject, NSFetchedResultsControllerDelegate where Value: FoundationValueProtocol {
    
    /// 获取器
    var fetcher: NSFetchedResultsController<NSManagedObject>?
    
    /// 发布者
    let sender: PassthroughSubject<[AnyConvertibleValueObservableObject<Value>], Never>
    
    /// 更新请求
    /// - Parameters:
    ///   - context: 上下文
    ///   - request: 请求
    func updateRequest(context: NSManagedObjectContext, request: NSFetchRequest<NSManagedObject>) {
        precondition(context.concurrencyType == .mainQueueConcurrencyType, "只支持类型为 main Queue 的托管对象上下文")
        fetcher = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetcher?.delegate = self
        do {
            try fetcher?.performFetch()
        } catch {
            fatalError("执行请求错误：\(error.localizedDescription)")
        }
        publishValue(fetcher?.fetchedObjects)
    }
    
    /// 初始化
    /// - Parameter sender: 发布者
    init(sender: PassthroughSubject<[AnyConvertibleValueObservableObject<Value>], Never>) {
        self.sender = sender
    }
    
    /// 发布请求结果
    /// - Parameter values: 值
    func publishValue(_ values: [NSFetchRequestResult]?) {
        guard let values else { return }
        let results = values.compactMap {
            ($0 as? any ConvertibleValueObservableObject<Value>)?.eraseToAny()
        }
        sender.send(results)
    }
    
    /// 将要更改内容
    /// - Parameter controller: 控制器
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        publishValue(controller.fetchedObjects)
    }
    
}
