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

@propertyWrapper public struct EasyFetchRequest<Input, Output>: DynamicProperty where Input: NSManagedObject, Output: FoundationValueProtocol {
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var values: [AnyConvertibleValueObservableObject<Output>] = []
    public var wrappedValue: [AnyConvertibleValueObservableObject<Output>] { values }
    
    private let animation: Animation?
    private let fetchRequest: (any FetchRequestProtocol<Input>)?
    
    @State private var updateWrappedValue = MutableHolder<([AnyConvertibleValueObservableObject<Output>]) -> Void>({ _ in })
    @State private var firstUpdate = MutableHolder<Bool>(true)
    @State private var fetcher = MutableHolder<ConvertibleValueObservableObjectFetcher<Output>?>(nil)
    @State private var cancellable = MutableHolder<AnyCancellable?>(nil)
    @State private var sender = PassthroughSubject<[AnyConvertibleValueObservableObject<Output>], Never>()
    
    public init(
        fetchRequest: (any FetchRequestProtocol<Input>)? = nil,
        animation: Animation? = .default
    ) {
        self.animation = animation
        self.fetchRequest = fetchRequest
    }
    
    public var publisher: AnyPublisher<Void, Never> {
        sender
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func update() {
        // set updateWrappedValue
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
        
        // fetch Request
        if fetcher.value == nil {
            fetcher.value = .init(sender: sender)
            if let fetchRequest {
                updateFetchRequest(fetchRequest)
            }
        }
    }
    
    private func updateFetchRequest(_ request: (any FetchRequestProtocol<Input>)) {
        fetcher.value?.updateRequest(context: viewContext, request: (request.body as! NSFetchRequest<NSManagedObject>))
    }
    
    public var projectedValue: (any FetchRequestProtocol<Input>)? {
        get {
            if let fetchRequest = fetcher.value?.fetcher?.fetchRequest as? NSFetchRequest<Input> {
                return FetchRequest(fetchRequest: fetchRequest)
            } else {
                return fetchRequest
            }
        }
        nonmutating set {
            if let request = newValue {
                updateFetchRequest(request)
            }
        }
    }
}

extension EasyFetchRequest {
    private final class MutableHolder<T> {
        var value: T
        @inlinable
        init(_ value: T) {
            self.value = value
        }
    }
}

extension EasyFetchRequest {
    private struct FetchRequest: FetchRequestProtocol {
        typealias Result = Input
        typealias Body = NSFetchRequest<Result>
        private var fetchRequest: Body
        var body: NSFetchRequest<Result> {
            fetchRequest
        }
        init(fetchRequest: Body) {
            self.fetchRequest = fetchRequest
        }
    }
}
