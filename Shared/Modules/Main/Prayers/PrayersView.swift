//
//  ContentView.swift
//  Shared
//
//  Created by Ahmed Ramy on 13/10/2021.
//

import SwiftUI

struct PrayersView: View {
  @EnvironmentObject var state: PrayersState
  @EnvironmentObject var dateState: DateState
  
  @State var currentOffset: CGFloat = 0
  @State var lastOffset: CGFloat = 0
  
  var body: some View {
    VStack {
      List {
        DeedsList(
          sectionTitle: "Faraaid".localized,
          deeds: state.faraaid
        ).padding()
        
        DeedsList(
          sectionTitle: "Sunnah".localized,
          deeds: state.sunnah
        ).padding()
        
        DeedsList(
          sectionTitle: "Nafila".localized,
          deeds: state.nafila
        ).padding()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    PrayersView()
      .preferredColorScheme(.dark)
      .environmentObject(app.state.homeState)
      .previewInterfaceOrientation(.portrait)
  }
}

struct DeedsList: View {
  var sectionTitle: String
  var deeds: [Deed] = []
  
  var allDeedsAreDone: Bool { deeds.first(where: { $0.isDone == false }) == nil }
  
  var body: some View {
    Section(content: {
      if allDeedsAreDone {
        Text("Well Done".localized(arguments: sectionTitle))
          .padding(.p48)
          .multilineTextAlignment(.center)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
          .foregroundColor(.mono.offwhite)
          .background(Color.success.default)
          .font(.displaySmall)
          .cornerRadius(.r16)
      } else {
        ForEach(deeds) { deed in
          HStack {
            Text(deed.title)
              .font(.pBody)
            if deed.isDone {
              Spacer()
              Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.success.default)
            }
          }.if(!deed.isDone, transform: { view in
            view.swipeActions(edge: .trailing) {
              Button(
                action: {
                  withAnimation {
                    app.did(deed: deed)
                  }
                },
                label: { Image(systemName: "checkmark.seal") }
              ).tint(.success.default)
            }
          }).if(deed.isDone, transform: { view in
            view.swipeActions(edge: .leading) {
              Button(
                action: {
                  withAnimation {
                    app.undo(deed: deed)
                  }
                },
                label: { Image(systemName: "delete.backward.fill") }
              ).tint(.danger.default)
            }
          })
        }
      }
    }, header: {
      Text(sectionTitle)
        .font(.pSubheadline)
    })
  }
}

extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}

#if swift(<5.1)
extension Strideable where Stride: SignedInteger {
  func clamped(to limits: CountableClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
#endif

extension Animation {
  func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
    if expression {
      return self.repeatForever(autoreverses: autoreverses)
    } else {
      return self
    }
  }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
