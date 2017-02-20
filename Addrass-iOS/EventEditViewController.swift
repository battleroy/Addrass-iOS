//
//  EventEditViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import CZPicker

class EventEditViewController: ScrollableContentViewController, CZPickerViewDataSource, CZPickerViewDelegate {
    
    // MARK: Constants
    
    static let textFieldInset: CGFloat = 8.0
    static let textFieldHeight: CGFloat = 40.0
    static let eventTypes = Event.EventType.allValues.map { $0.stringValue }
    
    
    // MARK: Variables
    
    var eventData: Event!
    
    var friendsArray: [User]?
    var friendsAreMemberArray: [Bool]?
    
    var nameTextField: ADPaddedTextField!
    var ownerLabel: UILabel!
    var membersLabel: UILabel!
    var editMembersButton: UIButton!
    var datePicker: UIDatePicker!
    var eventTypeSegmentedControl: UISegmentedControl!
    
    var friendsPicker: CZPickerView!
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.ad.edit
        contentScrollView.backgroundColor = UIColor.ad.gray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String.ad.cancel, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.ad.save, style: .done, target: self, action: #selector(barButtonPressed(_:)))
        
        createSubviews()
        setConstraints()
        
        updateView()
    }
    
    
    // MARK: Private methods
    
    func createSubviews() {
        
        ownerLabel = UILabel()
        ownerLabel.font = UIFont.ad.bodyFont
        ownerLabel.textColor = UIColor.ad.white
        ownerLabel.textAlignment = .center
        contentScrollView.addSubview(ownerLabel)
        
        let inset = EventEditViewController.textFieldInset
        nameTextField = ADPaddedTextField(forPadding: UIEdgeInsetsMake(inset, inset, inset, inset))
        nameTextField.backgroundColor = UIColor.clear
        nameTextField.font = UIFont.ad.bodyFont
        nameTextField.textColor = UIColor.ad.white
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: String.ad.name,
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.lightGray
            ]
        )
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.layer.borderWidth = 1.0
        contentScrollView.addSubview(nameTextField)
        
        membersLabel = UILabel()
        membersLabel.font = UIFont.ad.bodyFont
        membersLabel.textColor = UIColor.ad.lightGray
        membersLabel.numberOfLines = 0
        contentScrollView.addSubview(membersLabel)
        
        editMembersButton = UIButton()
        editMembersButton.setAttributedTitle(
            NSAttributedString(
                string: String.ad.edit,
                attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.yellow
                ]
            ),
            for: .normal
        )
        editMembersButton.setTitleColor(UIColor.ad.yellow, for: .normal)
        editMembersButton.addTarget(self, action: #selector(editContactsButtonPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(editMembersButton)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date().addingTimeInterval(10.0 * 60.0)
        datePicker.setValue(UIColor.ad.white, forKeyPath: "textColor")
        contentScrollView.addSubview(datePicker)
        
        eventTypeSegmentedControl = UISegmentedControl(items: EventEditViewController.eventTypes)
        eventTypeSegmentedControl.selectedSegmentIndex = 0
        eventTypeSegmentedControl.tintColor = UIColor.ad.yellow
        contentScrollView.addSubview(eventTypeSegmentedControl)
        
        friendsPicker = CZPickerView(headerTitle: String.ad.members, cancelButtonTitle: String.ad.cancel, confirmButtonTitle: String.ad.save)
        friendsPicker.dataSource = self
        friendsPicker.delegate = self
        friendsPicker.tapBackgroundToDismiss = false
        friendsPicker.allowMultipleSelection = true
        friendsPicker.checkmarkColor = UIColor.ad.yellow
        friendsPicker.headerBackgroundColor = UIColor.ad.darkGray
        friendsPicker.headerTitleFont = UIFont.ad.boldFont
        friendsPicker.headerTitleColor = UIColor.ad.white
        friendsPicker.cancelButtonBackgroundColor = UIColor.ad.darkGray
        friendsPicker.cancelButtonNormalColor = UIColor.ad.white
        friendsPicker.cancelButtonHighlightedColor = UIColor.ad.white
        friendsPicker.confirmButtonBackgroundColor = UIColor.ad.darkGray
        friendsPicker.confirmButtonNormalColor = UIColor.ad.white
        friendsPicker.confirmButtonHighlightedColor = UIColor.ad.white
    }
    
    
    func setConstraints() {
        
        ownerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(8.0)
            make.left.top.equalTo(contentScrollView).offset(8.0)
            make.right.equalTo(view).offset(-8.0)
            make.right.equalTo(contentScrollView).offset(-8.0)
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(ownerLabel)
            make.top.equalTo(ownerLabel.snp.bottom).offset(8.0)
            make.height.equalTo(EventEditViewController.textFieldHeight)
        }
        
        membersLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTextField)
            make.top.equalTo(nameTextField.snp.bottom).offset(8.0)
        }
        
        editMembersButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(membersLabel)
            make.top.equalTo(membersLabel.snp.bottom)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(editMembersButton.snp.bottom).offset(8.0)
        }
        
        eventTypeSegmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTextField)
            make.top.equalTo(datePicker.snp.bottom).offset(8.0)
            make.bottom.equalTo(contentScrollView).offset(-8.0)
        }
        
    }
    
    
    func reloadData() {
        ownerLabel.text = String.ad.owner + ": " + SessionManager.currentUser!.fullName
        
        guard let friends = friendsArray, let memberIndicesArray = friendsAreMemberArray, let event = eventData else {
            return
        }
        
        
        var members = [User]()
        for i in 0..<friends.count {
            if memberIndicesArray[i] {
                members.append(friends[i])
            }
        }
        
        membersLabel.text = String.ad.members + ": " + members.map {
            $0.fullName
        }.joined(separator: ", ")
        
        
        datePicker.date = event.date!
    }
    
    
    func updateView() {
        friendsArray = nil
        friendsAreMemberArray = nil
        
        var friendsAreMembersDict = [User : Bool]()
        
        guard let eventID = eventData?.id else {
            return
        }
        
        APIManager.membersFromEvent(forEventID: eventID) { (fetchedMembers, fetchMembersError) in
            if let members = fetchedMembers {
                
                for member in members {
                    friendsAreMembersDict[member] = true
                }
            
                APIManager.friendsNotInEvent(forEventID: eventID) { (fetchedFriends, fetchErrorText) in
                    if let notMembers = fetchedFriends {
                        
                        for notMember in notMembers {
                            friendsAreMembersDict[notMember] = false
                        }
                        
                        self.friendsArray = [User]()
                        self.friendsAreMemberArray = [Bool]()
                        
                        for friend in Array(friendsAreMembersDict.keys).sorted(by: { $0.fullName < $1.fullName }) {
                            self.friendsArray!.append(friend)
                            self.friendsAreMemberArray!.append(friendsAreMembersDict[friend]!)
                        }
                        
                    } else {
                        UIAlertController.presentErrorAlert(withText: fetchErrorText!, parentController: self)
                    }
                    
                    self.friendsPicker.reloadData()
                }
            } else {
                self.membersLabel.text = String.ad.thereAreNoMembers
                UIAlertController.presentErrorAlert(withText: fetchMembersError!, parentController: self)
            }
        }
    }
    
    
    // MARK: CZPickerViewDataSource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        guard let friends = friendsArray else {
            return 0
        }
        
        return friends.count
    }
    
    
    func czpickerView(_ pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        guard let friends = friendsArray else {
            return NSAttributedString(string: "")
        }
        
        return NSAttributedString(
            string: friends[row].fullName,
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.white
            ]
        )
    }
    
    
    // MARK: CZPickerViewDelegate
    
    func czpickerViewWillDisplay(_ pickerView: CZPickerView!) {
        guard let members = friendsAreMemberArray else {
            return
        }
        
        var selectedIndices = [Int]()
        
        for i in 0..<members.count {
            if members[i] {
                selectedIndices.append(i)
            }
        }
        
        pickerView.setSelectedRows(selectedIndices)
    }
    
    
    func czpickerViewWillDismiss(_ pickerView: CZPickerView!) {
        guard let friends = friendsArray else {
            return
        }
        
        friendsAreMemberArray = [Bool](repeating: false, count: friends.count)
        
        for selectedMemberIndex in pickerView.selectedRows() {
            friendsAreMemberArray![selectedMemberIndex as! Int] = true
        }
    }
    
    
    // MARK: Actions
    
    func editContactsButtonPressed(_ sender: UIButton) {
        friendsPicker.show()
    }
    
    
    func barButtonPressed(_ sender: UIBarButtonItem) {
        if (sender == navigationItem.leftBarButtonItem) {
            _ = navigationController?.popViewController(animated: true)
        } else if (sender == navigationItem.rightBarButtonItem) {
            
        }
    }

}
