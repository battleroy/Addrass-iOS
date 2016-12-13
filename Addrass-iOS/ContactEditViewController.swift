//
//  ContactEditViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class ContactEditViewController: ScrollableContentViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Variables
    
    private let imageViewSize: CGFloat         = 100.0
    
    private let textFieldPadding: UIEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    private let textFieldHeight: CGFloat       = 40.0
    private let textFieldCornerRadius: CGFloat = 15.0
    
    var nameTextField: ADPaddedTextField!
    var groupSegmentedControl: UISegmentedControl!
    var colorSegmentedColor: UISegmentedControl!
    var imageView: UIImageView!
    var phoneTextField: ADPaddedTextField!
    var emailTextField: ADPaddedTextField!
    var companyTextField: ADPaddedTextField!
    var addressTextField: ADPaddedTextField!
    var notesTextField: ADPaddedTextField!
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ad.darkGray
        title = String.ad.edit

        setupSubviews()
    }
    
    
    // MARK: Private methods
    
    func setupSubviews() {
        
        nameTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.name, withSafeInput: false)
        phoneTextField = createTextField(withReturnType: .next, keyboardType: .phonePad, placeholder: String.ad.phone, withSafeInput: false)
        emailTextField = createTextField(withReturnType: .next, keyboardType: .emailAddress, placeholder: String.ad.email, withSafeInput: false)
        companyTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.company, withSafeInput: false)
        addressTextField = createTextField(withReturnType: .next, keyboardType: .default, placeholder: String.ad.address, withSafeInput: false)
        notesTextField = createTextField(withReturnType: .done, keyboardType: .default, placeholder: String.ad.notes, withSafeInput: false)
        
        
        groupSegmentedControl = UISegmentedControl(items: [String.ad.family, String.ad.friends, String.ad.work, String.ad.others])
        groupSegmentedControl.tintColor = UIColor.ad.yellow
        contentScrollView.addSubview(groupSegmentedControl)
        
        
        colorSegmentedColor = UISegmentedControl(items: ["A", "B", "C"])
        colorSegmentedColor.tintColor = UIColor.ad.yellow
        contentScrollView.addSubview(colorSegmentedColor)
        
        
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
        
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentScrollView).offset(10.0)
            make.width.height.equalTo(imageViewSize)
        }
        
        
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewSize).offset(10.0)
            make.left.equalTo(imageView.snp.right).offset(10.0)
            make.right.equalTo(contentScrollView).offset(-10.0)
            make.right.equalTo(view).offset(-10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        groupSegmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(10.0)
        }
        
        
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(imageView)
            make.right.equalTo(nameTextField)
            make.top.equalTo(imageView.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        companyTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        addressTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(companyTextField.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
        }
        
        
        notesTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(addressTextField.snp.bottom).offset(10.0)
            make.height.equalTo(textFieldHeight)
            make.bottom.equalTo(contentScrollView).offset(10.0)
        }
        
        
        colorSegmentedColor.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(notesTextField.snp.bottom).offset(10.0)
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
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            companyTextField.becomeFirstResponder()
        } else if textField == companyTextField {
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            notesTextField.becomeFirstResponder()
        } else if textField == notesTextField {
            notesTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
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
}
