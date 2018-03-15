//
//  Logging.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-11-03.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

struct Logger {
    private init() {}
    
    static func listSchools(_ schools: [School]) {
        print("\nList of Schools fields\n-----------------------")
        
        var schoolNames = [String]()
        var schoolCities = [String]()
        var schoolProvinces = [String]()
        
        schools.forEach {
            schoolNames.append($0.school ?? "N/A")
            schoolCities.append($0.city)
            schoolProvinces.append($0.province?.rawValue ?? "N/A")
        }
        
        print("let schoolNames = \(schoolNames)\n")
        print("let schoolCities = \(schoolCities)\n")
        print("let schoolProvinces = \(schoolProvinces)")
    }
    
    static func listJudges(_ judges: [Judge]) {
        
        print("\nList of Judges fields\n-----------------------")
        
        var firstNames = [String]()
        var lastNames = [String]()
        var cities = [String]()
        var provinces = [String]()
        var frenchSpeakings = [String]()
        
        judges.forEach {
            firstNames.append($0.firstName ?? "N/A")
            lastNames.append($0.lastName ?? "N/A")
            cities.append($0.city)
            provinces.append($0.province?.rawValue ?? "N/A")
            frenchSpeakings.append(String($0.frenchSpeaking))
        }
        
        print("let firstNames = \(firstNames)\n")
        print("let lastNames = \(lastNames)\n")
        print("let cities = \(cities)\n")
        print("let provinces = \(provinces)\n")
        print("let frenchSpeakings = \(frenchSpeakings)")
    }
    
    static func listMooters(_ mooters: [Mooter]) {
        
        print("\nList of Mooters fields\n-----------------------")
        
        var firstNames = [String]()
        var lastNames = [String]()
        var languages = [String]()
        var interpreterType = [String]()
        var sides = [String]()
        var orders = [String]()
        var schoolNames = [String]()
        
        mooters.forEach {
            firstNames.append($0.firstName ?? "N/A")
            lastNames.append($0.lastName ?? "N/A")
            languages.append($0.language.rawValue)
            interpreterType.append($0.interpreterType.initial)
            sides.append($0.side?.initial ?? "N/A")
            orders.append($0.order != nil ? String($0.order!.rawValue) : "N/A")
            schoolNames.append($0.school ?? "N/A")
        }
        
        print("let firstNames = \(firstNames)\n")
        print("let lastNames = \(lastNames)\n")
        print("let languages = \(languages)\n")
        print("let interpreterType = \(interpreterType)\n")
        print("let sides = \(sides)\n")
        print("let orders = \(orders)\n")
        print("let schoolNames = \(schoolNames)")
    }
    
    static func printSchools(_ schools: [LMSchool]) {
        print("\nSCHOOLS\n------------------------")
        schools.forEach {
            print("\($0.name), \($0.province.rawValue)    (Time zone = \($0.timeZone.rawValue)")
        }
    }
    
    static func printMooters(_ mooters: [LMMooter]) {
        print("\n \(mooters.count) MOOTERS\n---------------------------")
        var lastSchool = ""
        mooters.forEach {
            let school = $0.school.name
            if school != lastSchool {
                print("\n>> \(school)")
                lastSchool = school
            }
            let language = "\($0.language.initial)\($0.interpreterType.isValidLanguage ? "+" : "")"
            
            print("  \($0.position) - \($0.lastName), \($0.firstName)  \t\(language)")
        }
    }
    
    static func printPairs(_ pairs: [Pair]) {
        print("\n\(pairs.count) PAIRS\n     Lang   II    Ha\n-------------------------------------")
        
        for i in 0..<pairs.count {
            let firstMooter = pairs[i].firstMooter
            let secondMooter = pairs[i].secondMooter
            let pairLanguage = "\(firstMooter.language.initial)\(secondMooter.language.initial)"
            let interpreter = "\(firstMooter.interpreterType.initial)\(secondMooter.interpreterType.initial)"
            
            print("\(i).\t\(pairLanguage)\t\(interpreter)  \t\(pairs[i].hoursAhead)\t\(firstMooter.school.name)\t\t\(firstMooter.side.initial)-\(firstMooter.firstName) \(firstMooter.lastName), \(secondMooter.firstName) \(secondMooter.lastName)")
        }
    }
    
    static func printMatches(_ matches: [Match], hostName: String, hostTimeZone: Int) {
        print("\n\(matches.count) MATCHES (Host is \(hostName) in time zone \(hostTimeZone))\n-----II---Ha----A------------------------R-----------------")
        for i in 0..<matches.count {
            let interpreter = matches[i].needsInterpreter ? "II" : "--"
            let appellantSchool = matches[i].appellantPair.school.name
            let respondentSchool = matches[i].respondentPair.school.name
            print("\(i).\t\(interpreter)\t\(matches[i].hoursAhead)\t\(appellantSchool) <> \(respondentSchool)")
        }
    }

    static func firstLook(pairCount: Int, roomCount: Int, emptyRoomCount: Int) {
        print("\nFirst Look\n----------------------")
        print("There are \(pairCount / 2) schools")
        print("There are \(pairCount * 2) mooters")
        print("There are \(pairCount) pairs")
        print("There are \(pairCount / 2) matches in each of two rounds")

        // Two rounds of matches so number of Pairs == number of Matches
        print("There are \(pairCount) matches total in the two rounds")
        print("\(roomCount) courtrooms will be used")
        print("Of the \(roomCount * 6) slots available, \(emptyRoomCount) will not be used")
    }
}
