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
    static let shared = GlobalState.load()
    
    //MARK: Global Variables
    ///stores the background color
    var backgroundColour: ColourCodable!
    
    //MARK: Registry
    //exists so that a specific issue with decoding doesn't delete all stored data when new global varibles are added
    //also so that I don't have to write the same thing 5 or more times to prevent this annoying issue (that is technically working as intended)
    //incredibly jank but hopefully robust enough to not break
    //needs to remain up to date with the global variables otherwise refuses to compile due to properties not being initialised
    ///stores all default values for each of the variables
    static let registry: [AnyEntry] = [
        /*
         Format for the entry ($$ around text indicates to substitute text there:
         GlobalState.entry(
             key: .$keyName$,
             default: $defaultValue$,
             assign: { state, value in state.$variableName$ = value }
         )
         */
        GlobalState.entry(
            key: .backgroundColour,
            default: ColourCodable(red: 0.075, green: 0.114, blue: 0.137, alpha: 1.0),
            assign: { state, value in state.backgroundColour = value }
        )
    ]
    
    ///contains list of all variables
    enum CodingKeys: String, CodingKey {
        case backgroundColour
    }
    
    ///used to simplify writing registry entries, very jank
    static func entry<Value: Codable>(key: CodingKeys, default defaultValue: Value, assign: @escaping (GlobalState, Value) -> Void) -> AnyEntry {
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
    struct AnyEntry {
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
    
    ///saves the data to the file
    func save() {
        //encodes the data
        let data = try? JSONEncoder().encode(self)
        //writes data to file
        try? data?.write(to: GlobalState.fileURL)
    }
}
