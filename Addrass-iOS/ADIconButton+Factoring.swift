//
//  ADIconButton+Factoring.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/25/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import UIKit


extension ADIconButton {
    
    enum ADButtonType {
        case delete
        case edit
        case events
        case save
        case cancel
        case chat
    }
    
    
    static func createButton(withButtonType buttonType: ADButtonType) -> ADIconButton {
        
        let iconSize: CGFloat = 15.0
        var icon: UIImage?
        var attributedTitle: NSAttributedString?
        
        switch buttonType {
        case .delete:
            icon = #imageLiteral(resourceName: "delete-light")
            attributedTitle = NSAttributedString(
                string: String.ad.delete, attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        case .edit:
            icon = #imageLiteral(resourceName: "pencil-gray")
            attributedTitle = NSAttributedString(
                string: String.ad.edit, attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        case .events:
            icon = #imageLiteral(resourceName: "calendar-light")
            attributedTitle = NSAttributedString(
                string: String.ad.events, attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        case .save:
            icon = #imageLiteral(resourceName: "checkmark-white")
            attributedTitle = NSAttributedString(
                string: String.ad.save, attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        case .cancel:
            icon = #imageLiteral(resourceName: "cross-white")
            attributedTitle = NSAttributedString(
                string: String.ad.cancel, attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        case .chat:
            icon = #imageLiteral(resourceName: "mail-light")
            attributedTitle = NSAttributedString(
                string: String.ad.chat, attributes: [
                    NSFontAttributeName: UIFont.ad.boldFont,
                    NSForegroundColorAttributeName: UIColor.ad.white
                ]
            )
        }
        
        let button = ADIconButton(withIconSize: iconSize, icon: icon)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
}
