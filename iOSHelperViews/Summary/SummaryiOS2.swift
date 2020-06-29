//
//  SummaryiOS.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/21/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//
/*
 Need to represent the progress of the tasks and categories for daily, weekly, monthly and yearly basis for all the time.
 */

import SwiftUI


struct SummaryiOS: View {
    
    var format = DateFormatter()
    @EnvironmentObject var data:models
    @State var selection = 0
  
    @State var ShowTaskvsCategory = true

    let today = Date()
//    let timer4 = Timer.publish(every: 0.5, on: .main  , in: .common).autoconnect()

//    init(taskList:[models.task],categoryList:[models.category])
//    {
////        self.summaryRecord = .init(taskList:taskList,categoryList:categoryList)
//        print("calling init")
//    }
    
    func giveTime(time:Int)->String
     {
         var sec = time
         var min = sec/60
         let hr = min/60
         sec %= 60
         min %= 60
         if (hr>0){
             return ("\(hr):\(min):\(sec)")
         }
         else if(min>0)
         {
             return ("\(min):\(sec)")
         }
         
         return ("\(sec)")
         
     }
    
    func updateSummaryAndGiveInterval()->String
    {
        self.data.sumaryRecord.taskArr = self.data.taskData
        self.data.sumaryRecord.categoryList = self.data.categories
        self.data.sumaryRecord.update(dateComponent: self.data.summaryTimeRange, startDate: self.data.refDate)
        self.data.taskRecordArr = self.data.sumaryRecord.taskRecordArr
        self.data.catRecordArr = self.data.sumaryRecord.catRecordArr
        return ("Interval")
    }
    
    var body: some View {
    
        NavigationView{
            VStack{
          
                Picker(selection: self.$data.summaryTimeRange, label: Text("Interval")) {
                Text("Day").tag(Calendar.Component.day)
                Text("Week").tag(Calendar.Component.weekOfYear)
                Text("Month").tag(Calendar.Component.month)
                Text("Year").tag(Calendar.Component.year)
            }
//            .onReceive([self.calComponent].publisher.first(), perform: { value in
//                .onReceive(self.timer4){ _ in
//                print("updating View")
//                self.summaryRecord.taskArr = self.data.taskData
//                self.summaryRecord.categoryList = self.data.categories
//                self.summaryRecord.update(dateComponent: self.calComponent, startDate: Date())}
            .pickerStyle(SegmentedPickerStyle())
            
             
                
                VStack{
                    if(self.data.taskRecordArr.count == 0)
                            {
                                Spacer()
//                                HStack(){
//                                    Spacer()
//                                Text("Loading...").bold()
//                                    Spacer()
//                                }
                                Spacer()
                            }
           
                            else{
                                if(self.ShowTaskvsCategory)
                                {
                                    VStack{
                                        List{
//                                HStack{
//                                    Spacer()
//                                    Text("Task breakdown").bold()
//                                    Spacer()
//                                }
                
                    HStack{
//                        Rectangle().frame(width:20)
//                            .foregroundColor(.gray)
                        Text("Task").bold()
                        Spacer()
                        Text("Time").bold()
                    }
                                            
                                            ForEach(self.data.taskRecordArr.indices,id:\.self)
            {
                ind in
             
                HStack{
                    Rectangle().frame(width:20)
                        .foregroundColor((self.data.taskData.count > ind) ? self.data.getColor(self.data.categories[self.data.taskRecordArr[ind].task.categoryInd].color) : .gray)
                    Text((self.data.taskData.count > ind) ? self.data.taskRecordArr[ind].task.name : "Deleted")
                    Spacer()
                    Text(self.giveTime(time: (self.data.taskData.count > ind) ? Int(self.data.taskRecordArr[ind].time) : 0))
                }

                }
                                }
                                }
                                }
                                else{
                                    VStack{
                                        List{
//                                HStack{
//                                    Spacer()
//                                    Text("Category breakdown").bold()
//                                    Spacer()
//                                }
                    
                    
                     HStack{
//                                Image(systemName: "bookmark.fill").frame(width:20)
//                                      .foregroundColor(.gray)
                                  Text("Category").bold()
                                  Spacer()
                                  Text("Time").bold()
                              }
                                            ForEach(self.data.catRecordArr.indices,id:\.self)
                              {
                                  ind in
                                
                                HStack{
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor((self.data.catRecordArr[ind].categoryInd < self.data.categories.count) ?  self.data.getColor(self.data.categories[self.data.catRecordArr[ind].categoryInd].color) : .white)
                                    Text((self.data.catRecordArr[ind].categoryInd < self.data.categories.count) ? self.data.categories[self.data.catRecordArr[ind].categoryInd].name : "")
                                    Spacer()
                                    Text(self.giveTime(time:Int(self.data.catRecordArr[ind].time)))
                                }
                              }
                                            pieChart(catRecordArr: self.$data.catRecordArr)
                                                .frame(height:300)
                                            .padding()
                                        }
                                    }
                                }
                            }
                    
             
                }
                
                selectRange(dateField: self.$data.summaryTimeRange, dateValue: self.$data.refDate).environmentObject(self.data)

                    Picker(selection: self.$ShowTaskvsCategory, label:Text("Choice"))
                    {
                        
                        Text("Task").tag(true)
                        Text("Category").tag(false)
                    }
                .pickerStyle(SegmentedPickerStyle())
                
                }
            
    .navigationBarTitle("Summary")
//            .navigationBarItems(trailing: Text(self.updateSummaryAndGiveInterval()))
//        .navigationBarItems(trailing: Button(action:{
////            self.summaryRecord.refresh()
//        })
//        {
//            Text("Refresh")
//        })
        }
        .onAppear()
            {
                print("onAppear Summary")
                self.format.dateFormat = "MM_dd_yyyy"
//                self.calComponent = .day
//                self.summaryRecord.taskArr = self.data.taskData
//                self.summaryRecord.categoryList = self.data.categories
//                self.summaryRecord.update(dateComponent: self.calComponent, startDate: Date())
                self.data.calculateSummary = true
        }
        .onDisappear(){
            self.data.calculateSummary = false
        }
//        .onReceive(self.timer4){ _ in
//        print("updating View")
//        self.summaryRecord.taskArr = self.data.taskData
//        self.summaryRecord.categoryList = self.data.categories
//        self.summaryRecord.update(dateComponent: self.calComponent, startDate: Date())}
    }
}

struct SummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        SummaryiOS().environmentObject(models())
    }
}
