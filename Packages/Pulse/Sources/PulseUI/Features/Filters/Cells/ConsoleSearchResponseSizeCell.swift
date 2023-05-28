// The MIT License (MIT)
//
// Copyright (c) 2020–2023 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(macOS)

import Pulse
import SwiftUI

struct ConsoleSearchResponseSizeCell: View {
    @Binding var selection: ConsoleFilers.ResponseSize

    var body: some View {
        HStack {
            Text("Size").lineLimit(1)
            Spacer()
            ConsoleSearchInlinePickerMenu(title: selection.unit.title, width: 50) {
                Picker("Unit", selection: $selection.unit) {
                    ForEach(ConsoleFilers.ResponseSize.MeasurementUnit.allCases) {
                        Text($0.title).tag($0)
                    }
                }
                .labelsHidden()
            }
            RangePicker(range: $selection.range)
        }
    }
}

#endif
