//
//  ModelContext.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/07.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import Foundation
import SwiftData

/*
 参考URL
 https://zenn.dev/yumemi_inc/articles/2a929c839b2000#%E6%9C%AC%E7%A8%BF%E7%94%A8%E3%81%AE%E4%BE%BF%E5%88%A9%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89

 */

extension ModelContext {
    static let shared: ModelContext = {
        do {
            return try ModelContext(for: SalesRecord.self)
        } catch {
            fatalError("ModelContext initialization failed: \(error)")
        }
    }()

    private convenience init(
        for types: any PersistentModel.Type...
    ) throws {
        let schema = Schema(types)
        let modelConfiguration = ModelConfiguration(schema: schema)

        let modelContainer = try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )

        self.init(modelContainer)
    }

    func fetch<Model>(
        for type: Model.Type
    ) throws -> [Model] where Model: PersistentModel {
        try fetch(.init())
    }

    func fetchCount<Model>(
        for type: Model.Type
    ) throws -> Int where Model: PersistentModel {
        try fetchCount(FetchDescriptor<Model>())
    }

    func fetch<Model>(
        for type: Model.Type,
        id persistentModelID: PersistentIdentifier
    ) throws -> Model? where Model: PersistentModel {
        var fetchDescriptor = FetchDescriptor<Model>(
            predicate: #Predicate {
                $0.persistentModelID == persistentModelID
            }
        )
        fetchDescriptor.fetchLimit = 1

        return try fetch(fetchDescriptor).first
    }

    func fetch<Model>(
        for type: Model.Type,
        offset: Int? = nil,
        limit: Int? = nil,
        sortBy sortDescriptors: [SortDescriptor<Model>]
    ) throws -> [Model] where Model: PersistentModel {
        var fetchDescriptor = FetchDescriptor<Model>(sortBy: sortDescriptors)
        fetchDescriptor.fetchOffset = offset
        fetchDescriptor.fetchLimit = limit

        return try fetch(fetchDescriptor)
    }
}

