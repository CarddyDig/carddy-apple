//
//  SpaceView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI

struct SpaceView: View {
    @State private var showingAddSheet = false
    @State private var showingSortSheet = false
    @State private var showingDisplayOptions = false
    @State private var showingSettings = false
    @State private var layoutMode: LayoutMode = .grid
    @State private var sortOption: SortOption = .name

    enum LayoutMode: String, CaseIterable {
        case grid = "网格布局"
        case list = "列表布局"

        var systemImage: String {
            switch self {
            case .grid:
                return "square.grid.2x2"
            case .list:
                return "list.bullet"
            }
        }
    }

    enum SortOption: String, CaseIterable {
        case name = "名称"
        case createTime = "创建时间"
        case modifyTime = "修改时间"
        case cardCount = "卡片数量"

        var systemImage: String {
            switch self {
            case .name:
                return "textformat.abc"
            case .createTime:
                return "calendar.badge.plus"
            case .modifyTime:
                return "calendar.badge.clock"
            case .cardCount:
                return "number.square"
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // 这是一个空白页面
                Text("欢迎来到空间")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .navigationTitle("空间")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbar
            }
            .sheet(isPresented: $showingAddSheet) {
                // 添加页面
                Text("添加内容")
            }
            .sheet(isPresented: $showingSortSheet) {
                // 排序页面
                Text("排序选项")
            }
            .sheet(isPresented: $showingDisplayOptions) {
                DisplayOptionsSheet()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }

    /**
     * 顶部工具栏配置
     *
     * @ToolbarContentBuilder 用于构建工具栏内容
     * 使用 ToolbarItemGroup 实现工具按钮和头像的分离
     * 兼容当前 iOS 版本，使用 .navigationBarTrailing 实现分组效果
     */
    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        // 工具按钮组 - 添加按钮和更多选项按钮
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                showingAddSheet = true
            } label: {
                Label("添加", systemImage: "plus")
            }
            .buttonStyle(.borderless)

            Menu {
                // 筛选选项组
                Section("筛选") {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button {
                            sortOption = option
                        } label: {
                            HStack {
                                Text(option.rawValue)
                                Image(systemName: option.systemImage)
                                if sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                // 分隔线
                Divider()

                // 布局选项组
                Section("布局") {
                    ForEach(LayoutMode.allCases, id: \.self) { mode in
                        Button {
                            layoutMode = mode
                        } label: {
                            HStack {
                                Text(mode.rawValue)
                                Image(systemName: mode.systemImage)
                                if layoutMode == mode {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                // 分隔线
                Divider()

                // 更多选项
                Section {
                    Button {
                        showingDisplayOptions = true
                    } label: {
                        HStack {
                            Text("更多选项")
                            Image(systemName: "gear")
                        }
                    }
                }
            } label: {
                Label("更多", systemImage: "ellipsis.circle")
            }
            .buttonStyle(.borderless)
        }

        // 头像 - 单独的 ToolbarItem，使用 .navigationBarLeading 实现分离
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                // 头像点击事件 - 跳转到设置页面
                showingSettings = true
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    SpaceView()
}

