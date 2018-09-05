//
//  Constants.swift
//  EMobileView
//
//  Created by Yung Dai on 2016-11-02.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public typealias Payload = [String: AnyObject]
public typealias HandlerResponse = (response: URLResponse?, error: Error?)
//typealias Users = [User]
public typealias SchoolInfo = (city: String, province: Province, shortName: String, schoolNumber: Int)
public typealias Property = (label: String, value: Any)
public typealias PropertyString = (label: String, value: String)
public typealias LMMooterPair = (first: LMMooter, second: LMMooter)
public typealias MatchPairs = (appellant: Pair, respondent: Pair)

/// The key is the session number and the value is the match
public typealias Sessions = [Int: Match?]
public typealias SessionsData = (session: Sessions, availableSessions: [Int])
/// The key is the room number and the value is the sessions in that room
public typealias Rooms = [Int: Sessions]
/// The key is the day and the value is the rooms on that day
public typealias ScheduleDictionary = [Int: Rooms]

/// Users Data Object containing all users
public typealias Users = [UserType: [User]]

public struct K: Codable {
    
    // segue constants
    public struct SegueNamed: Codable {
        public static let showUserInformation = "showPersonInformation"
        public static let dismissUserInformation = "dismissUserInfoVC"
        public static let dayRoomOverview = "dayRoomOverview"
        public static let showMatchData = "showMatchData"
    }
    
    public struct CellIdentifiers: Codable {
        public static let detailedUserInfoCell = "detailedUserInfoCell"
        public static let sessionOverviewCell = "sessionOverviewCell"
        public static let matchDataCell = "matchDataCell"
        public static let matchHeaderCell = "matchHeaderCell"
        public static let gridMatchCollectionViewCell = "gridMatchCollectionViewCell"
    }
    
    public struct VC: Codable {
        
        public static let settingsPopUp = "settingsVCPopOver"
        public static let settings = "settingsVC"
        public static let search = "searchVC"
    }
    
    public struct APIKey: Codable {
        public static let darkSkyAPI = "DarkSkyAPIKey"
    }
    
    public struct Weather: Codable {
        public static let url = "https://api.darksky.net/forecast"
    }
    
    public struct DeviceType: Codable {
        public static let deviceType: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    }
}
