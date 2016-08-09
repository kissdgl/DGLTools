//
//  SQLiteManager.swift
//  01-SQLite的使用(基本使用)
//
//  Created by 丁贵林 on 16/8/6.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

import UIKit
import FMDB

class SQLiteManager: NSObject {
    
    //设计成单例
    static let shareManager : SQLiteManager = SQLiteManager()
    
    //MARK: - 定义数据库对象
    var db : FMDatabase!
    
}

//MARK: - 打开数据库
extension SQLiteManager {
    
    func openDB(dbPath : String) -> Bool {

        db = FMDatabase(path: dbPath)
        
        //2.打开数据库
      return db.open()
    }
}


//MARK: - 执行SQL语句操作
extension SQLiteManager {
    
    func exeSQL(sqlString : String) -> Bool {
        //2.执行SQL语句
        return db.executeUpdate(sqlString, withArgumentsInArray: nil)
    }
    
}

//MARK: - 事务的相关操作
extension SQLiteManager {
    
    func beginTransaction() {
        //1.开启事务
        db.beginTransaction()
    }
    
    func commitTransaction() {
        //1.提交事务语句
        db.commit()
    }
    
    func rollbackTransaction() {
        //1.回滚事务语句
        db.rollback()
    }
    
}


//MARK: - 查询数据操作
extension SQLiteManager {
    
    func queryData(querySQLString : String) -> [[String : NSObject]] {
        
        //1.执行查询语句
        let resultSet = db.executeQuery(querySQLString, withArgumentsInArray: nil)
        
        //2.开始查询
        let count = resultSet.columnCount()
        
        //3定义数组
        var tempArray = [[String : NSObject]]()
        
        //4.查询数据
        while resultSet.next() {
            
            //遍历所有的键值对
            var dict = [String : NSObject]()
            for i in 0..<count {
                let key = resultSet.columnNameForIndex(i)
                let value = resultSet.stringForColumnIndex(i)
                dict[key] = value
            }
            tempArray.append(dict)
        }
        return tempArray
    }
    
}