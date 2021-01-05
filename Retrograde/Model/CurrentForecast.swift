//
//  CurrentForecast.swift
//  Retrograde
//
//  Created by Hector Delgado on 1/4/21.
//

import Foundation

struct CurrentForecast: Codable {
    var lat: Double
    var lon: Double
    var timezone: String
    var timezone_offset: Int
    
    
}
