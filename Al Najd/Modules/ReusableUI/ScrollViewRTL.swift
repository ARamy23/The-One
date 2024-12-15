import SwiftUIIntrospect
import SwiftUI

public struct ScrollViewRTL<Content: View>: View {
    @ViewBuilder var content: Content
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var hasAdjustedPosition = false

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    @ViewBuilder public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    content
                }
                .rotation3DEffect(Angle(degrees: layoutDirection == .rightToLeft ? -180 : 0), axis: (
                    x: CGFloat(0),
                    y: CGFloat(layoutDirection == .rightToLeft ? -10 : 0),
                    z: CGFloat(0)))
            }
            .introspect(.scrollView, on: .iOS(.v18)) { scrollView in
                scrollView.clipsToBounds = false
            }
            .rotation3DEffect(Angle(degrees: layoutDirection == .rightToLeft ? 180 : 0), axis: (
                x: CGFloat(0),
                y: CGFloat(layoutDirection == .rightToLeft ? 10 : 0),
                z: CGFloat(0)))
            .onAppear {
                adjustScrollPosition(proxy: proxy)
            }
        }
    }

    private func adjustScrollPosition(proxy: ScrollViewProxy) {
        // Delay adjustment to ensure the view is fully rendered
        DispatchQueue.main.async {
            if layoutDirection == .rightToLeft, !hasAdjustedPosition {
                proxy.scrollTo(0, anchor: .leading)
                hasAdjustedPosition = true
            }
        }
    }
}
