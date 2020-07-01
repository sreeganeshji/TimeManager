//
//  ContentView.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data:models
    @State var i:Int = 0
    @State var currentTaskIndx:Int? //set if concurrent tasks are disabled
    
//    let today = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date())
    @State var interval = TimeInterval()
    let format = DateFormatter()
    @State var today :String = ""
    let displayFormat = DateFormatter()
    
    @State var showSheet = false
    @State var addTaskRequest = false
    @State var settingsView = false
    @State var showTaskOptions = false
    @State var selectedTaskInd : Int = 0
    
    
    let tempTask = models.task(myId: 5, name: "Test task", description: "Something's wrong")
    
    init() {
        self.format.dateFormat = "MM_dd_yyyy"
        self.displayFormat.dateFormat = "hh:MM:ss"
    }
    
    
// convert seconds into demarkations
    func formattedTime(time:TimeInterval)->String
    {
        var seconds:Int = Int(time.binade)
        var minutes = seconds/60
        let hours = minutes/60
        minutes = minutes%60
        seconds = seconds%60
        return("\(hours):\(minutes):\(seconds)")
    }
    
    // increment the activated task times based on the timer.
    func incrementTaskCounter(task:Binding< models.task>)
    {
        /*
        If the task is selected, increment its counter
         */
        let originalTaskname = task.wrappedValue.name
            let interval = task.wrappedValue.timestamp[self.today]
            /*
             Check if the timer was changed recently.
             
             */
            let lastChangedDate = Date(timeIntervalSince1970: task.wrappedValue.lastChanged ?? Date().timeIntervalSince1970)
//        print(lastChangedDate.timeIntervalSince1970)
        let newTaskname = task.wrappedValue.name
        if(originalTaskname != newTaskname)
        {
            print("Task changed from \(originalTaskname) to \(newTaskname)")
        }
            let duration = DateInterval(start: lastChangedDate, end: Date()).duration.magnitude
            
            task.wrappedValue.lastChanged = Date().timeIntervalSince1970
            if duration > 1.50
            {
                task.wrappedValue.timestamp[self.today] = TimeInterval(interval!.advanced(by: Double(Int(duration))))
            }
            else{
            task.wrappedValue.timestamp[self.today] = TimeInterval(interval!.advanced(by: 1))
            }
        
        
    }
    
    //select task based on app settings.
    func selectTask(taskInd:Int)
    {
  
        //if running, stop
        if (self.$data.taskData[taskInd].wrappedValue.selected)
        {
            self.$data.taskData[taskInd].wrappedValue.selected = false
            self.data.taskData[taskInd].lastChanged = nil
            self.currentTaskIndx = nil
            return
        }
        
        /*
           1. check if the the current task is selected and check for the concurrent condition.
           2. increment that interval for the current day
           */
        if(!self.data.concurrentTasks && self.currentTaskIndx != nil && self.currentTaskIndx! < self.data.taskData.count)
        {
            //if one task is already selected, stop the running task
            self.data.taskData[self.currentTaskIndx!].lastChanged = nil
            self.$data.taskData[self.currentTaskIndx!].selected.wrappedValue = false
        }
        else if (self.currentTaskIndx != nil && self.currentTaskIndx! >= self.data.taskData.count)
        {
            self.currentTaskIndx = nil
        }
        //add today's record if it doesn't exist
        let todayData = self.data.taskData[taskInd].timestamp[self.today]
        if (todayData == nil)
        {
            //add to the task
            self.$data.taskData[taskInd].wrappedValue.timestamp[self.today] = TimeInterval()
        }
        
        self.$data.taskData[taskInd].wrappedValue.selected = true
        if(!self.data.concurrentTasks){
            self.currentTaskIndx = taskInd
        }
    }
    
    func getColor(_ taskInd:Int)->Binding<Color>
    {
        return .constant(.init( self.data.categories[self.data.taskData[taskInd].categoryInd].color))
    }
    
    var body: some View {
//        NavigationView{
    
            TabView() {
                //Begin task tab view
                NavigationView{

            List{
                        ForEach(data.taskData.indices,id: \.self)
                        {
                            index in
                                
                            taskRowiOS2(taskInd:index)
                             
                            
                            .onTapGesture {
                                    self.selectTask(taskInd: index)
                                    }
                            .onLongPressGesture {
                                self.selectedTaskInd = index
                                self.showTaskOptions = true
                                self.showSheet = true
                            }
                        }
                        .onDelete(perform: { ind in
                            self.data.taskData.remove(atOffsets: ind)
                            self.data.sumaryRecord.taskArr = self.data.taskData
                            self.data.sumaryRecord.categoryList = self.data.categories
                            self.data.sumaryRecord.update(dateComponent: .day, startDate: Date())

                        })
                            .onMove { (IndSet, ind) in
                                self.data.taskData.move(fromOffsets: IndSet, toOffset: ind)
                    }
                }
            .onAppear(){
                if(self.data.concurrentTasks)
                {
                    self.currentTaskIndx = nil
                }
                
                if(self.currentTaskIndx == nil && !self.data.concurrentTasks)
                {
                    for i in 0...self.data.taskData.count-1
                    {
                        self.data.taskData[i].selected = false
                        self.data.taskData[i].lastChanged = nil
                    }
                }
                self.today = self.format.string(from: Date())
            }
                .navigationBarTitle("Tasks")
            
                .navigationBarItems(leading: EditButton() ,trailing:
              
                    Button(action:{
                        self.addTaskRequest = true
                        self.showSheet = true
                    })
                        {
                    Image(systemName: "square.and.pencil")
                        }
                    )
                }
        .tabItem{
            Image(systemName: "list.bullet")
            Text("Tasks")
                }
                //End Tasks tab view
                
                
                //Summary tab view
                NavigationView{
                    SummaryiOS(ShowTaskvsCategory: self.data.showTaskvsCategory).environmentObject(self.data)
            }
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Summary")
                }
                
                
                //Cattegories tab view
                NavigationView{
                CategoryList().environmentObject(self.data)
            }
                    .tabItem({
                        Image(systemName: "bookmark.fill")
                        Text("Categories")
                    })
                
                
                NavigationView{
                  
                    SettingsiOS(activeView:.constant(false)).environmentObject(self.data)
                    
                    .navigationBarTitle("Settings")
                    .environmentObject(self.data)
                }
                    .tabItem{
                        Image(systemName: "slider.horizontal.3")
                        Text("Settings")
                }
                
            
                
            } //ending tabView

                // Timer handler
                .onReceive(self.data.timer) { _ in
                    //update every fourth count or 1 second.
                    if(self.data.timeCounter == 4)
                    {
                        self.data.timeCounter = 0
                                   if self.data.taskData.count == 0
                                   {
                                       return
                                   }
                                   for ind in 0...self.$data.taskData.wrappedValue.count-1
                                 {
                                   if self.data.taskData[ind].selected{
                                     self.incrementTaskCounter(task: self.$data.taskData[ind])
                                   }
                                 }
                        if (self.format.string(from: .init()) != self.today)
                        {
                            self.today = self.format.string(from: .init())
                        }
                    }
                    //Update Summary records
                    if(self.data.calculateSummary){
                    self.data.sumaryRecord.taskArr = self.data.taskData
                    self.data.sumaryRecord.categoryList = self.data.categories
                    self.data.sumaryRecord.update(dateComponent: self.data.summaryTimeRange, startDate: self.data.refDate)
                    self.data.taskRecordArr = self.data.sumaryRecord.taskRecordArr
                    self.data.catRecordArr = self.data.sumaryRecord.catRecordArr
                    }
                    self.data.timeCounter += 1
            }
                     
                    .navigationBarTitle("Tasks")
            .sheet(isPresented: $showSheet, content: {
                
                if (self.settingsView)
                {
                Settings(activeView: self.$showSheet).environmentObject(self.data)
                    .onDisappear()
                        {
                            self.settingsView = false
                    }
                }
                else if (self.showTaskOptions)
                {
                    TaskSummaryiOS(taskInd: self.selectedTaskInd, showSheet: self.$showSheet).environmentObject(self.data)
                    .onDisappear()
                        {
                            self.showTaskOptions = false
                    }
                }
                else if (self.addTaskRequest)
                {
                    addTaskiOS(activeView: self.$showSheet,categoryList: self.data.categories).environmentObject(self.data)
                    .onDisappear()
                        {
                            self.addTaskRequest = false
                    }
                }
          
                })

//            .contextMenu(menuItems: {
//
//                VStack{
//                    Button(action:{self.addTaskRequest = true; self.showSheet = true},label: {
//                        VStack{
//                        Text("Add task")
//                        Image(systemName: "plus.circle.fill")
//                        }
//                    })
//                    Button(action:{self.settingsView = true; self.showSheet = true},label: {
//                         VStack{
//                         Text("Settings")
//                         Image(systemName: "slider.horizontal.3")
//                         }
//                     })
//                }
//
//            })
                                        
           
 
            
//            Button(action:{
//                let interval = self.$data.taskData[1].timestamp.wrappedValue[self.today]
//                self.$data.taskData[1].timestamp.wrappedValue[self.today] = interval!.advanced(by: 1)
//            })
//            {
//                Text("\(self.$data.taskData[1].name.wrappedValue) \($data.taskData[1].timestamp.wrappedValue[self.today] == nil ? "" : $data.taskData[1].timestamp.wrappedValue[self.today]!.description )")
            }
        }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(models())
    }
}
