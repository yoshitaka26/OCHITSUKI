//
//  AddView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import RealmSwift
import SwiftData

struct AddView: View {
    let context: ModelContext? = ModelContext.shared
    @FocusState private var focused: Bool
    @State private var title: String = ""
    @State private var actualRevenue: String = ""
    @State private var grossProfit: String = ""
    @State private var orderDate: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("内容") {
                    TextField("入力してください", text: $title)
                        .font(.subheadline)
                        .focused($focused)
                        .keyboardType(.twitter)
                }

                HStack(spacing: 20) {
                    Text("受注")
                    TextField("数字を入力してください", text: $actualRevenue)
                        .focused($focused)
                        .keyboardType(.numberPad)
                }
                HStack(spacing: 20) {
                    Text("粗利")
                    TextField("数字を入力してください", text: $grossProfit)
                        .focused($focused)
                        .keyboardType(.numberPad)
                }

                Section("受注日") {
                    DatePicker("", selection: $orderDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 10)
                }
            }
            .font(.subheadline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        let salesModel = SalesRecord(
                            title: title,
                            actualRevenue: Double(actualRevenue) ?? 0,
                            grossProfit: Double(grossProfit) ?? 0,
                            orderDate: orderDate
                        )
                        context?.insert(salesModel)
                        reset()
                    } label: {
                        Text("追加")
                    }
                    .disabled(addButtonDisabled)
                }
            }
        }
    }

    var addButtonDisabled: Bool {
        guard Double(actualRevenue) != nil, Double(grossProfit) != nil else { return true }
        return title.isEmpty
    }

    func reset() {
        title = ""
        actualRevenue = ""
        grossProfit = ""
        focused = false
    }
}

#Preview {
    AddView()
}
