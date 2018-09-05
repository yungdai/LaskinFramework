//
//  UserManager.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-08-14.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public class UserManager: NSObject, HTTPDelegate {
    
    override init() {
        super.init()
        
        httpManager.delegate = self
    }
    
    public var json: Payload?
    public var httpManager = HTTPManager()
	var userData: Payload?
	var users: [User]?
    public let utilities = Utilities()

    public var gotData: Bool = false {
        didSet {
            
            if gotData == true && httpManager.isLoggedIntoWordPress == true {
                
                if let json = jsonData as Payload? {
					userData = json
                }
            }
        }
    }
    
    public var jsonData: Payload? {
        didSet {
            print("did Set")
        }
    }
    
    public var failedLoading: Bool = false
    public var dataTask: URLSessionTask = URLSessionDataTask()

    // function to parse the JSON
    public func getJSON(completion: () -> Void) {
        
        // get the json file from the LaskinFramework
        guard let file = Bundle.init(identifier: "com.yungdai.LaskinFramework")?.path(forResource: "newData", ofType: "json") as String? else { return }
        
        let url = URL(fileURLWithPath: file)
        let data = try! Data(contentsOf: url)
        
        do {
            
            try json = (JSONSerialization.jsonObject(with: data, options:[.mutableContainers, .allowFragments]) as? Payload)
            parseJSON(object: json!)
        } catch  {
            
            print(error)
        }
        
        completion()
    }
	
	
	// TODO: Refactor for the new Laskin API WebServer
    public func getLaskinURL() -> URL {
        
        let plistUtility = PlistUtility()
        let laskinURL = NSMutableURLRequest(url: URL(string: "http://laskin.ca/wp-json/frm/v2/entries")!)
        
        if let formidableAPIKey = plistUtility.getValueFromPlist(forResource: "Data", fileExtension: "plist", key: "FormidableAPIKey") as! String? {
            
            let loginString: String = "\(formidableAPIKey):x"
            let loginEncoded = loginString.base64Encode()
            
            laskinURL.addValue("Basic \(String(describing: loginEncoded)))", forHTTPHeaderField: "Authorization")
        }
        
        return laskinURL.url!
    }
	
    
    /// Parse the JSON for the Laskin objects
    func parseJSON(object: Payload) {
        
        guard let people = object["userInfo"] as? [Payload] else { return }
        
        for person in people {
            
            var userType: UserType = .none
            
            if let type = person["userType"] as? String {
                userType = UserType(rawValue: type.lowercased()) ?? .none
            } else { return }
            
            switch userType {
                
            case .administrator:
                
                let admin = self.processAdministrator(data: person)
                
                if let count = UserStore.sharedUserStore.users(for: .administrator)?.count {
                    UserStore.sharedUserStore.insert(users: [admin], into: .administrator, at: count)
                } else {
                    UserStore.sharedUserStore.insert(users: [admin], into: .administrator, at: 0)
                }

            case .mooter:
                
                let mooter = self.processMooter(data: person)
                users?.append(mooter)
                
                if let count = UserStore.sharedUserStore.users(for: .mooter)?.count {
                    UserStore.sharedUserStore.insert(users: [mooter], into: .mooter, at: count)
                } else {
                    UserStore.sharedUserStore.insert(users: [mooter], into: .mooter, at: 0)
                }
 
            case .coach:
                
                let coach = self.processCoach(data: person)
                
                if let count = UserStore.sharedUserStore.users(for: .coach)?.count {
                   UserStore.sharedUserStore.insert(users: [coach], into: .coach, at: count)
                } else {
                    UserStore.sharedUserStore.insert(users: [coach], into: .coach, at: 0)
                }

            case .researcher:
                
                let researcher = self.processResearcher(data: person)
                
                if let count = UserStore.sharedUserStore.users(for: .researcher)?.count {
                    UserStore.sharedUserStore.insert(users: [researcher], into: .researcher, at: count)
                } else {
                    UserStore.sharedUserStore.insert(users: [researcher], into: .researcher, at: 0)
                }
                
            case .contactPerson:
                
                let contactPerson = self.processContactPerson(data: person)

                if let count = UserStore.sharedUserStore.users(for: .contactPerson)?.count {
                    UserStore.sharedUserStore.insert(users: [contactPerson], into: .contactPerson, at: count)
                } else {
                    UserStore.sharedUserStore.insert(users: [contactPerson], into: .contactPerson, at: 0)
                }
                
            case .judge:
                
                let judge = self.processJudge(data: person)
                
                if let count = UserStore.sharedUserStore.users(for: .judge)?.count {
                    UserStore.sharedUserStore.insert(users: [judge], into: .judge, at: count)
                } else {
                    UserStore.sharedUserStore.insert(users: [judge], into: .judge, at: 0)
                }
                
            default:
                break
            }
        }
        
        users = UserStore.getAllUsers()
    }
	
	// MARK: User Procesing API
    private func processAdministrator(data: Payload) -> Administrator {
        
        var admin = Administrator()
        
        if let id = data["id"] as? String {
            admin.id = Int(id)
        }
        
        if let firstName = data["firstName"] as? String {
            admin.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            admin.lastName = lastName
        }
        
        if let emailAddress = data["emailAddress"] as? String {
            admin.emailAddress =  emailAddress
        }
        
        return admin
    }
    
    private func processMooter(data: Payload) -> Mooter {
        
        var mooter = Mooter()
        
        if let id = data["id"] as? String {
            mooter.id = Int(id)
        }
        
        if let  firstName = data["firstName"] as? String {
            mooter.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            mooter.lastName = lastName
        }
        
        if let emailAddress = data["emailAddress"] as? String {
            mooter.emailAddress =  emailAddress
        }
        
        if let school = data["school"] as? String {
            mooter.school = school
        }
        
        if let side = data["side"] as? String {
            mooter.side = Side(string: side)
        }
        
        if let order = data["order"] as? String {
            
            if let orderNum = Int(order) {
                mooter.order = Order(rawValue: orderNum)
            }
        } else if let order = data["order"] as? Int {
            
            mooter.order = Order(rawValue: order)
        }
            
        if let needsInterpreter = data["needsInterpreter"] as? Bool {
            mooter.needsInterpreter = needsInterpreter
        }
        
        if let needsInterpreter = data["needsInterpreter"] as? String {
            
            let lowercased = needsInterpreter.lowercased()
            
            if lowercased == "yes" || lowercased == "true" {
                mooter.needsInterpreter = true
            } else {
                mooter.needsInterpreter = false
            }
        }
        
        if let requiresAccessibility = data["requiresAccessibility"] as? Bool {
            mooter.requiresAccessibility = requiresAccessibility
        }
        
        if let accessibilityNeeds = data["accessibilityNeeds"] as? String {
            mooter.accessibilityNeeds = accessibilityNeeds
        }
        
        if let hasDietaryNeeds = data["hasDietaryNeeds"] as? Bool {
            mooter.hasDietaryNeeds = hasDietaryNeeds
        }
        
        if let dietaryNeeds = data["dietaryNeeds"] as? String {
            mooter.dietaryNeeds = dietaryNeeds
        }
        
        if let mobilePhone = data["mobilePhone"] as? String {
            mooter.mobilePhone = mobilePhone
        } else {
            mooter.mobilePhone = String(describing: data["mobilePhone"])
        }
        
        if let language = data["language"] as? String {
            mooter.language = Language(rawValue: language.lowercased())!
        }
        
        if let schoolInfo = processSchoolInformation(for: mooter) {
            
            mooter.province = schoolInfo.province
            mooter.city = schoolInfo.city
            mooter.shortName = schoolInfo.shortName
            mooter.schoolNumber = schoolInfo.schoolNumber
        }
        
        return mooter
    }
    
    private func processJudge(data: Payload) -> Judge {
        
        var judge = Judge()
        
        if let id = data["id"] as? String {
            
            judge.id = Int(id)
        }
        
        if let  firstName = data["firstName"] as? String {
            
            judge.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            
            judge.lastName = lastName
        }
        
        if let emailAddress = data["emailAddress"] as? String {
            
            judge.emailAddress =  emailAddress
        }
        
        if let mobilePhone = data["mobilePhone"] as? String {
            
            judge.mobilePhone = mobilePhone
        } else {
            
            judge.mobilePhone = String(describing: data["mobilePhone"])
        }
        
        if let isRealJudge = data["isRealJudge"] as? Bool {
            
            judge.isRealJudge = isRealJudge
        }
        
        if let gender = data["gender"] as? String,
            let jgender = Gender(rawValue: gender) {
            
            judge.gender = jgender
        }
        
        if let englishOnly = data["englishOnly"] as? Bool {
            
            judge.englishOnly = englishOnly
        }
        
        if let judgeExperience = data["judgeExperience"] as? String,
            let jExperience = JudgeExperience(rawValue: judgeExperience) {
            
            judge.judgeExperience = jExperience
        }
        
        if let hardConflict = data["hardConflicts"] as? String {
            judge.hardConflicts = hardConflict
        }
        
        if let softConflicts = data["softConflictgs"] as? String {
            
            judge.softConflicts = softConflicts
        }
        
        if let schoolInfo = processSchoolInformation(for: judge) {
            judge.province = schoolInfo.province
            judge.city = schoolInfo.city
            judge.shortName = schoolInfo.shortName
            judge.schoolNumber = schoolInfo.schoolNumber
        }
        
        return judge
    }
    
    private func processCoach(data: Payload) -> Coach {
        
        var coach = Coach()
        
        if let id = data["id"] as? String {
            
            coach.id = Int(id)
        }
        
        if let  firstName = data["firstName"] as? String {
            
            coach.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            
            coach.lastName = lastName
        }
        
        if let emailAddress = data["emailAddress"] as? String {
            
            coach.emailAddress =  emailAddress
        }
        
        if let mobilePhone = data["mobilePhone"] as? String {
            
            coach.mobilePhone = mobilePhone
        } else {
            
            coach.mobilePhone = String(describing: data["mobilePhone"])
        }
        
        
        if let school = data["school"] as? String {
            
            coach.school = school
        }
        
        if let requiresAccessibility = data["requiresAccessibility"] as? Bool {
            
            coach.requiresAccessibility = requiresAccessibility
        }
        
        if let accessibilityNeeds = data["accessibilityNeeds"] as? String {
            
            coach.accessibilityNeeds = accessibilityNeeds
        }
        
        if let hasDietaryNeeds = data["hasDietaryNeeds"] as? Bool {
            
            coach.hasDietaryNeeds = hasDietaryNeeds
        }
        
        if let dietaryNeeds = data["dietaryNeeds"] as? String {
            
            coach.dietaryNeeds = dietaryNeeds
        }
        
        if let isEnglishOK = data["isEnglishOK"] as? Bool {
            
            coach.isEnglishOK = isEnglishOK
        }
        
        if let willAttend = data["willAttend"] as? Bool {
            
            coach.willAttend = willAttend
        }
    
        if let schoolInfo = processSchoolInformation(for: coach) {
            coach.province = schoolInfo.province
            coach.city = schoolInfo.city
            coach.shortName = schoolInfo.shortName
            coach.schoolNumber = schoolInfo.schoolNumber
        }
        
        return coach
    }
    
    private func processResearcher(data: Payload) -> Researcher {
        
        var researcher = Researcher()
        
        if let id = data["id"] as? String {
            
            researcher.id = Int(id)
        }
        
        if let  firstName = data["firstName"] as? String {
            
            researcher.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            
            researcher.lastName = lastName
        }
        
        if let emailAddress = data["emailAddress"] as? String {
            
            researcher.emailAddress =  emailAddress
        }
        
        if let mobilePhone = data["mobilePhone"] as? String {
            
            researcher.mobilePhone = mobilePhone
        } else {
            
            researcher.mobilePhone = String(describing: data["mobilePhone"])
        }
        
        if let school = data["school"] as? String {
            
            researcher.school = school
        }
        
        if let requiresAccessibility = data["requiresAccessibility"] as? Bool {
            
            researcher.requiresAccessibility = requiresAccessibility
        }
        
        if let accessibilityNeeds = data["accessibilityNeeds"] as? String {
            
            researcher.accessibilityNeeds = accessibilityNeeds
        }
        
        if let hasDietaryNeeds = data["hasDietaryNeeds"] as? Bool {
            
            researcher.hasDietaryNeeds = hasDietaryNeeds
        }
        
        if let dietaryNeeds = data["dietaryNeeds"] as? String {
            
            researcher.dietaryNeeds = dietaryNeeds
        }
        
        if let willAttend = data["willAttend"] as? Bool {
            
            researcher.willAttend = willAttend
        }
        
        if let schoolInfo = processSchoolInformation(for: researcher) {
            researcher.province = schoolInfo.province
            researcher.city = schoolInfo.city
            researcher.shortName = schoolInfo.shortName
            researcher.schoolNumber = schoolInfo.schoolNumber
        }
        
        return researcher
    }
    
    private func processContactPerson(data: Payload) -> ContactPerson {
        
        var contactPerson = ContactPerson()
        
        if let id = data["id"] as? String {
            
            contactPerson.id = Int(id)
        }
        
        if let  firstName = data["firstName"] as? String {
            
            contactPerson.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            
            contactPerson.lastName = lastName
        }
        
        if let emailAddress = data["emailAddress"] as? String {
            
            contactPerson.emailAddress =  emailAddress
        }
        
        if let mobilePhone = data["mobilePhone"] as? String {
            
            contactPerson.mobilePhone = mobilePhone
        } else {
            
            contactPerson.mobilePhone = String(describing: data["mobilePhone"])
        }
        
        if let isEnglishOK = data["isEnglishOK"] as? Bool {
            
            contactPerson.isEnglishOK = isEnglishOK
        }
        
        return contactPerson
    }
    
    // process the cell based on the type of user.
  

    //MARK: - School Assembling
    private func processSchoolInformation(for school: School) -> SchoolInfo? {
        
        guard let schoolName = school.school else { return nil }
        guard let schoolEnum = SchoolName(rawValue: schoolName) else { return nil }
        
        var schoolInfo: SchoolInfo
        
        switch schoolEnum {
            
        case .alberta:
            schoolInfo.city = "Calgary"
            schoolInfo.province = .alberta
            schoolInfo.shortName = "Albert"
            schoolInfo.schoolNumber = 17
            
        case .dalhousie:
            schoolInfo.city = "Halifax"
            schoolInfo.province = .novaScotia
            schoolInfo.shortName = "Dalhousie"
            schoolInfo.schoolNumber = 6
            
        case .laval:
            schoolInfo.city = "Laval"
            schoolInfo.province = .quebec
            schoolInfo.shortName = "Lavel"
            schoolInfo.schoolNumber = 13
            
        case .manitoba:
            schoolInfo.city = "Winnipeg"
            schoolInfo.province = .manitoba
            schoolInfo.shortName = "Manitoba"
            schoolInfo.schoolNumber = 7
            
        case .mcgill:
            schoolInfo.city = "Montreal"
            schoolInfo.province = .quebec
            schoolInfo.shortName = "McGill"
            schoolInfo.schoolNumber = 12
            
        case .moncton:
            schoolInfo.city = "Moncton"
            schoolInfo.province = .newBrunswick
            schoolInfo.shortName = "Moncton"
            schoolInfo.schoolNumber = 8
            
        case .montreal:
            schoolInfo.city = "Montréal"
            schoolInfo.province = .quebec
            schoolInfo.shortName = "Montréal"
            schoolInfo.schoolNumber = 13
            
        case .montréal:
            schoolInfo.city = "Montréal"
            schoolInfo.province = .quebec
            schoolInfo.shortName = "Montréal"
            schoolInfo.schoolNumber = 13
            
        case .osgoode:
            schoolInfo.city = "Toronto"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "Osgoode"
            schoolInfo.schoolNumber = 3
            
        case .ottawaCivil:
            schoolInfo.city = "Ottawa"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "OttawaCivil"
            schoolInfo.schoolNumber = 10
            
        case .ottawaCommon:
            schoolInfo.city = "Ottawa"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "OttawaCommon"
            schoolInfo.schoolNumber = 1
            
        case .queens:
            schoolInfo.city = "Kingston"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "Queens"
            schoolInfo.schoolNumber = 14
            
        case .saskatchewan:
            schoolInfo.city = "Regina"
            schoolInfo.province = .saskatchewan
            schoolInfo.shortName = "Saskatchewan"
            schoolInfo.schoolNumber = 19
            
        case .sherbrooke:
            schoolInfo.city = "Sherbrooke"
            schoolInfo.province = .quebec
            schoolInfo.shortName = "Sherbrooke"
            schoolInfo.schoolNumber = 15
        
        case .toronto:
            schoolInfo.city = "Toronto"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "Toronto"
            schoolInfo.schoolNumber = 5
            
        case .ubc:
            schoolInfo.city = "Vancouver"
            schoolInfo.province = .britishColumbia
            schoolInfo.shortName = "UBC"
            schoolInfo.schoolNumber = 9
            
        case .unb:
            schoolInfo.city = "Fredrickton"
            schoolInfo.province = .newBrunswick
            schoolInfo.shortName = "UNB"
            schoolInfo.schoolNumber = 16
            
        case .uqam:
            schoolInfo.city = "Montreal"
            schoolInfo.province = .quebec
            schoolInfo.shortName = "UQAM"
            schoolInfo.schoolNumber = 11
            
        case .western:
            schoolInfo.city = "London"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "Western"
            schoolInfo.schoolNumber = 4
            
        case .windsor:
            schoolInfo.city = "Windsor"
            schoolInfo.province = .ontario
            schoolInfo.shortName = "Windsor"
            schoolInfo.schoolNumber = 2
        }
        
        return schoolInfo
    }
    
    static func parseUserProperties(_ user: User) -> [PropertyString] {
        let properties = user.propertiesTupleArray()
        return properties.map { property -> PropertyString in
            let value = parsePropertyToString(property: property.1)
            return (property.0.splitCamelCase().capitalized, value)
            
        }
    }
    
    private static func parsePropertyToString(property: Any) -> String {
        if let stringValue = property as? String {
            return stringValue
        } else if let intValue = property as? Int {
            return String(intValue)
        } else if let boolValue = property as? Bool {
            return boolValue == true ? "Yes" : "No"
        } else if let enumValue = unwrap(any: property) as? StringRepresentableEnum {
            return enumValue.rawValue.capitalized
        } else if let timeZone = property as? LSATimeZone {
            return String(timeZone.rawValue)
        } else if let order = property as? Order {
            return String(order.rawValue)
        }
        return "N/A"
    }
}

