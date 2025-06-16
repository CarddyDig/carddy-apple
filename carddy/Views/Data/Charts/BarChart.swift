//
//  BarChart.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI

/**
 * 柱状图组件，显示周度或月度统计数据
 *
 * @component
 * @example
 * ```swift
 * BarChart(data: barData)
 * ```
 *
 * 提供以下功能：
 * - 自定义绘制的柱状图
 * - 渐变色填充效果
 * - 支持点击交互
 * - 显示统计信息
 * - 平滑动画效果
 */
struct BarChart: View {
    let data: [ChartDataItem]
    @State private var selectedBar: ChartDataItem?
    @State private var animationProgress: CGFloat = 0
    
    private let barSpacing: CGFloat = 8
    private let chartHeight: CGFloat = 200
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题和统计信息
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("周度统计")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("最近12周的创作数量")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 统计信息
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 12) {
                        StatItem(title: "总计", value: "\(totalValue)")
                        StatItem(title: "平均", value: String(format: "%.1f", averageValue))
                        StatItem(title: "最高", value: "\(maxValue)")
                    }
                }
            }
            
            // 柱状图
            VStack(spacing: 8) {
                // 图表区域
                GeometryReader { geometry in
                    HStack(alignment: .bottom, spacing: barSpacing) {
                        ForEach(data) { item in
                            VStack(spacing: 4) {
                                // 柱子
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                selectedBar?.id == item.id ? .blue : .blue.opacity(0.8),
                                                selectedBar?.id == item.id ? .blue.opacity(0.6) : .blue.opacity(0.4)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(height: barHeight(for: item, in: geometry))
                                    .scaleEffect(y: animationProgress, anchor: .bottom)
                                    .overlay(
                                        // 选中时的边框
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.blue, lineWidth: selectedBar?.id == item.id ? 2 : 0)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedBar = selectedBar?.id == item.id ? nil : item
                                        }
                                    }
                                
                                // 数值标签
                                if selectedBar?.id == item.id {
                                    Text("\(Int(item.value))")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .frame(height: chartHeight)
                
                // X轴标签
                HStack(alignment: .top, spacing: barSpacing) {
                    ForEach(data) { item in
                        Text(formatWeekLabel(item.label))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 4)
            }
            
            // 选中项详情
            if let selected = selectedBar {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("选中周期")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(formatWeekLabel(selected.label))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("创作数量")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(selected.value))")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animationProgress = 1.0
            }
        }
    }
    
    // MARK: - 计算属性
    
    /**
     * 总数值
     */
    private var totalValue: Int {
        Int(data.reduce(0) { $0 + $1.value })
    }
    
    /**
     * 平均值
     */
    private var averageValue: Double {
        guard !data.isEmpty else { return 0 }
        return data.reduce(0) { $0 + $1.value } / Double(data.count)
    }
    
    /**
     * 最大值
     */
    private var maxValue: Int {
        Int(data.map { $0.value }.max() ?? 0)
    }
    
    /**
     * 最大数据值（用于计算比例）
     */
    private var maxDataValue: Double {
        data.map { $0.value }.max() ?? 1
    }
    
    // MARK: - 辅助方法
    
    /**
     * 计算柱子高度
     */
    private func barHeight(for item: ChartDataItem, in geometry: GeometryProxy) -> CGFloat {
        let ratio = item.value / maxDataValue
        return max(4, geometry.size.height * ratio) // 最小高度4
    }
    
    /**
     * 格式化周标签
     */
    private func formatWeekLabel(_ label: String) -> String {
        // 将 "2024-W23" 格式转换为 "W23"
        if label.contains("-W") {
            return String(label.suffix(3))
        }
        return label
    }
}

/**
 * 统计项组件
 */
struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    let sampleData = (1...12).map { week in
        ChartDataItem(
            label: "2024-W\(String(format: "%02d", week))",
            value: Double.random(in: 0...10)
        )
    }
    
    return BarChart(data: sampleData)
        .padding()
}
