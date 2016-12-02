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
    
    var bottomSpaceAccumulator: CGFloat = 0.0
    
    
    // MARK: VCL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        contentScrollView = UIScrollView()
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
        
        contentScrollView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardBoundsWillBeChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: self)
    }
    
    
    // MARK: Notifications
    
    func keyboardBoundsWillBeChanged(_ note: Notification) {
        if let beginRect = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let endRect   = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let deltaY = beginRect.origin.y + beginRect.size.height - (endRect.origin.y + endRect.size.height);
            bottomSpaceAccumulator += deltaY;
            
            let newInsets = UIEdgeInsetsMake(0.0, 0.0, bottomSpaceAccumulator, 0.0)
            contentScrollView?.contentInset = newInsets
            contentScrollView?.scrollIndicatorInsets = newInsets
            
        }
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(false)
    }

}
