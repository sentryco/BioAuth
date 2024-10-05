// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BioAuth", // Defines the package name as BioAuth
    platforms: [
        .macOS(.v14), // Specifies macOS 14 and later as a supported platform
        .iOS(.v17) // Specifies iOS 17 and later as a supported platform
    ], // Lists the platforms supported by the package
    products: [
        .library(
            name: "BioAuth",
            targets: ["BioAuth"]) // Defines the library product with the target BioAuth
    ], // Lists the products of the package
    dependencies: [
        //.package(url: "https://github.com/sentryco/Logger.git", branch: "main") // Adds Logger as a dependency
    ], // Lists the dependencies of the package
    targets: [
        .target(
            name: "BioAuth",
            dependencies: [/*"Logger"*/]), // Defines the BioAuth target with Logger as a dependency
        .testTarget(
            name: "BioAuthTests",
            dependencies: ["BioAuth"]) // Defines the BioAuthTests target with a dependency on BioAuth
    ] // Lists the targets of the package
)
