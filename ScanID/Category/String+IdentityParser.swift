//
//  String+IdentityParser.swift
//  ScanID
//
//  Created by Ashley Han on 27/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import Foundation

extension String {
    
    func trimWhteSpacesAndNewline() -> String {
        let characterSet = CharacterSet.init(charactersIn: "\n ")
        return self.trimmingCharacters(in: characterSet)
    }
    
    func parseDriverLicence() -> (isValidLicence: Bool, familyName: String, firstNames: String, dateOfbirth: String, license: String, version: String, address: String) {
        var isValidLicense = false
        var familyName = ""
        var firstNames = ""
        var dateOfBirth = ""
        var license = ""
        var version = ""
        var address = ""
        
        let lowercasedString = self.lowercased()
        
        // Check keywords
        if self.range(of: "NEW ZEALAND DRIVER LICENCE") != nil || self.range(of: "DRIVER IDENTITY INFORMATION") != nil
        || self.range(of: "DRIVER LICENCE") != nil || self.range(of: "DRIVER IDENTITY") != nil {
            isValidLicense = true
            let surnameRange = lowercasedString.range(of: "surname")
            let firstnamesRange = lowercasedString.range(of: "first names")
            let dateRange = lowercasedString.range(of: "date")
            let dateOfBirthRange = lowercasedString.range(of: "date of birth")
            let licenseRange = self.range(of: "Licence")
            let versionRange = lowercasedString.range(of: "version")
            let donorStatusRange = lowercasedString.range(of: "donor status")
            let addressRange = lowercasedString.range(of: "address")
            
            if surnameRange != nil && firstnamesRange != nil {
                familyName = self.substring(with: Range(uncheckedBounds: (lower: surnameRange!.upperBound, upper: firstnamesRange!.lowerBound))).trimWhteSpacesAndNewline()
            }
            
            if firstnamesRange != nil && dateRange != nil {
                firstNames = self.substring(with: Range(uncheckedBounds: (lower: firstnamesRange!.upperBound, upper: dateRange!.lowerBound))).trimWhteSpacesAndNewline()
            }
            
            if dateOfBirthRange != nil && licenseRange != nil {
                dateOfBirth = self.substring(with: Range(uncheckedBounds: (lower: dateOfBirthRange!.upperBound, upper: licenseRange!.lowerBound))).trimWhteSpacesAndNewline()
            }
            
            if licenseRange != nil && versionRange != nil {
                license = self.substring(with: Range(uncheckedBounds: (lower: licenseRange!.upperBound, upper: versionRange!.lowerBound))).trimWhteSpacesAndNewline()
            }
            
            if versionRange != nil {
                if donorStatusRange != nil {
                    version = self.substring(with: Range(uncheckedBounds: (lower: versionRange!.upperBound, upper: donorStatusRange!.lowerBound))).trimWhteSpacesAndNewline()
                } else if addressRange != nil {
                    version = self.substring(with: Range(uncheckedBounds: (lower: versionRange!.upperBound, upper: addressRange!.lowerBound))).trimWhteSpacesAndNewline()
                }
                
            }
            
            if addressRange != nil {
                address = self.substring(from: addressRange!.upperBound).trimWhteSpacesAndNewline()
            }
        } else {
            print("May not valid driver licence")
        }
        
        return (isValidLicense, familyName, firstNames, dateOfBirth, license, version, address)
    }
}
