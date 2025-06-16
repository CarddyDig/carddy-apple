//
//  SettingsView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/15.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // 用户信息部分
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("用户名")
                                .font(.headline)
                            Text("user@example.com")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("编辑") {
                            // 编辑用户信息
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 8)
                }
                
                // 应用设置部分
                Section("应用设置") {
                    SettingsRow(
                        icon: "bell.fill",
                        title: "通知",
                        subtitle: "管理推送通知",
                        iconColor: .orange
                    ) {
                        // 通知设置
                    }
                    
                    SettingsRow(
                        icon: "moon.fill",
                        title: "外观",
                        subtitle: "深色模式和主题",
                        iconColor: .purple
                    ) {
                        // 外观设置
                    }
                    
                    SettingsRow(
                        icon: "icloud.fill",
                        title: "同步",
                        subtitle: "iCloud 同步设置",
                        iconColor: .blue
                    ) {
                        // 同步设置
                    }
                }
                
                // 数据管理部分
                Section("数据管理") {
                    SettingsRow(
                        icon: "square.and.arrow.down.fill",
                        title: "导入数据",
                        subtitle: "从其他应用导入",
                        iconColor: .green
                    ) {
                        // 导入数据
                    }
                    
                    SettingsRow(
                        icon: "square.and.arrow.up.fill",
                        title: "导出数据",
                        subtitle: "备份您的数据",
                        iconColor: .blue
                    ) {
                        // 导出数据
                    }
                }
                
                // 帮助和支持部分
                Section("帮助和支持") {
                    SettingsRow(
                        icon: "questionmark.circle.fill",
                        title: "帮助中心",
                        subtitle: "常见问题和教程",
                        iconColor: .cyan
                    ) {
                        // 帮助中心
                    }
                    
                    SettingsRow(
                        icon: "envelope.fill",
                        title: "联系我们",
                        subtitle: "反馈和建议",
                        iconColor: .indigo
                    ) {
                        // 联系我们
                    }
                    
                    SettingsRow(
                        icon: "star.fill",
                        title: "评价应用",
                        subtitle: "在 App Store 评价",
                        iconColor: .yellow
                    ) {
                        // 评价应用
                    }
                }
                
                // 关于部分
                Section("关于") {
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "关于 Carddy",
                        subtitle: "版本 1.0.0",
                        iconColor: .gray
                    ) {
                        // 关于页面
                    }
                    
                    SettingsRow(
                        icon: "doc.text.fill",
                        title: "隐私政策",
                        subtitle: "了解我们如何保护您的隐私",
                        iconColor: .green
                    ) {
                        // 隐私政策
                    }
                    
                    SettingsRow(
                        icon: "doc.fill",
                        title: "服务条款",
                        subtitle: "使用条款和条件",
                        iconColor: .blue
                    ) {
                        // 服务条款
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
}
