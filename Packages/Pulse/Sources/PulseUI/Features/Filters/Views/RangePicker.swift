// The MIT License (MIT)
//
// Copyright (c) 2020–2023 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(macOS)
import Pulse
import SwiftUI

struct RangePicker: View {
    @Binding var range: ValuesRange<String>

    var body: some View {
        HStack {
            textField("Min", text: $range.lowerBound)
            textField("Max", text: $range.upperBound)
        }
        #if os(macOS)
        .frame(width: 120)
        #elseif os(watchOS)
        .frame(width: 130)
        #endif
    }

    private func textField(_ title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .multilineTextAlignment(.center)
        #if os(iOS)
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
        #elseif os(macOS)
            .textFieldStyle(.plain)
        #endif
    }
}
#endif

// MARK: - ValuesRange

// Can't use `Swift.Range` because values are immutable.
struct ValuesRange<T> {
    var lowerBound: T
    var upperBound: T
}

// MARK: Equatable

extension ValuesRange: Equatable where T: Equatable { }

// MARK: Hashable

extension ValuesRange: Hashable where T: Hashable { }

extension ValuesRange where T == String {
    static let empty = ValuesRange(lowerBound: "", upperBound: "")
}
