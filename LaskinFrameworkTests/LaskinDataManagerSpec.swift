//
//  LaskinDataManagerSpec.swift
//  LaskinFrameworkTests
//
//  Created by Yung Dai on 2018-08-05.
//  Copyright © 2018 Yung Dai. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import LaskinFramework

class LaskinDataManagerSpec: QuickSpec {
	
	var laskinDataManager: LaskinDataManager?
	var userManager: UserManager?
	var users: Users?
	var schedule: Schedule?

	var testJSON: Payload?
	
	override func spec() {
		
		beforeEach() {
			self.laskinDataManager = LaskinDataManager()
			self.schedule = self.laskinDataManager?.schedule
			self.userManager = self.laskinDataManager?.userManager
		}
		
		describe("LaskinManager should initialise") {
			
			it("should make sure that UserManager is not nil") {
				
				expect(self.laskinDataManager?.userManager).toNot(beNil())
			}
			
			it("should get users") {
				
				self.users = self.laskinDataManager?.getUsers()
				expect(self.users).toNot(beNil())
			}
		}
	}
	
	public func getJSON() throws -> Payload?  {
		
		// get the json file from the LaskinFramework
		guard let file = Bundle.init(identifier: "com.yungdai.LaskinFramework")?.path(forResource: "newData", ofType: "json") as String? else { return nil }
		
		let url = URL(fileURLWithPath: file)
		let data = try! Data(contentsOf: url)
		
		do {
			
			let json = try (JSONSerialization.jsonObject(with: data, options:[.mutableContainers, .allowFragments]) as? Payload)
			return json
		} catch  {
			return error as? Payload
		}
	}
}
