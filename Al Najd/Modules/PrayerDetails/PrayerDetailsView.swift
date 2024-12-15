//
//  PrayerDetailsView.swift
//
//
//  Created by Ahmed Ramy on 10/08/2022.
//

import ComposableArchitecture
import Inject
import SwiftUI


// MARK: - PrayerDetailsView

public struct PrayerDetailsView: View {
    @ObserveInjection var inject
    let store: StoreOf<PrayerDetails>
    @ObservedObject var viewStore: ViewStoreOf<PrayerDetails>
    
    @State var showSheet: Bool = true {
        didSet {
            if showSheet == false {
                UIView.animate(withDuration: 0.6) {
                    showSheet = true
                }
            }
        }
    }

    public init(store: StoreOf<PrayerDetails>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Label(viewStore.date, systemImage: "calendar")
                        .foregroundColor(.mono.offwhite)
                        .scaledFont(.pFootnote)
                        .multilineTextAlignment(.center)

                    Spacer()

                    Button {
                        viewStore.send(.dismiss, animation: .default)
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(.mono.offwhite)
                            .scaledFont(.pFootnote)
                            .frame(width: 12, height: 12)
                            .padding(.p8)
                            .background(
                                Circle()
                                    .foregroundColor(.mono.offwhite.opacity(0.25)))
                    }
                }.padding()

                Text(viewStore.prayer.title)
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(locale: .arabic, .pBody)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }.background(
            viewStore.prayer.image
                .swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .overlay(
                    Color.mono.offblack.opacity(0.5))
        )
        .sheet(isPresented: $showSheet, content: {
            TasksView(viewStore: viewStore)
                .shadow(radius: 100)
                .presentationBackground(Color.clear)
                .presentationCornerRadius(.r24 + .r8)
                .presentationDragIndicator(.automatic)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
                .presentationDetents(
                    [
                        .height(100),
                        .fraction(0.25),
                        .fraction(0.5),
                        .fraction(0.75),
                    ]
                )
        })
        .enableInjection()
    }
}

extension Double {
    func asPercentage() -> CGFloat {
        getScreenSize().height * self
    }
}

extension CGFloat {
    func asPercentage() -> CGFloat {
        getScreenSize().height * self
    }
}

// MARK: - TasksView

struct TasksView: View {
    let viewStore: ViewStoreOf<PrayerDetails>

    @State var tab = 0
    @ObserveInjection var inject

    var body: some View {
        ZStack {
            BlurView(.systemChromeMaterialDark)
                .cornerRadius(.r24 + .r8)

            VStack(alignment: .center) {
                TabView(selection: $tab) {
                    makeTasksList()
                    makeRewardsList()
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }
            .padding(.top)
            .padding(.bottom, getSafeArea().bottom)
        }
        .ignoresSafeArea()
        .enableInjection()
    }

    @ViewBuilder
    func makeTasksList() -> some View {
        VStack {
            SubtaskView(viewStore.prayer) {
                viewStore.send(.onDoingPrayer, animation: .default)
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                Text("نواية ما قبل الصلاة")
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(.pFootnote, .bold)
                    .multilineTextAlignment(.center)
                    .if(viewStore.prayer.prePrayer.isEmpty, transform: { _ in EmptyView() })
                
                ForEach(viewStore.prayer.prePrayer) { task in
                    RepeatableSubtaskView(task, onDoing: {})
                }
                
                Text(L10n.sunnah)
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(.pFootnote, .bold)
                    .multilineTextAlignment(.center)
                    .if(viewStore.prayer.sunnah.isEmpty, transform: { _ in EmptyView() })
                ForEach(viewStore.prayer.sunnah) { sunnah in
                    SubtaskView(sunnah) {
                        viewStore.send(.onDoingSunnah(sunnah), animation: .default)
                    }.frame(maxWidth: .infinity)
                }
                Text(L10n.azkar)
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(.pFootnote, .bold)
                    .multilineTextAlignment(.center)
                ForEach(viewStore.prayer.afterAzkar) { zekr in
                    RepeatableSubtaskView(zekr) {
                        viewStore.send(.onDoingZekr(zekr), animation: .default)
                    }.frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    func makeRewardsList() -> some View {
        VStack {
            if viewStore.prayer.isDone {
                Text(L10n.alfard)
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(.pFootnote, .bold)
                    .multilineTextAlignment(.center)
                RewardView(viewStore.prayer)
                if viewStore.prayer.sunnah.filter({ $0.isDone }).count > 0 {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(L10n.sunnah)
                            .foregroundColor(.mono.offwhite)
                            .scaledFont(.pFootnote, .bold)
                            .multilineTextAlignment(.center)
                            .if(
                                viewStore.prayer.sunnah.isEmpty, transform: { _ in EmptyView() })
                        ForEach(viewStore.prayer.sunnah) { sunnah in
                            RewardView(sunnah)
                                .frame(maxWidth: .infinity)
                        }
                    }
                } else {
                    Spacer()
                }
            } else {
                Text("🤷‍♂️")
                    .scaledFont(.pLargeTitle, .bold)
                    .multilineTextAlignment(.center)
                Text(L10n.fardNotDoneYet)
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(.pTitle1, .bold)
                    .multilineTextAlignment(.center)
            }
        }.padding(.bottom, getSafeArea().bottom * 5)
    }
}

// MARK: - RewardView

struct RewardView: View {
    var title: String
    var subtitle: String

    init(_ prayer: Prayer) {
        title = prayer.title
        subtitle = prayer.reward.localized
    }

    init(_ sunnah: Sunnah) {
        title = sunnah.title
        subtitle = sunnah.reward.localized
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.mono.offwhite)
                    .scaledFont(.pBody)
                    .multilineTextAlignment(.leading)
                Text(subtitle)
                    .foregroundColor(.success.light)
                    .scaledFont(.pBody, .bold)
                    .multilineTextAlignment(.leading)
            }

            Spacer()
        }
        .padding(.horizontal, .p16)
        .padding(.bottom, .p8)
    }
}
