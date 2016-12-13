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
    
    let users = ["Yana", "Dasha", "Vasya", "Petya", "Katya"]
    
    static let textFieldInset: CGFloat = 8.0
    static let eventTypes = [String.ad.company, String.ad.family, String.ad.others]
    static let textFieldHeight: CGFloat = 40.0
    
    
    // MARK: Variables
    
    var nameTextField: ADPaddedTextField!
    var ownerLabel: UILabel!
    var membersLabel: UILabel!
    var editMembersButton: UIButton!
    var datePicker: UIDatePicker!
    var eventTypeSegmentedControl: UISegmentedControl!
    
    var usersPicker: CZPickerView!
    
    
    // MARK: VCL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.ad.edit
        contentScrollView.backgroundColor = UIColor.ad.gray
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String.ad.cancel, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.ad.save, style: .done, target: self, action: #selector(barButtonPressed(_:)))
        
        createSubviews()
        setConstraints()
    }
    
    
    // MARK: Private methods
    
    func createSubviews() {
        
        ownerLabel = UILabel()
        ownerLabel.font = UIFont.ad.bodyFont
        ownerLabel.textColor = UIColor.ad.white
        ownerLabel.textAlignment = .center
        ownerLabel.text = String.ad.owner + ": " + "Ivan Ivanovich"
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
        membersLabel.text = String.ad.members + ": " + users.joined(separator: ", ")
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
        
        usersPicker = CZPickerView(headerTitle: String.ad.members, cancelButtonTitle: String.ad.cancel, confirmButtonTitle: String.ad.save)
        usersPicker.dataSource = self
        usersPicker.delegate = self
        usersPicker.tapBackgroundToDismiss = false
        usersPicker.allowMultipleSelection = true
        usersPicker.checkmarkColor = UIColor.ad.yellow
        usersPicker.headerBackgroundColor = UIColor.ad.darkGray
        usersPicker.headerTitleFont = UIFont.ad.boldFont
        usersPicker.headerTitleColor = UIColor.ad.white
        usersPicker.cancelButtonBackgroundColor = UIColor.ad.darkGray
        usersPicker.cancelButtonNormalColor = UIColor.ad.white
        usersPicker.cancelButtonHighlightedColor = UIColor.ad.white
        usersPicker.confirmButtonBackgroundColor = UIColor.ad.darkGray
        usersPicker.confirmButtonNormalColor = UIColor.ad.white
        usersPicker.confirmButtonHighlightedColor = UIColor.ad.white
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
    
    
    // MARK: CZPickerViewDataSource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return users.count
    }
    
    
    func czpickerView(_ pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        return NSAttributedString(
            string: users[row],
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.white
            ]
        )
    }
    
    
    // MARK: CZPickerViewDelegate
    
    func czpickerViewWillDismiss(_ pickerView: CZPickerView!) {
        
    }
    
    
    // MARK: Actions
    
    func editContactsButtonPressed(_ sender: UIButton) {
        usersPicker.show()
    }
    
    
    func barButtonPressed(_ sender: UIBarButtonItem) {
        if (sender == navigationItem.leftBarButtonItem) {
            _ = navigationController?.popViewController(animated: true)
        } else if (sender == navigationItem.rightBarButtonItem) {
            
        }
    }

}
