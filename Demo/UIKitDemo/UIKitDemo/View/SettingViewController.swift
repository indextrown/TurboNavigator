//
//  SettingViewController.swift
//  UIKitDemo
//
//  Created by Codex on 4/1/26.
//

import TurboNavigator
import UIKit

final class SettingViewController: UIViewController, AnyRouteIdentifiable {
    let anyRoute: AnyHashable = AppRoute.settings

    private let navigator: Navigator<AppDependencies, AppRoute>

    init(navigator: Navigator<AppDependencies, AppRoute>) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        title = "Settings"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        let stack = UIStackView(arrangedSubviews: [
            titleLabel("Settings"),
            descriptionLabel("Modal과 stack 동작을 UIKit 앱에서 직접 확인할 수 있습니다."),
            makeButton("Push Detail 7", target: self, action: #selector(pushDetail)),
            makeButton("Dismiss Or Back", target: self, action: #selector(dismissOrBack)),
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    @objc private func pushDetail() {
        navigator.push(.detail(id: "7"))
    }

    @objc private func dismissOrBack() {
        navigator.back()
    }
}
