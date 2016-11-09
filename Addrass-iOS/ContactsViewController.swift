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
    
    var contactsTableView: UITableView?
    var searchBarContainerView: UIView?
    weak var searchBar: UISearchBar?
    var users: [User]?
    
    var searchBarConstraints: [Constraint]?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = true
        title = "Contacts"
        view.backgroundColor = UIColor.ad.gray
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        users = [
            User(withName: "Sergei Zyazulkin", group: "Gods", image: UIImage(named: "logo"), color: UIColor.red),
            User(withName: "Stanislav Baretskiy", group: "Beer Lovers", image: UIImage(named: "logo"), color: UIColor.green)
        ]
        
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactsTableView?.reloadData()
    }
    
    
    // MARK: Private Methods
    
    func setupSubviews() {
        
        searchBarContainerView = UIView()
        view.addSubview(searchBarContainerView!)
        
        searchBar = searchController.searchBar
        searchBar?.delegate = self
        searchBar?.backgroundImage = UIImage()
        searchBarContainerView?.addSubview(searchBar!)
        
        contactsTableView = UITableView()
        contactsTableView?.backgroundColor = UIColor.ad.gray
        contactsTableView?.dataSource = self
        contactsTableView?.delegate = self
        contactsTableView?.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.cellIdentifier)
        contactsTableView?.tableFooterView = UIView()
        
        view.addSubview(contactsTableView!)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        searchBarContainerView?.snp.makeConstraints({ (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(44.0)
        })
        
        contactsTableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(searchBarContainerView!.snp.bottom)
            make.left.right.bottom.equalTo(view)
        })
        
        searchBar?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchBar?.translatesAutoresizingMaskIntoConstraints = true
        searchBar?.frame = CGRect.zero
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.cellIdentifier, for: indexPath) as! ContactTableViewCell
        
        if let users = users {
            
            cell.updateCell(withContact: users[indexPath.row])
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let users = users {
            return ContactTableViewCell.cellHeight(forContact: users[indexPath.row])
        }
        
        return 0.0
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
}
