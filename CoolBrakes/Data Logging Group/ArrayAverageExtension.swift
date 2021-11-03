//
//  ArrayExtension.swift
//  CoolBrakes
//
//  Created by James Ford on 11/2/21.
//
//Created a method to aveage ints and doubles

import Foundation

extension Collection where Element == Int {
    func sum() -> Element{
        return reduce(0, +)
    }
    
    func average() -> Element {
        isEmpty ? .zero : sum() / Element(count)
    }
}

extension Collection where Element == Double {
    func sum() -> Element{
        return reduce(0, +)
    }
    
    func average() -> Element {
        isEmpty ? .zero : sum() / Element(count)
    }
}
