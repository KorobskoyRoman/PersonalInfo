//
//  MainViewController.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 24.10.2022.
//

import UIKit

final class MainViewController: UIViewController {
    private let personalView = PersonalView()
    private let childsView = ChildsView()
    private let viewModel: MainViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        childsView.delegate = self
        setConstraints()
    }

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        let inset: CGFloat = 32

        view.addSubview(personalView)
        view.addSubview(childsView)
        personalView.translatesAutoresizingMaskIntoConstraints = false
        childsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            personalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            personalView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: inset),
            personalView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -inset),

            childsView.topAnchor.constraint(equalTo: personalView.bottomAnchor),
            childsView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: inset),
            childsView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -inset),
            childsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -inset)
        ])
    }
}
