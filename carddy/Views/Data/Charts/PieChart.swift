//
//  PieChart.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI

/**
 * 饼状图组件，显示数据分布情况
 *
 * @component
 * @example
 * ```swift
 * PieChart(data: pieData)
 * ```
 *
 * 提供以下功能：
 * - 自定义绘制的环形饼图
 * - 多彩色扇形区域
 * - 图例显示
 * - 支持点击选择
 * - 显示百分比信息
 */
struct PieChart: View {
    let data: [ChartDataItem]
    @State private var selectedSlice: ChartDataItem?
    @State private var animationProgress: CGFloat = 0
    
    private let chartSize: CGFloat = 200
    private let innerRadius: CGFloat = 60
    private let outerRadius: CGFloat = 90
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("时间分布")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("不同时间段的创作分布")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 24) {
                // 饼图
                ZStack {
                    // 背景圆环
                    Circle()
                        .stroke(Color(.systemGray6), lineWidth: outerRadius - innerRadius)
                        .frame(width: chartSize, height: chartSize)
                    
                    // 饼图扇形
                    ForEach(Array(slicesData.enumerated()), id: \.element.item.id) { index, slice in
                        PieSlice(
                            startAngle: slice.startAngle,
                            endAngle: slice.endAngle,
                            innerRadius: innerRadius,
                            outerRadius: selectedSlice?.id == slice.item.id ? outerRadius + 8 : outerRadius
                        )
                        .fill(colorForIndex(index))
                        .scaleEffect(animationProgress)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedSlice = selectedSlice?.id == slice.item.id ? nil : slice.item
                            }
                        }
                    }
                    
                    // 中心文字
                    VStack(spacing: 2) {
                        if let selected = selectedSlice {
                            Text("\(Int(selected.value))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(percentageString(for: selected))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("\(totalValue)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("总计")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(width: chartSize, height: chartSize)
                
                // 图例
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                        HStack(spacing: 8) {
                            // 颜色指示器
                            RoundedRectangle(cornerRadius: 2)
                                .fill(colorForIndex(index))
                                .frame(width: 12, height: 12)
                                .scaleEffect(selectedSlice?.id == item.id ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: selectedSlice?.id)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.label)
                                    .font(.subheadline)
                                    .fontWeight(selectedSlice?.id == item.id ? .semibold : .regular)
                                
                                HStack(spacing: 4) {
                                    Text("\(Int(item.value))")
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                    
                                    Text("(\(percentageString(for: item)))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedSlice = selectedSlice?.id == item.id ? nil : item
                            }
                        }
                    }
                }
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
     * 扇形数据
     */
    private var slicesData: [(item: ChartDataItem, startAngle: Angle, endAngle: Angle)] {
        var result: [(item: ChartDataItem, startAngle: Angle, endAngle: Angle)] = []
        var currentAngle: Double = -90 // 从顶部开始
        
        let total = data.reduce(0) { $0 + $1.value }
        
        for item in data {
            let percentage = item.value / total
            let angleSize = percentage * 360
            
            let startAngle = Angle(degrees: currentAngle)
            let endAngle = Angle(degrees: currentAngle + angleSize)
            
            result.append((item: item, startAngle: startAngle, endAngle: endAngle))
            currentAngle += angleSize
        }
        
        return result
    }
    
    // MARK: - 辅助方法
    
    /**
     * 根据索引获取颜色
     */
    private func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [.green, .blue, .orange, .purple, .pink, .red]
        return colors[index % colors.count]
    }
    
    /**
     * 计算百分比字符串
     */
    private func percentageString(for item: ChartDataItem) -> String {
        let total = data.reduce(0) { $0 + $1.value }
        let percentage = (item.value / total) * 100
        return String(format: "%.1f%%", percentage)
    }
}

/**
 * 饼图扇形
 */
struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var path = Path()
        
        // 外弧
        path.addArc(
            center: center,
            radius: outerRadius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        // 内弧
        path.addArc(
            center: center,
            radius: innerRadius,
            startAngle: endAngle,
            endAngle: startAngle,
            clockwise: true
        )
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    let sampleData = [
        ChartDataItem(label: "早晨 (6-12)", value: 15),
        ChartDataItem(label: "下午 (12-18)", value: 25),
        ChartDataItem(label: "晚上 (18-24)", value: 20),
        ChartDataItem(label: "深夜 (0-6)", value: 8)
    ]
    
    return PieChart(data: sampleData)
        .padding()
}
