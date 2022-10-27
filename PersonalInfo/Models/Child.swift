//
//  Child.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 24.10.2022.
//

import Foundation

struct Child {
    let id: UUID = UUID()
    var name: String
    var age: String?
}

extension Child {
    static var emptyChild: Child {
        return Child(name: "", age: "")
    }
}
