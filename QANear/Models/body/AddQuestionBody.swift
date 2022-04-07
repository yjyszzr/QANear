//
//  AddQuestionBody.swift
//  QANear
//
//  Created by zzr on 2021/11/15.
//

import Foundation
import UIKit

class AddQuestionBody: Codable {
    var content: String
    var imgs: String

    init(content: String,imgs: String) {
        self.content = content
        self.imgs = imgs
    }
}
