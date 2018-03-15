//
//  ScheduleStore.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2017-12-21.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public class ScheduleStore: NSObject {

    public static let sharedScheduleStore: ScheduleStore = {
    
        // generating match data for testing
        return ScheduleStore(store: Schedule(schedule: MatchesData.generateSampleData()))
        
    }()

    public var schedule: Schedule
    
    public init(store: Schedule) {
        
        schedule = store
    }
    
    // MARK: - Empty out of the schedule
    public class func emptyScheduelStore() -> ScheduleStore {
        
        return ScheduleStore(store: Schedule())
    }
    
    // MARK: - Convenince functions for manipulating the dictionary
//    func schedule(onDay day: Int) -> [Int: [Int: Match?]]? {
//        return schedule[day]
//    }
//
//    func getSessionWithMatches(onDay day: Int, inRoom room: Int) -> [Int: Match?]? {
//        return schedule[day]?[room]
//    }
//
//    func schedule(onDay day: Int, inRoom room: Int, duringSession session: Int) -> Match? {
//        return schedule[day]?[room]?[session] ?? nil
//    }
//
//    func insert(match: Match?, atSessionNumber session: Int, inRoom room: Int, onDay day: Int) {
//        schedule[day]?[room]?[session] = match
//    }
//
//    func deleteMatch(atSession session: Int, onDay day: Int, inRoom room: Int) {
//        schedule[day]?[room]?[session] = nil
//    }
}
