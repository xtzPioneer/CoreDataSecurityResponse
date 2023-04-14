//
//  ConvertibleValueObservableObjectFetcher.swift
//  
//
//  Created by 张雄 on 2023/4/11.
//

import Foundation
import CoreData
import Combine

final class ConvertibleValueObservableObjectFetcher<Value>: NSObject, NSFetchedResultsControllerDelegate where Value: FoundationValueProtocol {
    var fetcher: NSFetchedResultsController<NSManagedObject>?
    let sender: PassthroughSubject<[AnyConvertibleValueObservableObject<Value>], Never>
    
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
    
    init(sender: PassthroughSubject<[AnyConvertibleValueObservableObject<Value>], Never>) {
        self.sender = sender
    }
    
    func publishValue(_ values: [NSFetchRequestResult]?) {
        guard let values else { return }
        let results = values.compactMap {
            ($0 as? any ConvertibleValueObservableObject<Value>)?.eraseToAny()
        }
        sender.send(results)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        publishValue(controller.fetchedObjects)
    }
}
