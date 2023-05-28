// The MIT License (MIT)
//
// Copyright (c) 2020–2023 Alexander Grebenyuk (github.com/kean).

import Combine
import CoreData
import Pulse
import SwiftUI

// MARK: - PinsView

@available(*, deprecated, message: "PinsView view is no longer available. Please use ConsoleView instead.") // 3.0
public struct PinsView: View {
    public var body: some View {
        EmptyView()
    }
}

#if !os(macOS) && !os(watchOS)
@available(*, deprecated, message: "Please use ConsoleView pre-configured with .network mode") // 3.0
public struct NetworkView: View {
    private let store: LoggerStore

    public init(store: LoggerStore) {
        self.store = store
    }

    public var body: some View {
        ConsoleView.network(store: store)
    }
}
#endif

// MARK: - MainView

@available(*, deprecated, message: "Please use ConsoleView directly instead") // 3.0
public struct MainView: View {
    let environment: ConsoleEnvironment

    public init(store: LoggerStore = .shared, onDismiss: (() -> Void)? = nil) {
        environment = ConsoleEnvironment(store: store)
    }

    public var body: some View {
        #if os(macOS)
        ConsoleView(environment: environment)
        #else
        NavigationView {
            ConsoleView(environment: environment)
        }.navigationViewStyle(.stack)
        #endif
    }
}

#if DEBUG
@available(*, deprecated, message: "Deprecated") // 3.0
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: .mock)
    }
}

#endif
