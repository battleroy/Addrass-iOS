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
    
    var messages: [Message]!
    var stompClient: StompClient?
    
    var messagesTableView: UITableView!
    var newMessageTextField: UITextField!
    var sendMessageButton: UIButton!
    
    var bottomAnchorConstraint: Constraint?
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        title = String.ad.chat
        
        messages = [Message]()
        
        setupSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        newMessageTextField = UITextField()
        newMessageTextField.placeholder = String.ad.enterMessage
        newMessageTextField.borderStyle = .roundedRect
        newMessageTextField.setContentHuggingPriority(100, for: .vertical)
        view.addSubview(newMessageTextField)
        
        sendMessageButton = UIButton()
        sendMessageButton.setTitle(String.ad.send, for: .normal)
        sendMessageButton.setTitleColor(UIColor.blue, for: .normal)
        sendMessageButton.addTarget(self, action: #selector(buttonWasPressed(_:)), for: .touchUpInside)
        view.addSubview(sendMessageButton)
        
        setConstraints()
    }
    
    
    func setConstraints() {
        messagesTableView.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(view)
        }
        
        newMessageTextField.snp.remakeConstraints { (make) in
            make.left.equalTo(view).offset(4.0)
            make.bottom.equalTo(view).offset(-4.0)
            make.top.equalTo(messagesTableView.snp.bottom).offset(4.0)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        sendMessageButton.snp.remakeConstraints { (make) in
            make.centerY.equalTo(newMessageTextField)
            make.left.equalTo(newMessageTextField.snp.right).offset(4.0)
            make.right.equalTo(view).offset(-4.0)
        }
    }
    
    
    func connectToChat() {
        stompClient = StompClient(url: URL(string: "ws://localhost:8080/ws/websocket")!)
        stompClient?.delegate = self
        stompClient?.connect()
    }
    
    
    // MARK: StompClientDelegate
    
    func stompClientDidConnect(_ client: StompClient) {
        print("conn")
        client.subscribe("/user/exchange/amq.direct/chat.message")
    }
    
    
    func stompClientDidDisconnect(_ client: StompClient) {
        print("disconn")
    }
    
    
    func stompClientError(_ client: StompClient, error: Error) {
        print("err: ", error.localizedDescription)
    }
    
    
    func stompClientDidReceiveText(_ client: StompClient, text: String?) {
        if let receivedText = text {
            UIAlertController.presentInfoAlert(withText: "Privet. " + receivedText, parentController: self)
        }
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
    
    
    // MARK: Actions
    
    func buttonWasPressed(_ sender: UIButton) {
        if sender === sendMessageButton {
            let stub = Message()
            stub.sender = (arc4random() % 2 == 0 ? SessionManager.currentUser : nil)
            stub.receiver = SessionManager.currentUser
            stub.text = newMessageTextField.text
            stub.time = Date()
            
            stompClient?.sendText(stub.text!, destination: "/app/chat.private.b")
            
            messagesTableView.beginUpdates()
            
            messages.append(stub)
            let lastRowIndex = messagesTableView.numberOfRows(inSection: 0)
            messagesTableView.insertRows(at: [IndexPath(row: lastRowIndex, section: 0)], with: .fade)
            
            messagesTableView.endUpdates()
            
            messagesTableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: 0), at: .bottom, animated: true)
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
