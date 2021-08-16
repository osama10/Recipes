//
//  UIViewController+Extensions.swift
//  Task2
//
//  Created by Osama Bashir on 10/26/20.
//

import UIKit

protocol AlertsPresentable : AnyObject {}
extension AlertsPresentable where Self : UIViewController {

    func showAlert(with title: String? = nil , and message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)

        present(alertController, animated: true, completion: nil)

    }
}
