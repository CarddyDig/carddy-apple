//
//  CommunityPostCard.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI

/**
 * 社区帖子卡片组件
 *
 * @component
 * @example
 * ```swift
 * CommunityPostCard(
 *     title: "精美卡片设计分享",
 *     author: "设计师",
 *     content: "这是一个非常棒的卡片设计...",
 *     likes: 42,
 *     comments: 15,
 *     isRecommended: true
 * )
 * ```
 *
 * @param title 帖子标题
 * @param author 作者名称
 * @param content 帖子内容
 * @param likes 点赞数
 * @param comments 评论数
 * @param isRecommended 是否为推荐内容
 */
struct CommunityPostCard: View {
    let title: String
    let author: String
    let content: String
    let likes: Int
    let comments: Int
    let isRecommended: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 头部信息
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(author)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("2小时前")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isRecommended {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            
            // 标题
            Text(title)
                .font(.headline)
                .lineLimit(2)
            
            // 内容
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            // 预览图片（占位）
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 120)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                        .font(.title)
                )
            
            // 底部操作
            HStack {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                        Text("\(likes)")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "message")
                        Text("\(comments)")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack(spacing: 16) {
        CommunityPostCard(
            title: "精美卡片设计分享",
            author: "设计师",
            content: "这是一个非常棒的卡片设计，使用了最新的 Liquid Glass 设计语言...",
            likes: 42,
            comments: 15,
            isRecommended: true
        )
        
        CommunityPostCard(
            title: "新作品展示",
            author: "用户",
            content: "刚刚完成的设计作品，希望大家多多指教...",
            likes: 8,
            comments: 3,
            isRecommended: false
        )
    }
    .padding()
}
