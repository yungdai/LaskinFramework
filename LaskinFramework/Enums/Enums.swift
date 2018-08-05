//
//  Enums.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2017-08-24.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public enum UserType: String, StringRepresentableEnum, Codable {
    case none
    case administrator
    case coach
    case contactPerson
    case judge
    case mooter
    case researcher
    
    public init() {
        self = .none
    }
}

public enum AppPrivileges: String, StringRepresentableEnum, Codable {
    case admin
    case user
    case none
    
    public init() {
        self = .none
    }
}

public enum Day: Int, Codable {
    case sunday = 1, monday = 2, tuesday = 3, wednesday = 4,
    thursday = 5, friday = 6, saturday = 7
}

public enum Month: Int, Codable {
    case jan = 1, feb = 2, march = 3, april = 4, may = 5, june = 6,
    july = 7, aug = 8, sept = 9, oct = 10, nov = 11, dec = 12
}

public enum JudgeExperience: String, StringRepresentableEnum, Codable {
    case rookie
    case some
    case veteran
    case notAJudge = "N/A"
    
    public init() {
        self = .notAJudge
    }
}

public enum Gender: String, StringRepresentableEnum, Codable {
    case male
    case female
    case notApplicable
    
    public init() {
        self = .notApplicable
    }
    
    public var initial: String {
        return String(rawValue.first!).uppercased()
    }
}

public enum Language: String, StringRepresentableEnum, Codable {
    case english
    case french
    case none
    
    public init() {
        self = .english
    }
    
    public init?(string: String) {
        let lowercased = string.lowercased()
        if lowercased == "english" || lowercased == "e" {
            self = .english
        } else if lowercased == "french" || lowercased == "f" {
            self = .french
        } else if lowercased == "none" || lowercased == "n" {
            self = .none
        } else {
            return nil
        }
    }
    
    public var initial: String {
        return isValidLanguage ? String(rawValue.first!).uppercased() : "-"
    }
    
    public var isValidLanguage: Bool {
        return self != .none
    }
}

public enum LSATimeZone: Int, Codable {
    case pacific = 0
    case mountain = 1
    case central = 2
    case eastern = 3
    case atlantic = 4
    case newfoundland = 5
}

public enum Province: String, StringRepresentableEnum, Codable {
    case britishColumbia = "British Columbia"
    case alberta = "Alberta"
    case saskatchewan = "Saskatchewan"
    case manitoba = "Manitoba"
    case ontario = "Ontario"
    case quebec = "Quebec"
    case novaScotia = "Nova Scotia"
    case newBrunswick = "New Brunswick"
    case princeEdwardIsland = "Prince Edward Island"
    case newfoundlandLabrador = "Newfoundland & Labrador"
    
    case yukon = "Yukon"
    case northwestTerritories = "Northwest Territories"
    case nunavut = "Nunavut"
    
    public var initials: String {
        return rawValue.initials()
    }
    
    public var timeZone: LSATimeZone {
        switch self {
        case .britishColumbia, .yukon:
            return .pacific
        case .alberta, .northwestTerritories:
            return .mountain
        case .saskatchewan, .manitoba, .nunavut:
            return .central
        case .ontario, .quebec:
            return .eastern
        case .novaScotia, .princeEdwardIsland, .newBrunswick:
            return .atlantic
        case .newfoundlandLabrador:
            return .newfoundland
        }
    }
}

public enum SchoolName: String, StringRepresentableEnum, Codable {
	
    case alberta = "Alberta"
    case dalhousie = "Dalhousie"
    case laval = "Laval"
    case manitoba = "Manitoba"
    case mcgill = "McGill"
    case moncton = "Moncton"
    case montreal = "Montreal"
    case montréal = "Montréal"
    case osgoode = "Osgoode"
    case ottawaCivil = "OttawaCivil"
    case ottawaCommon = "OttawaCommon"
    case queens = "Queen's"
    case saskatchewan = "Saskatchewan"
    case sherbrooke = "Sherbrooke"
    case toronto = "Toronto"
    case ubc = "UBC"
    case unb = "UNB"
    case uqam = "UQAM"
    case western = "Western"
    case windsor = "Windsor"
    
}

public enum Side: String, StringRepresentableEnum, Codable {
    case appellant
    case respondent
    
    public var initial: String {
        return String(rawValue.first!).uppercased()
    }
    
    public init?(string: String) {
        let lowercased = string.lowercased()
        if lowercased == "appellant" || lowercased == "a" {
            self = .appellant
        } else if lowercased == "respondent" || lowercased == "r" {
            self = .respondent
        } else {
            return nil
        }
    }
}

public enum Order: Int, Codable {
    case first = 1
    case second = 2
}

public enum SortType: Int, Codable {
    case firstName, lastName, school, userType
}
