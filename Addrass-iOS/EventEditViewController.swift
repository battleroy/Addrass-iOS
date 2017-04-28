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
    
    
    var eventTypeLabel: UILabel!
    var eventTypePicker: CZPickerView!
    var eventTypeButton: UIButton!
    
    
    var eventAccessibilityButton: ADIconButton!
    
    
    var deleteEventButton: UIButton!
    
    
    var viewsForOwnerOnly: [UIView]!
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
        title = (eventData?.owner == UserSessionManager.sharedManager.currentUser ? String.ad.edit : String.ad.event)
        contentScrollView.backgroundColor = UIColor.ad.gray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String.ad.cancel, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.ad.save, style: .done, target: self, action: #selector(barButtonPressed(_:)))
        
        createSubviews()
        setConstraints()
        
        reloadData()
    }
    
    
    // MARK: Private methods
    
    func createSubviews() {
        // --- Owner --- //
        ownerLabel = UILabel()
        ownerLabel.font = UIFont.ad.boldFont
        ownerLabel.textColor = UIColor.ad.white
        ownerLabel.textAlignment = .center
        contentScrollView.addSubview(ownerLabel)
        
        
        // --- Name Show --- //
        nameShowContainer = UIView()
        nameShowContainer.isHidden = false
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

        
        // --- Name Edit --- //
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
        
        
        // --- Members --- //
        membersLabel = UILabel()
        membersLabel.font = UIFont.ad.bodyFont
        membersLabel.textColor = UIColor.ad.lightGray
        membersLabel.numberOfLines = 0
        contentScrollView.addSubview(membersLabel)
        
        membersPicker = CZPickerView.createPickerView(withTitle: String.ad.members)
        membersPicker.dataSource = self
        membersPicker.delegate = self
        membersPicker.allowMultipleSelection = true
        
        editMembersButton = ADIconButton.createButton(withButtonType: .edit)
        editMembersButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(editMembersButton)
        
        
        // --- Date --- //
        dateLabel = UILabel()
        dateLabel.font = UIFont.ad.bodyFont
        dateLabel.textColor = UIColor.ad.white
        contentScrollView.addSubview(dateLabel)
        
        dateEditButton = ADIconButton.createButton(withButtonType: .edit)
        dateEditButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(dateEditButton)
        
        
        // --- Event Type --- //
        eventTypeLabel = UILabel()
        eventTypeLabel.font = UIFont.ad.bodyFont
        eventTypeLabel.textColor = UIColor.ad.white
        contentScrollView.addSubview(eventTypeLabel)
        
        eventTypePicker = CZPickerView.createPickerView(withTitle: String.ad.eventType)
        eventTypePicker.allowMultipleSelection = false
        eventTypePicker.dataSource = self
        eventTypePicker.delegate = self
        
        eventTypeButton = ADIconButton.createButton(withButtonType: .edit)
        eventTypeButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(eventTypeButton)
        
        
        deleteEventButton = ADIconButton.createButton(withButtonType: .delete)
        deleteEventButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        contentScrollView.addSubview(deleteEventButton)
        
        
        // ---- Accessibility ---- //
        eventAccessibilityButton = ADIconButton(withIconSize: 16.0, icon: nil)
        eventAccessibilityButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        eventAccessibilityButton.setAttributedTitle(NSAttributedString(
            string: String.ad.isPublic, attributes: [
                NSFontAttributeName: UIFont.ad.boldFont,
                NSForegroundColorAttributeName: UIColor.ad.white
            ]
            ), for: .normal)
        contentScrollView.addSubview(eventAccessibilityButton)
        
        
        viewsForOwnerOnly = [nameEditButton, nameTextField, nameSaveButton, nameCancelButton, editMembersButton, dateEditButton, eventTypeButton, deleteEventButton]
    }
    
    
    func setConstraints() {
        
        nameShowContainer.snp.remakeConstraints { (make) in
            make.left.equalTo(view).offset(8.0)
            make.right.equalTo(view).offset(-8.0)
            make.left.equalTo(contentScrollView).offset(8.0)
            make.right.equalTo(contentScrollView).offset(8.0)
            make.top.equalTo(contentScrollView).offset(8.0)
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
            make.top.equalTo(nameEditContainer.snp.bottom).offset(12.0)
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
            make.top.equalTo(membersLabel.snp.bottom).offset(12.0)
        }
        
        dateEditButton.snp.remakeConstraints { (make) in
            make.right.equalTo(nameEditContainer)
            make.centerY.equalTo(dateLabel)
            make.left.greaterThanOrEqualTo(dateLabel.snp.right).offset(8.0)
        }
        
        
        eventTypeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameEditContainer)
            make.top.equalTo(dateLabel.snp.bottom).offset(12.0)
        }
        
        eventTypeButton.snp.remakeConstraints { (make) in
            make.right.equalTo(nameEditContainer)
            make.centerY.equalTo(eventTypeLabel)
            make.left.greaterThanOrEqualTo(eventTypeLabel.snp.right).offset(8.0)
        }
        
        eventAccessibilityButton.snp.remakeConstraints { (make) in
            make.top.equalTo(eventTypeLabel.snp.bottom).offset(12.0)
            make.left.equalTo(nameEditContainer)
        }
        
        
        deleteEventButton.snp.remakeConstraints { (make) in
            make.left.equalTo(nameEditContainer)
            make.bottom.equalTo(contentScrollView).offset(-8.0)
            make.bottom.equalTo(bottomLayoutGuide.snp.bottom).offset(-8.0)
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
        eventTypeLabel.text = event.type.stringValue
        eventAccessibilityButton.iconImage = event.isPublic ? #imageLiteral(resourceName: "checkmark-white") : #imageLiteral(resourceName: "cross-white")
        eventAccessibilityButton.isEnabled = event.isOwnedByCurrentUser
        
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
        
        if eventData == nil {
            eventData = Event()
        }
        
        for ownerView in viewsForOwnerOnly {
            ownerView.isHidden = !eventData!.isOwnedByCurrentUser
            if ownerView === deleteEventButton && eventData!.id == nil {
                ownerView.isHidden = true
            }
        }
        
        if eventData?.id != nil {
            reloadDataForExistingEvent(eventData!)
        } else {
            reloadDataForNewEvent()
        }
    }
    
    
    func reloadDataForNewEvent() {
        
        APIManager.sharedManager.friends { (fetchedFriends, fetchedFriendsErrorText) in
            guard let friends = fetchedFriends else {
                UIAlertController.presentErrorAlert(withText: fetchedFriendsErrorText!, parentController: self)
                return
            }
            
            self.friendsArray = friends
            self.friendsAreMemberArray = [Bool](repeating: false, count: friends.count)
            
            self.updateView()
        }
        
    }
    
    
    func reloadDataForExistingEvent(_ existingEventData: Event) {
        var friendsAreMembersDict = [User : Bool]()
        
        guard let eventID = existingEventData.id else {
            return
        }
        
        if let saveBarButton = navigationItem.rightBarButtonItem {
            saveBarButton.isEnabled = existingEventData.isOwnedByCurrentUser
            saveBarButton.title = (existingEventData.isOwnedByCurrentUser ? String.ad.save : "")
        }
        
        APIManager.sharedManager.membersFromEvent(forEventID: eventID) { (fetchedMembers, fetchMembersError) in
            if let members = fetchedMembers {
                
                for member in members {
                    friendsAreMembersDict[member] = true
                }
                
                APIManager.sharedManager.friendsNotInEvent(forEventID: eventID) { (fetchedFriends, fetchErrorText) in
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
        
        if eventData?.id == nil {
            createEvent()
        } else {
            updateEvent()
        }
    }
    
    
    func createEvent() {
        APIManager.sharedManager.createEvent(eventData!) { (fetchedCreatedEvent, fetchedCreateErrorText) in
            guard let createdEventID = fetchedCreatedEvent?.id else {
                UIAlertController.presentErrorAlert(withText: fetchedCreateErrorText!, parentController: self)
                return
            }
            
            APIManager.sharedManager.membersUpdate(forEventID: createdEventID, newMembers: self.newMembersArray(), completion: { (fetchedMembersUpdateErrorText) in
                if let membersUpdateErrorText = fetchedMembersUpdateErrorText {
                    UIAlertController.presentErrorAlert(withText: membersUpdateErrorText, parentController: self)
                    return
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    func updateEvent() {
        let newEventData = eventData!
        
        APIManager.sharedManager.updateEvent(newEventData) { updateErrorText in
            if let updateError = updateErrorText {
                UIAlertController.presentErrorAlert(withText: updateError, parentController: self)
                return
            }
            
            guard let eventID = newEventData.id else {
                UIAlertController.presentErrorAlert(withText: String.ad.cantUpdateEventMembers, parentController: self)
                return
            }
            
            APIManager.sharedManager.membersUpdate(forEventID: eventID, newMembers: self.newMembersArray(), completion: { (fetchedMembersUpdateErrorText) in
                if let membersUpdateErrorText = fetchedMembersUpdateErrorText {
                    UIAlertController.presentErrorAlert(withText: membersUpdateErrorText, parentController: self)
                    return
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    func newMembersArray() -> [User] {
        var newMembers = [User]()
        
        if let friendsArray = self.friendsArray, let friendsAreMemberArray = self.friendsAreMemberArray {
            for i in 0..<friendsArray.count {
                if friendsAreMemberArray[i] {
                    newMembers.append(friendsArray[i])
                }
            }
        }
        
        return newMembers
    }
    
    
    func switchNameEdit(_ isOn: Bool, completion: (() -> Void)?) {
        self.nameShowContainer.isHidden = !isOn
        self.nameShowContainer.alpha = (isOn ? 1.0 : 0.0)
        self.nameEditContainer.isHidden = isOn
        self.nameEditContainer.alpha = (isOn ? 0.0 : 1.0)
        
        UIView.animate(withDuration: 0.3, animations: { 
            if isOn {
                self.nameShowContainer.alpha = 0.0
            } else {
                self.nameEditContainer.alpha = 0.0
            }
        }) { isCompletedHiding in
            if !isCompletedHiding {
                return
            }
            
            self.nameShowContainer.isHidden = isOn
            self.nameEditContainer.isHidden = !isOn
            
            UIView.animate(withDuration: 0.3, animations: { 
                if isOn {
                    self.nameEditContainer.alpha = 1.0
                } else {
                    self.nameShowContainer.alpha = 1.0
                }
            }) { isCompletedAppearance in
                if !isCompletedAppearance {
                    return
                }
                
                if let presentedCompletion = completion {
                    presentedCompletion()
                }
            }
        }
    }
    
    
    // MARK: CZPickerViewDataSource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        if pickerView === membersPicker {
            
            guard let friends = friendsArray else {
                return 0
            }
            
            return friends.count
            
        } else if pickerView === eventTypePicker {
            return EventEditViewController.eventTypes.count
        }
        
        return 0
    }
    
    
    func czpickerView(_ pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        var rowTitle: String?
        
        if pickerView === membersPicker {
        
            guard let friends = friendsArray else {
                return NSAttributedString(string: "")
            }
            
            rowTitle = friends[row].fullName
            
        } else if pickerView === eventTypePicker {
            rowTitle = EventEditViewController.eventTypes[row]
        }
        
        if let finalRowTitle = rowTitle {
            return NSAttributedString(
                string: finalRowTitle,
                attributes: [
                    NSFontAttributeName: UIFont.ad.bodyFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        }
        
        return NSAttributedString()
    }
    
    
    // MARK: CZPickerViewDelegate
    
    func czpickerViewWillDisplay(_ pickerView: CZPickerView!) {
        if pickerView === membersPicker {
        
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
            
        } else if pickerView === eventTypePicker {
            
            let activeTypeIndex = Event.EventType.allValues.index(of: eventData!.type)!
            pickerView.setSelectedRows([activeTypeIndex])
            
        }
    }
    
    
    func czpickerViewWillDismiss(_ pickerView: CZPickerView!) {
        if pickerView === membersPicker {
            
            guard let friends = friendsArray else {
                return
            }
            
            friendsAreMemberArray = [Bool](repeating: false, count: friends.count)
            
            for selectedMemberIndex in pickerView.selectedRows() {
                friendsAreMemberArray![selectedMemberIndex as! Int] = true
            }
            
        } else if pickerView === eventTypePicker {
            
            let pickedEventType = EventEditViewController.eventTypes[pickerView.selectedRows().first as! Int]
            eventData.type = Event.EventType(stringValue: pickedEventType)
            
        }
        
        updateView()
    }
    
    
    // MARK: Actions
    
    func buttonWasPressed(_ sender: UIButton) {
        if sender === nameEditButton && eventData!.isOwnedByCurrentUser {
            switchNameEdit(true, completion: nil)
        } else if sender === nameSaveButton {
            eventData.name = nameTextField.text
            updateView()
            switchNameEdit(false, completion: nil)
        } else if sender === nameCancelButton {
            switchNameEdit(false, completion: nil)
        } else if sender === editMembersButton {
            membersPicker.show()
        } else if sender === dateEditButton {
            guard let currentEventDate = eventData.date else {
                return
            }
            
            DatePickerDialog().show(title: String.ad.eventDate, doneButtonTitle: String.ad.done, cancelButtonTitle: String.ad.cancel, defaultDate: currentEventDate, minimumDate: nil, maximumDate: nil, datePickerMode: .dateAndTime, callback: { selectedDate in
                if let newDate = selectedDate {
                    self.eventData.date = newDate
                    self.updateView()
                }
            })
        } else if sender === eventTypeButton {
            eventTypePicker.show()
        } else if sender === deleteEventButton {
            APIManager.sharedManager.deleteEvent(forEventID: eventData.id!, completion: { fetchedDeleteErrorText in
                if let deleteErrorText = fetchedDeleteErrorText {
                    UIAlertController.presentErrorAlert(withText: deleteErrorText, parentController: self)
                    return
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            })
        } else if sender === eventAccessibilityButton {
            weak var weakSelf: EventEditViewController! = self
            
            UIView.animate(withDuration: 0.3, animations: { 
                weakSelf.eventAccessibilityButton.alpha = 0.0
            }, completion: { isCompleted in
                guard isCompleted else { return }
                
                weakSelf.eventData.isPublic = !weakSelf.eventData.isPublic
                weakSelf.updateView()
                
                UIView.animate(withDuration: 0.3) {
                    weakSelf.eventAccessibilityButton.alpha = 1.0
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
