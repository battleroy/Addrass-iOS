//
//  CalendarWeekDaysCollectionViewLayout.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 21/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class CalendarWeekDaysCollectionViewLayout: UICollectionViewFlowLayout {

    // MARK: Overrides
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes
        
        self.modifyLayoutAttributes(layoutAttributes: attributes)
        return attributes
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map {
            $0.copy() as! UICollectionViewLayoutAttributes
        }
        
        if let attributes = attributes {
            for attrs in attributes {
                self.modifyLayoutAttributes(layoutAttributes: attrs)
            }
        }
        
        return attributes
    }
    
    
    // MARK: Private methods
    
    func modifyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes?) {
        
        layoutAttributes?.frame.origin.y = 0.0
    }
    
}
