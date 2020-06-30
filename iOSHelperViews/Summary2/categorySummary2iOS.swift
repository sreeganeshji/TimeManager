//
//  categorySummary2iOS.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/29/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct categorySummary2iOS: View {
    var categoryList:[models.category]
    var catRecordArr:[SummaryDaemon.catRecord]
    @EnvironmentObject var data:models
    
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
    
    var catSum :Int{
          var currSum = 0
          for cat in self.catRecordArr{
              currSum += Int(cat.time)
          }
          return currSum
      }
      
      var catPercentages :[Int]{
          var catPerArr:[Int] = []
          for cat in self.catRecordArr{
              let value = (Double(cat.time)/Double(self.catSum)) * 100
              catPerArr.append(Int(value))
          }
          return catPerArr
      }
    
    var body: some View {
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
                                                ForEach(self.catRecordArr.indices,id:\.self)
                                  {
                                      ind in
                                    
                                    HStack{
                                        Image(systemName: "bookmark.fill")
                                            .foregroundColor( self.data.getColor(self.categoryList[self.catRecordArr[ind].categoryInd].color))
                                        
                                        Text( self.categoryList[self.catRecordArr[ind].categoryInd].name )
                                            .frame(width:150)
                                        Spacer()
                                        Text(self.giveTime(time:Int(self.catRecordArr[ind].time)))
                                            .frame(width:80)
                                        Spacer()
                                        Text(String(self.catPercentages[ind]))
                                        
                                            }
                                  }
                                                    GeometryReader{
                                                        reader in
                                                        pieChart(catRecordArr: self.catRecordArr,width:Double(reader.size.width),height:Double(reader.size.height))
                                                    
                                              
                        }
                                                          .padding()
                        .frame(height:300)
                        }
                    }    }
}

struct categorySummary2iOS_Previews: PreviewProvider {
    static var previews: some View {
        categorySummary2iOS(categoryList: [], catRecordArr: [])
    }
}
