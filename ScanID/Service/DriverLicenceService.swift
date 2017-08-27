//
//  DriverLicenceService.swift
//  ScanID
//
//  Created by Ashley Han on 27/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DriverLicenceService: NSObject {

    static func saveDriverLicence(entity: DriverLicenseEntity, image: UIImage) -> Int64 {
        let db: FMDatabase = FMDatabase.init(path: DBHelper.dbPath())
        
        if !db.open() {
            print("open database failed")
            return 0
        }
        
        let driverId = DriverLicenceDAO.insertModel(entity: entity, withDatabase: db)
        if driverId == 0 {
            return driverId
        }
        
        DriverLicenceDAO.insertImage(driverId: driverId, image: image, withDatabase: db)
        
        db.close()
        return driverId;
    }
    
    static func getAllDriverlicences() -> Array<DriverLicenseEntity>? {
        let db: FMDatabase = FMDatabase.init(path: DBHelper.dbPath())
        
        if !db.open() {
            print("open database failed")
            return nil
        }
        
        return DriverLicenceDAO.queryAllModel(withDatabase: db)
    }
    
    static func getImageForDriver(entity: DriverLicenseEntity) -> UIImage? {
        let db: FMDatabase = FMDatabase.init(path: DBHelper.dbPath())
        
        if !db.open() {
            print("open database failed")
            return nil
        }
        
        return DriverLicenceDAO.queryImage(driverId: entity.id, withDatabase: db)
    }
}
