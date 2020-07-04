//
//  mainView.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/3/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct mainView: View {
    
    
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
//        NavigationView{
            TabView(){
            //Tasks view
//            NavigationLink(destination:
//            ContentView().environmentObject(self.data))
//            {
//                HStack{
//                Image(systemName: "list.bullet")
//                Text("Tasks")
//                }
//            }
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
                         //End Tasks tab view
            
            //Summary tab view
//            NavigationLink(destination:
//
//                    SummaryiOS(ShowTaskvsCategory: self.data.showTaskvsCategory).environmentObject(self.data))
//
//                    {
//                        HStack{
//                            Image(systemName: "chart.pie.fill")
//                            Text("Summary")
//
//                        }
//
//                    }
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
                
                
                //Cattegories tab view
//                NavigationLink(destination:
//
//                CategoryList().environmentObject(self.data)
//
//                ){
//                    HStack{
//                        Image(systemName: "bookmark.fill")
//                    Text("Categories")
//                    }
//                }
                NavigationView{
                    CategoryList().environmentObject(self.data)
                        .onAppear(){
                            self.data.pauseTasksAndSummary()
                    }
                }
                    .tabItem({
                        Image(systemName: "bookmark.fill")
                        Text("Categories")
                    })
                
//                NavigationLink(destination:
//
//
//                    SettingsiOS(activeView:.constant(false)).environmentObject(self.data)
//
//                    .navigationBarTitle("Settings")
//                    .environmentObject(self.data)
//
//                ){
//                    HStack{
//                        Image(systemName: "slider.horizontal.3")
//                Text("Settings")
//                    }
//                }
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
            .onReceive(self.data.timer){
                _ in
                self.timerHandler()
        }
                 
//    }
}
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView().environmentObject(models())
    }
}
