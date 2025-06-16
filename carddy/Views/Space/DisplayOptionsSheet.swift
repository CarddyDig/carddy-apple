//
//  DisplayOptionsSheet.swift
//  carddy
//
//  Created by CreedChung on 2025/6/15.
//

import SwiftUI

/**
 * 显示选项弹窗视图
 *
 * @component
 * @example
 * ```swift
 * DisplayOptionsSheet()
 * ```
 *
 * 提供以下功能：
 * - 主题设置
 * - 显示偏好设置
 * - 其他应用选项
 */
struct DisplayOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTheme: ThemeOption = .system
    @State private var showCardCount = true
    @State private var showLastModified = true
    @State private var enableAnimations = true
    @State private var compactMode = false
    
    enum ThemeOption: String, CaseIterable {
        case light = "浅色"
        case dark = "深色"
        case system = "跟随系统"
        
        var systemImage: String {
            switch self {
            case .light:
                return "sun.max"
            case .dark:
                return "moon"
            case .system:
                return "circle.lefthalf.filled"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // 主题设置
                Section("主题") {
                    ForEach(ThemeOption.allCases, id: \.self) { theme in
                        HStack {
                            Image(systemName: theme.systemImage)
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            Text(theme.rawValue)
                            
                            Spacer()
                            
                            if selectedTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTheme = theme
                        }
                    }
                }
                
                // 显示选项
                Section("显示选项") {
                    Toggle(isOn: $showCardCount) {
                        HStack {
                            Image(systemName: "number.square")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            Text("显示卡片数量")
                        }
                    }
                    
                    Toggle(isOn: $showLastModified) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            Text("显示修改时间")
                        }
                    }
                    
                    Toggle(isOn: $enableAnimations) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.purple)
                                .frame(width: 24)
                            Text("启用动画效果")
                        }
                    }
                    
                    Toggle(isOn: $compactMode) {
                        HStack {
                            Image(systemName: "rectangle.compress.vertical")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            Text("紧凑模式")
                        }
                    }
                }
                
                // 其他选项
                Section("其他") {
                    Button {
                        // 重置所有设置
                        resetToDefaults()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.gray)
                                .frame(width: 24)
                            Text("重置为默认设置")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        // 导出设置
                        exportSettings()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            Text("导出设置")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("显示选项")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Actions
    
    /**
     * 重置为默认设置
     */
    private func resetToDefaults() {
        selectedTheme = .system
        showCardCount = true
        showLastModified = true
        enableAnimations = true
        compactMode = false
        print("已重置为默认设置")
    }
    
    /**
     * 导出设置
     */
    private func exportSettings() {
        print("导出设置")
        // 这里可以实现设置导出功能
    }
}

#Preview {
    DisplayOptionsSheet()
}
