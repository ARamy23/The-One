//
//  HomeView.swift
//
//
//  Created by Ahmed Ramy on 28/02/2022.
//

import ComposableArchitecture
import Inject
import SwiftUI

// MARK: - HomeView

public struct HomeView: View {
    @ObserveInjection var inject
    let store: StoreOf<Home>
    @ObservedObject var viewStore: ViewStoreOf<Home>

    public init(store: StoreOf<Home>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HeaderView(viewStore: viewStore)
                prayersSection(viewStore)
                daySelectorSection(viewStore)
                makeDuaaView(viewStore)
                nafilaSection(viewStore)
                hadeethSection()
            }
            .fullScreenCover(item: viewStore.$selectedPrayer) { _ in
                IfLetStore(store.scope(state: \.selectedPrayer, action: Home.Action.prayerDetails), then: {
                    PrayerDetailsView(store: $0)
                })
            }
            .fullScreenCover(item: viewStore.$selectedNafila) { _ in
                IfLetStore(store.scope(state: \.selectedNafila, action: Home.Action.nafilaDetails), then: {
                    NafilaDetailsView(store: $0)
                })
            }
            .background(Color.mono.background)
            .onAppear { viewStore.send(.onAppear) }
            .enableInjection()
        }.ignoresSafeArea(edges: .top)
    }
}

private extension HomeView {
    @ViewBuilder
    func nafilaSection(_ viewStore: ViewStoreOf<Home>) -> some View {
        NafilaSliderView(nafilas: viewStore.nafila) { viewStore.send(.onSelectingNafila($0)) }
            .padding(.bottom)
    }

    @ViewBuilder
    func hadeethSection() -> some View {
        VStack(alignment: .leading) {
            Text(L10n.ahadeeth)
                .foregroundColor(.mono.offblack)
                .scaledFont(locale: .arabic, .pFootnote, .bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, .p16)
            HadeethSliderView()
        }
        .padding()
    }



    @ViewBuilder
    func prayersSection(_ viewStore: ViewStoreOf<Home>) -> some View {
        PrayerSliderView(prayers: viewStore.prayers) { viewStore.send(
            .onSelecting($0), animation: .default) }
    }

    @ViewBuilder
    func daySelectorSection(_ viewStore: ViewStoreOf<Home>) -> some View {
        VStack {
            Text(L10n.pickDate)
                .foregroundColor(.mono.offblack)
                .scaledFont(locale: .arabic, .pFootnote, .bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, .p16)

            DatePicker("", selection: viewStore.$date, displayedComponents: .date)
                .datePickerStyle(.graphical)
        }.padding()
    }

    @ViewBuilder
    func makeDuaaView(_ viewStore: ViewStoreOf<Home>) -> some View {
        VStack {
            Text(L10n.todayDuaa)
                .foregroundColor(.mono.offblack)
                .scaledFont(locale: .arabic, .pFootnote, .bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, .p16)
            Text(viewStore.duaa)
                .scaledFont(.pBody)
                .multilineTextAlignment(.center)
                .foregroundColor(Asset.Colors.Apple.dark.swiftUIColor)
                .padding()
                .fillAndCenter()
                .background(
                    RoundedRectangle(cornerRadius: .r8)
                        .fill()
                        .foregroundColor(Asset.Colors.Apple.light.swiftUIColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: .r8)
                                .stroke(Asset.Colors.Apple.medium.swiftUIColor.gradient, lineWidth: 1))
                        .shadow(color: Asset.Colors.Apple.light.swiftUIColor, radius: 33, x: 0, y: 3))
        }.padding()
    }
}

// MARK: - HeaderView

struct HeaderView: View {
    let viewStore: ViewStoreOf<Home>

