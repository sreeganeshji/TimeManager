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
    @State var loadingMonth = true
    @State var showSheet = false
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
        if(self.loadingMonth)
        {
            return "Month:"
        }
        var monthComponent = calendar.dateComponents(in: .autoupdatingCurrent, from: self.dateValue)
        monthComponent.month = monthNo
        self.dateValue = calendar.date(from: monthComponent)!
        return "Month:"
    }
    
    var body: some View {
        VStack{
        
        if(self.dateField == .day)
        {
            NavigationLink(destination: chooseDate(dateVal: self.$dateValue,showSheet: self.$showSheet))
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
            .onAppear()
                {
                    self.dateValue = .init()
                }
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
            
            NavigationLink(destination:chooseMonth(monthVal: self.$thisMonth,showSheet: self.$showSheet))
            {
                Text(updateMonth(monthNo: self.thisMonth)).bold()
                Text(getMonth(self.dateValue))
                Text(getYear(self.dateValue))
            }
                .onAppear(){
                    self.showSheet = true
                    self.dateValue = .init()
                    self.thisMonth = self.calendar.component(.month, from: self.dateValue)
                    self.loadingMonth = false
            }
            
            }
        else if(self.dateField == .year)
        {
            Text("Year")
            }
        }
        .sheet(isPresented: self.$showSheet, content: {
            if(self.dateField == .day)
                    {
                        NavigationLink(destination: chooseDate(dateVal: self.$dateValue, showSheet: self.$showSheet))
                        {
                            HStack{
                                Text("Date:").bold()
                                Spacer()
                                Text(self.getMonth(self.dateValue))
                                Text(self.getDate(self.dateValue))
                                Text(self.getYear(self.dateValue))
                                Spacer()
                                Button(action:{self.dateValue = Date()})
                                {
                                    Text("Today").bold()
                                }
                               
                            }
                            .padding(.horizontal)
                        .onAppear()
                            {
                                self.dateValue = .init()
                            }
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
                        
                        NavigationLink(destination:chooseMonth(monthVal: self.$thisMonth,showSheet: self.$showSheet))
                        {
                            Text(self.updateMonth(monthNo: self.thisMonth)).bold()
                            Text(self.getMonth(self.dateValue))
                            Text(self.getYear(self.dateValue))
                        }
                            .onAppear(){
                                self.showSheet = true
                                self.dateValue = .init()
                                self.thisMonth = self.calendar.component(.month, from: self.dateValue)
                                self.loadingMonth = false
                        }
                        
                        }
                    else if(self.dateField == .year)
                    {
                        Text("Year")
                        }
        })
        
    }
}

struct selectRange_Previews: PreviewProvider {
    static var previews: some View {
        selectRange(dateField: .constant(.weekday),dateValue: .constant(.init()))
    }
}
