//
//  UserDefaultsStorage.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 24/04/2021.
//

import Entity
import Foundation
import Utils

final class UserDefaultsStorage {
    let defaults: UserDefaults = .init(suiteName: "com.nerdor.theone.The-One") ?? .standard
}

extension UserDefaultsStorage: WritableStorage {
    func save<T>(value: T, for key: StorageKey) throws where T: Codable {
        defaults.set(value.encode(), forKey: key.key)
    }

    func remove<T>(type _: T.Type, for key: StorageKey) throws where T: Codable {
        defaults.removeObject(forKey: key.key)
    }
}

extension UserDefaultsStorage: ReadableStorage {
    func fetchValue<T>(for key: StorageKey) -> T? where T: Codable {
        defaults.data(forKey: key.key)?.decode(T.self)
    }
}
