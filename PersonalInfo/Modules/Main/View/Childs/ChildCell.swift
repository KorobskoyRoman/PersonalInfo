//
//  ChildCell.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 26.10.2022.
//

import UIKit
import RxCocoa
import RxSwift

protocol DelegateTextChange: AnyObject {
    func changeText(newValue: String, indexPath: IndexPath, type: TextFieldType)
}

final class ChildCell: UITableViewCell {
    private enum Placeholders {
        static let delete = "Удалить"
        static let name = "Имя"
        static let age = "Возраст"

        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1
        static let borderColor: CGColor = UIColor.lightGray.cgColor
        static let leftRightInset: CGFloat = 10
    }

    static let reuseId = "ChildCell"
    private let disposeBag = DisposeBag()

    private lazy var nameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = Placeholders.name
        tf.layer.cornerRadius = Placeholders.cornerRadius
        tf.layer.borderWidth = Placeholders.borderWidth
        tf.layer.borderColor = Placeholders.borderColor
        tf.setRightPaddingPoints(Placeholders.leftRightInset)
        tf.setLeftPaddingPoints(Placeholders.leftRightInset)
        tf.autocorrectionType = .no
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
        tf.autocorrectionType = .no
        tf.keyboardType = .numberPad
        return tf
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Placeholders.delete, for: .normal)
        return button
    }()

    private lazy var stackView = UIStackView(arrangedSubviews: [nameTf, ageTf],
                                             axis: .vertical,
                                             spacing: 10,
                                             distribution: .fillEqually)

    weak var delegate: DelegateTextChange?
    var indexPath: IndexPath?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .mainBackground()
        setConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Child) {
        nameTf.text = model.name
        ageTf.text = model.age ?? ""
    }

    private func bind() {
        nameTf.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] text in
                guard let self else { return }
                guard let indexPath = self.indexPath else { return }

                if text != "" {
                    self.delegate?.changeText(newValue: text, indexPath: indexPath, type: .name)
                }
            }
            .disposed(by: disposeBag)

        ageTf.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] text in
                guard let self else { return }
                guard let indexPath = self.indexPath else { return }

                if text != "" {
                    self.delegate?.changeText(newValue: text, indexPath: indexPath, type: .age)
                }
            }
            .disposed(by: disposeBag)
    }

    private func setConstraints() {
        let height: CGFloat = 50
        let leadingButton: CGFloat = 10
        addSubview(stackView)
        addSubview(deleteButton)

        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        stackView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor,
                                          constant: leadingButton),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -frame.width / 2),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -leadingButton),

            deleteButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor,
                                                 constant: leadingButton),
            deleteButton.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}
