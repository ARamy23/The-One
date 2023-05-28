// The MIT License (MIT)
//
// Copyright (c) 2020–2023 Alexander Grebenyuk (github.com/kean).

import Combine
import CoreData
import Pulse
import SwiftUI

#if os(tvOS)

struct NetworkInspectorView: View {
    @ObservedObject var task: NetworkTaskEntity

    private var viewModel: NetworkInspectorViewModel { .init(task: task) }

    @State private var isCurrentRequest = false

    var body: some View {
        contents
            .inlineNavigationTitle(viewModel.title)
    }

    var contents: some View {
        HStack {
            Form { lhs }.frame(width: 740)
            Form { rhs }
        }
    }

    @ViewBuilder
    private var lhs: some View {
        Section {
            NetworkRequestStatusSectionView(viewModel: .init(task: task))
        }
        Section {
            NetworkInspectorRequestTypePicker(isCurrentRequest: $isCurrentRequest)
            NetworkInspectorView.makeRequestSection(task: task, isCurrentRequest: isCurrentRequest)
        } header: { Text("Request") }
        if viewModel.task.state != .pending {
            Section {
                NetworkInspectorView.makeResponseSection(task: task)
            } header: { Text("Response") }
        }
        Section {
            NetworkCURLCell(task: viewModel.task)
        } header: { Text("Transactions") }
    }

    @ViewBuilder
    private var rhs: some View {
        Section {
            NetworkInspectorView.makeHeaderView(task: task)
                .padding(.bottom, 32)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowBackground(Color.clear)
        NetworkInspectorMetricsViewModel(task: viewModel.task)
            .map(NetworkInspectorMetricsView.init)
    }
}

#if DEBUG
struct NetworkInspectorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NetworkInspectorView(task: LoggerStore.preview.entity(for: .login))
        }
    }
}
#endif

#endif
