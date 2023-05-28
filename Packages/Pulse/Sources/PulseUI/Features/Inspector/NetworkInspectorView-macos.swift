// The MIT License (MIT)
//
// Copyright (c) 2020–2023 Alexander Grebenyuk (github.com/kean).

import Combine
import CoreData
import Pulse
import SwiftUI

#if os(macOS)

struct NetworkInspectorView: View {
    @ObservedObject var task: NetworkTaskEntity
    @State var selectedTab: NetworkInspectorTab

    private var viewModel: NetworkInspectorViewModel { .init(task: task) }

    init(
        task: NetworkTaskEntity,
        tab: NetworkInspectorTab = NetworkInspectorPreferences().selectedTab) {
        self.task = task
        _selectedTab = State(initialValue: tab)
    }

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()
            selectedTabView
        }
        .onChange(of: selectedTab) {
            NetworkInspectorPreferences().selectedTab = $0
        }
    }

    @ViewBuilder
    private var toolbar: some View {
        HStack {
            InlineTabBar(items: NetworkInspectorTab.allCases, selection: $selectedTab)
            Spacer()

            ButtonChangeContentModeLayout()
            ButtonCloseDetailsView()
        }
        .padding(.horizontal, 10)
        .offset(y: -2)
        .frame(height: 27, alignment: .center)
    }

    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case .summary:
            RichTextView(viewModel: .init(string: TextRenderer(options: .sharing).make { $0.render(task, content: .summary) }))
        case .headers:
            RichTextView(viewModel: .init(string: renderHeaders()))
        case .request:
            NetworkInspectorRequestBodyView(viewModel: .init(task: task))
        case .response:
            NetworkInspectorResponseBodyView(viewModel: .init(task: task))
        case .metrics:
            if let viewModel = NetworkInspectorMetricsViewModel(task: task) {
                NetworkInspectorMetricsView(viewModel: viewModel)
            } else {
                placeholder
            }
        case .curl:
            RichTextView(viewModel: .init(string: TextRenderer().preformatted(task.cURLDescription())))
        }
    }

    private func renderHeaders() -> NSAttributedString {
        TextRenderer(options: .init(color: .monochrome)).make {
            $0.render([
                KeyValueSectionViewModel.makeHeaders(title: "Original Request Headers", headers: task.originalRequest?.headers),
                KeyValueSectionViewModel.makeHeaders(title: "Current Request Headers", headers: task.currentRequest?.headers),
                KeyValueSectionViewModel.makeHeaders(title: "Response Headers", headers: task.response?.headers)
            ])
        }
    }

    @ViewBuilder
    private var placeholder: some View {
        PlaceholderView(imageName: "exclamationmark.circle", title: "Not Available")
    }
}

private struct NetworkInspectorPreferences {
    // We want to save the latest preferences, but not update all open windows
    // on the change in selection.
    @AppStorage("network-inspector-selected-tab")
    var selectedTab: NetworkInspectorTab = .summary
}

enum NetworkInspectorTab: String, Identifiable, CaseIterable, CustomStringConvertible {
    case summary = "Summary"
    case request = "Request"
    case response = "Response"
    case headers = "Headers"
    case metrics = "Metrics"
    case curl = "cURL"

    var id: NetworkInspectorTab { self }
    var description: String { rawValue }
}

#if DEBUG
struct NetworkInspectorView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(macOS 13.0, *) {
            NavigationStack {
                NetworkInspectorView(task: LoggerStore.preview.entity(for: .login))
            }.previewLayout(.fixed(width: 500, height: 800))
        }
    }
}
#endif

#endif
