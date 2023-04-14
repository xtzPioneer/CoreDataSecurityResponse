//
//  FoundationValueProtocol.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation

public protocol FoundationValueProtocol: Equatable, Identifiable, Sendable {
    var id: WrappedID { get }
}
