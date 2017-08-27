//
//  DriverLicenceDAO.swift
//  ScanID
//
//  Created by Ashley Han on 27/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DriverLicenceDAO: NSObject {

    static func insertModel(entity: DriverLicenseEntity, withDatabase db: FMDatabase) -> Int64
    {
        do {
            try db.executeUpdate("INSERT INTO TB_DRIVER_LICENCE_DETAIL (familyName, firstNames, birth, licence, version, address) VALUES (?, ?, ?, ?, ?, ?)", values: [entity.familyName, entity.firstNames, entity.dateOfBirth, entity.lincese, entity.version, entity.address])
            return db.lastInsertRowId
        } catch let error as NSError {
            print("insert model failed: \(error.localizedDescription)")
            return 0
        }
    }
    
    static func insertImage(driverId: Int64, image: UIImage, withDatabase db: FMDatabase) -> Void {
        do {
            if let imageData: Data = UIImageJPEGRepresentation(image, 0) {
                try db.executeUpdate("INSERT INTO TB_DRIVER_LICENCE_IMAGE (driverId, image) VALUES (?, ?)", values: [NSNumber.init(value: driverId), imageData])
            }
        } catch let error as NSError {
            print("insert model failed: \(error.localizedDescription)")
        }
    }
    
    static func queryAllModel(withDatabase db: FMDatabase) -> Array<DriverLicenseEntity> {
        
        var allEntities: Array<DriverLicenseEntity> = []
        
        do {
            let s: FMResultSet = try db.executeQuery("SELECT * FROM TB_DRIVER_LICENCE_DETAIL", values: nil)
            
            while s.next() {
                let entity: DriverLicenseEntity = DriverLicenseEntity(withFMResultSet: s)
                allEntities.append(entity)
            }
            s.close()
        } catch let error as NSError {
            print("query model failed: \(error.localizedDescription)")
        }

        return allEntities
    }
    
    static func queryImage(driverId: Int64, withDatabase db: FMDatabase) -> UIImage? {
        
        do {
            let s: FMResultSet = try db.executeQuery("SELECT image FROM TB_DRIVER_LICENCE_IMAGE WHERE driverId = ?", values: [NSNumber.init(value: driverId)])
            while s.next() {
                let imageData: Data = s.data(forColumn: "image")!
                return UIImage.init(data: imageData)
            }
            s.close()
        } catch let error as NSError {
            print("query model failed: \(error.localizedDescription)")
        }

        return nil
    }
}
