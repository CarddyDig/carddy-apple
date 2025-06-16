//
//  CommunityView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI

/**
 * 社区视图，展示社区动态和用户交流
 *
 * @component
 * @example
 * ```swift
 * CommunityView()
 * ```
 *
 * 提供以下功能：
 * - 社区动态展示
 * - 用户作品分享
 * - 互动交流功能
 */
struct CommunityView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 顶部标签选择器
                Picker("社区类型", selection: $selectedTab) {
                    Text("推荐").tag(0)
                    Text("最新").tag(1)
                    Text("热门").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 内容区域
                TabView(selection: $selectedTab) {
                    RecommendedView()
                        .tag(0)
                    
                    LatestView()
                        .tag(1)
                    
                    PopularView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("社区")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("发布") {
                        // 发布新内容
                    }
                }
            }
        }
    }
}

/**
 * 推荐内容视图
 */
struct RecommendedView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<10, id: \.self) { index in
                    CommunityPostCard(
                        title: "精美卡片设计分享 #\(index + 1)",
                        author: "设计师\(index + 1)",
                        content: "这是一个非常棒的卡片设计，使用了最新的 Liquid Glass 设计语言...",
                        likes: Int.random(in: 10...100),
                        comments: Int.random(in: 5...50),
                        isRecommended: true
                    )
                }
            }
            .padding()
        }
    }
}

/**
 * 最新内容视图
 */
struct LatestView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<15, id: \.self) { index in
                    CommunityPostCard(
                        title: "新作品展示 #\(index + 1)",
                        author: "用户\(index + 1)",
                        content: "刚刚完成的设计作品，希望大家多多指教...",
                        likes: Int.random(in: 1...30),
                        comments: Int.random(in: 0...15),
                        isRecommended: false
                    )
                }
            }
            .padding()
        }
    }
}

/**
 * 热门内容视图
 */
struct PopularView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<8, id: \.self) { index in
                    CommunityPostCard(
                        title: "热门设计教程 #\(index + 1)",
                        author: "教程作者\(index + 1)",
                        content: "详细的设计教程，教你如何制作专业级别的卡片设计...",
                        likes: Int.random(in: 50...200),
                        comments: Int.random(in: 20...80),
                        isRecommended: false
                    )
                }
            }
            .padding()
        }
    }
}



#Preview {
    CommunityView()
}
