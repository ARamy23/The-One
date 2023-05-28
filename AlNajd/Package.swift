// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AlNajd",
    defaultLocalization: "ar",
    platforms: [
        .iOS(.v16),
        .macOS(.v11),
    ],
    products: ANProducts.all,
    dependencies: ANDependencies.all,
    targets: ANTargets.all)

// MARK: - ANTargets

private enum ANTargets {
    static let all: [Target] = ANTargets.alCore
        + ANTargets.common
        + ANTargets.entities
        + ANTargets.localization
        + ANTargets.prayerDetails
        + ANTargets.prayersClient
        + ANTargets.home
        + ANTargets.assets
        + ANTargets.dashboard
        + ANTargets.azkar
        + ANTargets.nafilaDetails
}

private extension ANTargets {
    static let alCore: [Target] = [
        .target(
            name: "AlCore",
            dependencies: [
                "Entities",
                "Localization",
                "Common",
                "PrayerDetails",
                "PrayersClient",
                "Home",
                "Assets",
                "Dashboard",
                "Azkar",
                "NafilaDetails",
                .product(name: "Core", package: "OrdiCore"),
            ]),
    ]
}

private extension ANTargets {
    static let nafilaDetails: [Target] = [
        .target(
            name: "NafilaDetails",
            dependencies: [
                "Common",
                "Entities",
                "Localization",
                "PrayersClient",
                .product(name: "Drawer", package: "swiftui-drawer"),
                .product(name: "Core", package: "OrdiCore"),
            ]),
    ]

    static let assets: [Target] = [
        .target(
            name: "Assets",
            resources: [
                .process("Resources"),
            ]),
    ]

    static let prayerDetails: [Target] = [
        .target(
            name: "PrayerDetails",
            dependencies: [
                "Common",
                "Entities",
                "Localization",
                "PrayersClient",
                .product(name: "Drawer", package: "swiftui-drawer"),
                .product(name: "Core", package: "OrdiCore"),
            ]),
    ]

    static let home: [Target] = [
        .target(
            name: "Home",
            dependencies: [
                "Common",
                "Entities",
                "Localization",
                "PrayerDetails",
                "Dashboard",
                "NafilaDetails",
                .product(name: "Core", package: "OrdiCore"),
                .product(name: "ScalingHeaderScrollView", package: "ScalingHeaderScrollView"),
            ]),
    ]

    static let prayersClient: [Target] = [
        .target(
            name: "PrayersClient",
            dependencies: [
                "Entities",
                "Localization",
                .product(name: "Core", package: "OrdiCore"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "Adhan", package: "adhan-swift"),
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "SwiftDate", package: "SwiftDate"),
            ],
            resources: [.process("Resources")]),
    ]

    static let common: [Target] = [
        .target(
            name: "Common",
            dependencies: [
                "Entities",
                "PrayersClient",
                .product(name: "Core", package: "OrdiCore"),
                .product(name: "ComposableCoreLocation", package: "composable-core-location"),
                .product(name: "Inject", package: "Inject"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
    ]

    static let localization: [Target] = [
        .target(
            name: "Localization",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]),
    ]

    static let entities: [Target] = [
        .target(
            name: "Entities",
            dependencies: [
                "Localization",
                "Assets",
                .product(name: "Core", package: "OrdiCore"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
    ]

    static let dashboard: [Target] = [
        .target(
            name: "Dashboard",
            dependencies: [
                "Localization",
                "Assets",
                "PrayersClient",
                "Common",
                .product(name: "Core", package: "OrdiCore"),
            ]),
    ]

    static let azkar: [Target] = [
        .target(
            name: "Azkar",
            dependencies: [
                "Localization",
                "Assets",
                "PrayersClient",
                "Common",
                .product(name: "Core", package: "OrdiCore"),
            ]
        )
    ]
}

// MARK: - ANDependencies

private enum ANDependencies {
    static let all: [Package.Dependency] = ordiCore
        + pointFree
        + inject
        + home
        + qaTools
}

private extension ANDependencies {
    static let ordiCore: [Package.Dependency] = [
        .package(path: "../OrdiCore"),
    ]

    static let pointFree: [Package.Dependency] = [
        .package(
            url: "https://github.com/pointfreeco/composable-core-location",
            .upToNextMajor(from: .init(0, 1, 0))),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            branch: "main"),
    ]

    static let inject: [Package.Dependency] = [
        .package(
            url: "https://github.com/krzysztofzablocki/Inject",
            .upToNextMajor(from: .init(1, 2, 1))),
    ]

    static let home: [Package.Dependency] = [
        .package(
            url: "https://github.com/batoulapps/adhan-swift",
            branch: "main"),
        .package(
            url: "https://github.com/maustinstar/swiftui-drawer",
            branch: "master"),
        .package(
            url: "https://github.com/groue/GRDB.swift",
            .upToNextMajor(from: .init(6, 0, 0))),
        .package(
            url: "https://github.com/malcommac/SwiftDate",
            .upToNextMajor(from: .init(7, 0, 0))),
        .package(
            url: "https://github.com/exyte/ScalingHeaderScrollView.git",
            .upToNextMajor(from: .init(0, 0, 6))),
    ]

    static let qaTools: [Package.Dependency] = [
        .package(path: "../Packages/Loggers"),
        .package(path: "../Packages/Configs"),
        .package(path: "../Packages/Common"),
        .package(path: "../Packages/DebuggingTools")
    ]
}

// MARK: - ANProducts

private enum ANProducts {
    static let all: [PackageDescription.Product] = [
        ANProducts.product(name: "AlCore"),
        ANProducts.product(name: "Entities"),
        ANProducts.product(name: "Localization"),
        ANProducts.product(name: "Common"),
        ANProducts.product(name: "PrayerDetails"),
        ANProducts.product(name: "PrayersClient"),
        ANProducts.product(name: "Home"),
        ANProducts.product(name: "Dashboard"),
        ANProducts.product(name: "Assets"),
        ANProducts.product(name: "Azkar"),
        ANProducts.product(name: "NafilaDetails"),
    ]

    static func product(name: String) -> PackageDescription.Product {
        .library(
            name: name,
            targets: [name])
    }
}
