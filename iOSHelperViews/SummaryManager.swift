//
//  SummaryManager.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/23/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import Foundation

class SummaryDaemon
{
    struct taskRecord : Hashable
    {
        init(_ task:models.task,_ time:TimeInterval)
        {
            self.task = task
            self.time = time
        }
        var task:models.task
        var time:TimeInterval
    }
    struct catRecord : Hashable
    {
        init(_ catInd:Int,_ time:TimeInterval)
        {
            self.categoryInd = catInd
            self.time = time
        }
        var categoryInd:Int
        var time:TimeInterval
    }
    
    var taskArr:[models.task]
    var formatter = DateFormatter()
    var DayTaskWise:[models.task:TimeInterval] = .init()
    var DayCatWise:[Int:TimeInterval] = .init()
    var DayTaskRecord : [taskRecord] = .init()
    var DayCatRecord : [catRecord] = .init()
    var processing:Bool = false

    init(taskArray:[models.task],format:String = "MM_dd_yyyy")
    {
        self.taskArr = taskArray
        self.formatter.dateFormat = format
    }
//    func fillArray<K:Hashable,L>(dictionary:[K:TimeInterval],array:inout[L])
//    {
//        array = []
//        for (key, value) in dictionary
//        {
//            array.append(L(key,value))
//        }
//    }
    func fillTaskArray(dic:[models.task:TimeInterval],array:inout [taskRecord])
    {
        array = .init()
        for (task,time) in dic{
            array.append(.init(task, time))
        }
        array.sort { (taskRecord1, taskRecord2) -> Bool in
            taskRecord1.time > taskRecord2.time
        }
    }
    func fillCatArray(dic:[Int:TimeInterval],array:inout [catRecord])
       {
        array = .init()
           for (cat,time) in dic{
               array.append(.init(cat, time))
           }
           array.sort { (catRecord1, catRecord2) -> Bool in
               catRecord1.time > catRecord2.time
           }
       }
    func refresh()
    {
//        self.day(date: Date())
        self.DayTaskWise = .init()
        self.DayCatWise = .init()
    }
    func dayExecute(date:Date)->()
    {
        // find all tasks in that day and add up their values
        let today = self.formatter.string(from: date)
        for task in self.taskArr
        {
            if task.timestamp[today] != nil{
                self.DayTaskWise[task] = task.timestamp[today]
             
                    if self.DayCatWise[task.categoryInd] == nil{
                        self.DayCatWise[task.categoryInd] = task.timestamp[today]
                    }
                    else{
                        self.DayCatWise[task.categoryInd] = self.DayCatWise[task.categoryInd]?.advanced(by: task.timestamp[today] ?? 0)
                    }
                }
            }
        
        self.fillTaskArray(dic: self.DayTaskWise, array: &self.DayTaskRecord)
        self.fillCatArray(dic: self.DayCatWise, array: &self.DayCatRecord)
    }
    
    
    
    func update(dateComponent:Calendar.Component, startDate:Date)
    {
        //clear previous results
        self.refresh()
        //declarations
        let calendar = Calendar.autoupdatingCurrent
        var dateDecrement = DateComponents()
        dateDecrement.day = -1
        //extract current date component
        let currentComponentValue = calendar.component(dateComponent, from: startDate)
    
        var newComponentValue = calendar.component(dateComponent, from: startDate)
        var date = startDate
        while(newComponentValue == currentComponentValue)
        {
            //execute day function
            self.dayExecute(date: date)
            
            //update date and components
            date = calendar.date(byAdding: dateDecrement, to: date) ?? date
            newComponentValue = calendar.component(dateComponent, from: date)
        }
        

    }
}
