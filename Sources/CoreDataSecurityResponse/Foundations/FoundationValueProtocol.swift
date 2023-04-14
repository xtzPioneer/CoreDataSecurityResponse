//
//  FoundationValueProtocol.swift
//  
//
//  Created by 张雄 on 2023/4/7.
//

import Foundation

/// 基础值协议
public protocol FoundationValueProtocol: Equatable, Identifiable, Sendable {
    
    /// 标识符
    var id: WrappedID { get }
    
}
