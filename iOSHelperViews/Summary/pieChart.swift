//
//  pieChart.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/26/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct pieChart: View {
    struct slice:Hashable{
        var startAngle:Angle
        var endAngle:Angle
        var catInd:Int
    }
    var totalTime:Double{
        var sum:Double = 0
        for record in self.catRecordArr
        {
            sum += Double(record.time)
        }
        return sum
    }
    var slices:[slice]{
        var slices:[slice] = []
        var prevAngle = Angle(degrees: 0)
        var nextAngle = Angle(degrees: 0)
        for ind in self.catRecordArr.indices
        {
            let angleValue = 360*(Double(self.catRecordArr[ind].time)/self.totalTime)
            nextAngle = (prevAngle+Angle(degrees:angleValue))
            slices.append(.init(startAngle: prevAngle, endAngle: nextAngle, catInd: self.catRecordArr[ind].categoryInd))
            prevAngle = nextAngle
        }
        return slices
    }
    @EnvironmentObject var data:models
    @Binding var catRecordArr:[models.catRecord]
//    @Binding var reader:GeometryProxy
    var width:Double
    var height:Double
    
    var body: some View {

//        GeometryReader{
//            reader in
            ForEach(self.slices,id:\.self)
            {
                slice in
                Path{
                    path in
                    path.addArc(center: .init(x: self.width/2, y: self.height/2), radius: CGFloat(min(self.width/2,self.height/2)), startAngle: slice.startAngle, endAngle: slice.endAngle, clockwise: false)
                    path.addLine(to: .init(x: self.width/2, y: self.height/2))
                    path.closeSubpath()
                }
                .foregroundColor((slice.catInd < self.data.categories.count) ? self.data.getColor(self.data.categories[slice.catInd].color) : .white)
            }
//        }
    }
}

struct pieChart_Previews: PreviewProvider {
    static var previews: some View {
        pieChart(catRecordArr: .constant(.init()), width:300,height:300).environmentObject(models())
    }
}
