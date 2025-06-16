//
//  ShareData.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import Foundation

/**
 * 分享数据模型，用于封装要分享的内容
 *
 * @model
 * @example
 * ```swift
 * let shareData = ShareData(
 *     title: "我的数据统计",
 *     content: "总作品数：10，本周新增：3",
 *     type: .statistics
 * )
 * ```
 *
 * 提供以下功能：
 * - 分享内容封装
 * - 多种分享类型支持
 * - 格式化分享文本
 */
struct ShareData {
    /**
     * 分享类型枚举
     */
    enum ShareType {
        case statistics    // 统计数据
        case activity     // 活动记录
        case summary      // 总结报告
        case custom       // 自定义内容
    }
    
    /**
     * 分享标题
     */
    let title: String
    
    /**
     * 分享内容
     */
    let content: String
    
    /**
     * 分享类型
     */
    let type: ShareType
    
    /**
     * 创建时间
     */
    let timestamp: Date
    
    /**
     * 附加数据（可选）
     */
    let metadata: [String: Any]?
    
    /**
     * 初始化分享数据
     *
     * @param title 分享标题
     * @param content 分享内容
     * @param type 分享类型，默认为统计数据
     * @param timestamp 创建时间，默认为当前时间
     * @param metadata 附加数据，默认为nil
     */
    init(
        title: String,
        content: String,
        type: ShareType = .statistics,
        timestamp: Date = Date(),
        metadata: [String: Any]? = nil
    ) {
        self.title = title
        self.content = content
        self.type = type
        self.timestamp = timestamp
        self.metadata = metadata
    }
    
    /**
     * 生成格式化的分享文本
     *
     * @returns 格式化后的分享文本
     */
    func formattedText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "zh_CN")
        
        let formattedDate = dateFormatter.string(from: timestamp)
        
        return """
        📊 \(title)
        
        \(content)
        
        📅 生成时间：\(formattedDate)
        🏷️ 来自 Carddy 应用
        """
    }
    
    /**
     * 生成简洁版分享文本
     *
     * @returns 简洁版分享文本
     */
    func compactText() -> String {
        return "\(title) - \(content)"
    }
}
