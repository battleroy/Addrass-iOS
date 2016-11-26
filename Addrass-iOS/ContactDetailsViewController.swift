//
//  ContactDetailsViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 15/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class ContactDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables
    
    private static let imageViewSize: CGFloat = 100.0
    private static let buttonIconSize: CGFloat = 15.0
    
    var user: User?
    
    var leftBarButtonItem: UIBarButtonItem?
    var rightBarButtonItem: UIBarButtonItem?
    
    var headerContainerView: UIView?
    var contactNameLabel: UILabel?
    var contactGroupLabel: UILabel?
    var contactImageView: UIImageView?
    var colorButton: UIButton?
    var colorIconView: UIView?
    var eventsButton: UIButton?
    var eventsImageView: UIImageView?
    
    var infoTableView: UITableView?
    
    var footerContainerView: UIView?
    var deleteButton: UIButton?
    var deleteImageView: UIImageView?
    var blacklistButton: UIButton?
    var blacklistImageView: UIView?
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.ad.details
        view.backgroundColor = UIColor.ad.darkGray
        
        setupNavigationBar()
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
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
        infoTableView?.dataSource = self
        infoTableView?.delegate = self
        infoTableView?.register(ContactInfoTableViewCell.self, forCellReuseIdentifier: ContactInfoTableViewCell.cellIdentifier)
        infoTableView?.backgroundColor = UIColor.ad.gray
        infoTableView?.separatorStyle = .none;
        view.addSubview(infoTableView!)
        
        headerContainerView = UIView()
        headerContainerView?.backgroundColor = UIColor.ad.darkGray
        view.addSubview(headerContainerView!)
        
        contactNameLabel = UILabel()
        contactNameLabel?.font = UIFont.ad.largeBoldFont
        contactNameLabel?.textColor = UIColor.ad.white
        headerContainerView?.addSubview(contactNameLabel!)
        
        contactGroupLabel = UILabel()
        contactGroupLabel?.font = UIFont.ad.bodyFont
        contactGroupLabel?.textColor = UIColor.ad.white
        headerContainerView?.addSubview(contactGroupLabel!)
        
        contactImageView = UIImageView()
        contactImageView?.contentMode = .scaleAspectFill
        contactImageView?.layer.cornerRadius = ContactDetailsViewController.imageViewSize / 2
        contactImageView?.layer.masksToBounds = true
        contactImageView?.layer.borderColor = UIColor.ad.yellow.cgColor
        contactImageView?.layer.borderWidth = 1.0
        headerContainerView?.addSubview(contactImageView!)
        
        colorIconView = UIView()
        colorIconView?.layer.cornerRadius = ContactDetailsViewController.buttonIconSize / 2
        colorIconView?.layer.masksToBounds = true
        colorButton = createIconButton(colorIconView!, title: String.ad.color)
        headerContainerView?.addSubview(colorButton!)
        
        eventsImageView = UIImageView(image: UIImage(named: "calendar-light"))
        eventsImageView?.contentMode = .scaleAspectFit
        eventsButton = createIconButton(eventsImageView!, title: String.ad.events)
        headerContainerView?.addSubview(eventsButton!)
        
        footerContainerView = UIView()
        footerContainerView?.backgroundColor = UIColor.ad.gray
        view.addSubview(footerContainerView!)
        
        deleteImageView = UIImageView(image: UIImage(named: "delete-light"))
        deleteImageView?.contentMode = .scaleAspectFit
        deleteButton = createIconButton(deleteImageView!, title: String.ad.delete)
        footerContainerView?.addSubview(deleteButton!)
        
        blacklistImageView = UIImageView(image: UIImage(named: "blacklist-light"))
        blacklistImageView?.contentMode = .scaleAspectFit
        blacklistButton = createIconButton(blacklistImageView!, title: String.ad.toBlacklist)
        footerContainerView?.addSubview(blacklistButton!)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        infoTableView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
        
        headerContainerView?.snp.makeConstraints({ (make) in
            make.height.equalTo(view).multipliedBy(0.3)
            make.left.right.top.equalTo(infoTableView!)
        })
        
        contactImageView?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(headerContainerView!)
            make.bottom.equalTo(headerContainerView!).offset(15.0)
            make.height.width.equalTo(ContactDetailsViewController.imageViewSize)
        })
        
        contactGroupLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(headerContainerView!)
            make.bottom.equalTo(contactImageView!.snp.top).offset(-8.0)
        })
        
        contactNameLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(headerContainerView!)
            make.bottom.equalTo(contactGroupLabel!.snp.top).offset(-8.0)
        })
        
        colorButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(headerContainerView!).offset(5.0)
            make.bottom.equalTo(headerContainerView!).offset(-5.0)
        })
        
        eventsButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(headerContainerView!).offset(-5.0)
            make.bottom.equalTo(headerContainerView!).offset(-5.0)
        })
        
        footerContainerView?.snp.makeConstraints({ (make) in
            make.height.equalTo(view).multipliedBy(0.1)
            make.left.right.bottom.equalTo(view)
        })
        
        deleteButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(footerContainerView!).offset(5.0)
            make.bottom.equalTo(footerContainerView!).offset(-5.0)
        })
        
        blacklistButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(footerContainerView!).offset(-5.0)
            make.bottom.equalTo(footerContainerView!).offset(-5.0)
        })
        
        infoTableView?.contentInset = UIEdgeInsetsMake(0.3 * view.bounds.height, 0.0, 0.1 * view.bounds.height, 0.0)
    }
    
    
    func createIconButton(_ iconView: UIView, title: String) -> UIButton {
        
        let button = UIButton()
        
        button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 10.0 + ContactDetailsViewController.buttonIconSize, 5.0, 5.0)
        
        button.setAttributedTitle(NSAttributedString(
            string: title, attributes: [
                NSFontAttributeName: UIFont.ad.boldFont,
                NSForegroundColorAttributeName: UIColor.ad.white
            ]
        ), for: .normal)
        button.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        
        button.addSubview(iconView)
        iconView.layer.position = CGPoint(x: 5.0 + ContactDetailsViewController.buttonIconSize / 2, y: 5.0 + ContactDetailsViewController.buttonIconSize / 2)
        iconView.bounds = CGRect(x: 0.0, y: 0.0, width: ContactDetailsViewController.buttonIconSize, height: ContactDetailsViewController.buttonIconSize)
        
        return button
    }
    
    
    func updateView() {
        
        contactNameLabel?.text = user?.name
        contactGroupLabel?.text = user?.group
        contactImageView?.image = user?.image
        colorIconView?.backgroundColor = user?.color
        
        let scrollPoint = CGPoint(x: 0.0, y: -infoTableView!.contentInset.top)
        infoTableView?.setContentOffset(scrollPoint, animated: false)
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cellIcon: UIImage?
        var cellType: String?
        var cellContent: String?
        
        switch indexPath.row {
        case 0:
            cellIcon = #imageLiteral(resourceName: "phone-light")
            cellType = String.ad.phone
            cellContent = user?.phone
            break
        case 1:
            cellIcon = #imageLiteral(resourceName: "mail-light")
            cellType = String.ad.email
            cellContent = user?.email
            break
        case 2:
            cellIcon = #imageLiteral(resourceName: "factory-light")
            cellType = String.ad.company
            cellContent = user?.company
            break
        case 3:
            cellIcon = #imageLiteral(resourceName: "pin-light")
            cellType = String.ad.address
            cellContent = user?.address
            break
        case 4:
            cellIcon = #imageLiteral(resourceName: "notes-light")
            cellType = String.ad.notes
            cellContent = user?.notes
            break
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactInfoTableViewCell.cellIdentifier, for: indexPath) as! ContactInfoTableViewCell
        cell.infoTypeIcon = cellIcon
        cell.infoTypeLabel.text = cellType
        cell.infoContentLabel.text = cellContent
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellContent: String?
        
        switch indexPath.row {
        case 0:
            cellContent = user?.phone
            break
        case 1:
            cellContent = user?.email
            break
        case 2:
            cellContent = user?.company
            break
        case 3:
            cellContent = user?.address
            break
        case 4:
            cellContent = user?.notes
            break
        default:
            break
        }
        
        return ContactInfoTableViewCell.cellHeight(forInfoContent: cellContent)
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: Actions
    
    func barButtonItemWasPressed(_ sender: UIBarButtonItem?) {
        if sender == leftBarButtonItem {
            _ = navigationController?.popViewController(animated: true)
        } else if sender == rightBarButtonItem {
            
        }
    }
    
    
    func buttonWasPressed(_ sender: UIButton?) {
        
    }
    
}
