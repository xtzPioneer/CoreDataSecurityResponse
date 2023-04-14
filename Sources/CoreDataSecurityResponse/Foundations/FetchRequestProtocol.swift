//
//  FetchRequestProtocol.swift
//  
//
//  Created by 张雄 on 2023/4/13.
//

import Foundation
import CoreData

public protocol FetchRequestProtocol<Result> {
    associatedtype Result: NSManagedObject

    associatedtype Body: NSFetchRequest<Result>
    
    var body: Self.Body { get }
}
