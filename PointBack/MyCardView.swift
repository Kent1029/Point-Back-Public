//
//  MyCardView.swift
//  PointBack
//
//  Created by Kent_Huang on 2024/11/19.
//

import SwiftUI

struct MyCardView: View {
    @State private var showingAddCardForm = false  // 控制表單顯示 // Control form display
    @Binding var cards: [Card]  // 綁定用戶的卡片清單 // Bind user's card list

    var body: some View {
        VStack {
            // 已新增的卡片列表 // List of added cards
            if cards.isEmpty {
                Text("目前沒有卡片，請點擊下方新增按鈕") // No cards yet, please click the add button below
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(cards) { card in
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
                            }
                        }
                    }
                    .onDelete(perform: deleteCard)  // 滑動刪除功能 // Swipe to delete functionality
                }
            }

            Spacer()

            // 新增按鈕 // Add button
            Button(action: {
                showingAddCardForm = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                    Text("新增卡片") // Add card
                        .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("我的卡片") // My cards
        .sheet(isPresented: $showingAddCardForm) {
            AddCardForm(cards: $cards)
        }
    }

    private func deleteCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
    }
}

// 卡片模型 // Card model
struct Card: Identifiable, Hashable {
    let id = UUID()
    let bankName: String
    let cardType: String
    let imageName: String
    let cashbackPercentage: Double  // 加入回饋百分比 // Add cashback percentage
}

// 銀行與卡片選項數據 // Bank and card options data
struct BankData {
    static let banks = [
        "中國信託 CTB Bank": [
            Card(bankName: "中國信託 CTB Bank", cardType: "LINE Pay VISA", imageName: "CTB_LINEPay_VISA", cashbackPercentage: 5),
            Card(bankName: "中國信託 CTB Bank", cardType: "ALL ME卡", imageName: "CTB_ALLME_Master", cashbackPercentage: 3),
        ],
        "國泰世華 Cathay Bank": [
            Card(bankName: "國泰世華 Cathay Bank", cardType: "CUBE VISA", imageName: "Cathay_Cube_VISA", cashbackPercentage: 4),
            Card(bankName: "國泰世華 Cathay Bank", cardType: "CUBE MasterCard", imageName: "Cathay_Cube_Master", cashbackPercentage: 6),
            Card(bankName: "國泰世華 Cathay Bank", cardType: "CUBE JCB", imageName: "Cathay_Cube_JCB", cashbackPercentage: 3.5),
        ],
        "永豐銀行 SinoPac Bank": [
            Card(bankName: "永豐銀行 SinoPac Bank", cardType: "DAWHO VISA 大戶卡", imageName: "SinoPac_DAWHO_VISA", cashbackPercentage: 2.5),
            Card(bankName: "永豐銀行 SinoPac Bank", cardType: "DAWAY VISA 大威卡", imageName: "SinoPac_DAWAY_VISA", cashbackPercentage: 4),
        ],
        "台新銀行 TaiShin Bank": [
            Card(bankName: "台新銀行 TaiShin Bank", cardType: "太陽/玫瑰 MasterCard", imageName: "TaiShin_SunRose_Master", cashbackPercentage: 3),
            Card(bankName: "台新銀行 TaiShin Bank", cardType: "FLY GO MasterCard", imageName: "TaiShin_FlyGo_Master", cashbackPercentage: 4.5),
        ],
    ]
}

// 新增卡片表單視圖 // Add card form view
struct AddCardForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var cards: [Card]

    @State private var selectedBank: String = "選擇銀行" // Select bank
    @State private var selectedCard: Card?
    @State private var availableCards: [Card] = []

    var body: some View {
        NavigationView {
            Form {
                // 選擇銀行 // Select bank
                Section(header: Text("選擇銀行")) { // Select bank
                    Picker("銀行名稱", selection: $selectedBank) { // Bank name
                        ForEach(BankData.banks.keys.sorted(), id: \.self) {
                            bank in
                            Text(bank)
                        }
                    }
                    .onChange(of: selectedBank) {
                        if let cards = BankData.banks[selectedBank] {
                            availableCards = cards
                        }
                        selectedCard = nil  // 重置選擇 // Reset selection
                    }
                }

                // 選擇卡片 // Select card
                if !availableCards.isEmpty {
                    Section(header: Text("選擇卡片")) { // Select card
                        Picker("卡片類型", selection: $selectedCard) { // Card type
                            ForEach(availableCards, id: \.id) { card in
                                Text(card.cardType)
                                    .tag(card as Card?)
                            }
                        }
                    }
                }
            }
            .navigationTitle("新增卡片") // Add card
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") { // Cancel
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") { // Save
                        if let card = selectedCard {
                            cards.append(card)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(selectedBank == "選擇銀行" || selectedCard == nil)
                }
            }
        }
    }
}
