//
//  ContactsViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Variables
    
    var contactsTableView: UITableView!
    var searchBarContainerView: UIView!
    var searchBar: UISearchBar?
    
    var signOutButton: UIBarButtonItem!
    var addContactButton: UIBarButtonItem!
    
    var searchBarConstraints: [Constraint]?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var contacts: [User]?
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = true
        title = String.ad.contacts
        view.backgroundColor = UIColor.ad.gray
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.contacts(forUser: SessionManager.currentUser!) { (contacts, errorText) in
            guard let userContacts = contacts else {
                UIAlertController.presentErrorAlert(withText: errorText!, parentController: self)
                return
            }
            
            self.contacts = userContacts
            self.contactsTableView.reloadData()
        }
        
    }
    
    
    // MARK: Private Methods
    
    func setupSubviews() {
        
        searchBarContainerView = UIView()
        view.addSubview(searchBarContainerView)
        
        searchBar = searchController.searchBar
        searchBar?.delegate = self
        searchBar?.backgroundImage = UIImage()
        searchBarContainerView.addSubview(searchBar!)
        
        contactsTableView = UITableView()
        contactsTableView.backgroundColor = UIColor.ad.gray
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        contactsTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.cellIdentifier)
        contactsTableView.tableFooterView = UIView()
        contactsTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, tabBarController?.tabBar.bounds.height ?? 0.0, 0.0)
        
        view.addSubview(contactsTableView)
        
        signOutButton = UIBarButtonItem(title: String.ad.signOut, style: .plain, target: self, action: #selector(barButtonItemPressed(_:)))
        navigationItem.leftBarButtonItem = signOutButton
        
        addContactButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemPressed(_:)))
        navigationItem.rightBarButtonItem = addContactButton
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        searchBarContainerView.snp.makeConstraints({ (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(44.0)
        })
        
        contactsTableView.snp.makeConstraints({ (make) in
            make.top.equalTo(searchBarContainerView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        })
        
        searchBar?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchBar?.translatesAutoresizingMaskIntoConstraints = true
        searchBar?.frame = CGRect.zero
    }
    
    
    func user(forRow row: Int) -> User {
        
        var cellUser: User? = nil
        if row == 0 {
            cellUser = SessionManager.currentUser!
        } else if let userContacts = contacts {
            cellUser = userContacts[row - 1]
        }
        
        return cellUser!
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (contacts != nil ? contacts!.count : 0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.cellIdentifier, for: indexPath) as! ContactTableViewCell

        
        cell.updateCell(withContact: user(forRow: indexPath.row))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ContactTableViewCell.cellHeight(forContact: user(forRow: indexPath.row))
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cdvc = ContactDetailsViewController()
        cdvc.user = user(forRow: indexPath.row)
        
        navigationController?.pushViewController(cdvc, animated: true)
    }
    
    
    // MARK: UISearchBarDelegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarConstraints?.forEach({
            $0.deactivate()
        })
        
        return true
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarConstraints?.forEach({
            $0.activate()
        })
        
        return true
    }
    
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    // MARK: Actions
    
    func barButtonItemPressed(_ sender: UIBarButtonItem) {
        if sender == signOutButton {
            APIManager.signOut {
                self.dismiss(animated: true, completion: nil)
            }
        } else if sender == addContactButton {
            let cevc = ContactEditViewController()
            cevc.existingContact = nil
            navigationController?.pushViewController(cevc, animated: true)
        }
    }
}
