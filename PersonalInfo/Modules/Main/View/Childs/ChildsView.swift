//
//  ChildsView.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 24.10.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Action

final class ChildsView: UIView {
    private enum Placeholders {
        static let clear = "Очистить"
        static let title = "Дети (макс.5)"
        static let add = "Добавить ребенка"

        static let cornerRadius: CGFloat = 20
    }

    weak var delegate: UIViewController?

    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()

    private let tableView = UITableView(frame: .zero)
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Placeholders.clear,
                        for: .normal)
        button.tintColor = .systemRed
        button.layer.cornerRadius = Placeholders.cornerRadius
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()
    private lazy var childsLabel: UILabel = {
        let label = UILabel()
        label.text = Placeholders.title
        label.font = .mainTitle()
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Placeholders.add,
                        for: .normal)
        button.setImage(UIImage(systemName: "plus"),
                        for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()

    private lazy var childsStack = UIStackView(arrangedSubviews: [childsLabel, addButton],
                                               axis: .horizontal,
                                               spacing: 10,
                                               distribution: .fillProportionally)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .mainBackground()
        tableView.register(ChildCell.self, forCellReuseIdentifier: ChildCell.reuseId)

        viewModel.childs
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { [weak self] tableView, item, element in
                guard let self else { return UITableViewCell() }
                guard let cell = self.tableView.dequeueReusableCell(
                    withIdentifier: ChildCell.reuseId,
                    for: IndexPath(item: item, section: 0)
                ) as? ChildCell else { return UITableViewCell() }

                cell.contentView.isUserInteractionEnabled = false
                cell.delegate = self
                cell.indexPath = IndexPath(item: item, section: 0)

                cell.configure(with: element)

                cell.deleteButton.rx.action = CocoaAction { _ in
                    self.viewModel.deleteChild(at: element)
                    return .empty()
                }

                return cell
            }.disposed(by: disposeBag)
    }

    private func setupView() {
        tableView.backgroundColor = .mainBackground()
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets.zero
        setupTableView()
        bind()
    }

    private func bind() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        addButton.rx.tap.subscribe { [weak self] _ in
            guard let self else { return }
            let oldValue = self.viewModel.childs.value
            self.viewModel.childs.accept(oldValue + [.emptyChild])
        }
        .disposed(by: disposeBag)

        clearButton.rx.tap.subscribe { [weak self] _ in
            guard let self else { return }
            ActionSheet.showActionsheet(viewController: self.delegate ?? UIViewController(),
                                        title: "Удалить данные?",
                                        message: "Вы уверены?") { _ in
                self.viewModel.childs.accept([])
            }
        }
        .disposed(by: disposeBag)

        viewModel.childs.map { arr in
            return !arr.isEmpty
        }
        .bind(to: clearButton.rx.isEnabled)
        .disposed(by: disposeBag)

        viewModel.childs.map { arr in
            return arr.count < 5
        }
        .bind(to: addButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }

    private func setConstraints() {
        let topInset: CGFloat = 20
        let clearButtonheight: CGFloat = 50
        let tableBottomInset: CGFloat = -10
        let addButtonHeight: CGFloat = 30

        addSubview(tableView)
        addSubview(clearButton)
        addSubview(childsStack)
        childsStack.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: addButtonHeight),

            childsStack.topAnchor.constraint(equalTo: topAnchor,
                                            constant: topInset),
            childsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            childsStack.trailingAnchor.constraint(equalTo: trailingAnchor),

            clearButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            clearButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: clearButtonheight),

            tableView.topAnchor.constraint(equalTo: childsStack.bottomAnchor,
                                          constant: topInset),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: clearButton.topAnchor,
                                             constant: tableBottomInset)
        ])
    }
}

extension ChildsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ChildsView: DelegateTextChange {
    func changeText(newValue: String, indexPath: IndexPath, type: TextFieldType) {
        viewModel.changeValues(newValue: newValue,
                               indexPath: indexPath,
                               type: type)
    }
}
