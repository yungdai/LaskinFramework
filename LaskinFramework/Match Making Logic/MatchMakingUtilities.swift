//
//  MatchMakingUtilities.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-11-05.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public struct MatchMakingUtilities {
//    public  init() {}
    
    /// Returns a dictionary where the keys are school names and the values are arrays of the mooters from that school.
    private static func createDictionary(from mooters: [LMMooter]) -> [String: [LMMooter]] {
        var dictionary = [String: [LMMooter]]()
        mooters.forEach { dictionary[$0.school.name, default: []].append($0) }
        return dictionary
    }
    
    /// Sorts an array of AMooters first by school, then by side, then by order.
    static func sortMooters(_ mooters: [LMMooter]) -> [LMMooter] {
        return mooters.sorted(by: {
            guard !($0.school.name < $1.school.name) else { return true }
            
            if $0.school.name == $1.school.name {
                guard !($0.side.rawValue < $1.side.rawValue) else { return true }
                
                if $0.side == $1.side {
                    return $0.order.rawValue < $1.order.rawValue
                }
            }
            return false
        })
    }

    /// Converts [Mooter] to [AMooter].
    public static func convertMooters(_ mooters: [Mooter], sorted: Bool) -> [LMMooter] {
        
        let converted = mooters.flatMap { LMMooter(mooter: $0) }
        return sorted ? sortMooters(converted) : converted
    }
    
    public static func getSchools(from mooters: [LMMooter]) -> [LMSchool] {
        return Set<LMSchool>(mooters.map({ $0.school })).sorted(by: { $0.name < $1.name })
    }
    
    /**
     Checks if the given mooters are valid based on following criteria:
     * Each school has 4 mooters, 2 appellants & 2 respondents.
     * Each school has at least 1 english and 1 french mooter.
     *
     * This to check to see if the mooters are valid
     */
    public static func validateMooters(_ mooters: [LMMooter]) throws {
        let dictionary = createDictionary(from: mooters)

        for schoolMooterGroup in dictionary.values {
            let school = schoolMooterGroup[0].school
            // Verify each school has 4 mooters
            guard schoolMooterGroup.count == 4 else {
                throw MooterError.incorrectNumberOfMooters(numberOfMooters: schoolMooterGroup.count, fromSchool: school)
            }
            // Verifty each school has a english mooter
            guard schoolMooterGroup.contains(where: { $0.language == .english }) else {
                throw MooterError.missingEnglishMooter(fromSchool: school)
            }
            // Verifty each school has a french mooter
            guard schoolMooterGroup.contains(where: { $0.language == .french }) else {
                throw MooterError.missingFrenchMooter(fromSchool: school)
            }
            
            let differenceSet = Set(schoolMooterGroup.map({ $0.position })) |> Set(["A1", "A2", "R1", "R2"]).subtracting
            if let position = differenceSet.first {
                throw MooterError.missingMooterInPosition(position: position, fromSchool: school)
            }
        }
    }
    
    /**
     Creates pairs from the given mooters.
     - Note: This function assumes the mooters have already been sorted using the sortMooters(_:) function.
     */
    public static func createPairs(from mooters: [LMMooter], hostTimeZone: Int) -> [Pair] {
        return stride(from: 0, to: mooters.count, by: 2).flatMap {
            
            // creates pairs of mooters and relays the time difference from the host timezone
            // TODO: perhaps change [$0 + 1] to [$1]
            Pair(firstMooter: mooters[$0], secondMooter: mooters[$0 + 1], hoursAhead: mooters[$0].school.timeZone.rawValue - hostTimeZone, matchCount: 99)
        }
    }
    
    /// Splits an array of pairs into an array of appellant pairs and an array of respondent pairs.
    public static func splitSides(pairs: [Pair]) -> (appellants: [Pair], respondents: [Pair]) {
        var appellants: [Pair] = [], respondents: [Pair] = []
        appellants.reserveCapacity(pairs.count / 2)
        respondents.reserveCapacity(pairs.count / 2)
        
        for i in 0..<pairs.count {
            pairs[i].side == .appellant ? appellants.append(pairs[i]) : respondents.append(pairs[i])
        }
        
        return (appellants, respondents)
    }
    
    public static func sessionsPerDay(matchCount: Int, roomCount: Int) -> (first: Int, second: Int) {
        let totalSessions = (Double(matchCount) / Double(roomCount)) |> ceil |> Int.init
        return (totalSessions - 2, 2)
    }
    
    public static func initializeSchedule(roomCount: Int, emptyRoomCount: Int, sessionsPerDay: (first: Int, second: Int)) -> Schedule {
        let firstDaySessions = Sessions(keys: [Int](1...sessionsPerDay.first), repeatedValue: nil)
        let firstDayRooms = Rooms(keys: [Int](1...roomCount), repeatedValue: firstDaySessions)
        let secondDaySessions = Sessions(keys: [Int](1...sessionsPerDay.second), repeatedValue: nil)
        let secondDayRooms = Rooms(keys: [Int](1...roomCount), repeatedValue: secondDaySessions)
        let schedule = Schedule(schedule: [1: firstDayRooms, 2: secondDayRooms])
        
        //Block number of empty cells
//        if emptyRoomCount > 0 {
//            var roomIndex = roomCount - 1
//            var sessionIndex = 5
//            for _ in 0..<emptyRoomCount {
//                schedule[roomIndex][sessionIndex] = 98
//                roomIndex -= 1
//                if roomIndex < iiCount {
//                    roomIndex = roomCount - 1
//                    sessionIndex -= 1
//                }
//            }
//        }
        
        return schedule
    }
    
    public static func resetMatches(_ matches: [Match]) -> [Match] {
        return matches.map { Match(appellantPair: $0.appellantPair, respondentPair: $0.respondentPair, hoursAhead: $0.hoursAhead,
                                   roomNumber: 99, sessionNumber: 99, needsInterpreter: $0.needsInterpreter, demerits: 0) }
    }
}
