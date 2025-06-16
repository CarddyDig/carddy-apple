//
//  ShareService.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import Foundation
import SwiftUI
import SwiftData

/**
 * 分享服务类，处理各种分享功能
 *
 * @service
 * @example
 * ```swift
 * let shareService = ShareService()
 * shareService.shareStatistics(items: items)
 * ```
 *
 * 提供以下功能：
 * - 统计数据分享
 * - 活动记录分享
 * - 系统分享面板调用
 * - 多种分享格式支持
 */
class ShareService {
    
    /**
     * 分享统计数据
     *
     * @param items 数据项数组
     * @param presentingViewController 用于展示分享面板的视图控制器
     */
    func shareStatistics(items: [Item]) {
        let shareData = generateStatisticsShareData(items: items)
        presentShareSheet(shareData: shareData)
    }
    
    /**
     * 分享活动记录
     *
     * @param items 数据项数组
     * @param limit 分享的记录数量限制，默认为10
     */
    func shareActivity(items: [Item], limit: Int = 10) {
        let shareData = generateActivityShareData(items: items, limit: limit)
        presentShareSheet(shareData: shareData)
    }
    
    /**
     * 分享自定义内容
     *
     * @param title 分享标题
     * @param content 分享内容
     */
    func shareCustomContent(title: String, content: String) {
        let shareData = ShareData(
            title: title,
            content: content,
            type: .custom
        )
        presentShareSheet(shareData: shareData)
    }
    
    // MARK: - Private Methods
    
    /**
     * 生成统计数据的分享内容
     *
     * @param items 数据项数组
     * @returns 统计数据的ShareData对象
     */
    private func generateStatisticsShareData(items: [Item]) -> ShareData {
        let statistics = StatisticsCalculator.calculateOverallStatistics(items: items)
        let totalCount = statistics.totalCount
        let weeklyCount = statistics.weeklyCount
        let activeDays = statistics.activeDays
        let dailyAverage = statistics.dailyAverage
        
        let content = """
        📈 总作品数：\(totalCount)
        📅 本周新增：\(weeklyCount)
        🔥 活跃天数：\(activeDays)
        ⚡ 平均每日：\(String(format: "%.1f", dailyAverage))
        """
        
        return ShareData(
            title: "我的创作数据统计",
            content: content,
            type: .statistics,
            metadata: [
                "totalCount": totalCount,
                "weeklyCount": weeklyCount,
                "activeDays": activeDays,
                "dailyAverage": dailyAverage
            ]
        )
    }
    
    /**
     * 生成活动记录的分享内容
     *
     * @param items 数据项数组
     * @param limit 记录数量限制
     * @returns 活动记录的ShareData对象
     */
    private func generateActivityShareData(items: [Item], limit: Int) -> ShareData {
        let recentItems = Array(items.prefix(limit))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "zh_CN")
        
        var content = "📝 最近活动记录：\n\n"
        
        for (index, item) in recentItems.enumerated() {
            let formattedDate = dateFormatter.string(from: item.timestamp)
            content += "\(index + 1). 创建了新作品 - \(formattedDate)\n"
        }
        
        return ShareData(
            title: "我的最近活动",
            content: content,
            type: .activity,
            metadata: ["itemCount": recentItems.count]
        )
    }
    
    /**
     * 展示系统分享面板
     *
     * @param shareData 要分享的数据
     */
    private func presentShareSheet(shareData: ShareData) {
        let formattedText = shareData.formattedText()
        
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                print("无法获取根视图控制器")
                return
            }
            
            let activityViewController = UIActivityViewController(
                activityItems: [formattedText],
                applicationActivities: nil
            )
            
            // 为iPad设置popover
            if let popover = activityViewController.popoverPresentationController {
                popover.sourceView = window
                popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityViewController, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    // 注意：统计计算方法已移至 StatisticsCalculator 工具类
}
