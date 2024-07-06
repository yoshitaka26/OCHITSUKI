//
//  ListView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ListView: View {
    @Binding var viewModel: ListViewModel

    var body: some View {
        VStack(spacing: 0) {
            SalesRecordList(viewModel: $viewModel)
            AdBannerView()
                .frame(height: 60)
        }
        .onAppear {
            viewModel.fetch()
        }
        .sheet(item: $viewModel.editSalesRecord) { item in
            EditView(
                viewModel: $viewModel,
                title: item.title,
                actualRevenue: String(Int(item.actualRevenue)),
                grossProfit: String(Int(item.grossProfit)),
                orderDate: item.orderDate,
                salesRecord: item
            )
        }
    }

    private struct SalesRecordList: View {
        @Binding var viewModel: ListViewModel

        var body: some View {
            List {
                ForEach(viewModel.dateOrder, id: \.self) { date in
                    Section(header: Text(formatDateForSection(date))) {
                        ForEach(viewModel.salesRecordsForList[date] ?? [], id: \.self) { salesRecord in
                            VStack {
                                HStack {
                                    Text(formatDateForItem(salesRecord.orderDate))
                                        .font(.subheadline)
                                        .padding(4)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(4)

                                    Spacer()

                                    Text(salesRecord.title)
                                        .font(.headline)
                                }
                                .font(.subheadline)

                                HStack {
                                    Text("受注")
                                        .frame(width: 80)
                                    Spacer()
                                    Text("¥\(String(Int(salesRecord.actualRevenue)))")
                                        .fontWeight(.semibold)
                                }
                                .font(.body)

                                HStack {
                                    Text("粗利")
                                        .frame(width: 80)
                                    Spacer()
                                    Text("¥\(String(Int(salesRecord.grossProfit)))")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                                .font(.body)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.delete(element: salesRecord)
                                } label: {
                                    Text("削除")
                                        .foregroundStyle(Color.red)
                                }
                                .tint(Color.red)
                                Button {
                                    viewModel.editSalesRecord = salesRecord
                                } label: {
                                    Text("編集")
                                }
                                .tint(Color.gray.opacity(0.5))
                                Button {
                                    viewModel.duplicate(element: salesRecord)
                                } label: {
                                    Text("複製")
                                }
                                .tint(Color.gray.opacity(0.5))
                            }
                        }
                    }
                }
            }
            .listStyle(.grouped)
        }

        private func formatDateForSection(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月"
            return formatter.string(from: date)
        }

        private func formatDateForItem(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "M月d日"
            return formatter.string(from: date)
        }
    }

    private struct EditView: View {
        @Binding var viewModel: ListViewModel
        @State var title: String
        @State var actualRevenue: String
        @State var grossProfit: String
        @State var orderDate: Date
        @FocusState private var focused: Bool

        let salesRecord: SalesRecord

        var body: some View {
            VStack {
                HStack {
                    Button {
                        viewModel.editSalesRecord = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    Spacer()
                    Button {
                        viewModel.updateSalesRecord(
                            salesRecord,
                            title: title,
                            actualRevenue: Double(actualRevenue) ?? 0,
                            grossProfit: Double(grossProfit) ?? 0,
                            orderDate: orderDate
                        )
                        viewModel.editSalesRecord = nil
                    } label: {
                        Text("更新")
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
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
            }
        }
    }
}

#Preview {
    ListView(viewModel: .constant(ListViewModel()))
}
