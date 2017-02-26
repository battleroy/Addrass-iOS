//
//  CZPickerView+Factoring.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/26/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import CZPicker


extension CZPickerView {
    
    static func createPickerView(withTitle title: String) -> CZPickerView {
        let picker = CZPickerView(headerTitle: title, cancelButtonTitle: String.ad.cancel, confirmButtonTitle: String.ad.OK)!
        
        picker.needFooterView = true
        picker.tapBackgroundToDismiss = false
        picker.checkmarkColor = UIColor.ad.yellow
        picker.headerBackgroundColor = UIColor.ad.darkGray
        picker.headerTitleFont = UIFont.ad.boldFont
        picker.headerTitleColor = UIColor.ad.white
        picker.cancelButtonBackgroundColor = UIColor.ad.darkGray
        picker.cancelButtonNormalColor = UIColor.ad.white
        picker.cancelButtonHighlightedColor = UIColor.ad.white
        picker.confirmButtonBackgroundColor = UIColor.ad.darkGray
        picker.confirmButtonNormalColor = UIColor.ad.white
        picker.confirmButtonHighlightedColor = UIColor.ad.white
        
        return picker
    }
    
}
