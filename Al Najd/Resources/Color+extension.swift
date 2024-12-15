//  swiftlint:disable all
//
//  The code generated using FigmaExport — Command line utility to export
//  colors, typography, icons and images from Figma to Xcode project.
//
//  https://github.com/RedMadRobot/figma-export
//
//  Don’t edit this code manually to avoid runtime crashes
//

import SwiftUI

// MARK: - BundleProvider

private enum BundleProvider {
    static let bundle = Bundle._module
}

public extension Color {
    static let appleDark: Color = .init("Apple / Dark", bundle: BundleProvider.bundle)
    static let appleLight: Color = .init("Apple / Light", bundle: BundleProvider.bundle)
    static let appleMedium: Color = .init("Apple / Medium", bundle: BundleProvider.bundle)
    static let applePrimary: Color = .init("Apple / Primary", bundle: BundleProvider.bundle)
    static let appleSuperlight: Color = .init("Apple / Superlight", bundle: BundleProvider.bundle)
    static let blueberryDark: Color = .init("Blueberry / Dark", bundle: BundleProvider.bundle)
    static let blueberryLight: Color = .init("Blueberry / Light", bundle: BundleProvider.bundle)
    static let blueberryMedium: Color = .init("Blueberry / Medium", bundle: BundleProvider.bundle)
    static let blueberrySuperlight: Color = .init("Blueberry / Superlight", bundle: BundleProvider.bundle)
    static let blueberryPrimary: Color = .init("Grey/Primary Grey", bundle: BundleProvider.bundle)
    static let cherryDark: Color = .init("Cherry / Dark", bundle: BundleProvider.bundle)
    static let cherryLight: Color = .init("Cherry / Light", bundle: BundleProvider.bundle)
    static let cherryMedium: Color = .init("Cherry / Medium", bundle: BundleProvider.bundle)
    static let cherryPrimary: Color = .init("Cherry / Primary", bundle: BundleProvider.bundle)
    static let cherrySuperlight: Color = .init("Cherry / Superlight", bundle: BundleProvider.bundle)
    static let greysGunMetal: Color = .init("Greys / Gun Metal", bundle: BundleProvider.bundle)
    static let greysNardo: Color = .init("Greys / Nardo", bundle: BundleProvider.bundle)
    static let greysSpaceGrey: Color = .init("Greys / Space Grey", bundle: BundleProvider.bundle)
    static let greysSuperLight: Color = .init("Greys / Super Light", bundle: BundleProvider.bundle)
    static let greysWhite: Color = .init("Greys / White", bundle: BundleProvider.bundle)
    static let greysBlackberry: Color = .init("Greys/Blackberry", bundle: BundleProvider.bundle)
    static let primaryBlackberry: Color = .init("Primary/Blackberry", bundle: BundleProvider.bundle)
    static let primaryBluberry: Color = .init("Primary/Bluberry", bundle: BundleProvider.bundle)
    static let primaryNardoGrey: Color = .init("Primary/Nardo Grey", bundle: BundleProvider.bundle)
    static let primarySolarbeam: Color = .init("Primary/Solarbeam", bundle: BundleProvider.bundle)
    static let primarySpaceGrey: Color = .init("Primary/Space Grey", bundle: BundleProvider.bundle)
    static let tangerineDark: Color = .init("Tangerine / Dark", bundle: BundleProvider.bundle)
    static let tangerineLight: Color = .init("Tangerine / Light", bundle: BundleProvider.bundle)
    static let tangerineMedium: Color = .init("Tangerine / Medium", bundle: BundleProvider.bundle)
    static let tangerinePrimary: Color = .init("Tangerine / Primary", bundle: BundleProvider.bundle)
    static let tangerineSuperlight: Color = .init("Tangerine / Superlight", bundle: BundleProvider.bundle)
    static let shadowMedium = Color("Shadow / Medium", bundle: BundleProvider.bundle)
    static let shadowBlueperry = Color("Shadow /Bluberry", bundle: BundleProvider.bundle)
    static let shadowCherry = Color("Shadow /Cherry", bundle: BundleProvider.bundle)
    static let shadowTangerine = Color("Shadow /Tangerine", bundle: BundleProvider.bundle)
}

private extension Foundation.Bundle {
    private class BundleFinder { }

    /// Returns the resource bundle associated with the current Swift module.
    static var _module: Bundle = .main
}
