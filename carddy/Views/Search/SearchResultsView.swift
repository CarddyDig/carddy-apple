//
//  SearchResultsView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI
import SwiftData

/**
 * 搜索结果视图
 *
 * @component
 * @example
 * ```swift
 * SearchResultsView(searchText: "名片", items: items)
 * ```
 *
 * @param searchText 搜索关键词
 * @param items 搜索结果数据
 */
struct SearchResultsView: View {
    let searchText: String
    let items: [Item]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("未找到相关结果")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("尝试使用其他关键词搜索")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(items) { item in
                        SearchResultCard(item: item, searchText: searchText)
                    }
                }
            }
            .padding()
        }
    }
}

/**
 * 搜索结果卡片
 *
 * @component
 * @example
 * ```swift
 * SearchResultCard(item: item, searchText: "名片")
 * ```
 *
 * @param item 数据项
 * @param searchText 搜索关键词
 */
struct SearchResultCard: View {
    let item: Item
    let searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "doc.richtext")
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("作品 \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    .font(.headline)
                    .lineLimit(1)
                
                Text("创建于 \(item.timestamp, format: .relative(presentation: .named))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    let item = Item(timestamp: Date())
    
    return VStack {
        SearchResultsView(searchText: "测试", items: [item])
        
        Divider()
        
        SearchResultCard(item: item, searchText: "测试")
            .padding()
    }
}
