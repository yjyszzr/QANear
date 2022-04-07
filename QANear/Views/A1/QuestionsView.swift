//
//  QuestionsView.swift
//  QANear
//
//  Created by zzr on 2021/7/6.
//

import SwiftUI
import SwiftUIPullToRefresh

struct QuestionsView: View {
    @State var numbers:[Int] = [23,45,76,54,76,3465,24,423,111,222,333,555,666,777,3331,888]
 
   
    var body: some View {
        RefreshableNavigationView(title: "", action:{
            self.numbers = self.generateRandomNumbers()
        },isDone:.constant(true)){
            ForEach(self.numbers, id: \.self){ number in
                VStack(alignment: .leading){
                    Text("\(number)")
                    Divider()
                }
            }
        }
    }
    
    func generateRandomNumbers() -> [Int] {
            var sequence = [Int]()
            for _ in 0...30 {
                sequence.append(Int.random(in: 0 ..< 100))
            }
            return sequence
    }
    
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}
