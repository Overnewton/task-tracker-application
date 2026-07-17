//
//  GlobalState.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 7/7/2026.
//

import Foundation
import UIKit

class GlobalState: Codable {
    //initializes the global state by setting it to a static variable
    static private(set) var shared = GlobalState.load()
    
    //MARK: Global Variables
    ///stores the background color
    var backgroundColour: ColourCodable!
    var foregroundColour: ColourCodable!
    var textColour: ColourCodable!
    var placeholderTextColour: ColourCodable!
    var iconColour: ColourCodable!
    var tasks: [Task]!
    
    //MARK: Registry
    //exists so that a specific issue with decoding doesn't delete all stored data when new global varibles are added
    //also so that I don't have to write the same thing 5 or more times to prevent this annoying issue (that is technically working as intended)
    //incredibly jank but hopefully robust enough to not break
    //needs to remain up to date with the global variables
    ///stores all default values for each of the variables
    private static let registry: [AnyEntry] = [
        /*
         Format for the entry ($$ around text indicates to substitute text there):
         GlobalState.entry(
         key: .$keyName$,
         default: $defaultValue$,
         assign: { state, value in state.$variableName$ = value }
         )
         */
        GlobalState.entry(
            key: .backgroundColour,
            default: ColourCodable(red: 0.10, green: 0.10, blue: 0.12, alpha: 1.00),
            assign: { state, value in state.backgroundColour = value }
        ),
        GlobalState.entry(
            key: .foregroundColour,
            default: ColourCodable(red: 0.13, green: 0.13, blue: 0.15, alpha: 1.00),
            assign: { state, value in state.foregroundColour = value }
        ),
        GlobalState.entry(
            key: .textColour,
            default: ColourCodable(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00),
            assign: { state, value in state.textColour = value }
        ),
        GlobalState.entry(
            key: .placeholderTextColour,
            default: ColourCodable(red: 0.42, green: 0.43, blue: 0.46, alpha: 1.00),
            assign: { state, value in state.placeholderTextColour = value }
        ),
        GlobalState.entry(
            key: .iconColour,
            default: ColourCodable(red: 0.59, green: 0.59, blue: 0.62, alpha: 1.00),
            assign: { state, value in state.iconColour = value }
        ),
        GlobalState.entry(
            key: .tasks,
            default: [],
            assign: { state, value in state.tasks = value }
        )
    ]
    
    ///contains list of all variables
    private enum CodingKeys: String, CodingKey {
        case backgroundColour
        case foregroundColour
        case textColour
        case iconColour
        case placeholderTextColour
        case tasks
    }
    
    ///used to simplify writing registry entries, very jank
    private static func entry<Value: Codable>(key: CodingKeys, default defaultValue: Value, assign: @escaping (GlobalState, Value) -> Void) -> AnyEntry {
        AnyEntry(
            //defines how the default values are assigned using properties provided to the function
            applyDefault: { state in
                assign(state, defaultValue)
            },
            //defines the decoder using the properties provided to the function
            //decoder is required for the class to be codable which is required to allow for writing to files
            decode: { decoder, state in
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let decoded = try container.decodeIfPresent(Value.self, forKey: key)
                assign(state, decoded ?? defaultValue)
            }
        )
    }
    
    ///defines registry elements
    private struct AnyEntry {
        //has to be functions due to limitations with swift
        //and due to me doing some incredibly jank stuff to make implementing variables much simpler
        
        ///sets the default value of the property
        let applyDefault: (GlobalState) -> Void
        ///sets the decoder to
        let decode: (Decoder, GlobalState) throws -> Void
    }
    
    //MARK: Init Functions
    ///basic init if it fails to read the file (such as if the file is missing)
    init() {
        //loops over all entries in the registry and sets them to their default value
        for entry in GlobalState.registry {
            entry.applyDefault(self)
        }
    }
    
    ///init for decoding the file to variables
    required init(from decoder: Decoder) throws {
        //loops over all entries in the registry and attempts to decode them
        for entry in GlobalState.registry {
            try entry.decode(decoder, self)
        }
    }
    
    //MARK: Save and Load Functions
    ///stores the file URL for where to save to
    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("global_state.json")
    }
    
    ///loads the data from the file
    static func load() -> GlobalState {
        //checks if file exists then loads data from file if it does exist
        if let data = try? Data(contentsOf: fileURL),
           let state = try? JSONDecoder().decode(GlobalState.self, from: data) {
            return state
        }
        
        // Default state if file doesn't exist
        return GlobalState()
    }
    
    static func reload() {
        GlobalState.shared = load()
    }
    
    ///deletes all saved data
    static func reset() {
        //deletes all saved data
        //used for testing
        //also for if the user wants to remove their data
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    ///saves the data to the file
    func save() {
        //encodes the data
        let data = try? JSONEncoder().encode(self)
        //writes data to file
        try? data?.write(to: GlobalState.fileURL)
    }
    
    //MARK: Global Functions
    ///switches the displayed viewController
    static func switchRoot(to newVC: UIViewController, animation: UIView.AnimationOptions = .transitionCrossDissolve, duration: TimeInterval = 0.4) {
        //UIKit specific stuff
        guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.keyWindow else { return }
        
        window.rootViewController = newVC
        UIView.transition(with: window, duration: duration, options: animation, animations: nil, completion: nil)
    }
}
