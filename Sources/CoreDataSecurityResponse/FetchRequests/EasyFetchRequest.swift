//
//  EasyFetchRequest.swift
//
//
//  Created by 张雄 on 2023/4/11.
//

import Foundation
import Combine
import CoreData
import SwiftUI

/// 获取请求
@propertyWrapper public struct EasyFetchRequest<Input, Output>: DynamicProperty where Input: NSManagedObject, Output: FoundationValueProtocol {
    
    /// 视图上下文
    @Environment(\.managedObjectContext) var viewContext
    
    /// 数据源
    @State private var values: [AnyConvertibleValueObservableObject<Output>] = []
    
    /// 包装数据源
    public var wrappedValue: [AnyConvertibleValueObservableObject<Output>] { values }
    
    /// 动画
    private let animation: Animation?
    
    /// 获取请求
    private let fetchRequest: (any FetchRequestProtocol<Input>)?
    
    /// 更新包装数据源
    @State private var updateWrappedValue = MutableHolder<([AnyConvertibleValueObservableObject<Output>]) -> Void>({ _ in })
    
    /// 首次更新
    @State private var firstUpdate = MutableHolder<Bool>(true)
    
    /// 获取器
    @State private var fetcher = MutableHolder<ConvertibleValueObservableObjectFetcher<Output>?>(nil)
    
    /// 订阅者
    @State private var cancellable = MutableHolder<AnyCancellable?>(nil)
    
    /// 发送者
    @State private var sender = PassthroughSubject<[AnyConvertibleValueObservableObject<Output>], Never>()
    
    /// 初始化
    /// - Parameters:
    ///   - fetchRequest: 获取请求
    ///   - animation: 动画
    public init(
        fetchRequest: (any FetchRequestProtocol<Input>)? = nil,
        animation: Animation? = .default
    ) {
        self.animation = animation
        self.fetchRequest = fetchRequest
    }
    
    /// 发布者
    public var publisher: AnyPublisher<Void, Never> {
        sender
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    /// 更新
    public func update() {
        // 设置更新包装数据源
        let values = _values
        let firstUpdate = firstUpdate
        let animation = animation
        updateWrappedValue.value = { data in
            var animation = animation
            if firstUpdate.value {
                animation = nil
                firstUpdate.value = false
            }
            withAnimation(animation) {
                values.wrappedValue = data
            }
        }
        // 订阅者
        if cancellable.value == nil {
            cancellable.value = sender
                .delay(for: .nanoseconds(1), scheduler: RunLoop.main)
                .removeDuplicates {
                    EquatableObjects($0) == EquatableObjects($1)
                }
                .receive(on: DispatchQueue.main)
                .sink {
                    updateWrappedValue.value($0)
                }
        }
        // 获取请求
        if fetcher.value == nil {
            fetcher.value = .init(sender: sender)
            if let fetchRequest, let request = fetchRequest.eraseToAny() {
                updateFetchRequest(request)
            }
        }
    }
    
    /// 更新获取请求
    /// - Parameter request: 请求
    private func updateFetchRequest(_ request: NSFetchRequest<NSManagedObject>) {
        fetcher.value?.updateRequest(context: viewContext, request: request)
    }
    
    /// 映射获取请求
    public var projectedValue: (any FetchRequestProtocol<Input>)? {
        get {
            if let fetchRequest = fetcher.value?.fetcher?.fetchRequest as? NSFetchRequest<Input> {
                return FetchRequest(fetchRequest)
            } else {
                return fetchRequest
            }
        }
        nonmutating set {
            if let fetchRequest = newValue, let request = fetchRequest.eraseToAny() {
                updateFetchRequest(request)
            }
        }
    }
    
}

extension EasyFetchRequest {
    
    /// 可变持有者
    final class MutableHolder<T> {
        
        /// 值
        var value: T
        
        /// 初始化
        /// - Parameter value: 值
        @inlinable init(_ value: T) {
            self.value = value
        }
        
    }
    
}

extension EasyFetchRequest {
    
    /// 获取请求
    struct FetchRequest: FetchRequestProtocol {
        
        typealias Result = Input
        
        /// 获取请求
        private var fetchRequest: NSFetchRequest<Input>
        
        var body: NSFetchRequest<Input> { fetchRequest }
        
        /// 初始化
        /// - Parameter fetchRequest: 获取请求
        init(_ fetchRequest: NSFetchRequest<Input>) {
            self.fetchRequest = fetchRequest
        }
        
    }
    
}


