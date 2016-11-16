//
//  SignInViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    // MARK: Variables
    
    var headerImageView: UIImageView?
    var headerLabel: UILabel?
    
    var signInButton: UIButton?
    var signUpButton: UIButton?
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    
    // MARK: Private Methods
    
    func setupSubviews() {
        view.backgroundColor = UIColor.ad.darkGray
        
        headerImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        headerImageView?.contentMode = .scaleAspectFit
        view.addSubview(headerImageView!)
        
        headerLabel = UILabel()
        headerLabel?.font = UIFont.ad.heading1Font
        headerLabel?.textColor = UIColor.ad.white
        headerLabel?.text = String.ad.welcome
        view.addSubview(headerLabel!)
        
        signInButton = UIButton(type: .roundedRect)
        signInButton?.backgroundColor = UIColor.yellow
        signInButton?.setAttributedTitle(
            NSAttributedString(string: String.ad.signIn, attributes: [
                NSFontAttributeName: UIFont.ad.boldFont,
                NSForegroundColorAttributeName: UIColor.darkGray
                ]),
            for: .normal)
        signInButton?.layer.borderWidth = 1.0
        signInButton?.layer.borderColor = UIColor.ad.darkGray.cgColor
        signInButton?.layer.masksToBounds = true
        signInButton?.layer.cornerRadius = 20.0
        signInButton?.addTarget(self, action: #selector(signInButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(signInButton!)
        
        signUpButton = UIButton(type: .roundedRect)
        signUpButton?.backgroundColor = UIColor.ad.darkGray
        signUpButton?.setAttributedTitle(
            NSAttributedString(string: String.ad.signUp, attributes: [
                NSFontAttributeName: UIFont.ad.boldFont,
                NSForegroundColorAttributeName: UIColor.yellow
                ]),
            for: .normal)
        signUpButton?.layer.borderWidth = 1.0
        signUpButton?.layer.borderColor = UIColor.ad.yellow.cgColor
        signUpButton?.layer.masksToBounds = true
        signUpButton?.layer.cornerRadius = 20.0
        signUpButton?.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(signUpButton!)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        headerImageView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(headerLabel!.snp.top).offset(-60.0)
            make.left.equalTo(headerLabel!)
            make.height.width.equalTo(60.0)
        })
        
        headerLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(signInButton!)
            make.bottom.equalTo(signInButton!.snp.top).offset(-60.0)
        })
        
        signInButton?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(view).inset(UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0))
            make.centerY.equalTo(view)
            make.height.equalTo(40.0)
        })
        
        signUpButton?.snp.makeConstraints({ (make) in
            make.left.right.height.equalTo(signInButton!)
            make.top.equalTo(signInButton!.snp.bottom).offset(10.0)
        })
    }
    
    
    // MARK: Actions
    
    func signInButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    
    func signUpButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
}
