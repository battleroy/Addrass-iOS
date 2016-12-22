//
//  SignUpViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 07/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class SignUpViewController: ScrollableContentViewController, UITextFieldDelegate {
    
    // MARK: Variables
    
    private let textFieldPadding               = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    private let textFieldHeight                = 40.0
    private let textFieldCornerRadius: CGFloat = 15.0
    
    var headerLabel: UILabel!
    var loginTextField: ADPaddedTextField!
    var passwordTextField: ADPaddedTextField!
    var repeatPasswordTextField: ADPaddedTextField!
    var nameTextField: ADPaddedTextField!
    var phoneTextField: ADPaddedTextField!
    var emailTextField: ADPaddedTextField!
    var organizationTextField: ADPaddedTextField!
    var addressTextField: ADPaddedTextField!
    
    var nonEmptyTextFields: [UITextField]!
    
    var doneButton: UIButton!
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    

    // MARK: Private Methods
    
    func setupSubviews() {
        view.backgroundColor = UIColor.ad.darkGray
        
        
        headerLabel = UILabel()
        headerLabel.textColor = UIColor.ad.white
        headerLabel.font = UIFont.ad.heading1Font
        headerLabel.text = String.ad.fillTheFields
        contentScrollView.addSubview(headerLabel)
        
        
        loginTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.login, withSafeInput: false)
        passwordTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.password, withSafeInput: true)
        repeatPasswordTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.repeatPassword, withSafeInput: true)
        nameTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.yourName, withSafeInput: false)
        phoneTextField = createTextField(withReturnType: .next, keyboardType: .phonePad, placeholder: String.ad.yourPhone, withSafeInput: false)
        emailTextField = createTextField(withReturnType: .next, keyboardType: .emailAddress, placeholder: String.ad.yourEmail, withSafeInput: false)
        organizationTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.yourCompany, withSafeInput: false)
        addressTextField = createTextField(withReturnType: .done, keyboardType: .default, placeholder: String.ad.yourAddress, withSafeInput: false)

        nonEmptyTextFields = Array<UITextField>()
        nonEmptyTextFields.append(loginTextField)
        nonEmptyTextFields.append(passwordTextField)
        nonEmptyTextFields.append(repeatPasswordTextField)
        nonEmptyTextFields.append(nameTextField)
        nonEmptyTextFields.append(phoneTextField)
        
        doneButton = UIButton(type: .roundedRect)
        doneButton.backgroundColor = UIColor.yellow
        doneButton.setAttributedTitle(
            NSAttributedString(string: String.ad.done, attributes: [
                NSFontAttributeName: UIFont.ad.boldFont,
                NSForegroundColorAttributeName: UIColor.darkGray
                ]),
            for: .normal)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 20.0
        doneButton.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(doneButton)
        
        setConstraints()
    }
    
    
    func createTextField(withReturnType returnType: UIReturnKeyType, keyboardType: UIKeyboardType, placeholder: String, withSafeInput: Bool) -> ADPaddedTextField {
        
        let textField = ADPaddedTextField(forPadding: textFieldPadding)
        textField.delegate = self
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnType
        textField.isSecureTextEntry = withSafeInput
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont.ad.bodyFont
        textField.textColor = UIColor.ad.white
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.lightGray
            ]
        )
        textField.layer.cornerRadius = textFieldCornerRadius
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
        contentScrollView.addSubview(textField)
     
        return textField
    }
    
    
    func setConstraints() {
        
        headerLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(loginTextField)
            make.top.equalTo(contentScrollView).offset(10.0)
        })
        
        loginTextField.snp.makeConstraints({ (make) in
            let insets = UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)
            
            make.left.right.equalTo(view).inset(insets)
            make.left.right.equalTo(contentScrollView).inset(insets)
            make.top.equalTo(headerLabel.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        })
        
        passwordTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(loginTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })
        
        repeatPasswordTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })
        
        nameTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })
        
        phoneTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })

        emailTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })

        organizationTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })
        
        addressTextField.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField)
            make.top.equalTo(organizationTextField.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField)
        })
        
        doneButton.snp.makeConstraints({ (make) in
            make.right.equalTo(addressTextField)
            make.top.equalTo(addressTextField.snp.bottom).offset(10.0)
            make.width.equalTo(60.0)
            make.height.equalTo(40.0)
            make.bottom.equalTo(contentScrollView).offset(-10.0)
        })
        
    }
    
    
    // MARK: Actions
    
    func doneButtonPressed(_ sender: UIButton) {
        
        var isEmptyFieldPresented = false
        if let nonEmptyTextFields = nonEmptyTextFields {
            
            for nonEmptyField in nonEmptyTextFields {
                
                if nonEmptyField.text?.characters.count == 0 {
                    nonEmptyField.blink(blinkColor: UIColor.red)
                    isEmptyFieldPresented = true
                }
                
            }
            
        }
        
        if !isEmptyFieldPresented {
            
            var newUser = User()
            
            newUser.login = loginTextField.text
            newUser.password = passwordTextField.text
            newUser.name = nameTextField.text
            newUser.phone = phoneTextField.text
            newUser.email = emailTextField.text
            newUser.company = organizationTextField.text
            newUser.address = addressTextField.text
        
            
            APIManager.register(newUser) { errorText in
                guard (errorText == nil) else {
                    UIAlertController.presentErrorAlert(withText: errorText!, parentController: self)
                    return
                }
                
                UIAlertController.presentInfoAlert(withText: String.ad.registered, parentController: self)
            }
            
        }
        
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else if textField == repeatPasswordTextField {
            nameTextField.becomeFirstResponder()
        } else if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            organizationTextField.becomeFirstResponder()
        } else if textField == organizationTextField {
            addressTextField.becomeFirstResponder()
        } else {
            addressTextField.resignFirstResponder()
        }
        
        return true
    }
    
}
