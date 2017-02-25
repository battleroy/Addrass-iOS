//
//  EventEditViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import CZPicker
import DatePickerDialog


class EventEditViewController: ScrollableContentViewController, CZPickerViewDataSource, CZPickerViewDelegate {
    
    // MARK: Constants
    
    static let textFieldInset: CGFloat = 8.0
    static let textFieldHeight: CGFloat = 40.0
    static let eventTypes = Event.EventType.allValues.map { $0.stringValue }
    
    
    // MARK: Variables
    
    var eventData: Event!
    
    
    var friendsArray: [User]?
    var friendsAreMemberArray: [Bool]?
    
    
    var nameShowContainer: UIView!
    var nameLabel: UILabel!
    var nameEditButton: UIButton!
    
    var nameEditContainer: UIView!
    var nameSaveButton: UIButton!
    var nameCancelButton: UIButton!
    var nameTextField: ADPaddedTextField!
    
    
    var ownerLabel: UILabel!
    
    
    var membersLabel: UILabel!
    var editMembersButton: UIButton!
    var membersPicker: CZPickerView!

    
    var dateLabel: UILabel!
    var dateEditButton: UIButton!
    
    
    var eventTypePicker: CZPickerView!
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.ad.edit
        contentScrollView.backgroundColor = UIColor.ad.gray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String.ad.cancel, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.ad.save, style: .done, target: self, action: #selector(barButtonPressed(_:)))
        
        createSubviews()
        setConstraints()
        
