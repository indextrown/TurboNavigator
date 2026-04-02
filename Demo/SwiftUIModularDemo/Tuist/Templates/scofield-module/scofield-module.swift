import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Scaffolds a SwiftUI feature module for SwiftUIModularDemo.",
    attributes: [
        nameAttribute,
    ],
    items: [
        .file(
            path: "Modules/Feature\(nameAttribute)/Sources/\(nameAttribute)View.swift",
            templatePath: "FeatureView.stencil"
        ),
        .file(
            path: "Modules/Feature\(nameAttribute)/README.md",
            templatePath: "FeatureREADME.stencil"
        ),
    ]
)
