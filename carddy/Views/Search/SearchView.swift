//
//  SearchView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI
import SwiftData

/**
 * 搜索视图，提供全局搜索功能
 *
 * @component
 * @example
 * ```swift
 * SearchView()
 * ```
 *
 * 提供以下功能：
 * - 全局内容搜索
 * - 搜索历史记录
 * - 热门搜索推荐
 */
struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 搜索栏
                SearchBar(text: $searchText, isSearching: $isSearching)
                    .padding()
                
                if searchText.isEmpty {
                    // 空状态 - 显示搜索建议
                    EmptySearchView()
                } else {
                    // 搜索结果
                    SearchResultsView(searchText: searchText, items: filteredItems)
                }
                
                Spacer()
            }
            .navigationTitle("搜索")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    /**
     * 过滤搜索结果
     */
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return []
        }
        // 这里可以根据实际需求实现更复杂的搜索逻辑
        return items.filter { item in
            // 简单的时间戳搜索示例
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: item.timestamp).localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(for: Item.self, inMemory: true)
}
