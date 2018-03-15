//
//  MatchMakingLogic.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2017-10-15.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import UIKit

public class MatchMakingLogic {
    
    public init() { }
    
    // this is an abritrary demerit point system to apply to matches
    public let demeritsZero = 0
    public let demeritsInterpreter = 11                 //
    public let demeritsTimeZone = [2, 1]       //Friday - 2,1   Saturday 1,0
    public let demeritsPairAdjacent = 13       //Absolute Nono
    public let demeritsPairSameSession = 17    //Physical impossibility
    public let demeritsSchoolSameSession = 4   //Watch out for same school twice
    
    // Data arrays and dictionary
    public var pairs: [Pair] = []
    public var matches: [Match] = []
    public var schedule = Schedule()
    
    public var roomCount = 0
    
    // Number of interpreters per sessions ?
    public var interpretersPerSession = 0
    
    // number of rooms that have not been filled yet with a match
    public var emptyRoomCount = 0
    
    // TODO: Remove?  Unused
    public var rightRow = 0
    
    // where the event is taking place
    public var hostName = ""
    public var hostProvince = ""
    public var hostTimeZone = 0
    
    public enum ScheduleType {
        case grid, short, complete
    }
    
    public var scheduleType: ScheduleType = .grid

    public func createMatches(fromMooters mooters: [Mooter]) throws -> [Match] {

        print("---- SETTING UP PAIRS ----------------\n--------------------------------------")
        // Get pairs from all the given mooters, will throw if unable to
        pairs = try makePairs(fromMooters: mooters)

        (roomCount, emptyRoomCount) = getRoomCount(pairCount: pairs.count)
        // print out the validated data
        Logger.firstLook(pairCount: pairs.count, roomCount: roomCount, emptyRoomCount: emptyRoomCount)

        print("\n\n---- DEFINING MATCHES ----------------\n--------------------------------------")
        // Create matches from pairs
        matches = makeMatches()
        Logger.printMatches(matches, hostName: hostName, hostTimeZone: hostTimeZone)

        // send out the data to the scheduleVC
        doSchedule(scheduleType: .complete)

        return matches
    }
    
    /// make pairs of matches
    public func makePairs(fromMooters mooters: [Mooter]) throws -> [Pair] {

        let mooters = MatchMakingUtilities.convertMooters(mooters, sorted: true)
        
        // get the school then print out the school
        MatchMakingUtilities.getSchools(from: mooters) |> Logger.printSchools
        
        // print mooters
        Logger.printMooters(mooters)

        // validate mooters, function will continue only if successful, otherwise will throw error
        try MatchMakingUtilities.validateMooters(mooters)
        print("\n*********** Mooters are valid")

        // create pairs of mooters based on who
        let pairs = MatchMakingUtilities.createPairs(from: mooters, hostTimeZone: hostTimeZone)
        Logger.printPairs(pairs)
        
        return pairs
    }
    
    public func doSchedule(scheduleType: ScheduleType) {
        
        print("\n\n---- DEFINING SCHEDULE ----------------\n------------------------------------------")
        
        makeSchedule()
        showSchedule(scheduleType: scheduleType)
    }
    
    // MARK: - Analysis

    /// Calculates the number of rooms needed and how many will be empty
    public func getRoomCount(pairCount: Int) -> (roomCount: Int, emptyRoomCount: Int) {
        return (Int((pairCount + 5) / 6), (roomCount * 6) - pairCount)
    }
    
