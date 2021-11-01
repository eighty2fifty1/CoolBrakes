//
//  GaugeData.swift
//  BrakeSensor
//
//  Created by James Ford on 9/5/21.
//

import Foundation
import Combine
/*
 
 final class ModelData: ObservableObject{
     @Published var landmarks: [Landmark] = load("landmarkData.json")
     var hikes: [Hike] = load("hikeData.json")
     @Published var profile = Profile.default
     
     var features: [Landmark] {
         landmarks.filter{$0.isFeatured}
     }
     
     var categories: [String: [Landmark]] {
         Dictionary(
             grouping: landmarks,
             by: { $0.category.rawValue}
         )
     }
 }
 */
final class ModelData: ObservableObject {
    @Published var importedSettings: Settings = load("settings")
    
    func writeJSON() {
        print("attempting to save")
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonURL = documentDirectory
            .appendingPathComponent("settings")
            .appendingPathExtension("json")
        do {
        try JSONEncoder().encode(importedSettings).write(to: jsonURL, options: .atomic)
        print("saved?")
        } catch {
            print("no worky")
        }
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    guard let readURL = Bundle.main.url(forResource: filename, withExtension: "json")
    else{
        fatalError("Couldn't find \(filename) in main bundle")
    }
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let jsonURL = documentDirectory
        .appendingPathComponent(filename)
        .appendingPathExtension("json")
    
    if !FileManager.default.fileExists(atPath: jsonURL.path) {
        try? FileManager.default.copyItem(at: readURL, to: jsonURL)
    }
    
    return try! JSONDecoder().decode(T.self, from: Data(contentsOf: jsonURL))
}
