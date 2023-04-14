//
//  ObjectFetcherProtocol.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine

public protocol ObjectFetcherProtocol<ConvertValue> {
    associatedtype ConvertValue: FoundationValueProtocol
    
    var stream: AsyncPublisher<AnyPublisher<[any ConvertibleValueObservableObject<ConvertValue>], Never>> { get }
}
