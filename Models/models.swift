//
//  models.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/13/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import Foundation
import SwiftUI

class models: ObservableObject
{
    var timer = Timer.publish(every: 1.0/4.0, on: .main  , in: .common).autoconnect()
     @Published var categories:[category] = []
    
     struct task:Equatable, Hashable, Codable
     {
        
        /*
         * name
         * category
         * timestamps
         *
         */
        var lastChanged:TimeInterval?
        var myId:Int
        var name:String
        var description:String
        var categoryInd:Int = 0 //0 is uncategorized
        var timestamp:[String:TimeInterval] = .init()
//            ["":TimeInterval()]
        var selected:Bool = false // if the current task is ON
        
    }
    
    struct category:Equatable, Hashable, Codable {
        var name:String
        var color:String
        
        init(_ name:String, _ color:String = "orange") {
            self.name = name
            self.color = color
        }
 
    }
    
    var pauseUpdate:Bool = false
    var pauseAllTasksMem:[Int] = []
    var pauseAtom:Bool = false
    func pauseAllTasks(){
        if(!pauseAtom){
        self.pauseAllTasksMem = []

        for ind in self.taskData.indices{
            if self.taskData[ind].selected{
                pauseAllTasksMem.append(ind)
                self.taskData[ind].selected = false
            }
        }
            self.pauseAtom = true
        }
    }
    
    func resumeAllTasks(){
        if(self.pauseAtom == true){
        for ind in pauseAllTasksMem{
            self.taskData[ind].selected = true
        }
        self.pauseAllTasksMem = []
            self.pauseAtom = false
        }
    }
    
    func pauseSummaryUpdates(){
        self.pauseUpdate = true
    }
    
    func resumeSummaryUpdates(){
        self.pauseUpdate = false
    }
    
    func pauseTasksAndSummary(){
        self.pauseAllTasks()
        self.pauseSummaryUpdates()
    }
    
    func resumeTasksAndSummary(){
        self.resumeAllTasks()
        self.resumeSummaryUpdates()
    }
    
    func getColorName(_ color:Color)->String
    {
        switch color {
        case .gray:
            return "gray"
        case .blue:
            return "blue"
        case .green:
            return "green"
        case .orange:
            return "orange"
        case .pink:
            return "pink"
        case .purple:
            return "purple"
        case .red:
            return "red"
        case .yellow:
            return "yellow"
        case .init(red: 195/256, green: 151/256, blue: 151/256):
            return "brown"
        case.init(red: 0/256, green: 206/256, blue: 209/256):
            return "cyan"
        case .init(red: 128/256, green: 0/256, blue: 0/256):
            return "maroon"
        case .init(red: 255/256, green: 195/256, blue: 160/256):
            return "pale"
        case .init(red:0,green:128/256,blue:128/256):
            return "dark green"
        case .init(red:218/256,green:165/256,blue:32/256):
            return "gold"
        default:
            return "orange"
        }
    }
    
    func getColor(_ colorName:String)->Color
    {
        switch colorName {
        case "gray":
            return .gray
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "red":
            return .red
        case "purple":
            return .purple
        case "pink":
            return .pink
        case "orange":
            return .orange
        case "green":
            return .green
        case "brown":
            return .init(red: 195/256, green: 151/256, blue: 151/256)
        case "cyan":
            return .init(red: 0/256, green: 206/256, blue: 209/256)
        case "maroon":
            return .init(red: 128/256, green: 0/256, blue: 0/256)
        case "pale":
            return .init(red: 255/256, green: 195/256, blue: 160/256)
        case "dark green":
            return .init(red:0,green:128/256,blue:128/256)
        case "gold":
            return .init(red:218/256,green:165/256,blue:32/256)
        default:
            return .orange
        }
    }
    
    var today:String = ""
    
    var colors:[Color] = [.blue,.red,.orange,.pink,.purple,.yellow,.green,
                          .init(red: 195/256, green: 151/256, blue: 151/256),.init(red: 0/256, green: 206/256, blue: 209/256),.init(red: 128/256, green: 0/256, blue: 0/256), .init(red: 255/256, green: 195/256, blue: 160/256),.init(red:0,green:128/256,blue:128/256),
                          .init(red:218/256,green:165/256,blue:32/256)
    ]
    
