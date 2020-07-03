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
    
    var pauseAllTasksMem:[Int] = []
    func pauseAllTasks(){
        self.pauseAllTasksMem = []
        
        for ind in self.taskData.indices{
            if self.taskData[ind].selected{
                pauseAllTasksMem.append(ind)
                self.taskData[ind].selected = false
            }
        }
    }
    
    func resumeAllTasks(){
        for ind in pauseAllTasksMem{
            self.taskData[ind].selected = true
        }
        self.pauseAllTasksMem = []
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
    let timer = Timer.publish(every: 1.0/4.0, on: .main  , in: .common).autoconnect()
    
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

    
}
