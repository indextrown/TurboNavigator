//
//  HomeViewController.swift
//  UIKitDemo
//
//  Created by Codex on 4/1/26.
//

import TurboNavigator
import UIKit

final class HomeViewController: UIViewController, AnyRouteIdentifiable {
    let anyRoute: AnyHashable = AppRoute.home

    private let navigator: Navigator<AppDependencies, AppRoute>
    private let routesLabel = UILabel()

    init(navigator: Navigator<AppDependencies, AppRoute>) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
        title = "UIKit Home"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        routesLabel.numberOfLines = 0
        routesLabel.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        routesLabel.textColor = .secondaryLabel
        routesLabel.text = "Current routes will appear here."

        let stack = UIStackView(arrangedSubviews: [
            titleLabel("TurboNavigator UIKit Demo"),
            descriptionLabel("SwiftUI bridge 없이 UINavigationController 위에서 Navigator를 직접 사용합니다."),
            makeButton("Push Detail 42", target: self, action: #selector(pushDetail)),
            makeButton("Push Detail 42 -> 99", target: self, action: #selector(pushDetailChain)),
            makeButton("Present Settings", target: self, action: #selector(presentSettings)),
            makeButton("Replace With Home -> Detail 77", target: self, action: #selector(replaceStack)),
            makeButton("Back Or Push Settings", target: self, action: #selector(backOrPushSettings)),
            makeButton("Show Current Routes", target: self, action: #selector(showCurrentRoutes)),
            routesLabel,
        ])
        stack.axis = .vertical
        stack.spacing = 12

        let scrollView = UIScrollView()
        let contentView = UIView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }

    @objc private func pushDetail() {
        navigator.push(.detail(id: "42"))
    }

    @objc private func pushDetailChain() {
        navigator.push([.detail(id: "42"), .detail(id: "99")])
    }

    @objc private func presentSettings() {
        navigator.present(.settings)
    }

    @objc private func replaceStack() {
        navigator.replace(with: [.home, .detail(id: "77")])
    }

    @objc private func backOrPushSettings() {
        navigator.backOrPush(.settings)
    }

    @objc private func showCurrentRoutes() {
        let routes = navigator.currentRoutes()
            .map { String(describing: $0) }
            .joined(separator: " -> ")
        routesLabel.text = routes.isEmpty ? "No routes" : routes
    }
}
