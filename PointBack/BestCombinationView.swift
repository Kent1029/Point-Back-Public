//
//  BestCombinationView.swift
//  PointBack
//
//  Created by Kent_Huang on 2024/11/19.
//

import SwiftUI

struct BestCombinationView: View {

    @Binding var cards: [Card]  // 綁定用戶的卡片清單 / Binding user's card list
    @State private var isLoading = true  // 加載狀態 / Loading state
    @State private var progress: Double = 0.0  // 進度條進度 / Progress bar progress

    var body: some View {
        VStack {
            if isLoading {
                // 顯示進度條與文字 / Show progress bar and text
                VStack {
                    Spacer()
                    Text("Point AI 為您努力分析中")
                        .font(.headline)
                        .bold()
                        .padding(.bottom, 20)

                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(width: 200)  // 設置進度條寬度 / Set progress bar width
                        .padding(.horizontal)

                    Spacer()
                }
                .onAppear {
                    startLoadingAnimation()  // 模擬進度條變化 / Simulate progress bar change
                }
            } else {
                // 顯示卡片清單或提示訊息 / Show card list or prompt message
                if cards.isEmpty {
                    Text("目前沒有選擇任何卡片，請返回並加入卡片")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack {
                        Text("您的最佳組合")
                            .font(.largeTitle)
                            .padding()

                        Image(systemName: "gift")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding()

                        Text("根據回饋百分比排序")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()

                        // 根據回饋百分比排序顯示卡片 / Display cards sorted by cashback percentage
                        List {
                            ForEach(
                                cards.sorted(by: {
                                    $0.cashbackPercentage
                                        > $1.cashbackPercentage
                                })
                            ) { card in
                                HStack {
                                    Image(card.imageName)
                                        .resizable()
                                        .frame(width: 100, height: 60)
                                        .cornerRadius(8)

                                    VStack(alignment: .leading) {
                                        Text(card.bankName)
                                            .font(.headline)
                                        Text(card.cardType)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(
                                            "回饋: \(card.cashbackPercentage, specifier: "%.2f")%"
                                        )
                                        .font(.body)
                                        .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("最佳組合")
    }

    // 模擬進度條動畫 / Simulate progress bar animation
    private func startLoadingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 100 {
                progress += 2  // 控制進度條增長的速度 / Control the speed of progress bar growth
            } else {
                timer.invalidate()  // 進度條達到100%後停止 / Stop when progress bar reaches 100%
                isLoading = false  // 完成後切換為顯示卡片頁面 / Switch to card display page after completion
            }
        }
    }
}
