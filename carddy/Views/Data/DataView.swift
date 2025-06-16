//
//  DataView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI
import SwiftData

/**
 * 数据视图，展示数据分析和统计信息
 *
 * @component
 * @example
 * ```swift
 * DataView()
 * ```
 *
 * 提供以下功能：
 * - 热力图、柱状图、饼状图、折线图
 * - 支持拖拽调整图表顺序
 * - 数据统计和分析
 * - iOS 26 兼容的现代化设计
 */
struct DataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var chartOrder: [ChartData] = []
    @AppStorage("chartOrder") private var savedChartOrder: Data = Data()
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if isLoading {
                        // 加载状态
                        loadingView
                    } else {
                        // 图表容器
                        chartContainer
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("数据")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("分享") {
                        shareData()
                    }

                    Button("导出") {
                        exportData()
                    }
                }
            }
            .refreshable {
                await refreshData()
            }
            .onAppear {
                loadChartData()
            }
        }
    }

    // MARK: - 视图组件

    /**
     * 加载视图
     */
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<4) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 200)
                    .shimmer()
            }
        }
        .padding(.horizontal)
    }

    /**
     * 图表容器
     */
    private var chartContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题和说明
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("数据分析")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("拖拽调整图表顺序")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 数据概览
                dataOverview
            }
            .padding(.horizontal)

            // 可拖拽的图表容器
            DraggableChartContainer(chartData: chartOrder) { newOrder in
                chartOrder = newOrder
                saveChartOrder()
            }
            .padding(.horizontal)
        }
    }

    /**
     * 数据概览
     */
    private var dataOverview: some View {
        HStack(spacing: 12) {
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(items.count)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text("总作品")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(weeklyCount)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)

                Text("本周")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(activeDays)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)

                Text("活跃天")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - 计算属性

    /**
     * 统计数据
     */
    private var statistics: (totalCount: Int, weeklyCount: Int, activeDays: Int, dailyAverage: Double) {
        StatisticsCalculator.calculateOverallStatistics(items: items)
    }

    /**
     * 计算本周新增作品数量
     */
    private var weeklyCount: Int {
        statistics.weeklyCount
    }

    /**
     * 计算活跃天数
     */
    private var activeDays: Int {
        statistics.activeDays
    }

    /**
     * 计算每日平均作品数
     */
    private var dailyAverage: Double {
        statistics.dailyAverage
    }

    // MARK: - 数据处理方法

    /**
     * 加载图表数据
     */
    private func loadChartData() {
        Task {
            // 模拟加载延迟
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒

            await MainActor.run {
                // 生成图表数据
                let generatedChartData = ChartDataGenerator.generateChartData(from: items)

                // 尝试从保存的顺序中恢复
                if let savedOrder = loadSavedChartOrder() {
                    // 合并保存的顺序和新生成的数据
                    var orderedCharts: [ChartData] = []

                    for savedChart in savedOrder {
                        if let matchingChart = generatedChartData.first(where: { $0.type == savedChart.type }) {
                            var updatedChart = matchingChart
                            updatedChart.order = savedChart.order
                            orderedCharts.append(updatedChart)
                        }
                    }

                    // 添加任何新的图表类型
                    for chart in generatedChartData {
                        if !orderedCharts.contains(where: { $0.type == chart.type }) {
                            orderedCharts.append(chart)
                        }
                    }

                    chartOrder = orderedCharts.sorted { $0.order < $1.order }
                } else {
                    chartOrder = generatedChartData
                }

                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }

    /**
     * 刷新数据
     */
    private func refreshData() async {
        await MainActor.run {
            isLoading = true
        }

        // 重新生成图表数据
        let generatedChartData = ChartDataGenerator.generateChartData(from: items)

        await MainActor.run {
            // 保持当前的排序，只更新数据
            var updatedCharts: [ChartData] = []

            for existingChart in chartOrder {
                if let newChart = generatedChartData.first(where: { $0.type == existingChart.type }) {
                    var updatedChart = newChart
                    updatedChart.order = existingChart.order
                    updatedCharts.append(updatedChart)
                }
            }

            // 添加任何新的图表类型
            for chart in generatedChartData {
                if !updatedCharts.contains(where: { $0.type == chart.type }) {
                    updatedCharts.append(chart)
                }
            }

            withAnimation(.easeInOut(duration: 0.3)) {
                chartOrder = updatedCharts.sorted { $0.order < $1.order }
                isLoading = false
            }
        }
    }

    /**
     * 保存图表顺序
     */
    private func saveChartOrder() {
        do {
            let orderData = try JSONEncoder().encode(chartOrder.map { chart in
                ChartOrderData(type: chart.type, order: chart.order)
            })
            savedChartOrder = orderData
        } catch {
            print("保存图表顺序失败: \(error)")
        }
    }

    /**
     * 加载保存的图表顺序
     */
    private func loadSavedChartOrder() -> [ChartOrderData]? {
        guard !savedChartOrder.isEmpty else { return nil }

        do {
            return try JSONDecoder().decode([ChartOrderData].self, from: savedChartOrder)
        } catch {
            print("加载图表顺序失败: \(error)")
            return nil
        }
    }

    /**
     * 分享数据
     */
    private func shareData() {
        // 实现分享功能
        print("分享数据功能")
    }

    /**
     * 导出数据
     */
    private func exportData() {
        // 实现导出功能
        print("导出数据功能")
    }
}

/**
 * 图表顺序数据模型，用于持久化存储
 */
struct ChartOrderData: Codable {
    let type: ChartType
    let order: Int
}

/**
 * 视觉效果扩展
 */
extension View {
    /**
     * 添加闪烁加载效果
     */
    func shimmer() -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: -200)
                .animation(
                    .linear(duration: 1.5).repeatForever(autoreverses: false),
                    value: UUID()
                )
        )
        .clipped()
    }
}

#Preview {
    DataView()
        .modelContainer(for: Item.self, inMemory: true)
}