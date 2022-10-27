//
//  ChildCell.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 26.10.2022.
//

import UIKit

final class ChildCell: UITableViewCell {
    private enum Placeholders {
        static let delete = "Удалить"
        static let name = "Имя"
        static let age = "Возраст"
    }

    static let reuseId = "ChildCell"

    private lazy var nameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = Placeholders.name
        tf.borderStyle = .line
        return tf
    }()

    private lazy var ageTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = Placeholders.age
        tf.borderStyle = .line
        return tf
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Placeholders.delete, for: .normal)
        return button
    }()

    private lazy var stackView = UIStackView(arrangedSubviews: [nameTf, ageTf],
                                             axis: .vertical,
                                             spacing: 10)
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .mainBackground()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Child) {
        nameTf.text = model.name
        ageTf.text = model.age ?? ""
    }

    private func setConstraints() {
        let height: CGFloat = 50
        let leadingButton: CGFloat = 10
        addSubview(stackView)
        addSubview(deleteButton)

        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        stackView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            nameTf.heightAnchor.constraint(equalToConstant: height),
            ageTf.heightAnchor.constraint(equalTo: nameTf.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -frame.width / 2),

            deleteButton.topAnchor.constraint(equalTo: topAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                                 constant: leadingButton),
            deleteButton.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}
