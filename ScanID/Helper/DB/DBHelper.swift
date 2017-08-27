//
//  DBHelper.swift
//  ScanID
//
//  Created by Ashley Han on 27/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DBHelper: NSObject {

    static func dbFolder() -> String {
        if let docDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last {
            let path = docDirectory.appending("/db")
            return path
        }
        
        return "db"
    }
    
    static func dbPath() -> String {
        let folder = DBHelper.dbFolder()
        let path = folder.appending("/book.sqlite")
        return path
    }
    
    static func buildDatabase() {
        if !FileManager.default.fileExists(atPath: DBHelper.dbFolder()) {
            do {
                try FileManager.default.createDirectory(atPath: DBHelper.dbFolder(), withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch let error as NSError {
                print("create directory error: \(error.localizedDescription)")
            }
        }
        
        let db: FMDatabase = FMDatabase.init(path: DBHelper.dbPath())
        if !db.open() {
            return
        }
        
        let succ: Bool = DBHelper.createTableWithDB(db: db)
        if succ {
            print("create table done")
        } else {
            print("create table failed")
        }
        
        db.close()
    }
    
    static func createTableWithDB(db: FMDatabase) -> Bool {
        var succ: Bool = true
        
        for sql in DBHelper.createTableSqls() {
            do {
                try db.executeUpdate(sql, values: nil)
            } catch let error as NSError {
                print("create table sql failed: \(error.localizedDescription)")
                succ = false
                break
            }
        }
        
        return succ
    }
    
    static func createTableSqls() -> [String] {
        return [
        "CREATE TABLE `TB_DRIVER_LICENCE_DETAIL` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `familyName` TEXT, `firstNames` TEXT, `birth` TEXT, `licence` TEXT, `version` TEXT, `address` TEXT);",
        "CREATE TABLE `TB_DRIVER_LICENCE_IMAGE` (`driverId` INTEGER, `image` BLOB);"
        ]
    }
}
