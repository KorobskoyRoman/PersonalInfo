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
}

final class MainViewModel: MainViewModelType {
    var childs = BehaviorRelay<[Child]>(value: [Child(name: "sda", age: "233")])

    func getChild(at index: Int) -> Child {
        childs.value[index]
    }
}
