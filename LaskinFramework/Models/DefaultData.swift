//
//  DefaultData.swift
//  LaskinFramework
//
//  Created by Yung Dai on 2018-09-05.
//  Copyright © 2018 Yung Dai. All rights reserved.
//

import Foundation

// struct user to decode and encode all default data for NSUserDefaults
public class DefaultData: NSObject, Codable {
	
	var users: Users?

	public init(users: Users) {
		
		self.users = users
	}
	
	enum CodingKeys: String, CodingKey {
		
		case users = "Users"
		case additionalInfo
	}
	
	enum AdditionalInfoKeys: String, CodingKey {
		case none
		case administrator
		case coach
		case contactPerson
		case judge
		case mooter
		case researcher
	}
	
	public func encode(to encoder: Encoder) throws {
		
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
		
		try users?.forEach { args in
			
			let userType = args.key
			let users = args.value
			
			// convert the user protocol to a model that can be used for encoding decoding
			let additonalInfoKey: AdditionalInfoKeys = AdditionalInfoKeys.init(rawValue: userType.rawValue) ?? .none
			
			switch userType {
			case .administrator:
				let adminArray: [Administrator] = users.compactMap {
					guard let admin = $0 as? Administrator else { return nil }
					return admin
				}
				try additionalInfo.encode(adminArray, forKey: additonalInfoKey)
				
			case .coach:
				let coachArray: [Coach] = users.compactMap { guard let coach = $0 as? Coach else { return nil }
					return coach
				}
				try additionalInfo.encode(coachArray, forKey: additonalInfoKey)
				
			case .contactPerson:
				let contactPersonArray: [ContactPerson] = users.compactMap { guard let contactPerson = $0 as? ContactPerson else { return nil }
					return contactPerson
				}
				try additionalInfo.encode(contactPersonArray, forKey: additonalInfoKey)
				
			case .judge:
				let judgeArray: [Judge] = users.compactMap { guard let judge = $0 as? Judge else { return nil }
					return judge
				}
				try additionalInfo.encode(judgeArray, forKey: additonalInfoKey)
				
			case .mooter:
				let mooterArray: [Mooter] = users.compactMap { guard let mooter = $0 as? Mooter else { return nil }
					return mooter
				}
				try additionalInfo.encode(mooterArray, forKey: additonalInfoKey)
				
			case .researcher:
				let researcherArray: [Researcher] = users.compactMap { guard let researcher = $0 as? Researcher else { return nil }
					return researcher
				}
				try additionalInfo.encode(researcherArray, forKey: additonalInfoKey)
				
			default: break
			}
		}
	}
	
	required public init(from decoder: Decoder) throws {
		
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
		
		let keys = additionalInfo.allKeys
		
		var users: Users = [:]
		
		try keys.forEach {
			
			let userType = UserType(rawValue: $0.rawValue) ?? .none
			
			switch userType {
			case .administrator:
				
				let adminArray = try additionalInfo.decode([Administrator].self, forKey: .administrator)
				users[.administrator] = adminArray
				
			case .coach:
				let coachArray = try additionalInfo.decode([Coach].self, forKey: .coach)
				users[.coach] = coachArray
				
			case .contactPerson:
				let contactArray = try additionalInfo.decode([ContactPerson].self, forKey: .contactPerson)
				users[.administrator] = contactArray
				
			case .judge:
				let judgeArray = try additionalInfo.decode([Judge].self, forKey: .judge)
				users[.judge] = judgeArray
				
			case .mooter:
				let mooterArray = try additionalInfo.decode([Mooter].self, forKey: .mooter)
				users[.mooter] = mooterArray
				
			case .researcher:
				let researchArray = try additionalInfo.decode([Researcher].self, forKey: .researcher)
				users[.researcher] = researchArray
				
			case .none:
				users[.none] = []
			}
		}
		
		self.users = users
	}
}
