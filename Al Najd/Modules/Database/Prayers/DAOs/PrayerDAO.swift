//
//  File.swift
//
//
//  Created by Ahmed Ramy on 28/03/2023.
//


import Foundation
import GRDB


// MARK: - ANPrayerDAO

public struct PrayerDAO {
    public var id: Int64?
    public var name: String
    public var isDone: Bool
    public var raqaat: Int
    public var dayId: Int64
    public var reward: String
}

extension PrayerDAO {
    func toDomainModel(_ db: Database) throws -> Prayer {
        toDomainModel(
            sunnah: try sunnah.fetchAll(db).map { $0.toDomainModel() },
            azkar: try azkar.fetchAll(db).map { $0.toDomainModel() })
    }
    
    func toDomainModel(sunnah: [Sunnah], azkar: [Zekr]) -> Prayer {
        .init(
            id: id!,
            name: name,
            raqaat: raqaat,
            sunnah: .init(uniqueElements: sunnah),
            afterAzkar: .init(uniqueElements: azkar),
            isDone: isDone,
            reward: reward,
            prePrayer: .init(uniqueElements: [])
        )
    }
}

// MARK: Codable, FetchableRecord, MutablePersistableRecord

extension PrayerDAO: Codable, FetchableRecord, MutablePersistableRecord { }

// MARK: TableRecord, EncodableRecord

extension PrayerDAO: TableRecord, EncodableRecord {
    static let day = belongsTo(DayDAO.self)
    static let sunnah = hasMany(SunnahDAO.self)
    static let azkar = hasMany(AzkarDAO.self)

    public static var databaseTableName = "prayers"

    enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let isDone = Column(CodingKeys.isDone)
        static let raqaat = Column(CodingKeys.raqaat)
        static let dayId = Column(CodingKeys.dayId)
    }

    var day: QueryInterfaceRequest<DayDAO> {
        request(for: Self.day)
    }

    var doneFaraaid: QueryInterfaceRequest<PrayerDAO> {
        PrayerDAO.filter(Columns.isDone == true)
    }

    var sunnah: QueryInterfaceRequest<SunnahDAO> {
        request(for: Self.sunnah)
    }

    var doneSunnah: QueryInterfaceRequest<SunnahDAO> {
        sunnah.filter(SunnahDAO.Columns.isDone == true)
    }

    var azkar: QueryInterfaceRequest<AzkarDAO> {
        request(for: Self.azkar)
    }
}
