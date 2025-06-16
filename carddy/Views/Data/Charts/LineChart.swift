//
//  LineChart.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI

/**
 * 折线图组件，显示趋势变化
 *
 * @component
 * @example
 * ```swift
 * LineChart(data: lineData)
 * ```
 *
 * 提供以下功能：
 * - 平滑的曲线绘制
 * - 面积填充效果
 * - 可选数据点显示
 * - 趋势分析指示器
 * - 支持点击查看详情
 */
struct LineChart: View {
    let data: [ChartDataItem]
    @State private var selectedPoint: ChartDataItem?
    @State private var animationProgress: CGFloat = 0
    
    private let chartHeight: CGFloat = 200
    private let pointRadius: CGFloat = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题和趋势指示器
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("趋势分析")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("最近30天的创作趋势")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 趋势指示器
                HStack(spacing: 8) {
                    Image(systemName: trendIcon)
                        .foregroundColor(trendColor)
                        .font(.title3)
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(trendText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(trendColor)
                        
                        Text("趋势")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // 折线图
            VStack(spacing: 8) {
                // 图表区域
                GeometryReader { geometry in
                    ZStack {
                        // 网格线
                        gridLines(in: geometry)
                        
                        // 面积填充
                        areaPath(in: geometry)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .purple.opacity(0.3),
                                        .purple.opacity(0.1),
                                        .purple.opacity(0.0)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(areaPath(in: geometry))
                        
                        // 折线
                        linePath(in: geometry)
                            .trim(from: 0, to: animationProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple, .purple.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                            )
                        
                        // 数据点
                        ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                            let point = dataPoint(for: index, in: geometry)
                            
                            Circle()
                                .fill(.purple)
                                .frame(width: pointRadius * 2, height: pointRadius * 2)
                                .position(point)
                                .scaleEffect(selectedPoint?.id == item.id ? 1.5 : 1.0)
                                .opacity(animationProgress)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedPoint = selectedPoint?.id == item.id ? nil : item
                                    }
                                }
                        }
                        
                        // 选中点的详情
                        if let selected = selectedPoint,
                           let index = data.firstIndex(where: { $0.id == selected.id }) {
                            let point = dataPoint(for: index, in: geometry)
                            
                            VStack(spacing: 4) {
                                Text("\(Int(selected.value))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.purple)
                                    .cornerRadius(8)
                                
                                Text(selected.label)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .position(x: point.x, y: max(40, point.y - 40))
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .frame(height: chartHeight)
                .clipped()
                
                // X轴标签
                HStack {
                    ForEach(xAxisLabels, id: \.self) { label in
                        Text(label)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            
            // 统计信息
            HStack(spacing: 16) {
                StatItem(title: "最高", value: "\(maxValue)")
                StatItem(title: "最低", value: "\(minValue)")
                StatItem(title: "平均", value: String(format: "%.1f", averageValue))
                
                Spacer()
                
                if let selected = selectedPoint {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(selected.value))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        
                        Text(selected.label)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                animationProgress = 1.0
            }
        }
    }
    
    // MARK: - 计算属性
    
    /**
     * 最大值
     */
    private var maxValue: Int {
        Int(data.map { $0.value }.max() ?? 0)
    }
    
    /**
     * 最小值
     */
    private var minValue: Int {
        Int(data.map { $0.value }.min() ?? 0)
    }
    
    /**
     * 平均值
     */
    private var averageValue: Double {
        guard !data.isEmpty else { return 0 }
        return data.reduce(0) { $0 + $1.value } / Double(data.count)
    }
    
    /**
     * 趋势图标
     */
    private var trendIcon: String {
        guard data.count >= 2 else { return "minus" }
        let firstHalf = data.prefix(data.count / 2).reduce(0) { $0 + $1.value }
        let secondHalf = data.suffix(data.count / 2).reduce(0) { $0 + $1.value }
        
        if secondHalf > firstHalf {
            return "arrow.up.right"
        } else if secondHalf < firstHalf {
            return "arrow.down.right"
        } else {
            return "minus"
        }
    }
    
    /**
     * 趋势颜色
     */
    private var trendColor: Color {
        switch trendIcon {
        case "arrow.up.right":
            return .green
        case "arrow.down.right":
            return .red
        default:
            return .orange
        }
    }
    
    /**
     * 趋势文本
     */
    private var trendText: String {
        switch trendIcon {
        case "arrow.up.right":
            return "上升"
        case "arrow.down.right":
            return "下降"
        default:
            return "平稳"
        }
    }
    
    /**
     * X轴标签
     */
    private var xAxisLabels: [String] {
        let step = max(1, data.count / 6) // 显示大约6个标签
        return stride(from: 0, to: data.count, by: step).map { index in
            index < data.count ? data[index].label : ""
        }
    }
    
    // MARK: - 辅助方法
    
    /**
     * 计算数据点位置
     */
    private func dataPoint(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let xStep = geometry.size.width / CGFloat(max(1, data.count - 1))
        let x = CGFloat(index) * xStep
        
        let maxDataValue = data.map { $0.value }.max() ?? 1
        let minDataValue = data.map { $0.value }.min() ?? 0
        let range = maxDataValue - minDataValue
        
        let normalizedValue = range > 0 ? (data[index].value - minDataValue) / range : 0.5
        let y = geometry.size.height * (1 - normalizedValue)
        
        return CGPoint(x: x, y: y)
    }
    
    /**
     * 折线路径
     */
    private func linePath(in geometry: GeometryProxy) -> Path {
        var path = Path()
        
        for (index, _) in data.enumerated() {
            let point = dataPoint(for: index, in: geometry)
            
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        return path
    }
    
    /**
     * 面积路径
     */
    private func areaPath(in geometry: GeometryProxy) -> Path {
        var path = linePath(in: geometry)
        
        if !data.isEmpty {
            let lastPoint = dataPoint(for: data.count - 1, in: geometry)
            let firstPoint = dataPoint(for: 0, in: geometry)
            
            path.addLine(to: CGPoint(x: lastPoint.x, y: geometry.size.height))
            path.addLine(to: CGPoint(x: firstPoint.x, y: geometry.size.height))
            path.closeSubpath()
        }
        
        return path
    }
    
    /**
     * 网格线
     */
    private func gridLines(in geometry: GeometryProxy) -> some View {
        Path { path in
            // 水平网格线
            for i in 0...4 {
                let y = geometry.size.height * CGFloat(i) / 4
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: geometry.size.width, y: y))
            }
        }
        .stroke(Color(.systemGray5), lineWidth: 0.5)
    }
}

#Preview {
    let sampleData = (0..<30).map { day in
        ChartDataItem(
            label: String(format: "%02d-%02d", (day % 12) + 1, (day % 30) + 1),
            value: Double.random(in: 0...10),
            date: Calendar.current.date(byAdding: .day, value: -day, to: Date())
        )
    }.reversed()
    
    return LineChart(data: Array(sampleData))
        .padding()
}
