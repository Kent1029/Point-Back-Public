//
//  HistorySearchView.swift
//  PointBack
//
//  Created by Kent_Huang on 2024/11/19.
//

import SwiftUI

struct HistorySearchView: View {
    @Binding var searchHistory: [String]  // 綁定搜尋歷史紀錄 / Bind search history
    @Binding var searchText: String       // 綁定搜尋文字 / Bind search text
    
    var body: some View {
        VStack {
            if searchHistory.isEmpty {
                Text("暫無搜尋記錄") // 顯示無搜尋記錄的訊息 / Display message when no search history
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(searchHistory, id: \.self) { history in
                        Text(history) // 顯示歷史記錄 / Display search history
                    }
                    .onDelete(perform: deleteHistory) // 左滑刪除功能 / Swipe to delete functionality
                }
            }
            Spacer()
        }
        .navigationTitle("歷史搜尋") // 設定導航標題 / Set navigation title
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton() // 編輯按鈕 / Edit button
            }
        }
    }
    
    private func deleteHistory(at offsets: IndexSet) {
        searchHistory.remove(atOffsets: offsets) // 刪除選定的歷史記錄 / Delete selected search history
    }
}
