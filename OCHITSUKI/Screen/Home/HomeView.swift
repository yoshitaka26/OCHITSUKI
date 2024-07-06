//
//  HomeView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import RealmSwift
import SwiftData

struct HomeView: View {
    @StateObject var appViewModel = AppViewModel()
    @State var listViewModel = ListViewModel()
    @State var selectedTab: Tab = .add

    enum Tab {
        case add
        case list
        case calendar
        case setting
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            AddView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("追加")
                }
                .tag(Tab.add)
            ListView(viewModel: $listViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("リスト")
                }
                .tag(Tab.list)
            CalendarView(listViewModel: $listViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("カレンダー")
                }
                .tag(Tab.calendar)
            SettingView(appViewModel: appViewModel)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("カレンダー")
                }
                .tag(Tab.setting)
        }
        .tint(Color.accentColor)
        .onAppear {
            if !appViewModel.isRealmMigrated {
                // Realmから移行
                let realm = try! Realm()
                let tasks = realm.objects(OchitsukiDataModel.self)
                let realmData = tasks.sorted(byKeyPath: "orderDate", ascending: true)
                let arrayData = Array(realmData)

                if !arrayData.isEmpty {
                    let context: ModelContext? = ModelContext.shared
                    for data in arrayData {
                        let actualRevenue = Double(data.orderAmountUnit ?? "") ?? 0
                        let grossProfit = Double(data.grossProfitUnit ?? "") ?? 0
                        let salesModel = SalesRecord(
                            title: data.title,
                            actualRevenue: actualRevenue,
                            grossProfit: grossProfit,
                            orderDate: Date(timeIntervalSince1970: data.orderDate)
                        )
                        context?.insert(salesModel)
                    }

                    try! realm.write {
                        realm.delete(realm.objects(OchitsukiDataModel.self))
                    }
                }
                appViewModel.isRealmMigrated = true
            }
        }
    }
}

#Preview {
    HomeView()
}
