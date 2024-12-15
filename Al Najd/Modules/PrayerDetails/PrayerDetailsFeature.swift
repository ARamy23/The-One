//
//  File.swift
//
//
//  Created by Ahmed Ramy on 14/08/2022.
//


import ComposableArchitecture

import Foundation



// MARK: - PrayerDetails

public struct PrayerDetails: Reducer {
    @Dependency(\.haptic)
    private var haptic

    @Dependency(\.prayersService)
    private var prayersDB

    public init() { }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onDoingPrayer:
            state.prayer.isDone = true
            prayersDB.save(prayer: state.prayer)
        case .onDoingSunnah(let sunnah):
            state.prayer.sunnah[id: sunnah.id]?.isDone = true
            prayersDB.save(sunnah: state.prayer.sunnah[id: sunnah.id])
        case .onDoingZekr(let zekr):
            let currentCount = state.prayer.afterAzkar[id: zekr.id]?.currentCount ?? 0
            state.prayer.afterAzkar[id: zekr.id]?.currentCount = max(0, currentCount - 1)
            prayersDB.save(zekr: state.prayer.afterAzkar[id: zekr.id])
        case .onFinishingZekr(let zekr):
            state.prayer.afterAzkar[id: zekr.id]?.currentCount = 0
            prayersDB.save(zekr: state.prayer.afterAzkar[id: zekr.id])
        default:
            break
        }
        haptic.send(.success)

        return .none
    }
}

// MARK: PrayerDetails.State

public extension PrayerDetails {
    struct State: Identifiable, Equatable {
        public var id: Prayer.ID { prayer.id }
        
        public var prayer: Prayer
        public var date: String

        public init(
            prayer: Prayer,
            date: Date) {
            self.prayer = prayer
            self.date = date.format(with: [.dayOfMonth, .monthFull, .yearFull]) ?? ""
        }
    }
}

// MARK: PrayerDetails.Action

public extension PrayerDetails {
    enum Action: Equatable {
        case onDoingPrayer
        case onDoingSunnah(Sunnah)
        case onDoingZekr(Zekr)
        case onFinishingZekr(Zekr)

        case dismiss
    }
}
