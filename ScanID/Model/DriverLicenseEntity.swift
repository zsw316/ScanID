//
//  DriverLicenseEntity.swift
//  ScanID
//
//  Created by Ashley Han on 27/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DriverLicenseEntity: BaseEntity {

    var id: Int64 = 0
    
    var familyName: String = ""
    
    var firstNames: String = ""
    
    var dateOfBirth: String = ""
    
    var lincese: String = ""
    
    var version: String = ""
    
    var address: String = ""
    
    init(familyName: String, firstNames: String, dateOfBirth: String, license: String, version: String, address: String) {
        super.init()
        self.familyName = familyName
        self.firstNames = firstNames
        self.dateOfBirth = dateOfBirth
        self.lincese = license
        self.version = version
        self.address = address
    }
    
    init(withFMResultSet set: FMResultSet) {
        super.init()
        
        self.id = set.longLongInt(forColumn: "id")
        
        if let familyName = set.string(forColumn: "familyName") {
            self.familyName = familyName
        }
        
        if let firstNames = set.string(forColumn: "firstNames") {
            self.firstNames = firstNames
        }
        
        if let dateOfBirth = set.string(forColumn: "birth") {
            self.dateOfBirth = dateOfBirth
        }
        
        if let licence = set.string(forColumn: "licence") {
            self.lincese = licence
        }
        
        if let version = set.string(forColumn: "version") {
            self.version = version
        }
        
        if let address = set.string(forColumn: "address") {
            self.address = address
        }
    }
}