    fileprivate func findRespondentPair(forAppellantPairIndex appellantPairIndex: Int, respondentIndexes indexes: [Int], _ round: Int, _ priorSchools: [LMSchool], _ run: Int) -> Match? {
        
        // Loop through the respondents until a successful match is found
        for index in indexes {
            let appellantPair = pairs[appellantPairIndex]
            let respondentPair = pairs[index]
            print("  Testing R pair \(index) - \(respondentPair.school.name)")
            
            if (respondentPair.matchCount < round) && (respondentPair.side == .respondent) && !priorSchools.contains(respondentPair.school) {
                print("    Pair \(index) is available")
                
                // check to see if the pair is elegible to run
                if pairIsEligible(inRun: run, pair: respondentPair) {
                    print("     Pair \(index) is eligible in run \(run)")
                    
                    let interpereterNeedsScore = matchInterpreterScore(appellantPair: appellantPair, respondentPair: respondentPair)
                    print("       Pair \(index) interpreter needs score = \(interpereterNeedsScore)")
                    
                    if interpereterNeedsScore < 90 {
                        print("       Pair \(index) is a match")
                        
                        let hoursAppellant = appellantPair.hoursAhead
                        let hoursRespondant = respondentPair.hoursAhead
                        let hoursAhead =  abs(hoursAppellant) > abs(hoursRespondant) ? hoursAppellant : hoursRespondant
                        
                        // Update match counts of pairs
                        pairs[appellantPairIndex].matchCount += 1
                        pairs[index].matchCount += 1
                        
                        // create a match with the data collected
                        // there are no rooms or sessions assited net
                        // Successful match, return it
                        return Match(appellantPair: pairs[appellantPairIndex], respondentPair: pairs[index],
                                     hoursAhead: hoursAhead, roomNumber: 99, sessionNumber: 99,
                                     needsInterpreter: interpereterNeedsScore > demeritsZero, demerits: 0)
                    }
                }
            }
        }
        
        // Was unable to find a successful match
        return nil
    }
    
    fileprivate func findMatches(_ matches: inout [Match], inRound round: Int) {
        //        Matching is done in three runs in each round using most important criteria first.
        //         To completer a schedule you need to do three runs.
        //         Run 1. Needy with needy (needs an interperter with another group that needs an interpreter)
        //         Run 2. Leftover needies with non-needy with non-needy result
        //         Run 3. All leftovers (at the end of the first round we have no pairs that need interpreters)
        for run in 1...3 { //3 runs for each types of match
            //                print("\nRun Number \(run) --------------------------")
            //Consider each pair for base A in this round
            for appellantPairIndex in stride(from: 0, to: pairs.count, by: 2) where
                
                // this designates the appellant pair for the currenet match
                pairs[appellantPairIndex].matchCount < round && pairIsEligible(inRun: run, pair: pairs[appellantPairIndex]) {
                    
                    // the school of the appellant
                    let appellantSchool = pairs[appellantPairIndex].school
                    print("\nA pair is \(appellantPairIndex): \(appellantSchool.name)")
                    
                    //  Don't match to itself, or any other school more than once
                    //    In round 1 may be 1 prior match as R.
                    //    In round 2 will be one prior A and 1 or 2 prior Rs
                    
                    // NEW NOTES: You can't count matches just by looking at the school, because the same school can participate more than once in a round if they one if an A and one is a R.  Setting up an array of schools that have already been scheduled with the site they're on.
                    var priorSchools = [appellantSchool]
                    for m in matches {
                        if m.appellantPair.school == appellantSchool {
                            priorSchools.append(m.respondentPair.school)
                        } else if m.respondentPair.school == appellantSchool {
                            priorSchools.append(m.appellantPair.school)
                        }
                    }
                    // end of the initalization
                    
                    
                    /* Start at random point to find a respondant pair for the appellant pair
                     arc4random_uniform(3) may return 0, 1 or 2 but not 3.
                     this where we get a random number to see where in the list of respondants to start the match making.
                     This is to ensure that the match making is random as per the Laskin Rules */
                    
                    // this ensures we start at an random odd number
                    let startIndex = 2 * Int(arc4random_uniform(UInt32(pairs.count / 2)))  + 1   //All Rs are odd indices
                    
                    /*
                     Example:
                     If get a startIndex of 3, and there are 10 pairs.  The odd number are respondants.  You would go through every second pair from 3, 5, 7, 9, 1/
                     */
                    let indexes = [Int](stride(from: startIndex, to: pairs.count, by: 2)) + [Int](stride(from: 1, to: startIndex, by: 2))
                    
                    // Try and find a match, if one is found add it to the matches array
                    if let match = findRespondentPair(forAppellantPairIndex: appellantPairIndex, respondentIndexes: indexes, round, priorSchools, run) {
                        matches.append(match)
                    }
            }   // For appellantPairIndex
        }
    }
    
