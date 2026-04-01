//
//  ViewFactory.swift
//  UIKitDemo
//
//  Created by Codex on 4/1/26.
//

import UIKit

func makeButton(_ title: String, target: Any?, action: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.configuration = .filled()
    button.configuration?.cornerStyle = .medium
    button.configuration?.title = title
    button.addTarget(target, action: action, for: .touchUpInside)
    return button
}

func titleLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = .preferredFont(forTextStyle: .largeTitle)
    label.numberOfLines = 0
    return label
}

func descriptionLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = .preferredFont(forTextStyle: .body)
    label.textColor = .secondaryLabel
    label.numberOfLines = 0
    return label
}
