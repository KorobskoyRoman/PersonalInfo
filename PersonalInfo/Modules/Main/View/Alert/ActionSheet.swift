//
//  ActionSheet.swift
//  PersonalInfo
//
//  Created by Roman Korobskoy on 27.10.2022.
//

import UIKit

final class ActionSheet {
    static func showActionsheet(viewController: UIViewController,
                                title: String,
                                message: String,
                                completion: @escaping (UIAlertAction) -> Void) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .actionSheet)
        let actionOk = UIAlertAction(title: "Сбросить данные",
                                     style: .destructive,
                                     handler: completion)
        let actionCancel = UIAlertAction(title: "Отмена",
                                         style: .cancel)

        alertViewController.addAction(actionOk)
        alertViewController.addAction(actionCancel)

        viewController.present(alertViewController, animated: true, completion: nil)
    }
}
