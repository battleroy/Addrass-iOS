//
//  SignInViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Variables
    
    static let textFieldPadding = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    
    var contentScrollView: UIScrollView?
    
    var headerLabel: UILabel?
    var loginTextField: ADPaddedTextField?
    var passwordTextField: ADPaddedTextField?
    var loginButton: UIButton?
    
    var bottomSpaceAccumulator: CGFloat = 0.0
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardBoundsWillBeChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: self)
    }
    
    
    // MARK: Private methods
    
    func setupSubviews() {
        view.backgroundColor = UIColor.ad.darkGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
        
        contentScrollView = UIScrollView()
        view.addSubview(contentScrollView!)
        
        headerLabel = UILabel()
        headerLabel?.textColor = UIColor.ad.white
        headerLabel?.font = UIFont.ad.heading1Font
        headerLabel?.text = String.ad.introduceYourself
        contentScrollView?.addSubview(headerLabel!)
        
        loginTextField = ADPaddedTextField(forPadding: SignInViewController.textFieldPadding)
        loginTextField?.delegate = self
        loginTextField?.returnKeyType = .next
        loginTextField?.backgroundColor = UIColor.clear
        loginTextField?.font = UIFont.ad.bodyFont
        loginTextField?.textColor = UIColor.ad.white
        loginTextField?.attributedPlaceholder = NSAttributedString(
            string: String.ad.login,
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.lightGray
            ]
        )
        loginTextField?.layer.cornerRadius = 15.0
        loginTextField?.layer.borderColor = UIColor.white.cgColor
        loginTextField?.layer.borderWidth = 1.0
        contentScrollView?.addSubview(loginTextField!)
        
        passwordTextField = ADPaddedTextField(forPadding: SignInViewController.textFieldPadding)
        passwordTextField?.delegate = self
        passwordTextField?.returnKeyType = .done
        passwordTextField?.backgroundColor = UIColor.clear
        passwordTextField?.font = UIFont.ad.bodyFont
        passwordTextField?.textColor = UIColor.ad.white
        passwordTextField?.attributedPlaceholder = NSAttributedString(
            string: String.ad.password,
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.lightGray
            ]
        )
        passwordTextField?.layer.cornerRadius = 15.0
        passwordTextField?.layer.borderColor = UIColor.white.cgColor
        passwordTextField?.layer.borderWidth = 1.0
        contentScrollView?.addSubview(passwordTextField!)
        
        loginButton = UIButton(type: .roundedRect)
        loginButton?.backgroundColor = UIColor.yellow
        loginButton?.setAttributedTitle(
            NSAttributedString(string: String.ad.enter, attributes: [
                NSFontAttributeName: UIFont.ad.boldFont,
                NSForegroundColorAttributeName: UIColor.darkGray
                ]),
            for: .normal)
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.cornerRadius = 20.0
        contentScrollView?.addSubview(loginButton!)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        contentScrollView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        headerLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(loginTextField!)
            make.bottom.equalTo(loginTextField!.snp.top).offset(-50.0)
        })
        
        loginTextField?.snp.makeConstraints({ (make) in
            let insets = UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)
            
            make.left.right.equalTo(view).inset(insets)
            make.left.right.equalTo(contentScrollView!).inset(insets)
            make.centerY.equalTo(contentScrollView!)
            make.height.equalTo(40.0)
        })
        
        passwordTextField?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(loginTextField!)
            make.top.equalTo(loginTextField!.snp.bottom).offset(10.0)
            make.height.equalTo(loginTextField!)
        })
        
        loginButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(passwordTextField!)
            make.top.equalTo(passwordTextField!.snp.bottom).offset(10.0)
            make.width.equalTo(60.0)
            make.height.equalTo(40.0)
            make.bottom.equalTo(contentScrollView!).offset(-10.0)
        })
        
    }
    
    
    // MARK: Actions
    
    func backgroundTapped(_ sender: UIView) {
        
        loginTextField?.resignFirstResponder()
        passwordTextField?.resignFirstResponder()
        
    }
    
    
    // MARK: Notifications
    
    func keyboardBoundsWillBeChanged(_ note: Notification) {
        if let beginRect = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
           let endRect   = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let deltaY = beginRect.origin.y + beginRect.size.height - (endRect.origin.y + endRect.size.height);
            bottomSpaceAccumulator += deltaY;
            
            let newInsets = UIEdgeInsetsMake(0.0, 0.0, bottomSpaceAccumulator, 0.0)
            contentScrollView?.contentInset = newInsets
            contentScrollView?.scrollIndicatorInsets = newInsets
            
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField?.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField?.resignFirstResponder()
        }
        
        return true
    }

}
