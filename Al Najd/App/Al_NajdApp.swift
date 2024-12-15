//
//  Al_NajdApp.swift
//  Shared
//
//  Created by Ahmed Ramy on 20/01/2022.
//

import ComposableArchitecture
import PulseUI
import SwiftUI
import Inject
// MARK: - Al_NajdApp

@main
struct Al_NajdApp: App {
    @State var showPulse = false

    let plugins: [AppPlugin] = [
        CorePlugin(),
        ThemePlugin(),
        AppearancesPlugin(),
        ReportPlugin(),
    ]

    init() {
        plugins.forEach { $0.setup() }
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: .mainRoot)
                .environment(\.layoutDirection, .rightToLeft)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onShake {
                    showPulse = true
                }
                .sheet(isPresented: $showPulse) {
                    NavigationView {
                        ConsoleView()
                            .navigationBarItems(leading: Button("Close") {
                                showPulse = false
                            })
                    }
                }
        }
    }
}

/// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// MARK: - DeviceShakeViewModifier

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        modifier(DeviceShakeViewModifier(action: action))
    }
}
