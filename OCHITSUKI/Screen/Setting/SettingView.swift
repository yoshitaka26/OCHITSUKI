//
//  SettingView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import StoreKit

struct SettingView: View {
    let appViewModel: AppViewModel

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(header: Text("お問い合わせ")) {
                    HStack {
                        Text("アプリレビュー")
                        Spacer()
                        Button(action: {
                            guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
                            // 最後にリクエストした日から1ヶ月たっていればレビューをリクエスト
                            if appViewModel.isReviewRequested {
                                if let date = appViewModel.reviewRequestedDate, Date(timeIntervalSince1970: date).addingTimeInterval(60 * 60 * 24 * 30) < Date() {
                                    SKStoreReviewController.requestReview(in: scene)
                                    appViewModel.reviewRequestedDate = Date().timeIntervalSince1970
                                } else {
                                    let appId = "1535364825"
                                    guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review")
                                    else { return }

                                    if UIApplication.shared.canOpenURL(writeReviewURL) {
                                        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                                    }
                                }
                            } else {
                                SKStoreReviewController.requestReview(in: scene)
                                appViewModel.isReviewRequested = true
                                appViewModel.reviewRequestedDate = Date().timeIntervalSince1970
                            }
                        }, label: {
                            Text("協力する")
                        })
                        .buttonStyle(BorderedButtonStyle())
                    }
                    HStack {
                        Text("機能追加")
                        Spacer()
                        Button(action: {
                            guard let writeReviewURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdQ4e-iZ12GUT8OGwETTi0qZpiZ89QH5lYseY6pkUfvMyIppg/viewform?usp=sf_link")
                            else { return }

                            if UIApplication.shared.canOpenURL(writeReviewURL) {
                                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                            }
                        }, label: {
                            Text("要望する")
                        })
                        .buttonStyle(BorderedButtonStyle())
                    }
                }

                Section(header: Text("アプリ情報")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                    }
                }
            }
            .font(.subheadline)
            .listStyle(.insetGrouped)

            AdBannerView()
                .frame(height: 60)
        }
        .navigationBarTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingView(appViewModel: AppViewModel())
}
