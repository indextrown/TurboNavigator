//
//  DetailViewController.swift
//  UIKitDemo
//
//  Created by Codex on 4/1/26.
//

import TurboNavigator
import UIKit

final class DetailViewController: UIViewController, AnyRouteIdentifiable {
    let anyRoute: AnyHashable

    private let navigator: Navigator<AppDependencies, AppRoute>
    private let userID: String
    private let repository: UserRepository

    init(
        navigator: Navigator<AppDependencies, AppRoute>,
        route: AppRoute,
        userID: String,
        repository: UserRepository
    ) {
        self.navigator = navigator
        self.anyRoute = AnyHashable(route)
        self.userID = userID
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        title = "Detail \(userID)"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let stack = UIStackView(arrangedSubviews: [
            titleLabel("Detail Screen"),
            descriptionLabel("userID: \(userID)"),
            descriptionLabel("displayName: \(repository.displayName(for: userID))"),
            makeButton("Push Next Detail", target: self, action: #selector(pushNextDetail)),
            makeButton("Back To Home", target: self, action: #selector(backToHome)),
            makeButton("Present Settings Full Screen", target: self, action: #selector(presentFullScreenSettings)),
            makeButton("Back", target: self, action: #selector(goBack)),
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

    @objc private func pushNextDetail() {
        navigator.push(.detail(id: userID + "-next"))
    }

    @objc private func backToHome() {
        navigator.backTo(.home)
    }

    @objc private func presentFullScreenSettings() {
        navigator.presentFullScreen(.settings)
    }

    @objc private func goBack() {
        navigator.back()
    }
}
