//
//  NearbyStoresView.swift
//  PointBack
//
//  Created by Kent_Huang on 2024/11/19.
//
import SwiftUI
import MapKit

struct NearbyStoresView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 25.016912884972854, longitude: 121.53384352429103),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    // 模擬的店家位置 / Simulated store locations
    let stores = [
        Store(
            name: "肯德基 KFC - 台大餐廳",
            feedback: "回饋：ApplePay 結帳送小杯可樂",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.01709358696348, longitude: 121.53314959340655)),
        Store(
            name: "麥當勞 - 公館餐廳",
            feedback: "回饋：麥當勞App 辣味雞塊買一送一",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.014248488107388, longitude: 121.53467128750488)),
        Store(
            name: "麥當勞 - 新生餐廳",
            feedback: "回饋：麥當勞App 超值全餐送頻果派",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.018256471325987, longitude: 121.53361292209405)),
        Store(
            name: "藍家割包",
            feedback: "回饋：信用卡綁定Apple Pay 2%回饋",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.015782216906384, longitude: 121.53266903372382)),
        Store(
            name: "德誼數位 Apple 台大門市",
            feedback: "回饋：AppleCare 9折優惠",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.01648789929942, longitude: 121.53247309352528)),
        Store(
            name: "麥當勞 - 台大餐廳",
            feedback: "回饋：麥當勞App 大蛋捲冰淇淋-$10元",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.01848394945812, longitude: 121.54194594336069)),
        Store(
            name: "小福樓",
            feedback: "回饋：瘋搶 $50折價券",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.01869717608361, longitude: 121.53743786621344)),
        Store(
            name: "全家便利商店 - 台大楓林店",
            feedback: "回饋：台大學生 9折優惠",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.019428116834774, longitude: 121.5393516941309)),
        Store(
            name: "女九餐廳",
            feedback: "回饋：自帶餐具 -$5元",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.019525133738863, longitude: 121.53952911328759)),
        Store(
            name: "活大餐廳",
            feedback: "回饋：台大學生 9折優惠",
            coordinate: CLLocationCoordinate2D(
                latitude: 25.018200699114907, longitude: 121.54046021507256)),
    ]
    
    @State private var selectedStore: Store? // 儲存當前選中的店家 / Store the currently selected store

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: stores) { store in
                MapAnnotation(coordinate: store.coordinate) {
                    Button(action: {
                        selectedStore = store // 更新選中的店家 / Update the selected store
                    }) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(store.name)
                                .font(.caption)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all) // 地圖全屏顯示 / Display the map in full screen
            
            VStack {
                Spacer() // 將按鈕放到底部 / Place the buttons at the bottom
                HStack {
                    Spacer() // 將按鈕放到右側 / Place the buttons on the right side
                    VStack(spacing: 10) {
                        Button(action: {
                            // 放大地圖 / Zoom in the map
                            region.span = MKCoordinateSpan(
                                latitudeDelta: region.span.latitudeDelta / 1.6,
                                longitudeDelta: region.span.longitudeDelta / 1.6
                            )
                        }) {
                            Image(systemName: "plus.magnifyingglass")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        
                        Button(action: {
                            // 縮小地圖 / Zoom out the map
                            region.span = MKCoordinateSpan(
                                latitudeDelta: region.span.latitudeDelta * 1.6,
                                longitudeDelta: region.span.longitudeDelta * 1.6
                            )
                        }) {
                            Image(systemName: "minus.magnifyingglass")
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                    }
                    .padding()
                }
            }
            
            // 彈窗顯示選中店家的回饋信息 / Popup to display feedback information of the selected store
            if let store = selectedStore {
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Text(store.name)
                            .font(.headline)
                        Text(store.feedback)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Button(action: {
                            selectedStore = nil // 關閉彈窗 / Close the popup
                        }) {
                            Text("關閉 / Close")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
        .navigationTitle("附近店家 / Nearby Stores")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 店家數據模型 / Store data model
struct Store: Identifiable {
    let id = UUID()
    let name: String
    let feedback: String // 添加回饋資訊 / Add feedback information
    let coordinate: CLLocationCoordinate2D
}
