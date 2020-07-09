//
//  mainView2.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/8/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct mainView2: View {
    enum ViewOptions {
        case Tasks, Summary, Categories, Settings
    }
    @State var selectedView :ViewOptions = .Tasks
    
                    // Timer handler
    func timerHandler(){
                        
        
                            
                        //update every fourth count or 1 second.
                        if(self.data.timeCounter == 4)
                        {
                            self.data.timeCounter = 0
                                       if self.data.taskData.count == 0
                                       {
                                           return
                                       }
                                       for ind in 0...self.data.taskData.count-1
                                     {
                                       if self.data.taskData[ind].selected{
                                        self.data.incrementTaskCounter(task: self.$data.taskData[ind])
                                       }
                                     }
                            if (self.format.string(from: .init()) != self.data.today)
                            {
                                self.data.today = self.format.string(from: .init())
                            }
                        }
            if(!self.data.pauseUpdate)
            {
                        //Update Summary records
                        if(self.data.calculateSummary){
                        self.data.sumaryRecord.taskArr = self.data.taskData
                        self.data.sumaryRecord.categoryList = self.data.categories
                        self.data.sumaryRecord.update(dateComponent: self.data.summaryTimeRange, startDate: self.data.refDate)
                        self.data.taskRecordArr = self.data.sumaryRecord.taskRecordArr
    //                        for record in self.data.taskRecordArr{
    ////                            print(record.task, "time",record.time)
    //                        }
                        self.data.catRecordArr = self.data.sumaryRecord.catRecordArr
                        }
        }
                        self.data.timeCounter += 1
            
                }
    var format:DateFormatter = .init()
    
    init()
    {
        self.format.dateFormat = "MM_dd_yyyy"
    }
    
    @EnvironmentObject var data:models
    var body: some View {

        VStack{
            //Task View
            if(self.selectedView == .Tasks){
                NavigationView{
                ContentView().environmentObject(self.data)
                    .onAppear(){
                        self.data.resumeAllTasks()
                        self.timerHandler()
                    }
                }
            .tabItem{
                     Image(systemName: "list.bullet")
                     Text("Tasks")
                         }
            }
                
            //Summary View
            else if (self.selectedView == .Summary){
                NavigationView{
            SummaryiOS(ShowTaskvsCategory: self.data.showTaskvsCategory).environmentObject(self.data)
                    .onAppear(){
                        self.data.resumeTasksAndSummary()
                                      }
            .onDisappear(){
                self.data.pauseSummaryUpdates()
                    }
                }
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Summary")
                }
            }
                
                //Category view
            else if (self.selectedView == .Categories){
                NavigationView{
                    CategoryList().environmentObject(self.data)
                        .onAppear(){
                            self.data.pauseTasksAndSummary()
                    }
                    .onDisappear(){
                        print("Disappeared")
                    }
                }
                    .tabItem({
                        Image(systemName: "bookmark.fill")
                        Text("Categories")
                    })
            }
                //Settings view
            else if(self.selectedView == .Settings)
            {
                NavigationView{
                SettingsiOS(activeView:.constant(false)).environmentObject(self.data)
                    .onAppear(){
                        self.data.pauseTasksAndSummary()
                    }

                }
                    .tabItem{
                        Image(systemName: "slider.horizontal.3")
                        Text("Settings")
                }
            }
            HStack{
                                                
                                         
                                                VStack{
                                               Image(systemName: "list.bullet")
                                                    Text("Tasks").font(.footnote)
                                                }
                                                .onTapGesture {
                                                    self.selectedView = .Tasks
                }
                .foregroundColor((self.selectedView == .Tasks) ? .blue : .gray)
                
                Spacer()
                

                                 VStack{
                                 Image(systemName: "chart.pie.fill")
                                    Text("Summary").font(.footnote)
                                 }
                                 .onTapGesture {
                                    self.selectedView = .Summary
                                 }
                                 .foregroundColor((self.selectedView == .Summary) ? .blue : .gray)
                                 
//                             }
                
                Spacer()
                
                    VStack{
                    Image(systemName: "bookmark.fill")
                        Text("Categories").font(.footnote)
                    }
                     .foregroundColor((self.selectedView == .Categories) ? .blue : .gray)
                    .onTapGesture {
                         self.selectedView = .Categories
                }
                
                Spacer()
                
                                 VStack{
                                 Image(systemName: "slider.horizontal.3")
                                    Text("Settings").font(.footnote)
                                 }
                                 .onTapGesture {
                                    self.selectedView = .Settings
                                    
                }
                .foregroundColor((self.selectedView == .Settings) ? .blue : .gray)
                             
            }.padding()
               
            
        }
            
            .onReceive(self.data.timer){
                _ in
                self.timerHandler()
        }
                 
//    }
}
}

struct mainView2_Previews: PreviewProvider {
    static var previews: some View {
        mainView2().environmentObject(models())
    }
}
