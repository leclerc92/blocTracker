//
//  Constantes.swift
//  blockTracker
//
//  Created by clement leclerc on 09/01/2026.
//

import Foundation

enum SCORE_CONSTANTS {
    static let STYLE_BASE:Double = 1.0
    static let STYLE_FACTOR:Double =  1.25
    static let SUCCES_BONUS:Double = 1.2
    static let INTENSITY_POW:Double = 1.8
    static let INTENSITY_FACTOR:Double = 5.0
    static let BASE_EFFORT:Double = 0.30
    static let ATTEMPT_FACTOR:Double = 0.05
    static let BASE_ATTEMPT:Double = 0.5
    static let BASE_EFFICIENCY:Double = 1.0
    static let EFFICIENCY_FACTOR:Double = 0.01
}

enum BLOC_CONSTANTS {
    static let LEVEL_MIN = 1.0
    static let LEVEL_MAX = 16.0
    static let LEVEL_RANGE = LEVEL_MIN...LEVEL_MAX
    static let ATTEMPT_MAX:Int = 30
}
