//
//  StringExtension.swift
//  Panagram
//
//  Created by Frascella Claudio on 8/7/17.
//  Copyright © 2017 TeamDecano. All rights reserved.
//

import Foundation


extension String {

    func isAnagramOf(_ s: String) -> Bool {
        //1
        //let lowerSelf = self.lowercased().replacingOccurrences(of: " ", with: "")
        let lowerSelf = self.lowercased().alphanumericsOnly()
        //let lowerOther = s.lowercased().replacingOccurrences(of: " ", with: "")
        let lowerOther = s.lowercased().alphanumericsOnly()
        //2
        return lowerSelf.characters.sorted() == lowerOther.characters.sorted()
    }
    
    func isPalindrome() -> Bool {
        //1
        //let f = self.lowercased().replacingOccurrences(of: " ", with: "")
        let f = self.lowercased().alphanumericsOnly()
        //2
        let s = String(f.characters.reversed())
        //3
        return  f == s
    }
    
    private func alphanumericsOnly() -> String {
        return String(characters.filter {
            String($0).rangeOfCharacter(from: .alphanumerics) != nil
        })
    }
    
}
