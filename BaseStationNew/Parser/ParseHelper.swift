//
//  ParseHelper.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 01.04.2021.
//

import Foundation

class ParseHelper {
    private var pages = 0
    
    init(pages: Int) {
        self.pages = pages
    }
    
    public func getRangeForThreadParse(threads: Int, threadNumber: Int) -> ClosedRange<Int> {
        let from: Int = {
            if threadNumber == 0 {
                return 1
            } else {
                return ((pages / threads) * (threadNumber)) + 1
            }
        }()
        
        let to: Int = {
            if threadNumber == 0 {
                return pages / threads
            } else if threadNumber + 1 == threads {
                return pages
            } else {
                return (pages / threads) * (threadNumber + 1)
            }
        }()
        
        return from...to
    }
}
