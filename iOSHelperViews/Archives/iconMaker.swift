//
//  iconMaker.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/29/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct iconMaker: View {
    let colors:[Color] = [.red,.green,.blue,.orange,.purple,.yellow]
    let weights:[Int] = [1,2,3,5,8,13]
    var totalWeight:Int{
        var sumVal = 0
        for weight in self.weights{
            sumVal += weight
        }
        return sumVal
    }
    
    struct slice:Hashable{
          var startAngle:Angle
          var endAngle:Angle
      }
    var slices:[slice]{
        var slices:[slice] = []
        var prevAngle = Angle(degrees: 0)
        for weight in weights{
            let sliceAngle = (Double(weight)/Double(self.totalWeight))*360
            let nextAngle = prevAngle + Angle(degrees: Double(sliceAngle))
            slices.append(.init(startAngle: prevAngle, endAngle: nextAngle))
            prevAngle = nextAngle
        }
        return slices
    }
    
    var body: some View {
        GeometryReader{
            reader in
        
        ZStack{
//        RoundedRectangle(cornerRadius:20)
//            .frame(width:min(reader.size.height,reader.size.width),height:min(reader.size.height,reader.size.width))
//            .foregroundColor(.white)
//            .shadow(radius: 20)
            
            ForEach(self.slices.indices,id:\.self)
                     {
                         ind in
                         Path{
                             path in
                            path.addArc(center: .init(x: reader.size.width/2, y: reader.size.height/2), radius: CGFloat(min(reader.size.width/2,reader.size.height/2)), startAngle: self.slices[ind].startAngle, endAngle: self.slices[ind].endAngle, clockwise: false)
                             path.addLine(to: .init(x: reader.size.width/2, y: reader.size.height/2))
                             path.closeSubpath()
                         }
                         .foregroundColor(self.colors[ind])
            }
//        .padding()
            
//                            .rotationEffect(.degrees(-180))
            
        }
        
    }
//        .frame(width:200)
}
}
struct iconMaker_Previews: PreviewProvider {
    static var previews: some View {
        iconMaker()
    }
}