    @Published var sumaryRecord = SummaryDaemon()
    
    @Published var concurrentTasks:Bool = false
    
    @Published var taskData:[task] = []

    var timeCounter = 0
    
    init()
    {
//        categories = [category("No category", .gray),category("Work"),category("Study"),category("Play"),category("Socialize")]

        
        //        taskData = taskData = [task( myId:1,name: "CS6515", description: "Study that", categoryInd:0),task(myId:2,name: "analog work", description: "run simulation",categoryInd:1)]
        
        print("Initializing models")
    }
    //Summary models
    struct taskRecord : Hashable
    {
        init(_ task:Int,_ time:TimeInterval)
        {
            self.task = task
            self.time = time
        }
        var task:Int
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
    var summaryTimeRange : Calendar.Component = .day
    var refDate = Date()
    @Published var taskRecordArr:[taskRecord] = .init()
    @Published var catRecordArr:[catRecord] = .init()
    var calculateSummary = false
    var showTaskvsCategory = true

    //Task Management
    var currentTaskIndx:Int? //set if concurrent tasks are disabled
    
      //select task based on app settings.
      func selectTask(taskInd:Int)
      {
    
          //if running, stop
          if (self.taskData[taskInd].selected)
          {
              self.taskData[taskInd].selected = false
              self.taskData[taskInd].lastChanged = nil
              self.currentTaskIndx = nil
              return
          }
          
          /*
             1. check if the the current task is selected and check for the concurrent condition.
             2. increment that interval for the current day
             */
          if(!self.concurrentTasks && self.currentTaskIndx != nil && self.currentTaskIndx! < self.taskData.count)
          {
              //if one task is already selected, stop the running task
              self.taskData[self.currentTaskIndx!].lastChanged = nil
              self.taskData[self.currentTaskIndx!].selected = false
          }
          else if (self.currentTaskIndx != nil && self.currentTaskIndx! >= self.taskData.count)
          {
              self.currentTaskIndx = nil
          }
          //add today's record if it doesn't exist
          let todayData = self.taskData[taskInd].timestamp[self.today]
          if (todayData == nil)
          {
              //add to the task
              self.taskData[taskInd].timestamp[self.today] = TimeInterval()
          }
          
          self.taskData[taskInd].selected = true
          if(!self.concurrentTasks){
              self.currentTaskIndx = taskInd
          }
      }
    
        // increment the activated task times based on the timer.
        func incrementTaskCounter(task:Binding< models.task>)
        {
            /*
            If the task is selected, increment its counter
             */
                let interval = task.wrappedValue.timestamp[self.today]
                /*
                 Check if the timer was changed recently.
                 
                 */
                let lastChangedDate = Date(timeIntervalSince1970: task.wrappedValue.lastChanged ?? Date().timeIntervalSince1970)
    //        print(lastChangedDate.timeIntervalSince1970)
                let endDate = Date()
            var duration :Double = 0
//            print("start \(lastChangedDate.description) and end \(endDate.description)")
            if(lastChangedDate < endDate){
            let DateIntervalVal = DateInterval(start: lastChangedDate, end: endDate)
            duration = DateIntervalVal.duration.magnitude
            }
            else{
                duration = 0
            }
                task.wrappedValue.lastChanged = Date().timeIntervalSince1970
                if duration > 1.50
                {
                    if(duration > 60*60*24){
                        // adding more than a day.
                        //temporary fix
                        duration = min(duration,60*60*24)
                    }
                    
                    task.wrappedValue.timestamp[self.today] = TimeInterval((interval ?? TimeInterval(0)).advanced(by: Double(Int(duration))))
                    
                }
                else{
                
                task.wrappedValue.timestamp[self.today] = TimeInterval((interval ?? TimeInterval(0)).advanced(by: 1))
                    task.wrappedValue.timestamp[self.today] = Swift.min(task.wrappedValue.timestamp[self.today] ?? 0,60*60*24)
                    
                   
                }
            
            
        }
    
}