        reloadData()
    }
    
    
    // MARK: Private methods
    
    func createSubviews() {
        
        ownerLabel = UILabel()
        ownerLabel.font = UIFont.ad.boldFont
        ownerLabel.textColor = UIColor.ad.white
        ownerLabel.textAlignment = .center
        contentScrollView.addSubview(ownerLabel)
        
        
        nameShowContainer = UIView()
        nameShowContainer.isHidden = true
        contentScrollView.addSubview(nameShowContainer)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.ad.heading1Font
        nameLabel.textColor = UIColor.ad.white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameShowContainer.addSubview(nameLabel)
        
        nameEditButton = ADIconButton.createButton(withButtonType: .edit)
        nameEditButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        nameShowContainer.addSubview(nameEditButton)
        
        
        nameEditContainer = UIView()
        nameEditContainer.isHidden = true
        contentScrollView.addSubview(nameEditContainer)
        
        nameSaveButton = ADIconButton.createButton(withButtonType: .save)
        nameSaveButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        nameEditContainer.addSubview(nameSaveButton)
        
        nameCancelButton = ADIconButton.createButton(withButtonType: .cancel)
        nameCancelButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        nameEditContainer.addSubview(nameCancelButton)
        
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
        nameEditContainer.addSubview(nameTextField)
        
        
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
        editMembersButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(editMembersButton)
        
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.ad.bodyFont
        dateLabel.textColor = UIColor.ad.white
        contentScrollView.addSubview(dateLabel)
        
        dateEditButton = ADIconButton.createButton(withButtonType: .edit)
        dateEditButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(dateEditButton)
        
        
        membersPicker = CZPickerView(headerTitle: String.ad.members, cancelButtonTitle: String.ad.cancel, confirmButtonTitle: String.ad.save)
        membersPicker.dataSource = self
        membersPicker.delegate = self
        membersPicker.tapBackgroundToDismiss = false
        membersPicker.allowMultipleSelection = true
        membersPicker.checkmarkColor = UIColor.ad.yellow
        membersPicker.headerBackgroundColor = UIColor.ad.darkGray
        membersPicker.headerTitleFont = UIFont.ad.boldFont
        membersPicker.headerTitleColor = UIColor.ad.white
        membersPicker.cancelButtonBackgroundColor = UIColor.ad.darkGray
        membersPicker.cancelButtonNormalColor = UIColor.ad.white
        membersPicker.cancelButtonHighlightedColor = UIColor.ad.white
        membersPicker.confirmButtonBackgroundColor = UIColor.ad.darkGray
        membersPicker.confirmButtonNormalColor = UIColor.ad.white
        membersPicker.confirmButtonHighlightedColor = UIColor.ad.white
    }
    
    
    func setConstraints() {
        
        nameShowContainer.snp.remakeConstraints { (make) in
            make.left.equalTo(view).offset(8.0)
            make.right.equalTo(view).offset(-8.0)
            make.left.equalTo(contentScrollView).offset(8.0)
            make.right.equalTo(contentScrollView).offset(8.0)
            make.top.equalTo(contentScrollView).offset(8.0)
            make.bottom.equalTo(contentScrollView).offset(-8.0)
        }
        
        nameLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(nameShowContainer)
            make.top.bottom.equalTo(nameShowContainer)
            make.left.greaterThanOrEqualTo(nameShowContainer).offset(0.0)
        }
        
        nameEditButton.snp.remakeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(8.0)
            make.right.lessThanOrEqualTo(nameShowContainer).offset(0.0)
        }
        
        
        nameEditContainer.snp.remakeConstraints { (make) in
            make.left.equalTo(view).offset(8.0)
            make.right.equalTo(view).offset(-8.0)
            make.left.equalTo(contentScrollView).offset(8.0)
            make.right.equalTo(contentScrollView).offset(8.0)
            make.top.equalTo(contentScrollView).offset(8.0)
            make.bottom.equalTo(contentScrollView).offset(-8.0)
        }
        
        nameTextField.setContentHuggingPriority(100, for: .horizontal)
        nameTextField.snp.remakeConstraints { (make) in
            make.left.equalTo(nameEditContainer)
            make.top.bottom.equalTo(nameEditContainer)
            make.left.greaterThanOrEqualTo(nameEditContainer).offset(0.0)
        }
        
        nameSaveButton.snp.remakeConstraints { (make) in
            make.centerY.equalTo(nameTextField)
            make.left.equalTo(nameTextField.snp.right).offset(8.0).priority(800.0)
        }
        
        nameCancelButton.snp.remakeConstraints { (make) in
            make.centerY.equalTo(nameTextField)
            make.left.equalTo(nameSaveButton.snp.right).offset(8.0)
            make.right.equalTo(nameEditContainer)
        }
        
        
        ownerLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(nameEditContainer)
            make.top.equalTo(nameEditContainer.snp.bottom).offset(8.0)
        }
        
        
        membersLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameEditContainer)
            make.top.equalTo(ownerLabel.snp.bottom).offset(12.0)
        }
        
        editMembersButton.snp.remakeConstraints { (make) in
            make.right.equalTo(nameEditContainer)
            make.centerY.equalTo(membersLabel)
            make.left.greaterThanOrEqualTo(membersLabel.snp.right).offset(8.0)
        }
        
        
        dateLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameEditContainer)
            make.top.equalTo(membersLabel.snp.bottom).offset(8.0)
        }
        
        dateEditButton.snp.remakeConstraints { (make) in
            make.right.equalTo(nameEditContainer)
            make.centerY.equalTo(dateLabel)
            make.left.greaterThanOrEqualTo(dateLabel.snp.right).offset(8.0)
        }
    }
    
    
    func updateView() {
        guard let friends = friendsArray, let memberIndicesArray = friendsAreMemberArray, let event = eventData else {
            return
        }
        
        ownerLabel.text = String.ad.owner + ": " + event.owner!.fullName
        nameLabel.text = event.name
        nameTextField.text = event.name
        dateLabel.text = DateFormatter.fullDateFormatter.string(from: event.date!)
        
        nameEditContainer.isHidden = false
        
        var members = [User]()
        for i in 0..<friends.count {
            if memberIndicesArray[i] {
                members.append(friends[i])
            }
        }
        
        if members.count > 0 {
            membersLabel.text = String.ad.members + ": " + members.map {
                $0.fullName
            }.joined(separator: ", ")
        } else {
            membersLabel.text = String.ad.thereAreNoMembers
        }
        
        
        self.membersPicker.reloadData()
    }
    
    
    func reloadData() {
        friendsArray = nil
        friendsAreMemberArray = nil
        
        var friendsAreMembersDict = [User : Bool]()
        
        guard let eventID = eventData?.id else {
            return
        }
        
        if let editBarButton = navigationItem.rightBarButtonItem {
            editBarButton.isEnabled = eventData.isOwnedByCurrentUser
            editBarButton.tintColor = (eventData.isOwnedByCurrentUser ? nil : UIColor.clear)
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
                        
                        self.updateView()
                        
                    } else {
                        UIAlertController.presentErrorAlert(withText: fetchErrorText!, parentController: self)
                    }
                    
                }
            } else {
                self.membersLabel.text = String.ad.thereAreNoMembers
                UIAlertController.presentErrorAlert(withText: fetchMembersError!, parentController: self)
            }
        }
    }
    
    
    func saveEventAndLeaveIfSuccess() {
        if !eventData.isOwnedByCurrentUser {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        let newEventData = eventData!
        newEventData.name = nameTextField.text
        // newEventData.type =
        
        APIManager.updateEvent(newEventData) { updateErrorText in
            if let updateError = updateErrorText {
                UIAlertController.presentErrorAlert(withText: updateError, parentController: self)
                return
            }
            
            _ = self.navigationController?.popViewController(animated: true)
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
        
        updateView()
    }
    
    
    // MARK: Actions
    
    func buttonWasPressed(_ sender: UIButton) {
        if sender === nameEditButton {
            
        } else if sender === nameSaveButton {
            
        } else if sender === nameCancelButton {
            
        } else if sender === editMembersButton {
            membersPicker.show()
        } else if sender === dateEditButton {
            guard let currentEventDate = eventData.date else {
                return
            }
            
            DatePickerDialog().show(title: String.ad.eventDate, doneButtonTitle: String.ad.done, cancelButtonTitle: String.ad.cancel, defaultDate: currentEventDate, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime, callback: { selectedDate in
                if let newDate = selectedDate {
                    self.eventData.date = newDate
                }
            })
        }
    }
    
    
    func barButtonPressed(_ sender: UIBarButtonItem) {
        if (sender == navigationItem.leftBarButtonItem) {
            _ = navigationController?.popViewController(animated: true)
        } else if (sender == navigationItem.rightBarButtonItem) {
            saveEventAndLeaveIfSuccess()
        }
    }

}
