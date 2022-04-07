//
//  PropertyStoring.swift
//  QANear
//
//  Created by zzr on 2021/11/5.
//

import Foundation
import SwiftUI
import UIKit

public protocol PropertyStoring {
    
    associatedtype T
    associatedtype AlbumT
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: AlbumT) -> AlbumT
}

public extension PropertyStoring {
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: AlbumT) -> AlbumT {
        guard let value = objc_getAssociatedObject(self, key) as? AlbumT else {
            return defaultValue
        }
        return value
    }
}


