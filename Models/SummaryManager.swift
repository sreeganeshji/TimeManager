//
//  SummaryManager.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/23/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import Foundation

class SummaryDaemon:ObservableObject
{

    
  
    var taskArr:[models.task]
    var formatter = DateFormatter()
    var DayTaskWise:[models.task:TimeInterval] = .init()
    var DayCatWise:[Int:TimeInterval] = .init()
    var taskRecordArr : [models.taskRecord] = .init()
    var catRecordArr : [models.catRecord] = .init()
    var processing:Bool = false
    var categoryList: [models.category]

    init(format:String = "MM_dd_yyyy")
    {
        self.formatter.dateFormat = format
        self.taskArr = []
        self.categoryList = []
    }
    init(taskList:[models.task],categoryList:[models.category])
    {
        self.formatter.dateFormat = "MM_dd_yyyy"
        self.taskArr = taskList
        self.categoryList = categoryList
    }
//    func fillArray<K:Hashable,L>(dictionary:[K:TimeInterval],array:inout[L])
//    {
//        array = []
//        for (key, value) in dictionary
//        {
//            array.append(L(key,value))
//        }
//    }
    func fillTaskArray(dic:[models.task:TimeInterval],curArray:inout [models.taskRecord])
    {
        var array:[models.taskRecord] = .init()
        for (task,time) in dic{
            array.append(.init(task, time))
        }
        array.sort { (taskRecord1, taskRecord2) -> Bool in
            if(taskRecord1.time > taskRecord2.time)
            {
                return true
            }
            else if (taskRecord1.time == taskRecord2.time) && (taskRecord1.task.name > taskRecord2.task.name)
            {
                return true
            }
            return false
        
        }
        curArray = .init(array)
    }

    func giveTaskArray(dic:[models.task:TimeInterval]) ->([models.taskRecord])
    {
        var array:[models.taskRecord] = .init()
        for (task,time) in dic{
            array.append(.init(task, time))
        }
        array.sort { (taskRecord1, taskRecord2) -> Bool in
            if(taskRecord1.time > taskRecord2.time)
            {
                return true
            }
            else if (taskRecord1.time == taskRecord2.time) && (taskRecord1.task.name > taskRecord2.task.name)
            {
                return true
            }
            return false
        
        }
        return array
    }
    
    func fillCatArray(dic:[Int:TimeInterval],curArray:inout [models.catRecord])
       {
        var array :[models.catRecord] = .init()
           for (cat,time) in dic{
               array.append(.init(cat, time))
           }
           array.sort { (catRecord1, catRecord2) -> Bool in
               if(catRecord1.time > catRecord2.time)
               {
                return true
           }
            else if (catRecord1.time == catRecord2.time) && ( self.categoryList[catRecord1.categoryInd].name > categoryList[catRecord2.categoryInd].name)
               {
                return true
            }
            return false

       }
        curArray = .init(array)
    }
    
    func giveCatArray(dic:[Int:TimeInterval])->([models.catRecord])
       {
        var array :[models.catRecord] = .init()
           for (cat,time) in dic{
               array.append(.init(cat, time))
           }
           array.sort { (catRecord1, catRecord2) -> Bool in
               if(catRecord1.time > catRecord2.time)
               {
                return true
           }
            else if (catRecord1.time == catRecord2.time) && ( self.categoryList[catRecord1.categoryInd].name > categoryList[catRecord2.categoryInd].name)
               {
                return true
            }
            return false

       }
        return array
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
        
        self.fillTaskArray(dic: self.DayTaskWise, curArray: &self.taskRecordArr)
        self.fillCatArray(dic: self.DayCatWise, curArray: &self.catRecordArr)
    }
    
    var timeRange:Calendar.Component = .day
    
    func update(dateComponent:Calendar.Component, startDate:Date)
    {
        //clear previous results
        self.refresh()
        //declarations
        let calendar = Calendar.autoupdatingCurrent
        var dateDecrement = DateComponents()
        dateDecrement.day = -1
        //extract current date component
        let currentComponentValue = calendar.component(timeRange, from: startDate)
    
        var newComponentValue = calendar.component(timeRange, from: startDate)
        var date = startDate
        while(newComponentValue == currentComponentValue)
        {
            //execute day function
            self.dayExecute(date: date)
            
            //update date and components
            date = calendar.date(byAdding: dateDecrement, to: date) ?? date
            newComponentValue = calendar.component(timeRange, from: date)
        }
        print("problem")
    }
}
