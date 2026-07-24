import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("18.0")
let bundlePrefix = "com.turbonavigator.demo.tca.modular"

let sharedSettings: Settings = .settings(
    base: [
        "SWIFT_VERSION": "6.0",
        "SWIFT_STRICT_CONCURRENCY": "complete",
    ]
)

let project = Project(
    name: "SwiftUITCATurboModularDemo",
    organizationName: "TurboNavigator",
    packages: [
        .package(path: "../../"),
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "1.26.1")
        ),
    ],
    settings: sharedSettings,
    targets: [
        .target(
            name: "SwiftUITCATurboModularDemo",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundlePrefix).app",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:],
                ]
            ),
            sources: ["App/Sources/**"],
            dependencies: [
                .target(name: "AppNavigation"),
            ],
            settings: .settings(
                base: [
                    "CODE_SIGN_STYLE": "Automatic",
                    "ENABLE_PREVIEWS": "YES",
                    "OTHER_LDFLAGS": "$(inherited) -ObjC",
                ]
            )
        ),
        .target(
            name: "AppCore",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundlePrefix).core",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/AppCore/Sources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
            ]
        ),
        .target(
            name: "DemoDesignSystem",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundlePrefix).designsystem",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/DemoDesignSystem/Sources/**"]
        ),
        .target(
            name: "FeatureHome",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundlePrefix).feature.home",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureHome/Sources/**"],
            dependencies: [
                .target(name: "AppCore"),
                .target(name: "DemoDesignSystem"),
            ]
        ),
        .target(
            name: "FeatureDetail",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundlePrefix).feature.detail",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureDetail/Sources/**"],
            dependencies: [
                .target(name: "AppCore"),
                .target(name: "DemoDesignSystem"),
            ]
        ),
        .target(
            name: "FeatureSettings",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundlePrefix).feature.settings",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureSettings/Sources/**"],
            dependencies: [
                .target(name: "AppCore"),
                .target(name: "DemoDesignSystem"),
            ]
        ),
        .target(
            name: "AppNavigation",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundlePrefix).navigation",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/AppNavigation/Sources/**"],
            dependencies: [
                .target(name: "AppCore"),
                .target(name: "FeatureHome"),
                .target(name: "FeatureDetail"),
                .target(name: "FeatureSettings"),
                .package(product: "TurboNavigator"),
            ]
        ),
        .target(
            name: "FeatureHomeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundlePrefix).feature.home.tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureHome/Tests/**"],
            dependencies: [
                .target(name: "AppCore"),
                .target(name: "FeatureHome"),
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": "$(inherited) -ObjC",
                ]
            )
        ),
        .target(
            name: "SwiftUITCATurboModularDemoUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "\(bundlePrefix).ui.tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["App/UITests/**"],
            dependencies: [
                .target(name: "SwiftUITCATurboModularDemo"),
            ]
        ),
    ]
)
