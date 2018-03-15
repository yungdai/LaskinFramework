//
//  Errors.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-12-25.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public enum MooterError: Error {
    case incorrectNumberOfMooters(numberOfMooters: Int, fromSchool: LMSchool)
    case missingMooterInPosition(position: String, fromSchool: LMSchool)
    case missingEnglishMooter(fromSchool: LMSchool)
    case missingFrenchMooter(fromSchool: LMSchool)
}