    public func makeMatches() -> [Match] {
        //        print("\nMaking matches................")
        var matches: [Match] = []
        while matches.count < pairs.count {  //In case can't complete the matches
            
            //Initialize and empty the match array at the begining of each time the while loops runs
            matches = []
        
            // Number of matches are known so reserve capacity beforehand to prevent unnecessary reallocation
            matches.reserveCapacity(pairs.count)
            for i in 0..<pairs.count {
                // reset all the matchCounts to 0
                pairs[i].matchCount = 0
            }
            
            for round in 1...2 { //Two rounds of matches
                print("\n\nROUND \(round) ###############################")
                
                findMatches(&matches, inRound: round)
            }
        }
        
        return matches
    }
    
    public func pairIsEligible(inRun run: Int, pair: Pair) -> Bool {
        let needsInterpreter = !pair.interpreterTypesNeeded().isEmpty
        
        switch run {
        case 1:
            return needsInterpreter
        case 2:
            return pair.side == .appellant && needsInterpreter
        default:        // 3
            return true
        }
    }
    
    /// Returns a scores of how in need of an interpret the match is based on the demerit scoring system below
    public func matchInterpreterScore(appellantPair: Pair, respondentPair: Pair) -> Int {
        //no match can have consecutive arguments with II (order is A1, A2, R1, R2
        let demeritsImpossible = 97
        let demeritsNeeds = 3
        let matchPairs = [appellantPair, respondentPair]
        let languages = matchPairs.flatMap { [$0.firstMooter.language, $0.secondMooter.language] }
        let interpretersNeeded =
            matchPairs.flatMap { [$0.firstMooter.interpreterType, $0.secondMooter.interpreterType] } |> Set.init
        
        if interpretersNeeded == Set([Language.none]) {
            return demeritsZero    //Neither pair has need
        }
        
        let argNeeds = languages.map { interpretersNeeded.contains($0) }
        
        for i in 0...2 where argNeeds[i] && argNeeds[i + 1] {
            return demeritsImpossible        //Two successive args have need
        }
        
        return demeritsNeeds * argNeeds.filter { $0 }.count  //Could be 0
    }
    
    
    // Take the matches and put them into a schedule
    fileprivate func findBestSessionAndRoom(_ perfect: inout Bool, _ sessionsPerDay: (first: Int, second: Int), _ match: Match, _ bestYetDemerits: inout Int, _ bestYetDay: inout Int, _ bestYetRoom: inout Int, _ bestYetSession: inout Int) {
        // go through the all the rooms and the days
        for day in 1...2 where !perfect {
            for room in 1...roomCount where !perfect {
                
                // return the available sessions based on the first or second day
                let sessionCount = day == 1 ? sessionsPerDay.first : sessionsPerDay.second
                
                // iterate through the sessions
                for session in 1...sessionCount where !perfect && schedule.match(onDay: day, inRoom: room, duringSession: session) == nil {
                    
                    
                    print("   Checking room \(room), session \(session)")
                    
                    // based on the match we check the demerits score
                    let dems = getDemerits(match: match, room: room, day: day, session: session)
                    
                    // if the current demerits is < than the best demerits then make the current demerits the best
                    if dems < bestYetDemerits {
                        bestYetDemerits = dems
                        bestYetDay = day
                        bestYetRoom = room
                        bestYetSession = session
                        perfect = dems == 0
                        print("      \(bestYetDemerits) demerits is \(perfect ? "perfect" : "best yet")")
                    }
                }
            }
        }
    }
    
