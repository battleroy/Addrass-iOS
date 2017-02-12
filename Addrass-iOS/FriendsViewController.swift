//
//  ContactsViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Variables
    
    var friendsTableView: UITableView!
    var searchBarContainerView: UIView!
    var searchBar: UISearchBar?
    
    var signOutButton: UIBarButtonItem!
    var addFriendButton: UIBarButtonItem!
    
    var searchBarConstraints: [Constraint]?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var friends: [User]?
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = true
        title = String.ad.friends
        view.backgroundColor = UIColor.ad.gray
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.friends(forUser: SessionManager.currentUser!) { (friends, errorText) in
            
            self.friends = friends
            
            if friends == nil {
                UIAlertController.presentErrorAlert(withText: errorText!, parentController: self)
            }
            
            self.friendsTableView.reloadData()
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
        
        friendsTableView = UITableView()
        friendsTableView.backgroundColor = UIColor.ad.gray
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.cellIdentifier)
        friendsTableView.tableFooterView = UIView()
        friendsTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, tabBarController?.tabBar.bounds.height ?? 0.0, 0.0)
        
        view.addSubview(friendsTableView)
        
        signOutButton = UIBarButtonItem(title: String.ad.signOut, style: .plain, target: self, action: #selector(barButtonItemPressed(_:)))
        navigationItem.leftBarButtonItem = signOutButton
        
        addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemPressed(_:)))
        navigationItem.rightBarButtonItem = addFriendButton
        
        setConstraints()
    }
    
    
    func setConstraints() {
        
        searchBarContainerView.snp.makeConstraints({ (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(44.0)
        })
        
        friendsTableView.snp.makeConstraints({ (make) in
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
        } else if let userFriends = friends {
            cellUser = userFriends[row - 1]
        }
                
        return cellUser!
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (friends != nil ? friends!.count : 0)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.cellIdentifier, for: indexPath) as! FriendTableViewCell

        cell.updateCell(withUser: user(forRow: indexPath.row))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return FriendTableViewCell.cellHeight(forContact: user(forRow: indexPath.row))
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let udvc = UserDetailsViewController()
        udvc.userLogin = user(forRow: indexPath.row).login
        
        navigationController?.pushViewController(udvc, animated: true)
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
        } else if sender == addFriendButton {
            // TODO: New friend search
        }
    }
}
