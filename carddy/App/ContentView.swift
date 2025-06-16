//
//  ContentView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI
import SwiftData

/**
 * 主内容视图，使用新的 Liquid Glass 设计语言和 TabView API
 *
 * @component
 * @example
 * ```swift
 * ContentView()
 *     .modelContainer(for: Item.self)
 * ```
 *
 * 提供以下功能：
 * - 空间：最近作品和快速操作
 * - 数据：统计分析和数据展示
 * - 社区：用户交流和作品分享
 * - 搜索按钮：仅提供UI反馈，不跳转页面
 */
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    private let shareService = ShareService()
    @State private var selectedTab: String = "home"
    @State private var showAddSheet: Bool = false

    var body: some View {
        // 正常模式：根据当前 tab 显示不同的右侧按钮
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newValue in
                // 防止选中右侧的功能按钮，只允许选中主要的 tab
                if ["home", "data", "community"].contains(newValue) {
                    selectedTab = newValue
                }
                // 如果点击了右侧按钮，执行相应的动作但不切换 tab
                else if newValue == "share" {
                    handleShareAction()
                } else if newValue == "search" {
                    handleSearchAction()
                }
            }
        )) {
            Tab("空间", systemImage: "house.fill", value: "home") {
                SpaceView()
            }

            Tab("数据", systemImage: "chart.bar.fill", value: "data") {
                DataView()
            }

            Tab("社区", systemImage: "person.3.fill", value: "community") {
                CommunityView()
            }

            // 根据当前选中的 tab 显示不同的右侧按钮（仅 UI，不跳转）
            if selectedTab == "home" {
                Tab("搜索", systemImage: "magnifyingglass", value: "search", role: .search) {
                    EmptyView() // 空视图，不会跳转
                }
            } else if selectedTab == "data" {
                Tab("分享", systemImage: "square.and.arrow.up", value: "share") {
                    EmptyView() // 空视图，不会跳转
                }
            } else if selectedTab == "community" {
                Tab("搜索", systemImage: "magnifyingglass", value: "search", role: .search) {
                    EmptyView() // 空视图，不会跳转
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .sheet(isPresented: $showAddSheet) {
            AddBottomSheetView()
        }
    }

    // MARK: - Actions

    /**
     * 处理分享按钮点击事件
     */
    private func handleShareAction() {
        print("分享按钮被点击")

        // 分享当前数据页面的统计信息
        shareService.shareStatistics(items: items)
    }

    /**
     * 处理搜索按钮点击事件
     */
    private func handleSearchAction() {
        print("搜索按钮被点击")
        // 搜索功能暂时不可用，仅提供UI反馈
        // 可以在这里添加其他逻辑，比如显示提示信息等
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
