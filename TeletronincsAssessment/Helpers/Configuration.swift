//
//  Configuration.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 17/06/2024.
//

import Foundation

class Configuration {
    
    static var clientID: String {
        // Retrieve the `ClientID` value from Info.plist
        // FYI: Use the `ClientID-2` incase this key exceeds limit
        if let clientID = Bundle.main.object(forInfoDictionaryKey: "ClientID") as? String {
            return clientID
        } else {
            return ""
        }
        
    }
}
