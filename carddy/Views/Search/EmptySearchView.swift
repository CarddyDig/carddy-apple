//
//  EmptySearchView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI

/**
 * 空搜索状态视图
 *
 * @component
 * @example
 * ```swift
 * EmptySearchView()
 * ```
 *
 * 提供以下功能：
 * - 热门搜索推荐
 * - 搜索历史记录
 * - 搜索建议提示
 */
struct EmptySearchView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 热门搜索
                VStack(alignment: .leading, spacing: 12) {
                    Text("热门搜索")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(hotSearchTerms, id: \.self) { term in
                            Button(term) {
                                // 点击热门搜索
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // 搜索历史
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("搜索历史")
                            .font(.headline)
                        Spacer()
                        Button("清空") {
                            // 清空搜索历史
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(searchHistory, id: \.self) { history in
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                
                                Text(history)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button(action: {
                                    // 删除单个历史记录
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                // 搜索建议
                VStack(alignment: .leading, spacing: 12) {
                    Text("搜索建议")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(searchSuggestions, id: \.self) { suggestion in
                            HStack {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                
                                Text(suggestion)
                                    .font(.subheadline)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private let hotSearchTerms = ["卡片设计", "模板", "教程", "配色", "字体", "图标"]
    private let searchHistory = ["名片模板", "海报设计", "Logo制作"]
    private let searchSuggestions = ["尝试搜索具体的设计类型", "使用关键词组合搜索", "搜索颜色或风格"]
}

#Preview {
    EmptySearchView()
}
