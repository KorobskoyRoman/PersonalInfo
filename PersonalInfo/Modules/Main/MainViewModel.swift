//
//  MainViewModel.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 24.10.2022.
//

import RxSwift
import RxCocoa

protocol MainViewModelType {
    var childs: BehaviorRelay<[Child]> { get set }
    func getChild(at index: Int) -> Child
    func deleteChild(at child: Child)
    func changeValues(newValue: String,
                      indexPath: IndexPath,
                      type: TextFieldType)
}

final class MainViewModel: MainViewModelType {
    var childs = BehaviorRelay<[Child]>(value: [])

    func getChild(at index: Int) -> Child {
        guard !childs.value.isEmpty else { return .emptyChild }
        return childs.value[index]
    }

    func deleteChild(at child: Child) {
        guard let index = childs.value
            .firstIndex(where: { $0.id == child.id }) else { return }
        var value = childs.value
        value.remove(at: index)
        childs.accept(value)
    }

    func changeValues(newValue: String,
                      indexPath: IndexPath,
                      type: TextFieldType) {
        print(childs.value)
        var value = getChild(at: indexPath.row)
        deleteChild(at: value)
        let oldValue = childs.value

        switch type {
        case .name:
            value.name = newValue
            childs.accept(oldValue + [value])
            break
        case .age:
            value.age = newValue
            childs.accept(oldValue + [value])
            break
        }
    }
}
