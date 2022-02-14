//
//  RewardsFeature.swift
//  Al Najd
//
//  Created by Ahmed Ramy on 25/01/2022.
//

import Foundation
import ComposableArchitecture
import Business
import Entities
import Common

struct RewardsState: Equatable {
  var activeDate: Date = .now
  var prayers: [DeedCategory: [Deed]] = [
    .fard: [],
    .sunnah: [],
    .nafila: []
  ]
  
  var azkar: [AzkarCategory: [RepeatableDeed]] = [
    .sabah: [],
    .masaa: []
  ]
}

enum RewardsAction: Equatable {
  case onAppear
  case onDoingDeed(Deed)
  case onUndoingDeed(Deed)
  case onDoingRepeatableDeed(RepeatableDeed)
  case onUndoingRepeatableDeed(RepeatableDeed)
  case onQuickFinishRepeatableDeed(RepeatableDeed)
}

struct RewardsEnvironment {}

let rewardsReducer = Reducer<
  RewardsState,
  RewardsAction,
  CoreEnvironment<RewardsEnvironment>
> { state, action, env in
  switch action {
  case .onAppear:
    state.prayers = [
      .fard: env.getPrayersRewardsFromCache(state.activeDate, .fard) ?? [],
      .sunnah: env.getPrayersRewardsFromCache(state.activeDate, .sunnah) ?? [],
      .nafila: env.getPrayersRewardsFromCache(state.activeDate, .nafila) ?? []
    ]
    
    state.azkar = [
      .sabah: env.getAzkarRewardsFromCache(state.activeDate, .sabah) ?? [],
      .masaa: env.getAzkarRewardsFromCache(state.activeDate, .masaa) ?? []
    ]
  case let .onDoingDeed(deed):
    state.prayers[deed.category]?.findAndReplaceElseAppend(with: deed)
  case let .onUndoingDeed(deed):
    state.prayers[deed.category]?.findAndReplaceElseAppend(with: deed)
  case let .onDoingRepeatableDeed(repeatableDeed: deed):
    state.azkar[deed.category]?.findAndReplaceElseAppend(with: deed)
  case let .onUndoingRepeatableDeed(repeatableDeed: deed):
    state.azkar[deed.category]?.findAndReplaceElseAppend(with: deed)
  case let .onQuickFinishRepeatableDeed(repeatableDeed: deed):
    state.azkar[deed.category]?.findAndReplaceElseAppend(with: deed)
  }
  
  return .none
}

fileprivate func cachePrayerRewards(_ state: RewardsState, _ env: CoreEnvironment<RootEnvironment>) {
  state.prayers.forEach {
    env.cache().save($0.value.filter { $0.isDone }, for: .prayersRewards(state.activeDate, $0.key))
  }
}

fileprivate func cacheAzkarRewards(_ state: RewardsState, _ env: CoreEnvironment<RootEnvironment>) {
  state.azkar.forEach {
    env.cache().save($0.value.filter { $0.isDone }, for: .azkarRewards(state.activeDate, $0.key))
  }
}

extension Store where State == RewardsState, Action == RewardsAction {
  static let main: Store<State, Action>  = .init(
    initialState: .init(),
    reducer: rewardsReducer,
    environment: .live(RewardsEnvironment())
  )
  
  static let dev: (
    _ prayers: [Deed],
    _ azkar: [RepeatableDeed]
  ) -> (Store<RewardsState, RewardsAction>) = { prayers, azkar in
    let env = CoreEnvironment.live(RewardsEnvironment())
    env.cache().save(
      prayers,
      for: .prayers(
        .now,
        .fard
      )
    )
    
    env.cache().save(
      azkar,
      for: .azkar(
        .now,
        .sabah
      )
    )
    
    return .init(
      initialState: .init(),
      reducer: rewardsReducer,
      environment: env
    )
  }
}
