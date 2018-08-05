//
//  Schedule.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-12-23.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public struct Schedule: Codable {
    
    /// Schedule consists of [Day: [Room: [Session: Match?]]]
    private var dictionary: ScheduleDictionary

    public init(schedule: ScheduleDictionary) {
        dictionary = schedule
    }

    public init() {
        dictionary = [:]
    }

    public func numberOfRooms(onDay day: Int) -> Int? {
        return dictionary[day]?.count
    }
    
    public func rooms(onDay day: Int) -> Rooms {
        return dictionary[day] ?? [:]
    }

    public func sessions(onDay day: Int, inRoom room: Int) -> SessionsData {
        
        var availableSessions: [Int] = []
        
        for sessionNumber in 1...7 {
            
            if ((dictionary[day]?[room]?[sessionNumber]) != nil) {
                
                availableSessions.append(sessionNumber)
            }
        }
        
        return (dictionary[day]?[room] ?? [:], availableSessions)
    }
    
    

    public func match(onDay day: Int, inRoom room: Int, duringSession session: Int) -> Match? {
        return dictionary[day]?[room]?[session] ?? nil
    }

    public mutating func insertRoom(_ room: Rooms, onDay day: Int) {
        dictionary[day] = room
    }

    public mutating func insertSessions(_ sessions: Sessions, onDay day: Int, inRoom room: Int) {
        dictionary[day]?[room] = sessions
    }

    public mutating func insertMatch(_ match: Match, onDay day: Int, inRoom room: Int, duringSession session: Int) {
        dictionary[day]?[room]?[session] = match
    }

    @discardableResult
    public mutating func deleteRooms(onDay day: Int) -> Rooms? {
        return dictionary.removeValue(forKey: day)
    }

    @discardableResult
    public mutating func deleteSessions(onDay day: Int, inRoom room: Int) -> Sessions? {
        return dictionary[day]?.removeValue(forKey: room)
    }

    @discardableResult
    public mutating func deleteMatch(onDay day: Int, inRoom room: Int, duringSession session: Int) -> Match? {
        return dictionary[day]?[room]?.removeValue(forKey: session) ?? nil
    }

    /** Returns the match in each room on a given day during a given session.
     **Note**: Due to the way dictionaries work this method does not preserve room order.
    If order is an issue do not use this method.
    */
    public func matches(onDay day: Int, duringSession session: Int) -> [Match] {
        return rooms(onDay: day).values.compactMap { $0[session] ?? nil }
    }
}
