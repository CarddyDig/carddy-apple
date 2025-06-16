//
//  DraggableChartContainer.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI
import UniformTypeIdentifiers

/**
 * 可拖拽的图表容器，支持拖拽调整图表顺序
 *
 * @component
 * @example
 * ```swift
 * DraggableChartContainer(chartData: chartOrder) { newOrder in
 *     chartOrder = newOrder
 *     saveChartOrder()
 * }
 * ```
 *
 * 提供以下功能：
 * - 长按拖拽重新排序
 * - 平滑的动画过渡
 * - 自动保存排序状态
 * - 视觉反馈效果
 */
struct DraggableChartContainer: View {
    let chartData: [ChartData]
    let onReorder: ([ChartData]) -> Void
    
    @State private var draggedItem: ChartData?
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(chartData) { chart in
                chartView(for: chart)
                    .scaleEffect(draggedItem?.id == chart.id ? 1.05 : 1.0)
                    .opacity(draggedItem?.id == chart.id ? 0.8 : 1.0)
                    .offset(draggedItem?.id == chart.id ? dragOffset : .zero)
                    .animation(.spring(response: 0.3), value: draggedItem?.id)
                    .animation(.spring(response: 0.3), value: dragOffset)
                    .onDrag {
                        NSItemProvider(object: chart.id.uuidString as NSString)
                    }
                    .onDrop(of: [UTType.text], delegate: ChartDropDelegate(
                        chart: chart,
                        chartData: chartData,
                        draggedItem: $draggedItem,
                        onReorder: onReorder
                    ))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if draggedItem == nil {
                                    draggedItem = chart
                                }
                                dragOffset = value.translation
                            }
                            .onEnded { _ in
                                draggedItem = nil
                                dragOffset = .zero
                            }
                    )
            }
        }
    }
    
    /**
     * 根据图表类型返回对应的视图
     */
    @ViewBuilder
    private func chartView(for chart: ChartData) -> some View {
        switch chart.type {
        case .heatmap:
            if let heatmapData = chart.heatmapData {
                HeatmapChart(data: heatmapData)
            } else {
                EmptyChartView(title: chart.title, subtitle: chart.subtitle)
            }
            
        case .bar:
            BarChart(data: chart.data)
            
        case .pie:
            PieChart(data: chart.data)
            
        case .line:
            LineChart(data: chart.data)
        }
    }
}

/**
 * 拖拽委托
 */
struct ChartDropDelegate: DropDelegate {
    let chart: ChartData
    let chartData: [ChartData]
    @Binding var draggedItem: ChartData?
    let onReorder: ([ChartData]) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = draggedItem else { return false }
        
        var newChartData = chartData
        
        // 找到拖拽项和目标项的索引
        guard let fromIndex = newChartData.firstIndex(where: { $0.id == draggedItem.id }),
              let toIndex = newChartData.firstIndex(where: { $0.id == chart.id }) else {
            return false
        }
        
        // 重新排序
        let movedItem = newChartData.remove(at: fromIndex)
        newChartData.insert(movedItem, at: toIndex)
        
        // 更新 order 属性
        for (index, var chartItem) in newChartData.enumerated() {
            chartItem.order = index
            newChartData[index] = chartItem
        }
        
        onReorder(newChartData)
        self.draggedItem = nil
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem,
              draggedItem.id != chart.id else { return }
        
        var newChartData = chartData
        
        guard let fromIndex = newChartData.firstIndex(where: { $0.id == draggedItem.id }),
              let toIndex = newChartData.firstIndex(where: { $0.id == chart.id }) else {
            return
        }
        
        if fromIndex != toIndex {
            withAnimation(.spring(response: 0.3)) {
                let movedItem = newChartData.remove(at: fromIndex)
                newChartData.insert(movedItem, at: toIndex)
                
                // 更新 order 属性
                for (index, var chartItem) in newChartData.enumerated() {
                    chartItem.order = index
                    newChartData[index] = chartItem
                }
                
                onReorder(newChartData)
            }
        }
    }
}

/**
 * 空图表视图
 */
struct EmptyChartView: View {
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("暂无数据")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

/**
 * iOS 26 兼容的拖拽手势修饰符
 */
extension View {
    /**
     * 添加长按拖拽手势
     */
    func draggableChart<T: Identifiable>(
        item: T,
        draggedItem: Binding<T?>,
        onDragChanged: @escaping (DragGesture.Value) -> Void = { _ in },
        onDragEnded: @escaping (DragGesture.Value) -> Void = { _ in }
    ) -> some View {
        self.gesture(
            LongPressGesture(minimumDuration: 0.5)
                .sequenced(before: DragGesture())
                .onChanged { value in
                    switch value {
                    case .second(true, let drag):
                        if draggedItem.wrappedValue == nil {
                            draggedItem.wrappedValue = item
                        }
                        if let drag = drag {
                            onDragChanged(drag)
                        }
                    default:
                        break
                    }
                }
                .onEnded { value in
                    switch value {
                    case .second(true, let drag):
                        if let drag = drag {
                            onDragEnded(drag)
                        }
                        draggedItem.wrappedValue = nil
                    default:
                        break
                    }
                }
        )
    }
}

#Preview {
    let sampleChartData = [
        ChartData(
            type: .heatmap,
            title: "活动热力图",
            subtitle: "过去一年的创作活动",
            heatmapData: (0..<365).map { i in
                let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                return HeatmapDataItem(date: date, value: Int.random(in: 0...4))
            },
            order: 0
        ),
        ChartData(
            type: .bar,
            title: "周度统计",
            subtitle: "最近12周的创作数量",
            data: (1...12).map { week in
                ChartDataItem(
                    label: "2024-W\(String(format: "%02d", week))",
                    value: Double.random(in: 0...10)
                )
            },
            order: 1
        ),
        ChartData(
            type: .pie,
            title: "时间分布",
            subtitle: "不同时间段的创作分布",
            data: [
                ChartDataItem(label: "早晨 (6-12)", value: 15),
                ChartDataItem(label: "下午 (12-18)", value: 25),
                ChartDataItem(label: "晚上 (18-24)", value: 20),
                ChartDataItem(label: "深夜 (0-6)", value: 8)
            ],
            order: 2
        ),
        ChartData(
            type: .line,
            title: "趋势分析",
            subtitle: "最近30天的创作趋势",
            data: (0..<30).map { day in
                ChartDataItem(
                    label: String(format: "%02d-%02d", (day % 12) + 1, (day % 30) + 1),
                    value: Double.random(in: 0...10),
                    date: Calendar.current.date(byAdding: .day, value: -day, to: Date())
                )
            }.reversed(),
            order: 3
        )
    ]
    
    return DraggableChartContainer(chartData: sampleChartData) { newOrder in
        print("新的排序: \(newOrder.map { $0.title })")
    }
    .padding()
}
