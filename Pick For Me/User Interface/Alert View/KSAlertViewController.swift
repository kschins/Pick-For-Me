//
//  KSAlertViewController.swift
//  Pick For Me
//
//  Created by Kasey Schindler on 10/31/18.
//  Copyright © 2018 Kasey Schindler. All rights reserved.
//

import UIKit

/// Apple does not support subclassing UIAlertController so this class
/// is meant to mimic the functionality of that class yet allow a little
/// more customization. It is not meant to be fully customizable and most
/// likely will only meet my needs.

protocol KSAlertViewProtocol {
    func addButtonTapped(with option: String)
    func cancelButtonTapped()
}

final class KSAlertViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: KSAlertViewProtocol?
    
    // MARK: - IBOutlets
    @IBOutlet private var alertView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initial setup
        addButton.isEnabled = false
        textField.becomeFirstResponder()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped() {
        textField.resignFirstResponder()
        delegate?.addButtonTapped(with: textField.text!)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped() {
        textField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        dismiss(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        addButton.isEnabled = newLength > 0
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addButtonTapped()
        
        return true
    }

}
