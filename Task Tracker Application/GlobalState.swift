//
//  GlobalState.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 7/7/2026.
//

import Foundation
import UIKit

class GlobalState: Codable {

    static let shared = GlobalState.load()

    var backgroundColour: ColourCodable
    
    
    init(backgroundColour: ColourCodable) {
        self.backgroundColour = backgroundColour
    }
    
    private static var fileURL: URL {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return dir.appendingPathComponent("global_state.json")
        }

        static func load() -> GlobalState {
            let url = fileURL

            if let data = try? Data(contentsOf: url),
               let state = try? JSONDecoder().decode(GlobalState.self, from: data) {
                return state
            }

            // Default state if file doesn't exist
            return GlobalState(backgroundColour: ColourCodable(red: 0.075, green: 0.114, blue: 0.137, alpha: 1.0))
        }

        func save() {
            let url = GlobalState.fileURL
            let data = try? JSONEncoder().encode(self)
            try? data?.write(to: url)
        }
}

struct ColourCodable: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    func UIColor() -> UIColor {
        UIKit.UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(from color: UIColor) {
        self.red = color.cgColor.components?[0] ?? 0
        self.green = color.cgColor.components?[1] ?? 0
        self.blue = color.cgColor.components?[2] ?? 0
        self.alpha = color.cgColor.components?[3] ?? 0
    }
}
