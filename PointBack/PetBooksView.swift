//
//  PetBooksView.swift
//  PointBack
//
//  Created by Kent_Huang on 2024/11/19.
//

import SwiftUI

struct PetBooksView: View {
    @State private var showPurchasePopup = false
    @State private var purchasedPets: Set<Int> = []

    let petImages = [
        "Bichon1", "Ragdoll4", "pet3", "pet4", "pet5", "pet6", "pet7", "pet8",
        "pet9",
    ]

    var body: some View {
        VStack {
            Text("你的寵物圖鑑")
                .font(.largeTitle)
                .padding()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20)
            {
                ForEach(0..<petImages.count, id: \.self) { index in
                    ZStack {
                        if purchasedPets.contains(index) {
                            Image(petImages[index])
                                .resizable()
                                .scaledToFit()
                        } else {
                            Color.gray
                                .overlay(
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                )
                        }
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                }
            }
            .padding()

            Button("購買") {
                showPurchasePopup.toggle()
            }
            .padding()
            .sheet(isPresented: $showPurchasePopup) {
                PurchaseOptionsView(purchasedPets: $purchasedPets)
            }

            Spacer()
        }
        .navigationTitle("寵物圖鑑")
    }
}

struct PurchaseOptionsView: View {
    @Binding var purchasedPets: Set<Int>
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Text("選擇您的方案")
                    .font(.title)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                    .frame(maxWidth: .infinity, alignment: .center)

                Section(header: Text("方案 A")) {
                    HStack {
                        Text("每週解鎖一隻點數寵物")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("$499")
                                .font(.subheadline)
                                .strikethrough(true, color: .gray)
                                .foregroundColor(.gray)

                            HStack {
                                Text("$149")
                                    .font(.subheadline)
                                    .foregroundColor(.green)

                                Text("70% OFF")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.leading, 5)
                            }
                        }
                    }

                    Button("購買方案 A") {
                        purchasedPets.insert(0)
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                Section(header: Text("方案 B")) {
                    HStack {
                        Text("每週解鎖兩隻點數寵物")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("$998")
                                .font(.subheadline)
                                .strikethrough(true, color: .gray)
                                .foregroundColor(.gray)

                            HStack {
                                Text("$299")
                                    .font(.subheadline)
                                    .foregroundColor(.green)

                                Text("70% OFF")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .padding(.leading, 5)
                            }
                        }
                    }

                    Button("購買方案 B") {
                        purchasedPets.insert(0)
                        purchasedPets.insert(1)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("選擇方案", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PetBooksView()
}
