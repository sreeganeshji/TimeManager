//
//  selectRange.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/27/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct selectRange: View {
    @Binding var dateField:Calendar.Component
    @Binding var dateValue:Date
    @State var weekOffset:Int = 0
    @State var thisMonth:Int = 0
    @State var showSheet = false
    @State var yearOffset:Int = 0
//    init()
//    {
//        self.weekOffset = 0
//    }
    var monthDict:[Int:String] = [1:"January",2:"Feburary",3:"March",4:"April",5:"May",6:"June",7:"July",8:"August",9:"September",10:"October",11:"November",12:"December"]
    var calendar = Calendar.autoupdatingCurrent
    func getDate(_ date:Date)->String{
        let date = calendar.dateComponents([.day], from: date)
        return String(date.day!)
    }
    func getWeekOfMonth(_ date:Date)->String{
        let week = calendar.dateComponents([.weekOfMonth], from: date)
        return String(week.weekOfMonth!)
    }
    
    func getMonth(_ date:Date)->String{
        let month = calendar.dateComponents([.month], from: date)
        return monthDict[month.month!]!
    }
    
    func getMonthNo(_ date:Date)->String{
        let month = calendar.dateComponents([.month], from: date)
        return String(month.month!)
    }
    
    func getYear(_ date:Date)->String{
        let week = calendar.dateComponents([.year], from: date)
        return String(week.year!)
    }
    func getWeekRange(weekOffset:Int)->String
    {
        //get the start of this week
        let weekInterval = self.calendar.dateInterval(of: .weekOfYear, for: .init())
        let endDate = weekInterval?.end
        var offsetEndDate = self.calendar.date(byAdding: .weekOfYear, value: weekOffset, to: endDate ?? .init())!
        offsetEndDate = self.calendar.date(byAdding: .day, value: -1, to: offsetEndDate)!
        self.dateValue = offsetEndDate
        let offsetWeekInterval = self.calendar.dateInterval(of: .weekOfYear, for: offsetEndDate) ?? DateInterval.init()
        let offsetWeekStartDate = offsetWeekInterval.start
        let offsetWeekEndDate = calendar.date(byAdding: .day, value: -1, to: offsetWeekInterval.end)!
        return(getMonthNo(offsetWeekStartDate)+"/"+getDate(offsetWeekStartDate)+"/"+getYear(offsetWeekStartDate)+" "+"to"+" "+getMonthNo(offsetWeekEndDate)+"/"+getDate(offsetWeekEndDate)+"/"+getYear(offsetWeekEndDate))
        
    }
    
    func updateMonth(monthNo:Int)->String{
        var monthComponent = calendar.dateComponents(in: .autoupdatingCurrent, from: self.dateValue)
        monthComponent.month = monthNo
        self.dateValue = calendar.date(from: monthComponent)!
        return "Month:"
    }
    
    func getYearRange(yearOffset:Int)->String{
        //get the start of this week
        let yearInterval = self.calendar.dateInterval(of: .year, for: .init())
        let endDate = yearInterval?.end
        var offsetEndDate = self.calendar.date(byAdding: .year, value: yearOffset, to: endDate ?? .init())!
        offsetEndDate = self.calendar.date(byAdding: .day, value: -1, to: offsetEndDate)!
        self.dateValue = offsetEndDate
        let offsetYearInterval = self.calendar.dateInterval(of: .year, for: offsetEndDate) ?? DateInterval.init()
        let offsetWeekStartDate = offsetYearInterval.start
        let offsetWeekEndDate = calendar.date(byAdding: .day, value: -1, to: offsetYearInterval.end)!
        return getYear(offsetEndDate)
    }
    
//    func updateYear(yearNo:Int)->String{
//        let yearInterval = calendar.dateInterval(of: .year, for: calendar.date(bySetting: .year, value: yearNo, of: .init())!)
//        let nextYearFirstDay = yearInterval!.end
//        let givenYearLastDay = calendar.date(byAdding: .day, value: -1, to: nextYearFirstDay)
//        self.dateValue = givenYearLastDay!
//        return "Year:"
//    }
    
    var body: some View {
        VStack{
        
        if(self.dateField == .day)
        {
//            NavigationLink(destination: chooseDate(dateVal: self.$dateValue,showSheet: self.$showSheet))
            Button(action:{self.showSheet = true})
            {
                HStack{
                    Text("Date:").bold()
                    Spacer()
                    Text(getMonth(self.dateValue))
                    Text(getDate(self.dateValue))
                    Text(getYear(self.dateValue))
                    Spacer()
                    Button(action:{self.dateValue = Date()})
                    {
                        Text("Today").bold()
                    }
                   
                }
                .padding(.horizontal)
            }
            
        }
        else if(self.dateField == .weekOfYear)
        {
//            Text("Week")
            Stepper(value: self.$weekOffset, in: -10...10) {
                VStack{
                    Text("Dates:").bold()
                Text(getWeekRange(weekOffset: self.weekOffset))
                }
            }
            .padding(.horizontal)
            .onAppear(){
                self.dateValue = .init()
                self.weekOffset = 0
            }
        }
        else if(self.dateField == .month)
        {
            
            Button(action:{self.showSheet = true})
            {
                Text(updateMonth(monthNo: self.thisMonth)).bold()
                Text(getMonth(self.dateValue))
                Text(getYear(self.dateValue))
            }
                .onAppear(){
                    self.dateValue = .init()
                    self.thisMonth = self.calendar.component(.month, from: self.dateValue)
            }
            
            }
        else if(self.dateField == .year)
        {
           Stepper(value: self.$yearOffset, in: -10...10) {
               VStack{
                   Text("Year:").bold()
                Text(getYearRange(yearOffset: self.yearOffset))
               }
           }
           .padding(.horizontal)
                .onAppear(){
                    self.dateValue = .init()    
            }

            }
        }
        .sheet(isPresented: self.$showSheet, content: {
            if(self.dateField == .day)
                    {
                        NavigationView{
                       chooseDate(dateVal: self.$dateValue, showSheet: self.$showSheet)

                        }
   
                    }
                    else if(self.dateField == .weekOfYear)
                    {
            //            Text("Week")
                        Stepper(value: self.$weekOffset, in: -10...10) {
                            VStack{
                                Text("Dates:").bold()
                                Text(self.getWeekRange(weekOffset: self.weekOffset))
                            }
                        }
                        .padding(.horizontal)
                        .onAppear(){
                            self.dateValue = .init()
                            self.weekOffset = 0
                        }
                    }
                    else if(self.dateField == .month)
                    {
                        NavigationView{
                        chooseMonth(monthVal: self.$thisMonth,showSheet: self.$showSheet)
                        
                        }
            }
                    
        })
        
    }
}

struct selectRange_Previews: PreviewProvider {
    static var previews: some View {
        selectRange(dateField: .constant(.weekday),dateValue: .constant(.init()))
    }
}
