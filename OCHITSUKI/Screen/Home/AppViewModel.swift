//
//  AppViewModel.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import SwiftData

final class AppViewModel: ObservableObject {
    @AppStorage("isRealmMigrated") var isRealmMigrated: Bool = false
    @AppStorage("isReviewRequested") var isReviewRequested: Bool = false
    @AppStorage("reviewRequestedDate") var reviewRequestedDate: Double?
}
