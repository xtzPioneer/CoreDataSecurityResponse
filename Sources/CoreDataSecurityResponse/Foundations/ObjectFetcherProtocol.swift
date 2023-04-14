//
//  ObjectFetcherProtocol.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation
import Combine

/// 对象获取器协议
public protocol ObjectFetcherProtocol<ConvertValue> {
    
    /// 转换值
    associatedtype ConvertValue: FoundationValueProtocol
    
    /// 流
    var stream: AsyncPublisher<AnyPublisher<[any ConvertibleValueObservableObject<ConvertValue>], Never>> { get }
    
}