    public func makeSchedule() {
        print("\nScheduling Matches ........")
        
        var totalDemerits = 0
        var maxDemerits = 99
        var attemptCount = 0
        var matchesScheduled = 0
        let matchCount = pairs.count
        
        // try 26 attempts to get maxDemerits to < 10 that is when the schedule will automatically be accepted
        while (maxDemerits > 10) && (attemptCount < 26) {
        
            matchesScheduled = 0
    
            while matchesScheduled < matchCount {
                attemptCount += 1
                print("Scheduling attempt #\(attemptCount)")
                maxDemerits = 0
                totalDemerits = 0
                
                // get the amount of sessions per day
                let sessionsPerDay = MatchMakingUtilities.sessionsPerDay(matchCount: matches.count, roomCount: roomCount)
                
                // create an empty schedule with values established by sessionsPerDay
                schedule = MatchMakingUtilities.initializeSchedule(roomCount: roomCount, emptyRoomCount: emptyRoomCount, sessionsPerDay: sessionsPerDay)
                matches = MatchMakingUtilities.resetMatches(matches)
                
                //Four runs: place demanding matches first
                // There are four runs because there are four different criterias for demand
                for run in 1...4 {
                    
                    // start at a randomIndex for the matchCount
                    let startIndex = Int(arc4random_uniform(UInt32(matchCount)))
                    let indexes = [Int](startIndex..<matchCount) + [Int](0..<startIndex)
                    
                    // start at the first index from the random startIndex
                    for index in indexes {
                        
                        //Try this match in all available slots and pick the one with the lowest demerits
                        var bestYetDemerits = 99
                        var bestYetDay = 99
                        var bestYetRoom = 99
                        var bestYetSession = 99
                        var perfect = false
                        
                        var match = matches[index]
                        
                        // if match meets the demand for this run...
                        if matchIsEligible(run: run, match: match) {
                            print("Scheduling match \(index)")
                            
                            // finding best session and room based on demerits
                            findBestSessionAndRoom(&perfect, sessionsPerDay, match, &bestYetDemerits, &bestYetDay, &bestYetRoom, &bestYetSession)
                        
                            // keep the best room, session, and demerits
                            match.roomNumber = bestYetRoom
                            match.sessionNumber = bestYetSession
                            match.demerits = bestYetDemerits
                            
                            // save the match back into the matches array
                            matches[index] = match
                            
                            // add the match into the schedule
                            schedule.insertMatch(match, onDay: bestYetDay, inRoom: bestYetRoom, duringSession: bestYetSession)
                           
                            // add best demerits of this match to the current total demertis
                            
                            // FOR CHRIS:
                            // this will required to figure out which schedule is best based different schedules
                            // totalDemeris is for the schedule
                            totalDemerits += bestYetDemerits
                            
                            // bestYetDemertis only applies to this particular match
                            if bestYetDemerits > maxDemerits {
                                maxDemerits = bestYetDemerits
                            }
                        
                            matchesScheduled += 1
                        }
                    }
                }
            }
        }
        
        if attemptCount > 24 {
            print("Scheduling failed after 25 attempts. Rerun matches and try again.")
        } else {
            print("\n>>>>>>>     Max demerits = \(maxDemerits).\n     Total demerits for schedule = \(totalDemerits).")
        }
    }
    
    public func matchIsEligible(run: Int, match: Match) -> Bool {
        switch run {
        case 1:
            return match.needsInterpreter && (abs(match.hoursAhead) > 2)
        case 2:
            return match.needsInterpreter && !(abs(match.hoursAhead) > 2)
        case 3:
            return !match.needsInterpreter && (abs(match.hoursAhead) > 2)
        default:        //4
            return !match.needsInterpreter && !(abs(match.hoursAhead) > 2)
        }
    }
    
    public func getDemerits(match: Match, room: Int, day: Int, session: Int) -> Int {
        return getDemeritsInterpreter(match: match, room: room)
            + getDemeritsTimeZone(hoursAhead: match.hoursAhead, day: day, session: session)
            + getDemeritsPairAdjacent(match: match, day: day, session: session)
            + getDemeritsPairSameSession(match: match, day: day, session: session)
            + getDemeritsSchoolSameSession(match: match, day: day, session: session)
    }
    
    // checks if the session needs and intepreter and returns and demerit if the session requires an interperter
    public func getDemeritsInterpreter(match: Match, room: Int) -> Int {
        return match.needsInterpreter && (room > interpretersPerSession) ? demeritsInterpreter : demeritsZero
    }
    
    public func getDemeritsTimeZone(hoursAhead: Int, day: Int, session: Int) -> Int {
        
        if ((hoursAhead == -3) && (session == 1)) || ((hoursAhead == 3) && (session == 4)) {
            return demeritsTimeZone[day - 1]
        } else if ((hoursAhead == -3) && session == 2) || ((hoursAhead == 3) && session == 3) {
            return demeritsTimeZone[day - 1] - 1
        } else if ((hoursAhead == -2) && session == 1) || ((hoursAhead == 2) && session == 4) {
            return  demeritsTimeZone[day - 1] - 1
        }
        return demeritsZero
    }
    
