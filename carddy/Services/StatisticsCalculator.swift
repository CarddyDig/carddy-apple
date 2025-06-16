//
//  StatisticsCalculator.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import Foundation

/**
 * 统计计算工具类，提供统一的数据计算方法
 *
 * @utility
 * @example
 * ```swift
 * let calculator = StatisticsCalculator()
 * let weeklyCount = calculator.calculateWeeklyCount(items: items)
 * ```
 *
 * 提供以下功能：
 * - 本周新增作品数量计算
 * - 活跃天数计算
 * - 每日平均作品数计算
 */
struct StatisticsCalculator {
    
    /**
     * 计算本周新增作品数量
     *
     * @param items 作品数组
     * @returns 本周新增的作品数量
     */
    static func calculateWeeklyCount(items: [Item]) -> Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return items.filter { $0.timestamp >= weekAgo }.count
    }
    
    /**
     * 计算活跃天数
     *
     * @param items 作品数组
     * @returns 有作品创建的天数
     */
    static func calculateActiveDays(items: [Item]) -> Int {
        let calendar = Calendar.current
        let uniqueDays = Set(items.map { calendar.startOfDay(for: $0.timestamp) })
        return uniqueDays.count
    }
    
    /**
     * 计算每日平均作品数
     *
     * @param items 作品数组
     * @param activeDays 活跃天数，如果为nil则自动计算
     * @returns 每日平均作品数
     */
    static func calculateDailyAverage(items: [Item], activeDays: Int? = nil) -> Double {
        let days = activeDays ?? calculateActiveDays(items: items)
        guard days > 0 else { return 0.0 }
        return Double(items.count) / Double(days)
    }
    
    /**
     * 计算总体统计信息
     *
     * @param items 作品数组
     * @returns 包含所有统计信息的元组
     */
    static func calculateOverallStatistics(items: [Item]) -> (
        totalCount: Int,
        weeklyCount: Int,
        activeDays: Int,
        dailyAverage: Double
    ) {
        let totalCount = items.count
        let weeklyCount = calculateWeeklyCount(items: items)
        let activeDays = calculateActiveDays(items: items)
        let dailyAverage = calculateDailyAverage(items: items, activeDays: activeDays)
        
        return (
            totalCount: totalCount,
            weeklyCount: weeklyCount,
            activeDays: activeDays,
            dailyAverage: dailyAverage
        )
    }
}
