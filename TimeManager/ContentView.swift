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
   
    
//    let today = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date())
    @State var interval = TimeInterval()
    let format = DateFormatter()

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
    
    func getColor(_ taskInd:Int)->Binding<Color>
    {
        return .constant(.init( self.data.categories[self.data.taskData[taskInd].categoryInd].color))
    }
    
    var body: some View {
//        NavigationView{
    
//            TabView() {
                //Begin task tab view
//                NavigationView{

            List{
                        ForEach(data.taskData.indices,id: \.self)
                        {
                            index in
                                
                            taskRowiOS2(taskInd: index, selectedTaskInd: self.$selectedTaskInd, showTaskOptions: self.$showTaskOptions, showSheet: self.$showSheet)
                             
                            
//                            .onTapGesture {
//                                    self.selectTask(taskInd: index)
//                                    }
//                            .onLongPressGesture {
//                                self.selectedTaskInd = index
//                                self.showTaskOptions = true
//                                self.showSheet = true
//                            }
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
                if(self.data.taskState.concurrentTasks)
                {
                    self.data.taskState.currentTaskIndx = nil
                }
                
                if(self.data.taskState.currentTaskIndx == nil && !self.data.taskState.concurrentTasks)
                {
                    for i in 0...self.data.taskData.count-1
                    {
                        self.data.taskData[i].selected = false
                        self.data.taskData[i].lastChanged = nil
                    }
                }
                self.data.today = self.format.string(from: Date())
            }
                .navigationBarTitle("Tasks")
            
            .navigationBarItems(leading: EditButton() ,trailing:
              
                    Button(action:{
                        print("Pressed")
                        self.addTaskRequest = true
                        self.showSheet = true
                        self.data.pauseTasksAndSummary()
                    })
                        {
                            Image(systemName: "square.and.pencil")
                        }
                    )
//                }
//        .tabItem{
//            Image(systemName: "list.bullet")
//            Text("Tasks")
//                }
//                //End Tasks tab view
                
                
//                //Summary tab view
//                NavigationView{
//                    SummaryiOS(ShowTaskvsCategory: self.data.showTaskvsCategory).environmentObject(self.data)
//            }
//                    .tabItem {
//                        Image(systemName: "chart.pie.fill")
//                        Text("Summary")
//                }
//
//
//                //Cattegories tab view
//                NavigationView{
//                CategoryList().environmentObject(self.data)
//            }
//                    .tabItem({
//                        Image(systemName: "bookmark.fill")
//                        Text("Categories")
//                    })
//
//
//                NavigationView{
//
//                    SettingsiOS(activeView:.constant(false)).environmentObject(self.data)
//
//                    .navigationBarTitle("Settings")
//                    .environmentObject(self.data)
//                }
//                    .tabItem{
//                        Image(systemName: "slider.horizontal.3")
//                        Text("Settings")
//                }
                
            
                
//            } //ending tabView


                     
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
                    NavigationView{
                    TaskSummaryiOS(taskInd: self.selectedTaskInd, showSheet: self.$showSheet).environmentObject(self.data)
                        
                        
                }
                    .onDisappear()
                        {
                            self.data.resumeAllTasks()
                            self.showTaskOptions = false
                    }
                }
                else if (self.addTaskRequest)
                {
                    NavigationView{
                    addTaskiOS(activeView: self.$showSheet,categoryList: self.data.categories).environmentObject(self.data)
                }
                    .onAppear(){
                        self.data.pauseTasksAndSummary()
                    }
                    .onDisappear()
                        {
                            self.data.resumeTasksAndSummary()
                            self.addTaskRequest = false
                    }
                }
          
                })
        
//                    .onAppear(){
//                        print("Resme timer")
//                        self.data.resumeAllTasks()
//                        self.data.timer = Timer.publish(every: 1.0/4.0, on: .main  , in: .common).autoconnect()
//        }

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
