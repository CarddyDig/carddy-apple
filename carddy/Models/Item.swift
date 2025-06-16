//
//  Item.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import Foundation
import SwiftData

/**
 * 数据项模型，用于 SwiftData 持久化存储
 *
 * @model
 * @example
 * ```swift
 * let item = Item(timestamp: Date())
 * modelContext.insert(item)
 * ```
 *
 * 提供以下功能：
 * - 时间戳记录
 * - 唯一标识符
 * - SwiftData 持久化
 */
@Model
final class Item {
    /**
     * 创建时间戳
     */
    var timestamp: Date
    
    /**
     * 初始化新的数据项
     *
     * @param timestamp 创建时间，默认为当前时间
     */
    init(timestamp: Date = Date()) {
        self.timestamp = timestamp
    }
}
