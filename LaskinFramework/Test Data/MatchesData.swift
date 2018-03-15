//
//  MatchesData.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-12-21.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public struct MatchesData {
    public static func generateSampleData() -> ScheduleDictionary {
        let pairA = Pair(firstMooter: LMMooter(firstName: "Paula", lastName: "Cooper", school: LMSchool(name: "Alberta", city: "Calgary", province: .alberta), side: Side.appellant, order: Order.first, language: .english, interpreterType: .french), secondMooter: LMMooter(firstName: "Brendan", lastName: "Downey", school: LMSchool(name: "Alberta", city: "Calgary", province: .alberta), side: Side.appellant, order: Order.second, language: .english, interpreterType: .french), hoursAhead: 1, matchCount: 1)!
        
        let pairR = Pair(firstMooter: LMMooter(firstName: "Humda", lastName: "Tahir", school: LMSchool(name: "Osgoode", city: "Toronto", province: .ontario), side: Side.respondent, order: Order.first, language: .french, interpreterType: .none), secondMooter: LMMooter(firstName: "Douglas", lastName: "Montgomery", school: LMSchool(name: "Osgoode", city: "Toronto", province: .ontario), side: Side.respondent, order: Order.second, language: .english, interpreterType: .french), hoursAhead: 3, matchCount: 1)!
        
        let match = Match(appellantPair: pairA, respondentPair: pairR, hoursAhead: 3, roomNumber: 1, sessionNumber: 5, needsInterpreter: true, demerits: 11)
        
        var schedule = ScheduleDictionary()
        schedule[1] = [1: [1: match]]
        schedule[1]?[2] = [2: match]
        schedule[1]?[3] = [3: match]
        schedule[1]?[4] = [4: match]
        schedule[2] = [2: [1: match]]
        schedule[2]?[2] = [2: match]
        
        return schedule
    }
}
