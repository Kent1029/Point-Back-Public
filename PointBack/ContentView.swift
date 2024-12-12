//
//  ContentView.swift
//  PointBack
//
//  Created by Kent_Huang on 2024/11/14.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""  // 搜尋欄位輸入 / Search text input
    @State private var filteredMerchants: [(name: String, aliases: [String], rewards: [(String, String)])] = []  // 篩選後的商家 / Filtered merchants
    @State private var searchHistory: [String] = []  // 搜尋歷史紀錄 / Search history
    @State private var userCards: [Card] = []  // 用戶已新增的卡片 / User's added cards
    @State private var animateLogo = false  // 動畫效果控制 / Animation control
    @State private var isFlipped = false  // 跟蹤翻轉狀態 / Track flip state
    @State private var phase: Int = 1  // 根據回饋等級顯示不同圖片 / Display different images based on reward level
    
    // 商家回饋資料 / Merchant reward data
    let merchants = [
        (
            name: "7-Eleven", aliases: ["7-11", "小七", "7-seven"],
            rewards: [("CUBE VISA", "2%"), ("太陽/玫瑰 MasterCard", "3.8%")]
        ),
        (
            name: "Starbucks", aliases: ["星巴克", "Starbucks Coffee"],
            rewards: [("CUBE VISA", "3%"), ("太陽/玫瑰 MasterCard", "4%")]
        ),
        (
            name: "Costco", aliases: ["好市多"],
            rewards: [("CUBE VISA", "1.5%"), ("太陽/玫瑰 MasterCard", "2%")]
        ),
        (
            name: "Apple Store", aliases: ["蘋果商店", "Apple"],
            rewards: [("CUBE VISA", "2%"), ("太陽/玫瑰 MasterCard", "3.8%")]
        ),
        (
            name: "Amazon", aliases: ["亞馬遜"],
            rewards: [("CUBE VISA", "2.5%"), ("太陽/玫瑰 MasterCard", "3%")]
        ),
        (
            name: "Mcdonald's", aliases: ["麥當勞","麥麥","M記","m記"],
            rewards: [("CUBE VISA", "2%"), ("DAWAY VISA 大威卡", "1%"), ("LINE Pay VISA", "1%")]
        ),
        (
            name: "Uber Eats", aliases: ["吳柏毅","UB","外送"],
            rewards: [("CUBE VISA", "3%"), ("DAWAO VISA 大戶卡", "7%"), ("太陽/玫瑰 MasterCard", "3.8%")]
        ),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // 頂部區域 / Top area
                ZStack {
                    Color(.systemBlue).opacity(0.15)
                        .edgesIgnoringSafeArea(.top)
                    Text("Point Back")
                        .font(.title.bold())
                        .foregroundColor(Color(.systemBlue))
                        .padding(.top, 0)
                }
                .frame(height: 80)
                
                // 搜索欄位 / Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("Search...", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .onChange(of: searchText) { newValue in
                            filterMerchants()  // 篩選商家並更新 phase / Filter merchants and update phase
                        }
                    
                    // 如果 searchText 不為空，顯示“X”按鈕 / Show "X" button if searchText is not empty
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""  // 清除输入的文字 / Clear input text
                            filteredMerchants = []  // 清空篩選結果 / Clear filtered results
                            phase = 1  // 重置 phase / Reset phase
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                // 篩選結果顯示 / Display filtered results
                if !filteredMerchants.isEmpty {
                    List(filteredMerchants, id: \.name) { merchant in
                        Section(header: Text(merchant.name).font(.headline)) {
                            ForEach(merchant.rewards, id: \.0) { reward in
                                if userCards.contains(where: {
                                    $0.cardType == reward.0
                                }) {
                                    HStack {
                                        Text(reward.0)  // 卡片名稱 / Card name
                                        Spacer()
                                        Text(reward.1)  // 回饋百分比 / Reward percentage
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 300)  // 限制列表高度 / Limit list height
                } else if !searchText.isEmpty {
                    Text("沒有找到符合的商家")  // No matching merchants found
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                }
                
                Spacer()
                    .frame(height: 50)  // 控制 Spacer 高度為 50 / Control Spacer height to 50
                
                // 中央區域 / Central area
                let petImages = ["Bichon1", "Bichon2", "Bichon3", "Bichon4"]
                
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color(.systemBlue).opacity(0.01), lineWidth: 0.1
                        )
                        .frame(height: 300)
                        .overlay(
                            Group {
                                if isFlipped {
                                    Image(
                                        petImages[
                                            min(phase - 1, petImages.count - 1)]
                                    )
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(40)
                                    .shadow(radius: 10)  // 添加陰影 / Add shadow
                                } else {
                                    Image("icon")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(40)
                                        .shadow(radius: 100)  // 添加陰影 / Add shadow
                                }
                            }
                        )
                        .rotation3DEffect(
                            .degrees(isFlipped ? 180 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .animation(.easeInOut(duration: 0.55), value: isFlipped)
                        .onTapGesture {
                            isFlipped.toggle()
                        }
                    HStack {
                        Spacer()
                        Button(action: {
                            phase = min(phase + 1, petImages.count)  // 確保 phase 不超過圖片數量 / Ensure phase does not exceed the number of images
                        }) {
                            Text("我是隱藏按鈕")  // I am a hidden button
                                .font(.system(size: 14))  // 調整文字大小 / Adjust text size
                                .padding(6)  // 減小內部填充 / Reduce internal padding
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)  // 減小圓角 / Reduce corner radius
                        }
                        .padding(.trailing, 10)  // 調整按鈕與右邊距離 / Adjust button distance from the right
                    }
                }
                
                Spacer()
                
                // 底部分頁按鈕 / Bottom pagination buttons
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: HistorySearchView(
                            searchHistory: $searchHistory,
                            searchText: $searchText)
                    ) {
                        VStack {
                            Image(systemName: "timer")
                                .foregroundColor(Color(.systemBlue))
                            Text("歷史搜尋")  // History search
                                .font(.caption)
                                .padding(8)
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: NearbyStoresView()) {
                        VStack {
                            Image(systemName: "binoculars")
                                .foregroundColor(Color(.systemBlue))
                            Text("附近店家")  // Nearby stores
                                .font(.caption)
                                .padding(8)
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: PetBooksView()) {
                        VStack {
                            Image(systemName: "star.circle")
                                .foregroundColor(Color(.systemBlue))
                            Text("寵物圖鑑")  // Pet books
                                .font(.caption)
                                .padding(8)
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: BestCombinationView(cards: $userCards)) {
                        VStack {
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(Color(.systemBlue))
                            Text("最佳組合")  // Best combination
                                .font(.caption)
                                .padding(8)
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: MyCardView(cards: $userCards)) {
                        VStack {
                            Image(systemName: "creditcard.circle")
                                .foregroundColor(Color(.systemBlue))
                            Text("我的卡片")  // My cards
                                .font(.caption)
                                .padding(8)
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 16)
                .padding(.top, 8)
                .background(Color(.systemBlue).opacity(0.15))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private func filterMerchants() {
        if searchText.isEmpty {
            filteredMerchants = []
            phase = 1  // 重置 phase / Reset phase
        } else {
            // 篩選商家 / Filter merchants
            filteredMerchants = merchants.filter {
                $0.name.lowercased().contains(searchText.lowercased())
                || $0.aliases.contains(where: {
                    $0.lowercased().contains(searchText.lowercased())
                })
            }.map { merchant in
                // 僅保留用戶擁有卡片的回饋資訊 / Only keep reward information for user's cards
                let filteredRewards = merchant.rewards.filter { reward in
                    userCards.contains(where: { $0.cardType == reward.0 })  // 根據用戶卡片篩選 / Filter based on user's cards
                }
                // 排序 rewards，將回饋百分比從大到小排列 / Sort rewards by percentage in descending order
                let sortedRewards = filteredRewards.sorted {
                    // 將百分比字串轉換為數值進行比較 / Convert percentage string to number for comparison
                    let firstPercentage =
                    Double($0.1.replacingOccurrences(of: "%", with: ""))
                    ?? 0
                    let secondPercentage =
                    Double($1.1.replacingOccurrences(of: "%", with: ""))
                    ?? 0
                    return firstPercentage > secondPercentage
                }
                return (
                    name: merchant.name,
                    aliases: merchant.aliases,
                    rewards: sortedRewards
                )
            }
            // 更新 phase / Update phase
            let maxReward =
            filteredMerchants.flatMap { $0.rewards }.compactMap {
                Double($0.1.replacingOccurrences(of: "%", with: ""))
            }.max() ?? 0
            
            switch maxReward {
            case 0..<10:
                phase = 1
            case 10..<20:
                phase = 2
            case 20..<30:
                phase = 3
            default:
                phase = 4
            }
            
            // 搜尋文字長度 >= 3 且有篩選結果 / Search text length >= 3 and there are filtered results
            if searchText.count >= 3,
               let firstMerchant = filteredMerchants.first
            {
                if searchHistory.isEmpty
                    || searchHistory.last != firstMerchant.name
                {
                    searchHistory.append(firstMerchant.name)  // 儲存完整商家名稱 / Save full merchant name
                }
            }
        }
        
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
    }
}
#Preview {
    ContentView()
}
