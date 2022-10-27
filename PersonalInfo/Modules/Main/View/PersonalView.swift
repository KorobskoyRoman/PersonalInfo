//
//  PersonalView.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 24.10.2022.
//

import UIKit

final class PersonalView: UIView {
    private enum Placeholders {
        static let title = "Персональные данные"
        static let name = "Имя"
        static let age = "Возраст"

        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let borderColor: CGColor = UIColor.lightGray.cgColor
        static let leftRightInset: CGFloat = 10
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Placeholders.title
        label.font = .mainTitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = Placeholders.name
        tf.layer.cornerRadius = Placeholders.cornerRadius
        tf.layer.borderWidth = Placeholders.borderWidth
        tf.layer.borderColor = Placeholders.borderColor
        tf.setRightPaddingPoints(Placeholders.leftRightInset)
        tf.setLeftPaddingPoints(Placeholders.leftRightInset)
        return tf
    }()

    private lazy var ageTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = Placeholders.age
        tf.layer.cornerRadius = Placeholders.cornerRadius
        tf.layer.borderWidth = Placeholders.borderWidth
        tf.layer.borderColor = Placeholders.borderColor
        tf.setRightPaddingPoints(Placeholders.leftRightInset)
        tf.setLeftPaddingPoints(Placeholders.leftRightInset)
        return tf
    }()

    private lazy var stackView = UIStackView(arrangedSubviews: [nameTf, ageTf],
                                             axis: .vertical,
                                             spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        let height: CGFloat = 50
        let inset: CGFloat = 20
        addSubview(titleLabel)
        addSubview(stackView)

        stackView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            nameTf.heightAnchor.constraint(equalToConstant: height),
            ageTf.heightAnchor.constraint(equalTo: nameTf.heightAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                          constant: inset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
