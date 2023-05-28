// The MIT License (MIT)
//
// Copyright (c) 2020–2023 Alexander Grebenyuk (github.com/kean).

import Combine
import CoreData
import Pulse
import SwiftUI

struct NetworkInspectorViewModel {
    let task: NetworkTaskEntity

    var title: String {
        task.url.flatMap(URL.init(string:))?.lastPathComponent ?? "Request"
    }

    func shareTaskAsHTML() -> URL? {
        ShareService.share(task, as: .html).items.first as? URL
    }
}
