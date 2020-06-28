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
            slices.append(.init(startAngle: prevAngle, endAngle: nextAngle, catInd: ind))
            prevAngle = nextAngle
        }
        return slices
    }
    @EnvironmentObject var data:models
    @Binding var catRecordArr:[models.catRecord]
    var body: some View {

        GeometryReader{
            reader in
            ForEach(self.slices,id:\.self)
            {
                slice in
                Path{
                    path in
                    path.addArc(center: .init(x: reader.size.width/2, y: reader.size.height/2), radius: min(reader.size.width/2,reader.size.height/2), startAngle: slice.startAngle, endAngle: slice.endAngle, clockwise: false)
                    path.addLine(to: .init(x: reader.size.width/2, y: reader.size.height/2))
                    path.closeSubpath()
                }
                .foregroundColor(self.data.getColor(self.data.categories[slice.catInd].color))
            }
        }
    }
}

struct pieChart_Previews: PreviewProvider {
    static var previews: some View {
        pieChart(catRecordArr: .constant(.init())).environmentObject(models())
    }
}
