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
    let timer = Timer.publish(every: 1.0, on: .main  , in: .common).autoconnect()
//    let today = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date())
    @State var interval = TimeInterval()
    let format = DateFormatter()
    let today :String
    let displayFormat = DateFormatter()
    
    @State var showSheet = false
    @State var addTaskRequest = false
    @State var settingsView = false
    @State var showTaskOptions = false
    @State var selectedTaskInd : Int = 0
    
    
    let tempTask = models.task(myId: 5, name: "Test task", description: "Something's wrong")
    
    init() {
        self.format.dateFormat = "MM_dd_yyyy"
        self.today = format.string(from: Date())
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
        self.currentTaskIndx = taskInd
    }
    
    func getColor(_ taskInd:Int)->Binding<Color>
    {
        return .constant( self.data.categories[self.data.taskData[taskInd].categoryInd].color)
    }
    
    var body: some View {
//        NavigationView{
    
            TabView() {
                
                NavigationView{
//        Form{
    
            
            List{
                        ForEach(data.taskData.indices,id: \.self)
                        {
                            index in


//                                taskRowiOS(name: self.data.taskData[index].name, time: self.$data.taskData[index].timestamp[self.today].wrappedValue,color: self.getColor(index), isActive: self.$data.taskData[index].selected)
                                
                            taskRowiOS2(taskInd:index)
                             
                            
                            .onTapGesture {
                                    self.selectTask(taskInd: index)
                                    }
                            .onLongPressGesture {
                                self.selectedTaskInd = index
                                self.showTaskOptions = true
                                self.showSheet = true
                            }

                           
//                            }

                        }
                        
                        .onDelete(perform: { ind in
                            self.data.taskData.remove(atOffsets: ind)

                        })
                            .onMove { (IndSet, ind) in
                                self.data.taskData.move(fromOffsets: IndSet, toOffset: ind)
                }
                       
//            }
            

                    
//                            NavigationLink(destination:addTaskiOS(activeView: self.$addTaskRequest).environmentObject(data))
//                                        {
//                                            HStack{
//                                                Text("Add task")
//                                                Spacer()
//                                            Image(systemName: "plus.circle.fill")
//                                                .accentColor(.green)
//                                            }
//                                        }
//
//
//                        NavigationLink(destination: Settings(activeView: .constant(false)).environmentObject(self.data))
//                        {
//                            HStack{
//                            Text("Settings")
//                            Spacer()
//                            Image(systemName: "slider.horizontal.3")
//                            }
//                        }
//                        .accentColor(.orange)
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
                
//                TaskList().environmentObject(self.data)
//                    .tabItem({
//                        Image(systemName: "list.bullet")
//                                   Text("Tasks")
//                    })
                
                //Summary
                SummaryiOS().environmentObject(self.data)
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Summary")
                }
                
                
                CategoryList().environmentObject(self.data)
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
//    }//ending Navigation View
            .onReceive(self.timer) { _ in

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
                               }
            
                                                            
//                        .sheet(isPresented: $addTaskRequest, content:{ addTask(activeView: self.$addTaskRequest).environmentObject(self.data)})
//
                        
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
                    TaskSummaryiOS(taskInd: self.selectedTaskInd).environmentObject(self.data)
                    .onDisappear()
                        {
                            self.showTaskOptions = false
                    }
                }
                else if (self.addTaskRequest)
                {
                    addTaskiOS(activeView: self.$showSheet).environmentObject(self.data)
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