    var body: some View {
        VStack(spacing: .p4) {
            Text(L10n.hud88)
                .foregroundColor(.mono.offwhite)
                .scaledFont(locale: .arabic, .pFootnote, .bold)
                .multilineTextAlignment(.center)

            Label(viewStore.date.formatted(), systemImage: "calendar")
                .foregroundColor(.mono.offwhite)
                .scaledFont(locale: .arabic, .pFootnote)
                .multilineTextAlignment(.center)

            VStack(spacing: .p4) {
                HStack {
                    Text(L10n.todaySummary)
                        .foregroundColor(.mono.offwhite)
                        .scaledFont(.textXSmall)
                        .multilineTextAlignment(.center)

                    Spacer()

                    Text(
                        L10n
                            .todaySummaryNumeric(
                                viewStore.doneTodos.formatted(),
                                viewStore.todosCount.formatted(),
                                viewStore.percentage))
                        .foregroundColor(.mono.offwhite)
                        .scaledFont(.textXSmall)
                        .multilineTextAlignment(.center)
                }.padding(.horizontal, .p8)

                ProgressBar(
                    value: viewStore.$percentageValue)
                    .frame(height: 8)
                    .shadow(color: .shadowBlueperry, radius: 4, x: 0, y: 0)
                    .padding(.bottom, .p32)
                    .padding(.horizontal, .p8)
            }
            .padding([.top, .horizontal])
        }
        .frame(maxWidth: .infinity)
        .padding(.top, getSafeArea().top)
        .padding(.horizontal, .p8)
        .padding(.bottom, .p16)
        .background(
            ZStack {
                Color
                    .primaryBlackberry
                    .ignoresSafeArea()
                    .background(
                        Color.primaryBlackberry
                            .frame(height: 1000)
                            .offset(y: -500))
                    .offset(y: -100)

                Asset
                    .Background
                    .headerMini
                    .swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            })

        Spacer()
    }
}

// MARK: - ProgressBar

struct ProgressBar: View {
    @Binding var value: Float
    var color: Color = .mono.offwhite

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Group {
                    Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(color.opacity(0.75))

                    Rectangle()
                        .frame(width: min(CGFloat(value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .foregroundColor(color)

                }.cornerRadius(45.0)
            }
        }
    }
}

// MARK: - PrayerSliderView

struct PrayerSliderView: View {
    var prayers: IdentifiedArrayOf<Prayer>
    var onTap: (Prayer) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .p8) {
            Text(L10n.prayers)
                .foregroundColor(.mono.offblack)
                .scaledFont(locale: .arabic, .pFootnote, .bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .p16)
            ScrollViewRTL {
                HStack(spacing: .p32) {
                    ForEach(prayers) { prayer in
                        GeometryReader { geometry in
                            PrayerCardView(prayer: prayer)
                                .rotation3DEffect(
                                    .degrees(
                                        ((.p32 + geometry.frame(in: .local).width) / 2 - geometry.frame(in: .global).minX) /
                                            30.0),
                                    axis: (x: 15, y: 45, z: 0))
                                .onTapGesture {
                                    onTap(prayer)
                                }
                                .id(prayer.id)
                        }
                        .frame(width: 175, height: 265)
                    }
                }
                .padding(.horizontal, .p16)
                .padding(.vertical, .p8)
            }
        }.padding()
    }
}

// MARK: - NafilaSliderView

struct NafilaSliderView: View {
    var nafilas: IdentifiedArrayOf<Nafila>
    var onTap: (Nafila) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .p8) {
            Text(L10n.nafila)
                .foregroundColor(.mono.offblack)
                .scaledFont(locale: .arabic, .pFootnote, .bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .p16)
            ScrollViewRTL {
                HStack(spacing: .p32) {
                    ForEach(nafilas) { nafila in
                        GeometryReader { geometry in
                            PrayerCardView(nafila: nafila)
                                .rotation3DEffect(
                                    .degrees(
                                        ((.p32 + geometry.frame(in: .local).width) / 2 - geometry.frame(in: .global).minX) /
                                            30.0),
                                    axis: (x: 15, y: 45, z: 0))
                                .onTapGesture { onTap(nafila) }
                        }
                        .frame(width: 360, height: 265)
                    }
                }
                .padding(.horizontal, .p16)
            }
        }.padding(  )
    }
}

// MARK: - HadeethSliderView

struct HadeethSliderView: View {
    var ahadeeth: [String] = [
        L10n.hadeeth1,
        L10n.hadeeth2
    ]

    var body: some View {
        Text(ahadeeth.randomElement() ?? ahadeeth[0])
            .scaledFont(.pBody)
            .multilineTextAlignment(.center)
            .foregroundColor(Asset.Colors.Apple.dark.swiftUIColor)
            .padding()
            .frame(width: getScreenSize().width * 0.95)
            .background(
                RoundedRectangle(cornerRadius: .r8)
                    .fill()
                    .foregroundColor(Asset.Colors.Apple.light.swiftUIColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: .r8)
                            .stroke(Asset.Colors.Apple.medium.swiftUIColor.gradient, lineWidth: 1))
                    .shadow(color: Asset.Colors.Apple.light.swiftUIColor, radius: 33, x: 0, y: 3))
            .padding([.leading, .trailing, .bottom])
    }
}
