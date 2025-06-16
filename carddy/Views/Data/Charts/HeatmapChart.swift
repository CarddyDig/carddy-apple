//
//  HeatmapChart.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI

/**
 * 热力图组件，显示过去一年的活动热力图
 *
 * @component
 * @example
 * ```swift
 * HeatmapChart(data: heatmapData)
 * ```
 *
 * 提供以下功能：
 * - GitHub 风格的活动热力图
 * - 按日期显示活动强度
 * - 支持点击查看详细信息
 * - 颜色深浅表示活动频率
 */
struct HeatmapChart: View {
    let data: [HeatmapDataItem]
    @State private var selectedDate: Date?
    @State private var showDetail = false
    
    private let cellSize: CGFloat = 12
    private let cellSpacing: CGFloat = 2
    private let weeksInYear = 53
    private let daysInWeek = 7
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题和图例
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("活动热力图")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("过去一年的创作活动")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 图例
                HStack(spacing: 4) {
                    Text("少")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    ForEach(0..<5) { level in
                        Rectangle()
                            .fill(colorForLevel(level))
                            .frame(width: 8, height: 8)
                            .cornerRadius(2)
                    }
                    
                    Text("多")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // 热力图网格
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: cellSpacing) {
                    // 月份标签
                    monthLabels
                    
                    // 热力图主体
                    HStack(alignment: .top, spacing: cellSpacing) {
                        // 星期标签
                        weekdayLabels
                        
                        // 热力图网格
                        LazyHGrid(rows: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: daysInWeek), spacing: cellSpacing) {
                            ForEach(groupedData, id: \.date) { item in
                                Rectangle()
                                    .fill(colorForValue(item.value))
                                    .frame(width: cellSize, height: cellSize)
                                    .cornerRadius(2)
                                    .onTapGesture {
                                        selectedDate = item.date
                                        showDetail = true
                                    }
                                    .scaleEffect(selectedDate == item.date ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3), value: selectedDate)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showDetail) {
            if let date = selectedDate {
                HeatmapDetailView(date: date, value: valueForDate(date))
            }
        }
    }
    
    // MARK: - 计算属性
    
    /**
     * 按周分组的数据
     */
    private var groupedData: [HeatmapDataItem] {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -365, to: now) ?? now
        
        // 创建完整的365天数据
        var result: [HeatmapDataItem] = []
        var currentDate = startDate
        
        while currentDate <= now {
            if let existingItem = data.first(where: { calendar.isDate($0.date, inSameDayAs: currentDate) }) {
                result.append(existingItem)
            } else {
                result.append(HeatmapDataItem(date: currentDate, value: 0))
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return result
    }
    
    /**
     * 月份标签
     */
    private var monthLabels: some View {
        HStack(spacing: 0) {
            // 星期标签占位
            Rectangle()
                .fill(Color.clear)
                .frame(width: 20)
            
            // 月份标签
            ForEach(monthsInYear, id: \.self) { month in
                Text(month)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: cellSize * 4 + cellSpacing * 3, alignment: .leading)
            }
        }
    }
    
    /**
     * 星期标签
     */
    private var weekdayLabels: some View {
        VStack(spacing: cellSpacing) {
            ForEach(["", "一", "", "三", "", "五", ""], id: \.self) { day in
                Text(day)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: cellSize)
            }
        }
    }
    
    /**
     * 一年中的月份
     */
    private var monthsInYear: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.shortMonthSymbols
    }
    
    // MARK: - 辅助方法
    
    /**
     * 根据数值获取颜色
     */
    private func colorForValue(_ value: Int) -> Color {
        let level = min(value, 4)
        return colorForLevel(level)
    }
    
    /**
     * 根据等级获取颜色
     */
    private func colorForLevel(_ level: Int) -> Color {
        switch level {
        case 0:
            return Color(.systemGray6)
        case 1:
            return .orange.opacity(0.3)
        case 2:
            return .orange.opacity(0.5)
        case 3:
            return .orange.opacity(0.7)
        default:
            return .orange
        }
    }
    
    /**
     * 获取指定日期的数值
     */
    private func valueForDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        return data.first { calendar.isDate($0.date, inSameDayAs: date) }?.value ?? 0
    }
}

/**
 * 热力图详情视图
 */
struct HeatmapDetailView: View {
    let date: Date
    let value: Int
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(dateString)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(value) 次创作")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("活动详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        // 关闭详情视图
                    }
                }
            }
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

#Preview {
    let sampleData = (0..<365).map { i in
        let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
        return HeatmapDataItem(date: date, value: Int.random(in: 0...4))
    }
    
    return HeatmapChart(data: sampleData)
        .padding()
}