    public func getDemeritsSchoolSameSession(match: Match, day: Int, session: Int) -> Int {
        let baseSchools = [match.appellantPair.school, match.respondentPair.school]
        
        var demerits = 0
        for scheduledMatch in schedule.matches(onDay: day, duringSession: session) {
            let testSchools = [scheduledMatch.appellantPair.school, scheduledMatch.respondentPair.school]
            for i in 0...1 where testSchools.contains(baseSchools[i]) {
                demerits += demeritsSchoolSameSession
                if baseSchools[i] == testSchools[i] {
                    demerits += demeritsPairSameSession
                }
            }
        }
        return demerits
    }
    
    public func getDemeritsPairSameSession(match: Match, day: Int, session: Int) -> Int {
        return hasConflict(match: match, day: day, session: session) ? demeritsPairSameSession : demeritsZero
    }
    
    public func getDemeritsPairAdjacent(match: Match, day: Int, session: Int) -> Int {
        //Check only pertinent sessions
        var sessionsToCheck: [Int] = []
        if (session != 0) && (session != 4) {
            sessionsToCheck.append(session - 1)
        }
        
        if (session != 3) && (session != 5) {
            sessionsToCheck.append(session + 1)
        }
        
        for session in sessionsToCheck where hasConflict(match: match, day: day, session: session) {
            return demeritsPairAdjacent
        }
        return demeritsZero
    }
    
    public func hasConflict(match: Match, day: Int, session: Int) -> Bool {
        for scheduledMatch in schedule.matches(onDay: day, duringSession: session) {
            if scheduledMatch.appellantPair == match.appellantPair || scheduledMatch.respondentPair == match.respondentPair {
                return true
            }
        }
        
        return false
    }
    
    public func showSchedule(scheduleType: ScheduleType) {
        
        print("\nSCHEDULE\n###########################")
        
        switch scheduleType {
        case .grid:
            //Show grid
            //print("\n\nSchedule grid\n-----------------")
            for day in 1...2 {
                for session in 1...schedule.sessions(onDay: day, inRoom: 1).availableSessions.count {
                    var s = ""
                    for room in 0..<roomCount {
                        guard let match = schedule.match(onDay: day, inRoom: room, duringSession: session) else { continue }
                        s += "\t\t \(match.appellantPair.school.name[0..<3])"
                        s += " <\(match.needsInterpreter ? "*" : " ")> \(match.respondentPair.school.name[0..<3])"
                        s += " \(match.demerits)"
                    }
                    print(s)
                    if session == 1 {
                        print("\t\t------------------------------------------------------")
                    } else if session == 3 {
                        print("\t\t======================================================")
                    }
                }
            }
        case .short:     //Short
            for day in 1...2 {
                print("\nDAY \(day)\n================================")
                let sessionCount = day == 1 ? 4 : 2
                for room in 1...roomCount {
                    print("\n  Room \(room)\n  ---------------------")
                    for session in 1...sessionCount {
                        guard let match = schedule.match(onDay: day, inRoom: room, duringSession: session) else {
                            print("      Unscheduled")
                            continue
                        }
                        
                        let ii = match.needsInterpreter ? "II  " : "    "
                        let ms = "(Match \(matches.index(of: match) ?? -1))"
                        print("\n    Session \(session) \(ms)\n    ---------------------")
                        let schoolNames = [match.appellantPair.school.name, match.respondentPair.school.name]
                        print("      \(ii)\(schoolNames[0]) <> \(schoolNames[1])")
                    }
                }
            }
        case .complete:        //3 = Complete format
            for day in 1...2 {
                print("\nDAY \(day)\n================================")
                let sessionCount = day == 1 ? 4 : 2
                for session in 1...sessionCount {
                    
                    var lines = [String](repeating: "", count: 6) //6 lines of printing for each session
                    
                    for room in 1...roomCount {
                        //Each room adds on to the lines
                        guard let match = schedule.match(onDay: day, inRoom: room, duringSession: session) else { continue }
                        
                        let schoolNames = [match.appellantPair.school.name, match.respondentPair.school.name]
                        
                        //TODO: Take the firstPair, secondPair, mooters, schoolName and put it into an object this is [room: [session: Match]]
                        
                        lines[0] += "\t\t" + schoolNames[0]
                        lines[1] += "\t\t  <> " + schoolNames[1]
                    }
                    print("\n  \(lines[0])\n      \(lines[1])")
                }
            }
        }
    }
}
