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


    var catSum :Int{
        var currSum = 0
        for cat in self.data.catRecordArr{
            currSum += Int(cat.time)
        }
        return currSum
    }
    
    var catPercentages :[Int]{
        var catPerArr:[Int] = []
        for cat in self.data.catRecordArr{
            let value = (Double(cat.time)/Double(self.catSum)) * 100
            catPerArr.append(Int(value))
        }
        return catPerArr
    }
    
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
    
//        NavigationView{
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
                            }
           
    else{
            if(self.ShowTaskvsCategory)
            {
            VStack{
                List{

                
                    HStack  {
                        Text("Task").bold()
                        Spacer()
                        Text("Time").bold()
                            }
                                            
                                            
                ForEach(self.data.taskRecordArr.indices,id:\.self)
                        {
                ind in
             
                HStack      {
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
                    
                    
                     HStack{
//                                Image(systemName: "bookmark.fill").frame(width:20)
//                                      .foregroundColor(.gray)
                                  Text("Category").bold()
                                    .frame(width:140)
                                  Spacer()
                                  Text("Time").bold()
                                    .frame(width:80)
                        Spacer()
                        Text("%").bold()
                            }
                                            ForEach(self.data.catRecordArr.indices,id:\.self)
                              {
                                  ind in
                                
                                HStack{
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor((self.data.catRecordArr[ind].categoryInd < self.data.categories.count) ?  self.data.getColor(self.data.categories[self.data.catRecordArr[ind].categoryInd].color) : .white)
                                    Text((self.data.catRecordArr[ind].categoryInd < self.data.categories.count) ? self.data.categories[self.data.catRecordArr[ind].categoryInd].name : "")
                                        .frame(width:150)
                                    Spacer()
                                    Text(self.giveTime(time:Int(self.data.catRecordArr[ind].time)))
                                        .frame(width:80)
                                    Spacer()
                                    Text(String(self.catPercentages[ind]))
                                    
                                        }
                              }
                                                GeometryReader{
                                                    reader in
                                                    pieChart(catRecordArr: self.$data.catRecordArr,width:Double(reader.size.width),height:Double(reader.size.height))
                                                
                                          
                    }
                                                      .padding()
                    .frame(height:300)
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

//        }
        .onAppear()
            {
                self.format.dateFormat = "MM_dd_yyyy"

                self.data.calculateSummary = true
        }
        .onDisappear(){
            self.data.calculateSummary = false
        }
    }
}

struct SummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        SummaryiOS().environmentObject(models())
    }
}
