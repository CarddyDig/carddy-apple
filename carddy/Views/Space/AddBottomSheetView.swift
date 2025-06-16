//
//  AddBottomSheetView.swift
//  carddy
//
//  Created by CreedChung on 2025/6/16.
//

import SwiftUI
import SwiftData

/**
 * 添加底部弹出视图
 *
 * @component
 * @example
 * ```swift
 * AddBottomSheetView()
 * ```
 *
 * 提供以下功能：
 * - 快速添加新项目
 * - 简洁的用户界面
 * - 自动保存功能
 */
struct AddBottomSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var isAdding = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 标题
                VStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                    
                    Text("添加新项目")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("点击下方按钮快速添加一个新项目")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // 添加按钮
                Button(action: addItem) {
                    HStack {
                        if isAdding {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "plus")
                        }
                        
                        Text(isAdding ? "添加中..." : "添加项目")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isAdding)
                
                Spacer()
            }
            .padding()
            .navigationTitle("添加项目")
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
    
    /**
     * 添加新项目
     */
    private func addItem() {
        withAnimation {
            isAdding = true
        }
        
        // 模拟添加延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let newItem = Item()
            modelContext.insert(newItem)
            
            withAnimation {
                isAdding = false
            }
            
            // 延迟关闭弹窗
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        }
    }
}

#Preview {
    AddBottomSheetView()
        .modelContainer(for: Item.self, inMemory: true)
}
