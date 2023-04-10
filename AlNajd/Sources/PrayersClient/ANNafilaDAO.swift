//
//  File.swift
//  
//
//  Created by Ahmed Ramy on 28/03/2023.
//

import Entities
import Foundation
import GRDB
import Utils

public struct ANNafilaDAO {
    public var id: Int64?
    public var name: String
    /// -1 means its open
    public var raqaatCount: Int
    public var raqaat: RaqaatType
    public var reward: String
    public var isDone: Bool
    public var dayId: Int64
}

public extension ANNafilaDAO {
    enum RaqaatType: Int, Codable, DatabaseValueConvertible {
        case defined
        case atLeast
        case open
    }
}

extension ANNafilaDAO {
    func toDomainModel() -> ANNafila {
        .init(
            id: id!,
            name: name,
            raqaat: raqaatToDomainModel(),
            reward: reward,
            isDone: isDone
        )
    }
}

extension ANNafilaDAO {
    func raqaatToDomainModel() -> ANNafila.Raqaat {
        switch raqaat {
        case .open:
            return .open
        case .atLeast:
            return .atLeast(raqaatCount)
        case .defined:
            return .defined(raqaatCount)
        }
    }
}

extension ANNafilaDAO: Codable, FetchableRecord, MutablePersistableRecord { }

extension ANNafilaDAO: TableRecord, EncodableRecord {
    static let day = belongsTo(ANDayDAO.self)

    public static var databaseTableName: String = "nafilas"

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let raqaatCount = Column(CodingKeys.raqaatCount)
        static let raqaat = Column(CodingKeys.raqaat)
        static let reward = Column(CodingKeys.reward)
        static let isDone = Column(CodingKeys.isDone)
    }

    var day: QueryInterfaceRequest<ANDayDAO> {
        request(for: Self.day)
    }
}

// MARK: - Seedings
extension ANNafilaDAO {
    static let subh: (Int64) -> ANNafilaDAO = {
        .init(name: "subh", raqaatCount: 2, raqaat: .defined, reward: "nafila_subh", isDone: false, dayId: $0)
    }

    static let duha: (Int64) -> ANNafilaDAO = {
        .init(name: "duha", raqaatCount: 4, raqaat: .atLeast, reward: "nafila_duha", isDone: false, dayId: $0)
    }

    static let shafaa: (Int64) -> ANNafilaDAO = {
        .init(name: "shaf3", raqaatCount: 2, raqaat: .defined, reward: "nafila_shaf3", isDone: false, dayId: $0)
    }

    static let watr: (Int64) -> ANNafilaDAO = {
        .init(name: "watr", raqaatCount: 1, raqaat: .defined, reward: "nafila_watr", isDone: false, dayId: $0)
    }

    static let qeyam: (Int64) -> ANNafilaDAO = {
        .init(name: "qeyam", raqaatCount: -1, raqaat: .open, reward: "nafila_qeyam", isDone: false, dayId: $0)
    }
}
