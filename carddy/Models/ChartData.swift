//
//  ChartData.swift
//  carddy
//
//  Created by CreedChung on 2025/6/15.
//

import Foundation
import SwiftUI

/**
 * 图表数据模型，用于各种图表的数据展示
 *
 * @model
 * @example
 * ```swift
 * let chartData = ChartData(
 *     id: UUID(),
 *     type: .heatmap,
 *     title: "活动热力图",
 *     data: heatmapData
 * )
 * ```
 *
 * 提供以下功能：
 * - 多种图表类型支持
 * - 图表数据封装
 * - 拖拽排序支持
 */

/**
 * 图表类型枚举
 */
enum ChartType: String, CaseIterable, Identifiable, Codable {
    case heatmap = "热力图"
    case bar = "柱状图"
    case pie = "饼状图"
    case line = "折线图"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .heatmap:
            return "calendar.badge.clock"
        case .bar:
            return "chart.bar"
        case .pie:
            return "chart.pie"
        case .line:
            return "chart.line.uptrend.xyaxis"
        }
    }
    
    var color: Color {
        switch self {
        case .heatmap:
            return .orange
        case .bar:
            return .blue
        case .pie:
            return .green
        case .line:
            return .purple
        }
    }
}

/**
 * 图表数据项
 */
struct ChartDataItem: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double
    let date: Date?
    let category: String?
    
    init(label: String, value: Double, date: Date? = nil, category: String? = nil) {
        self.label = label
        self.value = value
        self.date = date
        self.category = category
    }
}

/**
 * 热力图数据项
 */
struct HeatmapDataItem: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let value: Int
    let weekday: Int
    let week: Int
    
    init(date: Date, value: Int) {
        self.date = date
        self.value = value
        
        let calendar = Calendar.current
        self.weekday = calendar.component(.weekday, from: date)
        
        // 计算是一年中的第几周
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        self.week = weekOfYear
    }
}

/**
 * 图表配置数据
 */
struct ChartData: Identifiable, Hashable {
    let id = UUID()
    let type: ChartType
    let title: String
    let subtitle: String?
    let data: [ChartDataItem]
    let heatmapData: [HeatmapDataItem]?
    var order: Int
    
    init(
        type: ChartType,
        title: String,
        subtitle: String? = nil,
        data: [ChartDataItem] = [],
        heatmapData: [HeatmapDataItem]? = nil,
        order: Int = 0
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.data = data
        self.heatmapData = heatmapData
        self.order = order
    }
    
    static func == (lhs: ChartData, rhs: ChartData) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/**
 * 图表数据生成器
 */
struct ChartDataGenerator {
    
    /**
     * 从 Item 数组生成图表数据
     */
    static func generateChartData(from items: [Item]) -> [ChartData] {
        return [
            generateHeatmapData(from: items),
            generateBarChartData(from: items),
            generatePieChartData(from: items),
            generateLineChartData(from: items)
        ]
    }
    
    /**
     * 生成热力图数据
     */
    private static func generateHeatmapData(from items: [Item]) -> ChartData {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -365, to: now) ?? now
        
        // 创建日期到数量的映射
        var dateCountMap: [String: Int] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for item in items {
            let dateKey = dateFormatter.string(from: item.timestamp)
            dateCountMap[dateKey, default: 0] += 1
        }
        
        // 生成过去一年的热力图数据
        var heatmapData: [HeatmapDataItem] = []
        var currentDate = startDate
        
        while currentDate <= now {
            let dateKey = dateFormatter.string(from: currentDate)
            let count = dateCountMap[dateKey] ?? 0
            heatmapData.append(HeatmapDataItem(date: currentDate, value: count))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return ChartData(
            type: .heatmap,
            title: "活动热力图",
            subtitle: "过去一年的创作活动",
            heatmapData: heatmapData,
            order: 0
        )
    }
    
    /**
     * 生成柱状图数据
     */
    private static func generateBarChartData(from items: [Item]) -> ChartData {
        let calendar = Calendar.current
        let now = Date()
        
        // 按周统计
        var weeklyData: [String: Int] = [:]
        let weekFormatter = DateFormatter()
        weekFormatter.dateFormat = "yyyy-'W'ww"
        
        for item in items {
            // 只统计最近12周
            if let weeksAgo = calendar.date(byAdding: .weekOfYear, value: -12, to: now),
               item.timestamp >= weeksAgo {
                let weekKey = weekFormatter.string(from: item.timestamp)
                weeklyData[weekKey, default: 0] += 1
            }
        }
        
        let chartData = weeklyData.map { key, value in
            ChartDataItem(label: key, value: Double(value))
        }.sorted { $0.label < $1.label }
        
        return ChartData(
            type: .bar,
            title: "周度统计",
            subtitle: "最近12周的创作数量",
            data: chartData,
            order: 1
        )
    }
    
    /**
     * 生成饼状图数据
     */
    private static func generatePieChartData(from items: [Item]) -> ChartData {
        let calendar = Calendar.current
        
        // 按小时统计
        var hourlyData: [Int: Int] = [:]
        
        for item in items {
            let hour = calendar.component(.hour, from: item.timestamp)
            hourlyData[hour, default: 0] += 1
        }
        
        // 按时间段分组
        let timeSlots = [
            ("早晨 (6-12)", 6..<12),
            ("下午 (12-18)", 12..<18),
            ("晚上 (18-24)", 18..<24),
            ("深夜 (0-6)", 0..<6)
        ]
        
        let chartData = timeSlots.map { label, range in
            let count = range.reduce(0) { sum, hour in
                sum + (hourlyData[hour] ?? 0)
            }
            return ChartDataItem(label: label, value: Double(count))
        }.filter { $0.value > 0 }
        
        return ChartData(
            type: .pie,
            title: "时间分布",
            subtitle: "不同时间段的创作分布",
            data: chartData,
            order: 2
        )
    }
    
    /**
     * 生成折线图数据
     */
    private static func generateLineChartData(from items: [Item]) -> ChartData {
        let calendar = Calendar.current
        let now = Date()
        
        // 按天统计最近30天
        var dailyData: [String: Int] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        for item in items {
            if let daysAgo = calendar.date(byAdding: .day, value: -30, to: now),
               item.timestamp >= daysAgo {
                let dateKey = dateFormatter.string(from: item.timestamp)
                dailyData[dateKey, default: 0] += 1
            }
        }
        
        // 生成最近30天的完整数据
        var chartData: [ChartDataItem] = []
        for i in (0..<30).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: now) {
                let dateKey = dateFormatter.string(from: date)
                let count = dailyData[dateKey] ?? 0
                chartData.append(ChartDataItem(
                    label: dateKey,
                    value: Double(count),
                    date: date
                ))
            }
        }
        
        return ChartData(
            type: .line,
            title: "趋势分析",
            subtitle: "最近30天的创作趋势",
            data: chartData,
            order: 3
        )
    }
}
