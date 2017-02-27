//
//  ScrollableContentViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 02/12/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit

class ScrollableContentViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Variables
    
    var contentScrollView: UIScrollView!
    
    var currentKeyboardHeight: CGFloat = 0.0
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        contentScrollView = UIScrollView()
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
        
        contentScrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardBoundsWillBeChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: self)
    }
    
    
    // MARK: Private methods
    
    func updateInsets() {
        let newInsets = UIEdgeInsetsMake(0.0, 0.0, currentKeyboardHeight, 0.0)
        contentScrollView.contentInset = newInsets
        contentScrollView.scrollIndicatorInsets = newInsets
    }
    
    
    // MARK: Notifications
    
    func keyboardWillShow(_ note: Notification) {
        guard let kbSizeInfo = note.userInfo?[UIKeyboardFrameEndUserInfoKey] else {
            return
        }
        
        let kbSize = (kbSizeInfo as! NSValue).cgRectValue
        currentKeyboardHeight = kbSize.height
        
        updateInsets()
    }
    
    
    func keyboardWillHide(_ note: Notification) {
        currentKeyboardHeight = 0.0
        
        updateInsets()
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(false)
    }

}
