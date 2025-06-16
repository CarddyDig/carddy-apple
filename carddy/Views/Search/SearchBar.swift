//
//  SearchBar.swift
//  carddy
//
//  Created by CreedChung on 2025/6/14.
//

import SwiftUI

/**
 * 搜索栏组件
 *
 * @component
 * @example
 * ```swift
 * SearchBar(text: $searchText, isSearching: $isSearching)
 * ```
 *
 * @param text 搜索文本绑定
 * @param isSearching 搜索状态绑定
 */
struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("搜索作品、模板、教程...", text: $text)
                    .onTapGesture {
                        isSearching = true
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isSearching {
                Button("取消") {
                    text = ""
                    isSearching = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSearching)
    }
}

#Preview {
    @Previewable @State var searchText = ""
    @Previewable @State var isSearching = false

    return VStack {
        SearchBar(text: $searchText, isSearching: $isSearching)
            .padding()

        Spacer()
    }
}
