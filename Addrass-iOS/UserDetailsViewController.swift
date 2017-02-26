//
//  ContactDetailsViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 15/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class UserDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables
    
    private static let imageViewSize: CGFloat = 100.0
    
    var userLogin: String?
    var fetchedUser: User? {
        didSet {
            updateView()
        }
    }
    
    var leftBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    
    var headerContainerView: UIView!
    var userNameLabel: UILabel!
    var userImageView: UIImageView!
    var eventsButton: UIButton!
    
    var infoTableView: UITableView!
    
    var footerContainerView: UIView!
    var deleteButton: UIButton!
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = UIColor.ad.darkGray
        edgesForExtendedLayout = []
        
        setupNavigationBar()
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.user(byLogin: userLogin) { (fetchedUser, fetchErrorText) in
            if fetchErrorText == nil {
                self.fetchedUser = fetchedUser
            } else {
                UIAlertController.presentErrorAlert(withText: fetchErrorText!, parentController: self)
            }
        }
    }
    
    
    // MARK: Private methods
    
    func setupNavigationBar() {
        
        leftBarButtonItem = UIBarButtonItem(title: String.ad.close, style: .plain, target: self, action: #selector(barButtonItemWasPressed(_:)))
        rightBarButtonItem = UIBarButtonItem(title: String.ad.edit, style: .plain, target: self, action: #selector(barButtonItemWasPressed(_:)))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupSubviews() {
        
        infoTableView = UITableView()
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: UserInfoTableViewCell.cellIdentifier)
        infoTableView.backgroundColor = UIColor.ad.gray
        infoTableView.separatorStyle = .singleLine;
        view.addSubview(infoTableView)
        
        headerContainerView = UIView()
        headerContainerView.backgroundColor = UIColor.ad.darkGray
        view.addSubview(headerContainerView)
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.ad.largeBoldFont
        userNameLabel.textColor = UIColor.ad.white
        headerContainerView.addSubview(userNameLabel)
        
        userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = UserDetailsViewController.imageViewSize / 2
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderColor = UIColor.ad.yellow.cgColor
        userImageView.layer.borderWidth = 1.0
        headerContainerView.addSubview(userImageView)
        
        eventsButton = ADIconButton.createButton(withButtonType: .events)
        eventsButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        headerContainerView.addSubview(eventsButton)
        
        footerContainerView = UIView()
        footerContainerView.backgroundColor = UIColor.ad.gray
        view.addSubview(footerContainerView)
        
        deleteButton = ADIconButton.createButton(withButtonType: .delete)
        deleteButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        footerContainerView.addSubview(deleteButton)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        infoTableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        headerContainerView.snp.makeConstraints({ (make) in
            make.height.equalTo(view).multipliedBy(0.3)
            make.left.right.top.equalTo(infoTableView)
        })
        
        userImageView.snp.makeConstraints({ (make) in
            make.centerX.equalTo(headerContainerView)
            make.bottom.equalTo(headerContainerView).offset(15.0)
            make.height.width.equalTo(UserDetailsViewController.imageViewSize)
        })
        
        userNameLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(headerContainerView)
            make.bottom.equalTo(userImageView.snp.top).offset(-16.0)
        })
        
        eventsButton.snp.makeConstraints({ (make) in
            make.right.equalTo(headerContainerView).offset(-8.0)
            make.bottom.equalTo(headerContainerView).offset(-8.0)
        })
        
        footerContainerView.snp.makeConstraints({ (make) in
            make.height.equalTo(view).multipliedBy(0.1)
            make.left.right.bottom.equalTo(view)
        })
        
        deleteButton.snp.makeConstraints({ (make) in
            make.left.equalTo(footerContainerView).offset(8.0)
            make.bottom.equalTo(footerContainerView).offset(-8.0)
        })
        
        infoTableView.contentInset = UIEdgeInsetsMake(0.3 * view.bounds.height, 0.0, 0.1 * view.bounds.height, 0.0)
    }
    
    
    func updateView() {
        
        userNameLabel.text = fetchedUser?.fullName
        
        let scrollPoint = CGPoint(x: 0.0, y: -infoTableView.contentInset.top)
        infoTableView.setContentOffset(scrollPoint, animated: false)
        
        if let currentUserLogin = userLogin, let editButton = navigationItem.rightBarButtonItem {
            let isEditingSelf = (currentUserLogin == SessionManager.currentUser?.login)
            
            editButton.isEnabled = isEditingSelf
            editButton.title = (isEditingSelf ? String.ad.edit : "")
            deleteButton.isHidden = isEditingSelf
        }
        
        infoTableView.reloadData()
        
        guard let imageLink = fetchedUser?.imageLink, let imageURL = URL(string: imageLink) else {
            userImageView.image = #imageLiteral(resourceName: "user-icon-placeholder")
            return
        }
        
        userImageView.af_setImage(withURL: imageURL, placeholderImage: #imageLiteral(resourceName: "user-icon-placeholder"))
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellIcon: UIImage?
        var cellType: String?
        var cellContent: String?
        
        switch indexPath.row {
        case 0:
            cellIcon = #imageLiteral(resourceName: "phone-light")
            cellType = String.ad.phone
            cellContent = fetchedUser?.phone
            break
        case 1:
            cellIcon = #imageLiteral(resourceName: "mail-light")
            cellType = String.ad.email
            cellContent = fetchedUser?.email
            break
        case 2:
            cellIcon = #imageLiteral(resourceName: "pin-light")
            cellType = String.ad.address
            cellContent = fetchedUser?.address
            break
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.cellIdentifier, for: indexPath) as! UserInfoTableViewCell
        cell.infoTypeIcon = cellIcon
        cell.infoTypeLabel.text = cellType
        cell.infoContentLabel.text = cellContent
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellContent: String?
        
        switch indexPath.row {
        case 0:
            cellContent = fetchedUser?.phone
            break
        case 1:
            cellContent = fetchedUser?.email
            break
        case 2:
            cellContent = fetchedUser?.address
            break
        default:
            break
        }
        
        return UserInfoTableViewCell.cellHeight(forInfoContent: cellContent)
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: Actions
    
    func barButtonItemWasPressed(_ sender: UIBarButtonItem?) {
        if sender === leftBarButtonItem {
            _ = navigationController?.popViewController(animated: true)
        } else {
            guard let currentUser = fetchedUser else {
                return
            }
            
            if currentUser.id == SessionManager.currentUser?.id {
                let uevc = UserEditViewController()
                navigationController?.pushViewController(uevc, animated: true)
            }
        }
    }
    
    
    func buttonWasPressed(_ sender: UIButton?) {
        if sender === deleteButton {
            if let currentUserLogin = fetchedUser?.login {
                APIManager.deleteFriend(currentUserLogin, completion: { errorText in
                    if let deleteErrorText = errorText {
                        UIAlertController.presentErrorAlert(withText: deleteErrorText, parentController: self)
                        return
                    }
                    
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
}
