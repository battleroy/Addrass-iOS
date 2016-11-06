//
//  SignInViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    // MARK: Variables
    
    static let textFieldPadding = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
    
    var headerLabel: UILabel?
    
    var loginTextField: ADPaddedTextField?
    var passwordTextField: ADPaddedTextField?
    
    var loginButton: UIButton?
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ad.darkGray

        headerLabel = UILabel()
        headerLabel?.textColor = UIColor.ad.white
        headerLabel?.font = UIFont.ad.heading1Font
        headerLabel?.text = String.ad.introduceYourself
        view.addSubview(headerLabel!)
        
        loginTextField = ADPaddedTextField(forPadding: SignInViewController.textFieldPadding)
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
        view.addSubview(loginTextField!)
        
        passwordTextField = ADPaddedTextField(forPadding: SignInViewController.textFieldPadding)
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
        view.addSubview(passwordTextField!)
        
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
        view.addSubview(loginButton!)
        
        setConstraints()
    }
    
    
    // MARK: Overrides
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    
    // MARK: Private methods
    
    func setConstraints() {
        
        headerLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(loginTextField!)
            make.bottom.equalTo(loginTextField!.snp.top).offset(-50.0)
        })
        
        loginTextField?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(view).inset(UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0))
            make.centerY.equalTo(view)
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
        })
        
    }

}
