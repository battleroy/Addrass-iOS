//
//  ChatViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/27/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class ChatViewController : UIViewController, StompClientDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Fields
    
    var friend: User?
    var messages: [Message]!
    var stompClient: StompClient?
    
    var messagesTableView: UITableView!
    var newMessageTextField: UITextField!
    var sendMessageButton: UIButton!
    var navBar: UINavigationBar!
    var closeBarButton: UIBarButtonItem!
    
    var bottomAnchorConstraint: Constraint?
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = String.ad.chat
        view.backgroundColor = UIColor.ad.darkGray
        
        messages = [Message]()
        
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateMessages()
        connectToChat()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stompClient?.disconnect()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: Private methods
    
    func setupSubviews() {
        
        messagesTableView = UITableView()
        messagesTableView.backgroundColor = UIColor.gray
        messagesTableView.register(ChatMessageTableViewCell.self, forCellReuseIdentifier: ChatMessageTableViewCell.cellIdentifier)
        messagesTableView.separatorStyle = .none
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        view.addSubview(messagesTableView)
        
        newMessageTextField = ADPaddedTextField(forPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        newMessageTextField.backgroundColor = UIColor.clear
        newMessageTextField.font = UIFont.ad.bodyFont
        newMessageTextField.textColor = UIColor.ad.white
        newMessageTextField.attributedPlaceholder = NSAttributedString(
            string: String.ad.enterMessage,
            attributes: [
                NSFontAttributeName: UIFont.ad.bodyFont,
                NSForegroundColorAttributeName: UIColor.ad.lightGray
            ]
        )
        newMessageTextField.layer.cornerRadius = 5.0
        newMessageTextField.layer.borderColor = UIColor.white.cgColor
        newMessageTextField.layer.borderWidth = 1.0
        newMessageTextField.setContentHuggingPriority(100, for: .vertical)
        view.addSubview(newMessageTextField)
        
        sendMessageButton = UIButton()
        sendMessageButton.setAttributedTitle(NSAttributedString(
            string: String.ad.send,
            attributes: [
                NSFontAttributeName : UIFont.ad.boldFont,
                NSForegroundColorAttributeName : UIColor.ad.yellow
            ]),
        for: .normal)
        sendMessageButton.setTitleColor(UIColor.ad.yellow, for: .normal)
        sendMessageButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        view.addSubview(sendMessageButton)
        
        createNavigationbar()
        
        setConstraints()
    }
    
    
    func createNavigationbar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 64))
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.isTranslucent = false
        navBar.tintColor = UIColor.ad.white
        navBar.barTintColor = UIColor.ad.darkGray
        navBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.ad.largeBoldFont,
            NSForegroundColorAttributeName: UIColor.ad.white
        ]
        
        let navItem = UINavigationItem()
        navItem.title = friend?.fullName
        
        closeBarButton = UIBarButtonItem(title: String.ad.close, style: .plain, target: self, action: #selector(barButtonWasPressed(_:)))
        navItem.leftBarButtonItem = closeBarButton
        
        navBar.items = [navItem]
        
        view.addSubview(navBar)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    func setConstraints() {
        messagesTableView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(navBar.snp.bottom)
        }
        
        newMessageTextField.snp.remakeConstraints { (make) in
            make.left.equalTo(view).offset(4.0)
            make.bottom.equalTo(view).offset(-4.0)
            make.top.equalTo(messagesTableView.snp.bottom).offset(4.0)
            make.width.equalTo(view).multipliedBy(0.8)
            make.height.equalTo(30.0)
        }
        
        sendMessageButton.snp.remakeConstraints { (make) in
            make.centerY.equalTo(newMessageTextField)
            make.left.equalTo(newMessageTextField.snp.right).offset(4.0)
            make.right.equalTo(view).offset(-4.0)
        }
    }
    
    
    func updateMessages() {
        guard let friendLogin = friend?.login else {
            return
        }
        
        APIManager.sharedManager.messages(withFriendLogin: friendLogin) { (fetchedMessages, fetchErrorText) in
            guard let messages = fetchedMessages else {
                UIAlertController.presentErrorAlert(withText: fetchErrorText!, parentController: self)
                return
            }
            
            self.messages = messages
            self.messagesTableView.reloadData()
            if self.messages.count > 0 {
                self.messagesTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    
    func connectToChat() {
        stompClient = StompClient(url: APIManager.chatEndpoint)
        stompClient?.delegate = self
        stompClient?.connect()
    }
    
    
    func acceptMessage(_ message: Message) {
        messagesTableView.beginUpdates()
        
        messages.append(message)
        let lastRowIndex = messagesTableView.numberOfRows(inSection: 0)
        messagesTableView.insertRows(at: [IndexPath(row: lastRowIndex, section: 0)], with: .fade)
        
        messagesTableView.endUpdates()
        
        messagesTableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: 0), at: .bottom, animated: true)

    }
    
    
    // MARK: StompClientDelegate
    
    func stompClientDidConnect(_ client: StompClient) {
        client.subscribe("/user/exchange/amq.direct/chat.message")
    }
    
    
    func stompClientDidDisconnect(_ client: StompClient) {
        print("disconn")
    }
    
    
    func stompClientError(_ client: StompClient, error: Error) {
        print("err: ", error.localizedDescription)
    }
    
    
    func stompClientDidReceiveText(_ client: StompClient, text: String?) {
        guard let receivedText = text else {
            return
        }
        
        guard let messageJSON = (try? JSONSerialization.jsonObject(with: receivedText.data(using: .utf8)!, options: [])) as? [String : Any] else {
            return
        }
        
        acceptMessage(Message.message(withDictionary: messageJSON))
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageTableViewCell.cellIdentifier, for: indexPath) as! ChatMessageTableViewCell
        
        cell.setupCell(forMessage: messages[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChatMessageTableViewCell.cellHeight(forMessage: messages[indexPath.row], tableWidth: tableView.bounds.width)
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        newMessageTextField.resignFirstResponder()
    }
    
    
    // MARK: Overrides
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Actions
    
    func buttonWasPressed(_ sender: UIButton) {
        if sender === sendMessageButton, let messageText = newMessageTextField.text, let login = friend?.login {
            stompClient?.sendText(messageText, destination: "/app/chat.private.\(login)")
            newMessageTextField.text = ""
        }
    }
    
    
    func barButtonWasPressed(_ sender: UIBarButtonItem) {
        if sender === closeBarButton {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: Notifications
    
    func keyboardWillShow(_ note: Notification) {
        guard let kbSizeInfo = note.userInfo?[UIKeyboardFrameEndUserInfoKey], let showDurationInfo = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] else {
            return
        }
        
        let kbSize = (kbSizeInfo as! NSValue).cgRectValue
        let showDuration = (showDurationInfo as! NSNumber).doubleValue
        UIView.animate(withDuration: showDuration) {
            self.newMessageTextField.snp.updateConstraints { [weak self] (make) in
                guard let `self` = self else {
                    return
                }
                
                make.bottom.equalTo(self.view).offset(-4.0 - kbSize.height + (self.tabBarController?.tabBar.bounds.height ?? 0.0))
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func keyboardWillHide(_ note: Notification) {
        guard let showDurationInfo = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] else {
            return
        }
        
        let showDuration = (showDurationInfo as! NSNumber).doubleValue
        UIView.animate(withDuration: showDuration) {
            self.newMessageTextField.snp.updateConstraints { [weak self] (make) in
                guard let `self` = self else {
                    return
                }
                
                make.bottom.equalTo(self.view).offset(-4.0)
                self.view.layoutIfNeeded()
            }
        }
    }
}
