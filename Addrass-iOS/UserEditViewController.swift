//
//  ContactEditViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class UserEditViewController: ScrollableContentViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Variables
    
    private let imageViewSize: CGFloat         = 100.0
    
    private let textFieldPadding: UIEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    private let textFieldHeight: CGFloat       = 40.0
    private let textFieldCornerRadius: CGFloat = 15.0
    
    var firstNameTextField: ADPaddedTextField!
    var lastNameTextField: ADPaddedTextField!
    var imageView: UIImageView!
    var phoneTextField: ADPaddedTextField!
    var emailTextField: ADPaddedTextField!
    var addressTextField: ADPaddedTextField!
    
    var cancelBarButtonItem: UIBarButtonItem!
    var saveBarButtonItem: UIBarButtonItem!
    
    var isUserIconChanged = false
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ad.darkGray
        title = String.ad.edit

        setupSubviews()
        updateView()
        
        isUserIconChanged = false
    }
    
    
    // MARK: Private methods
    
    func setupSubviews() {
        
        firstNameTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.firstName, withSafeInput: false)
        lastNameTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.lastName, withSafeInput: false)
        phoneTextField = createTextField(withReturnType: .next, keyboardType: .phonePad, placeholder: String.ad.phone, withSafeInput: false)
        emailTextField = createTextField(withReturnType: .next, keyboardType: .emailAddress, placeholder: String.ad.email, withSafeInput: false)
        addressTextField = createTextField(withReturnType: .done, keyboardType: .default, placeholder: String.ad.address, withSafeInput: false)
        
        imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageViewSize / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.ad.yellow.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.image = #imageLiteral(resourceName: "noavatar")
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(userImagePressed(_:))
            )
        )
        contentScrollView.addSubview(imageView)
        
        cancelBarButtonItem = UIBarButtonItem(title: String.ad.cancel, style: .plain, target: self, action: #selector(barButtonItemPressed(_:)))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        saveBarButtonItem = UIBarButtonItem(title: String.ad.save, style: .done, target: self, action: #selector(barButtonItemPressed(_:)))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentScrollView).offset(10.0)
            make.width.height.equalTo(imageViewSize)
        }
        
        
        firstNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewSize).offset(10.0)
            make.left.equalTo(imageView.snp.right).offset(10.0)
            make.right.equalTo(contentScrollView).offset(-10.0)
            make.right.equalTo(view).offset(-10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        lastNameTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(firstNameTextField)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(10.0)
        }
        
        
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(imageView)
            make.right.equalTo(firstNameTextField)
            make.top.equalTo(imageView.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        addressTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
    }
    
    
    func updateView() {
        let editingContact = SessionManager.currentUser!
        
        firstNameTextField.text = editingContact.firstName
        lastNameTextField.text = editingContact.lastName
        phoneTextField.text = editingContact.phone
        emailTextField.text = editingContact.email
        addressTextField.text = editingContact.address
        
        if let imageLink = editingContact.imageLink, let imageURL = URL(string: imageLink) {
            imageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "noavatar"))
        }
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
    
    
    func saveChangesAndLeaveIfSuccess() {
        let user = SessionManager.currentUser!
        
        user.firstName = firstNameTextField.text
        user.lastName = lastNameTextField.text
        user.phone = phoneTextField.text
        user.email = emailTextField.text
        user.address = addressTextField.text
        
        APIManager.updateUser(user) { updateError in
            if updateError != nil {
                UIAlertController.presentErrorAlert(withText: updateError!, parentController: self)
                return
            }
            
            if self.isUserIconChanged {
                APIManager.setUserIcon(self.imageView.image, completion: { (setImageError) in
                    if setImageError != nil {
                        UIAlertController.presentErrorAlert(withText: setImageError!, parentController: self)
                        return
                    }
                    
                    self.updateSessionAndLeaveIfSuccess()
                })
            } else {
                self.updateSessionAndLeaveIfSuccess()
            }
        }
    }
    
    
    func updateSessionAndLeaveIfSuccess() {
        SessionManager.refreshSessionUser { refreshErrorText in
            if let refreshError = refreshErrorText {
                UIAlertController.presentErrorAlert(withText: refreshError, parentController: self)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField === lastNameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField === phoneTextField {
            emailTextField.becomeFirstResponder()
        } else if textField === emailTextField {
            addressTextField.becomeFirstResponder()
        } else if textField === addressTextField {
            addressTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        isUserIconChanged = true
        imageView.image = pickedImage
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Actions
    
    func userImagePressed(_ sender: UITapGestureRecognizer) {
        let ac = UIAlertController(title: String.ad.pickImageFrom, message: nil, preferredStyle: .actionSheet)
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        var isAnySourceAvailable = false
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            ac.addAction(UIAlertAction(title: String.ad.gallery, style: .default, handler: { _ in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }))
         
            isAnySourceAvailable = true
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: String.ad.camera, style: .default, handler: { _ in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
         
            isAnySourceAvailable = true
        }
        
        if isAnySourceAvailable {
            ac.addAction(UIAlertAction(title: String.ad.cancel, style: .destructive, handler: { _ in
                ac.dismiss(animated: true, completion: nil)
            }))
            
            present(ac, animated: true, completion: nil)
        }
    }
    
    
    func barButtonItemPressed(_ sender: UIBarButtonItem) {
        if sender === saveBarButtonItem {
            saveChangesAndLeaveIfSuccess()
        } else if sender === cancelBarButtonItem {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
