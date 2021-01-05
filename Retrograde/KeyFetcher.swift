//
//  KeyFetcher.swift
//  Retrograde
//
//  Created by Hector Delgado on 1/4/21.
//

import Foundation

struct KeyFetcher {
    
    func getKeyFor(fileName: String, fileType: String, keyName: String) -> String {
        // Read PList file
        guard let filePath = Bundle.main.path(forResource: "OW-Info", ofType: "plist") else {
            fatalError("Couldn't find file \(fileName).\(fileType)")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let key = plist?.object(forKey: keyName) as? String else {
            fatalError("Couldn't fine key \(keyName) in \(fileName).\(fileType)")
        }
        
        return key
    }
}
