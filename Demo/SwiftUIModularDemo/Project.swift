import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("18.5")
let organizationName = "TurboNavigator"
let bundlePrefix = "com.turbonavigator.demo"

let appSettings: Settings = .settings(
    base: [
        "DEVELOPMENT_TEAM": "LGX4B4WC66",
        "CODE_SIGN_STYLE": "Automatic",
    ]
)

let project = Project(
    name: "SwiftUIModularDemo",
    organizationName: organizationName,
    packages: [
        .package(path: "../../")
    ],
    targets: [
        .target(
            name: "SwiftUIModularDemo",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundlePrefix).app",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:]
                ]
            ),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .target(name: "AppNavigation"),
                .target(name: "AppCore")
            ],
            settings: appSettings
        ),
        .target(
            name: "AppCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).domain",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/AppCore/Sources/**"],
            dependencies: [
                .package(product: "TurboNavigator")
            ]
        ),
        .target(
            name: "FeatureHome",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).feature.home",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureHome/Sources/**"],
            dependencies: [
                .target(name: "AppCore")
            ]
        ),
        .target(
            name: "FeatureDetail",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).feature.detail",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureDetail/Sources/**"],
            dependencies: [
                .target(name: "AppCore")
            ]
        ),
        .target(
            name: "FeatureSettings",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).feature.settings",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/FeatureSettings/Sources/**"],
            dependencies: [
                .target(name: "AppCore")
            ]
        ),
        .target(
            name: "AppNavigation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundlePrefix).navigation",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Modules/AppNavigation/Sources/**"],
            dependencies: [
                .target(name: "AppCore"),
                .target(name: "FeatureHome"),
                .target(name: "FeatureDetail"),
                .target(name: "FeatureSettings")
            ]
        )
    ]
)
