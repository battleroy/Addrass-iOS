//
//  UIFont+Addrass.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

extension UIFont {
    
    // MARK: Constants
    
    struct ADFonts {
        
        let smallFont     = UIFont(name: "HelveticaNeue", size: 10.0)!
        let smallBoldFont = UIFont(name: "HelveticaNeue-Bold", size: 10.0)!
        let bodyFont      = UIFont(name: "HelveticaNeue", size: 14.0)!
        let boldFont      = UIFont(name: "HelveticaNeue-Bold", size: 14.0)!
        let largeFont     = UIFont(name: "HelveticaNeue", size: 17.0)!
        let largeBoldFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
        let heading1Font  = UIFont(name: "HelveticaNeue-Bold", size: 24.0)!
        
    }
    
    static let ad = ADFonts()
    
    
    // MARK: Public methods
    
    func height(forGivenText text: String?, width: CGFloat) -> CGFloat {
        
        if let text = text {
        
            let attributedText = NSMutableAttributedString(string: text)
            
            attributedText.addAttribute(NSFontAttributeName, value: self, range: NSMakeRange(0, text.characters.count))
            
            return ceil(attributedText.boundingRect(with: CGSize(width: width, height: CGFloat(FLT_MAX)), options: .usesLineFragmentOrigin, context: nil).height)
                
        }
        
        return 0
    }
}
