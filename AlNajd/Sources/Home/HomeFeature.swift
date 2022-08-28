//
//  File.swift
//  
//
//  Created by Ahmed Ramy on 28/02/2022.
//

import ComposableArchitecture
import Entities
import PrayersClient
import Common
import TCACoordinators
import PrayerDetails

public struct HomeState: Equatable {
    public var prayers: IdentifiedArrayOf<ANPrayer>
    @BindableState var selectedPrayer: PrayerDetailsState?
    
    public init(prayers: IdentifiedArrayOf<ANPrayer> = []) {
        self.prayers = prayers
    }
}

public enum HomeAction: BindableAction, Equatable {
    case onAppear
    case prayerDetails(PrayerDetailsAction)
    case onSelecting(ANPrayer)
    case binding(BindingAction<HomeState>)
}

public struct HomeEnvironment { public init() { } }

public let homeReducer = Reducer<
    HomeState,
    HomeAction,
    CoreEnvironment<HomeEnvironment>
>.combine(
    prayerDetailsReducer
        .optional()
        .pullback(
            state: \HomeState.selectedPrayer,
            action: /HomeAction.prayerDetails,
            environment: { _ in .live(.init()) }),
    .init { state, action, env in
        switch action {
        case .onAppear:
            if state.prayers.isEmpty {
                state.prayers = .init(uniqueElements: env.prayersClient.prayers())
            }
        case let .onSelecting(prayer):
            state.selectedPrayer = .init(prayer: prayer)
        case .prayerDetails(.dismiss):
            guard let selectedState = state.selectedPrayer else { return .none }
            state.prayers[id: selectedState.prayer.id] = selectedState.prayer
            state.selectedPrayer = nil
        case .prayerDetails, .binding:
            break
        }
        return .none
    }
).binding()
