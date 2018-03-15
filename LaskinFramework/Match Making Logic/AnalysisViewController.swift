////
////  AnalysisViewController.swift
////  Moot
////
////  Created by Colin Moseley on 8/23/16.
////  Copyright © 2016 Colin Moseley. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//struct ASchool {
//    var name = ""
//    var city = ""
//    var province = ""
//    var timeZone = 99
//}
//
//struct AMooter {
//    var schoolIx = 99
//    var firstName = ""
//    var lastName = ""
//    var side = ""
//    var rank = 99
//    var language = ""
//    var needsIIFrom = ""
//}
//
//struct Team {
//    var side = ""
//    var mooterIxs: [Int] = [99, 99]    //A & R
//    var hoursAhead = 99
//    var matchCount = 99
//}
//
//struct Match {
//    var teamsIx: [Int] = [99, 99]
//    var hoursAhead = 99
//    var roomNumber = 99     // 0-based
//    var sessionNumber = 99     // 0-based
//    var needsII = false
//    var demerits = 0
//}
//
//class AnalysisViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//    
//    let demeritsII = 11                 //
//    let demeritsTimeZone = [2, 1]       //Friday - 2,1   Saturday 1,0
//    let demeritsTeamAdjacent = 13       //Absolute Nono
//    let demeritsTeamSameSession = 17    //Physical impossibility
//    let demeritsSchoolSameSession = 4   //Watch out for same school twice
//    
//    var fetchedSchools: [School] = []
//    var fetchedMooters: [Mooter] = []
//    var fetchedJudges: [Judge] = []
//    var schools: [ASchool] = []
//    var mooters: [AMooter] = []
//    var teams: [Team] = []
//    var matches: [Match] = []
//    var schedule: [[Int]] = [[]]  //Outside array is rooms, inside is 6 sessions
//    
//    var teamCount = 0
//    var matchCount = 0
//    var roomCount = 0
//    var iiCount = 0
//    var emptyRoomCount = 0
//    var rightRow = 0
//    var hostName = ""
//    var hostProvince = ""
//    var hostTimeZone = 0
//
//    @IBOutlet weak var pkrSchool: UIPickerView!
//    @IBOutlet weak var btnMakeTeams: UIButton!
//    @IBOutlet weak var btnMakeMatches: UIButton!
//    @IBOutlet weak var btnMakeSchedule: UIButton!
//    @IBOutlet weak var segFormat: UISegmentedControl!
//    
//    @IBAction func doTeams(_ sender: AnyObject) {
//        print("---- SETTING UP TEAMS ----------------\n--------------------------------------")
//        
//        matches = []
//        teams = []
//        
////        fetchSchools()
//        listSchools()
//        
////        fetchMooters()
//        listMooters()
//
//        let msg = mootersAreValid()
//        if msg == "" {
//            print("\n*********** Mooters are valid")
//
//            makeTeams()
//            listTeams()
//            
//            firstLook()
//            
//            btnMakeMatches.isEnabled = true
//        } else {
//            print("\nCAN'T DO IT: \(msg)")
//        }
//        
//    }
//    
//    @IBAction func doMatches(_ sender: UIButton) {
//        print("\n\n---- DEFINING MATCHES ----------------\n--------------------------------------")
//        //Sometimes not every team can be matched
//        makeMatches()
//        listMatches()
//        
//        btnMakeSchedule.isEnabled = true
//    }
//    
//    @IBAction func doSchedule(_ sender: UIButton) {
//        print("\n\n---- DEFINING SCHEDULE ----------------\n------------------------------------------")
//        
//        makeSchedule()
//        showSchedule()
//    }
//    
//    @IBAction func doListSchools(_ sender: UIButton) {
////      This logs arrays that can be copied into the Welcome controller to 
////      restore Core Data after a model change
//        print("\nList of Schools fields\n-----------------------")
//        
//        var sNames = ""
//        var sCities = ""
//        var sProvinces = ""
//        
//        var isFirst = true
//        for s in schools {
//            if !isFirst {
//                sNames = "\(sNames), "
//                sCities = "\(sCities), "
//                sProvinces = "\(sProvinces), "
//            } else {
//                isFirst = false
//            }
//            sNames = "\(sNames)\"\(s.name)\""
//            sCities = "\(sCities)\"\(s.city)\""
//            sProvinces = "\(sProvinces)\"\(s.province)\""
//        }
//        print("let sNames = [\(sNames)]\n")
//        print("let sCities = [\(sCities)]\n")
//        print("let sProvinces = [\(sProvinces)]")
//    }
//    
//    @IBAction func doListJudges(_ sender: UIButton) {
////      This logs arrays that can be copied into the Welcome controller to
////      restore Core Data after a model change
//        print("\nList of Judges fields\n-----------------------")
//        fetchJudges()
//        
//        var jFirstNames = ""
//        var jLastNames = ""
//        var jCities = ""
//        var jProvinces = ""
//        var jFrenchSpeakings = ""
//        
//        var isFirst = true
//        for j in fetchedJudges {
//            if !isFirst {
//                jFirstNames = "\(jFirstNames), "
//                jLastNames = "\(jLastNames), "
//                jCities = "\(jCities), "
//                jProvinces = "\(jProvinces), "
//                jFrenchSpeakings = "\(jFrenchSpeakings), "
//            } else {
//                isFirst = false
//            }
//            jFirstNames = "\(jFirstNames)\"\(j.firstName!)\""
//            jLastNames = "\(jLastNames)\"\(j.lastName!)\""
//            jCities = "\(jCities)\"\(j.city!)\""
//            jProvinces = "\(jProvinces)\"\(j.province!)\""
//            jFrenchSpeakings = "\(jFrenchSpeakings)\(j.frenchSpeaking!)"
//        }
//        print("let jFirstNames = [\(jFirstNames)]\n")
//        print("let jLastNames = [\(jLastNames)]\n")
//        print("let jCities = [\(jCities)]\n")
//        print("let jProvinces = [\(jProvinces)]\n")
//        print("let jFrenchSpeakings = [\(jFrenchSpeakings)]")
//    }
//    
//    @IBAction func doListMooters(_ sender: UIButton) {
////      This logs arrays that can be copied into the Welcome controller to
////      restore Core Data after a model change
//        print("\nList of Mooters fields\n-----------------------")
//        
//        var mFirstNames = ""
//        var mLastNames = ""
//        var mLanguages = ""
//        var mNeedsIIFroms = ""
//        var mSides = ""
//        var mRanks = ""
//        var mSchoolNames = ""
//        
//        var isFirst = true
//        for m in mooters {
//            if !isFirst {
//                mFirstNames = "\(mFirstNames), "
//                mLastNames = "\(mLastNames), "
//                mLanguages = "\(mLanguages), "
//                mNeedsIIFroms = "\(mNeedsIIFroms), "
//                mSides = "\(mSides), "
//                mRanks = "\(mRanks), "
//                mSchoolNames = "\(mSchoolNames), "
//           } else {
//                isFirst = false
//            }
//            mFirstNames = "\(mFirstNames)\"\(m.firstName)\""
//            mLastNames = "\(mLastNames)\"\(m.lastName)\""
//            mLanguages = "\(mLanguages)\"\(m.language)\""
//            mNeedsIIFroms = "\(mNeedsIIFroms)\"\(m.needsIIFrom)\""
//            mSides = "\(mSides)\"\(m.side)\""
//            mRanks = "\(mRanks)\(m.rank)"
//            mSchoolNames = "\(mSchoolNames)\(schools[m.schoolIx].name)"
//        }
//        print("let mFirstNames = [\(mFirstNames)]\n")
//        print("let mLastNames = [\(mLastNames)]\n")
//        print("let mLanguages = [\(mLanguages)]\n")
//        print("let mNeedsIIs = [\(mNeedsIIFroms)]\n")
//        print("let mSides = [\(mSides)]\n")
//        print("let mRanks = [\(mRanks)]\n")
//        print("let mSchoolNames = [\(mSchoolNames)]")
//    }
//    
//    // MARK: - System funcs
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Fetch from CoreData and put in arrays.
//        fetchSchools()
//        fetchMooters()
//        fetchJudges()
//        
//        pkrSchool.delegate = self
//        pkrSchool.dataSource = self
//        
//        pkrSchool.selectRow(0, inComponent: 0, animated: true)
//        btnMakeTeams.isEnabled = false
//        btnMakeMatches.isEnabled = false
//        btnMakeSchedule.isEnabled = false
//        
//        segFormat.selectedSegmentIndex = 2
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Fetches
//    func fetchJudges() {
//        
//        let judgesFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Judge")
//        judgesFetch.fetchBatchSize = 30
//        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
//        judgesFetch.sortDescriptors = [sortDescriptor]
//        
//        do {
//            fetchedJudges = try moc.fetch(judgesFetch) as! [Judge]
//        } catch {
//            fatalError("Failed to fetch judges: \(error)")
//        }
//    }
//
//    func fetchSchools() {
//        
//        let schoolsFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "School")
//        schoolsFetch.fetchBatchSize = 30
//        let sortDescriptor1 = NSSortDescriptor(key: "province", ascending: true)
//        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: true)
//        schoolsFetch.sortDescriptors = [sortDescriptor1, sortDescriptor2]
//        
//        do {
//            fetchedSchools = try moc.fetch(schoolsFetch) as! [School]
//        } catch {
//            fatalError("Failed to fetch schools: \(error)")
//        }
//
//        //Put them into the array
//        schools = []
//        for fs in fetchedSchools {
//            var s = ASchool()
//            s.name = fs.name!
//            s.city = fs.city!
//            s.province = fs.province!
//            s.timeZone = provinceTimeZones[fs.province!]!
//            schools.append(s)
//        }
//    }
//    
//    func listSchools() {
//        print("\nSCHOOLS\n------------------------")
//        for s in schools {
//            print("\(s.name), \(s.province)    (Time zone = \(s.timeZone)")
//        }
//    }
//    
//    func fetchMooters() {
//        let mootersFetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Mooter")
//        mootersFetch.fetchBatchSize = 50
//        let sortDescriptor1 = NSSortDescriptor(key: "school", ascending: true)
//        let sortDescriptor2 = NSSortDescriptor(key: "side", ascending: true)
//        let sortDescriptor3 = NSSortDescriptor(key: "rank", ascending: true)
//        mootersFetch.sortDescriptors = [sortDescriptor1, sortDescriptor2, sortDescriptor3]
//        
//        do {
//            fetchedMooters = try moc.fetch(mootersFetch) as! [Mooter]
//        } catch {
//            fatalError("Failed to fetch mooters: \(error)")
//        }
//        
//        //Put them into the array
//        mooters = []
//        for fm in fetchedMooters {
//            var m = AMooter()
//            for sIx in (0..<schools.count) {
//                if schools[sIx].name == fm.school!.name {
//                    m.schoolIx = sIx
//                    break
//                }
//            }
//            
//            m.firstName = fm.firstName!
//            m.lastName = fm.lastName!
//            m.language = fm.language!
//            m.side = fm.side!
//            m.rank = Int(fm.rank!)
//            m.needsIIFrom = (fm.needsII! == 0 ? "N": (fm.language! == "E" ? "F": "E"))
//            mooters.append(m)
//        }
//    }
//
//    func listMooters() {
//        print("\n \(mooters.count) MOOTERS\n---------------------------")
//        var lastSchool = ""
//        for m in mooters {
//            if schools[m.schoolIx].name != lastSchool {
//                print("\n>> \(schools[m.schoolIx].name)")
//                lastSchool = schools[m.schoolIx].name
//            }
//            var ml = m.language
//            if m.needsIIFrom != "N" {
//                ml = "\(ml)+"
//            }
//            print("  \(m.side)\(Int(m.rank) + 1) - \(m.lastName), \(m.firstName)  \t\(ml)")
//        }
//    }
//    
//    func  mootersAreValid() -> String {
//        let nextMooter = ["A1":"A2", "A2":"R1", "R1":"R2", "R2":"A1", "XX":"A1"]
//        var lastLabel = "XX"
//        var eCount = 0
//        var fCount = 0
//        for m in mooters {
//            let rk = (m.rank == 0 ? "1":"2")
//            let thisLabel = "\(m.side)\(rk)"
//            if thisLabel != nextMooter[lastLabel] {
//                return "A mooter is missing before \(m.lastName)"
//            } else {
//                if m.language == "E" {
//                    eCount += 1
//                } else {
//                    fCount += 1
//                }
//                if thisLabel == "R2" {
//                    if eCount < 1 {
//                        return "School \(schools[m.schoolIx].name) needs an english mooter."
//                    } else if fCount < 1 {
//                        return "School \(schools[m.schoolIx].name) needs a french mooter."
//                    }
//                    eCount = 0
//                    fCount = 0
//                }
//                lastLabel = thisLabel
//            }
//        }
//        return ""
//    }
//    
//    // MARK: - Analysis
//    func makeTeams() {
////        print("\nMaking teams...................")
//        var savedMooterIx = 99
//        
//        for mIx in (0..<mooters.count) {
//            let m = mooters[mIx]
//            
//            let rk = (m.rank == 0 ? "1":"2")
//            if rk == "1" {
//                //Save this first member of the team
//                savedMooterIx = mIx
//            } else {
//                //Put the team together
//                var thisTeam = Team()
//                thisTeam.side = m.side
//                thisTeam.mooterIxs = [mIx, savedMooterIx]
//                thisTeam.hoursAhead = provinceTimeZones[schools[m.schoolIx].province]! - hostTimeZone
//                teams.append(thisTeam)
//            }
//        }
//    }
//    
//    func listTeams() {
//        print("\n\(teams.count) TEAMS\n     Lang   II    Ha\n-------------------------------------")
//        var tCount = -1
//        for t in teams {
//            tCount += 1
//            var sLang = ""
//            var sNeedsII = ""
//            for ix in (0...1) {
//                let m = mooters[t.mooterIxs[ix]]
//                let l = m.language
//                sLang = "\(sLang)\(l)"
//                let n = m.needsIIFrom
//                if !(n == "N") {sNeedsII = "\(sNeedsII)\(n)"}
//            }
//            if sNeedsII == "" { sNeedsII = "-"}
//            let m1 = mooters[t.mooterIxs[0]]
//            let m2 = mooters[t.mooterIxs[1]]
//            print("\(tCount).\t\(sLang)\t\(sNeedsII)  \t\(t.hoursAhead)\t\(schools[m1.schoolIx].name)\t\t\(m1.side)-\(m1.firstName) \(m1.lastName), \(m2.firstName) \(m2.lastName)")
//        }
//    }
//    
//    func firstLook() {
//        print("\nFirst Look\n----------------------")
//        teamCount = teams.count
//        print("There are \(schools.count) schools")
//        print("There are \(teamCount) teams")
//        print("There are \(teamCount / 2) matches in each of two rounds")
//        
//        matchCount = teamCount
//        print("There are \(matchCount) matches total in the two rounds")
//        roomCount = Int((matchCount + 5) / 6)
//        print("\(roomCount) courtrooms will be used")
//        emptyRoomCount = (roomCount * 6) - matchCount
//        
//        print("Of the \(roomCount * 6) slots available, \(emptyRoomCount) will not be used")
//    }
//    
//    func makeMatches() {
//        //        print("\nMaking matches................")
//        while matches.count < matchCount {  //In case can't complete the matches
//            
//            //Initialize
//            matches = []
//            for tIx in (0..<teams.count) {
//                teams[tIx].matchCount = 0
//            }
//            
//            var roundNumber = 1     //Two rounds of matches
//            while (roundNumber <= 2) {
//                print("\n\nROUND \(roundNumber) ###############################")
//                
//                //        Matching is done in three runs in each round.
//                //            1. Needy with needy
//                //            2. Leftover needies with non-needy with non-needy result
//                //            3. All leftovers
//                var run = 1     //3 runs for each types of match
//                while run <= 3 {
//                    //                print("\nRun Number \(run) --------------------------")
//                    
//                    var tIxA = 0
//                    //Consider each team for base A in this round
//                    while (tIxA < teams.count) {
//                        if ((teams[tIxA].matchCount < roundNumber) && (teamIsEligibleInRun(run, side: "A", tIx: tIxA))) {
//                            let baseSchoolIx = mooters[teams[tIxA].mooterIxs[0]].schoolIx
//                        print("\nA team is \(tIxA): \(schools[baseSchoolIx].name)")
//                            
//                            //  Don't match to itself, or any other school more than once
//                            //    In round 1 may be 1 prior match as R
//                            //    In round 2 will be one prior A and 1 or 2 prior Rs
//                            var priorSchoolIxs: [Int] = [baseSchoolIx]
//                            for m in matches {
//                                for ix in (0...1) {
//                                    if (mooters[teams[m.teamsIx[ix]].mooterIxs[0]].schoolIx == baseSchoolIx) {
//                                        priorSchoolIxs.append(mooters[teams[m.teamsIx[1 - ix]].mooterIxs[0]].schoolIx)
//                                    }
//                                }
//                            }
//                            
//                            //Start at random point to find R ---------------
//                            //arc4random_uniform(3) may return 0, 1 or 2 but not 3.
//                            var finishedR = false
//                            let startIx = 2 * Int(arc4random_uniform(UInt32(teamCount / 2)))  + 1   //All Rs are odd indices
//                            var tIxR = startIx
//                            while !finishedR {
//                            print("  Testing R team \(tIxR) - \(schools[mooters[teams[tIxR].mooterIxs[0]].schoolIx].name)")
//                                
//                                let testSchoolIx = mooters[teams[tIxR].mooterIxs[0]].schoolIx
//                                if ((teams[tIxR].matchCount < roundNumber) && (teams[tIxR].side == "R") && !priorSchoolIxs.contains(testSchoolIx)) {
//                                    print("    Team \(tIxR) is available")
//                                    
//                                    if teamIsEligibleInRun(run, side: "R", tIx: tIxR) {
//                                        print("     Team \(tIxR) is eligible in run \(run)")
//                                        
//                                        let iiScore = matchIIScore(tIxA, tRIx: tIxR)
//                                        print("       Team \(tIxR) iiScore = \(iiScore)")
//                                        if iiScore < 90 {
//                                            print("       Team \(tIxR) is a match")
//                                            
//                                            var thisMatch = Match()
//                                            thisMatch.teamsIx = [tIxA, tIxR]
//                                            thisMatch.needsII = (iiScore > 0)
//                                            let hA = teams[thisMatch.teamsIx[0]].hoursAhead
//                                            let hR = teams[thisMatch.teamsIx[1]].hoursAhead
//                                            let hM =  ((abs(hA) > abs(hR)) ? hA: hR)
//                                            thisMatch.hoursAhead = hM
//                                            teams[tIxA].matchCount += 1
//                                            teams[tIxR].matchCount += 1
//                                            
//                                            matches.append(thisMatch)
//                                            finishedR = true
//                                        }   //Team is II match for R
//                                    }       //Team is eligible for R
//                                }           //Team is available for R
//                                if !finishedR {
//                                    tIxR += 2
//                                    if tIxR >= teams.count {
//                                        tIxR = 1
//                                    }
//                                    if tIxR == startIx {
//                                        finishedR = true
//                                        //                                    print("Failed to match team \(tIxA)") //On to next teamA
//                                    }
//                                }
//                            }   //While !finishedR
//                        }   //Team considered for A
//                        tIxA += 2
//                    }   //While tIxA
//                    run += 1
//                }   //While run
//                roundNumber += 1
//            }   //While roundNumber
//        }
//    }
//    
//    func teamIsEligibleInRun(_ run: Int, side: String, tIx: Int ) -> Bool {
//        var el = false
//        let need = teamNeedsIIFrom(tIx)
//        let needy = (need.contains("E") || need.contains("F"))
//        
//        switch run {
//        case 1:
//            if needy {
//                el = true
//            }
//        case 2:
//            if ((side == "A") && needy) {
//                el = true
//            }
//        default:        // 3
//            el = true
//        }
//        return el
//    }
//    
//    func teamNeedsIIFrom(_ tIx: Int) -> [String] {
//        var sa: [String] = []
//        for ix in (0...1) {
//            let mn = mooters[teams[tIx].mooterIxs[ix]].needsIIFrom
//            if (((mn == "E") || (mn == "F")) && !sa.contains(mn)) {
//                sa.append(mn)
//            }
//        }
//        return sa
//    }
//    
//    func matchIIScore(_ tAIx: Int, tRIx: Int) -> Int {
//        //no match can have consecutive arguments with II (order is A1, A2, R1, R2
//        let demeritsImpossible = 97
//        let demeritsNoNeeds = 0
//        let demeritsNeeds = 3
//        
//        let langs: [String] = [mooters[teams[tAIx].mooterIxs[0]].language, mooters[teams[tAIx].mooterIxs[1]].language,
//                               mooters[teams[tRIx].mooterIxs[0]].language, mooters[teams[tRIx].mooterIxs[1]].language]
//        let needs: [String] = [mooters[teams[tAIx].mooterIxs[0]].needsIIFrom, mooters[teams[tAIx].mooterIxs[1]].needsIIFrom, mooters[teams[tRIx].mooterIxs[0]].needsIIFrom, mooters[teams[tRIx].mooterIxs[1]].needsIIFrom]
//        
//        if (!needs.contains("E") && !needs.contains("F")) {
//            return demeritsNoNeeds    //Neither team has need
//        }
//        
//        var argNeeds = [false, false, false, false]
//        var iiCount = 0
//        for rank in (0...3) {
//            if needs.contains(langs[rank]) {
//                argNeeds[rank] = true
//                iiCount += 1
//            }
//        }
//        for argIx in (0...2) {
//            if (argNeeds[argIx] && argNeeds[argIx + 1]) {
//                return demeritsImpossible        //Two successive args have need
//            }
//        }
//        return iiCount * demeritsNeeds      //Could be 0
//    }
//    
//    func listMatches() {
//        print("\n\(matches.count) MATCHES (Host is \(hostName) in time zone \(hostTimeZone))\n-----II---Ha----A------------------------R-----------------")
//        for mIx in (0..<matches.count) {
//            let sII = (matches[mIx].needsII ? "II":"--")
//            let tA = teams[matches[mIx].teamsIx[0]]
//            let tR = teams[matches[mIx].teamsIx[1]]
//            let snA = schools[mooters[tA.mooterIxs[0]].schoolIx].name
//            let snR = schools[mooters[tR.mooterIxs[0]].schoolIx].name
//            print("\(mIx).\t\(sII)\t\(matches[mIx].hoursAhead)\t\(snA) <> \(snR)")
//        }
//    }
//    
//    func makeSchedule() {
//        print("\nScheduling Matches ........")
//        
//        var totalDemerits = 0
//        var maxDemerits = 99
//        var attemptCount = 0
//        var scheduleCount = 0
//        
//        while ((maxDemerits > 10) && (attemptCount < 26)) {
//            scheduleCount = 0
//            while (scheduleCount < matchCount) {
//                attemptCount += 1
//                print("Scheduling attempt #\(attemptCount)")
//                maxDemerits = 0
//                totalDemerits = 0
//                
//                initializeSchedule()
//                
//                //Four runs: place demanding matches first
//                for run in (1...4) {
//                    
//                    let startMIx = Int(arc4random_uniform(UInt32(matchCount)))
//                    var mIx = startMIx
//                    var nextMIx = true
//                    while nextMIx {
//                        //Try this match in all available slots and pick the one with the lowest demerits
//                        var bestYetDemerits = 99
//                        var bestYetRoom = 99
//                        var bestYetSession = 99
//                        var perfect = false
//                        
//                        if matchIsEligibleForRun(run, match: matches[mIx]) {
//                            //                    print("Scheduling match \(mIx)")
//                            
//                            var rIx = 0        // Try all rooms
//                            while ((rIx < roomCount) && !perfect) {
//                                
//                                var sIx = 0            // Try all sessions
//                                while ((sIx < 6) && !perfect) {
//                                    
//                                    if schedule[rIx][sIx] > 90 {       //Not yet scheduled
//                                        //print("   Checking room \(rIx), session \(sIx)")
//                                        let dems = getDemerits(mIx, rIx: rIx, sIx:sIx)
//                                        if (dems < bestYetDemerits) {
//                                            bestYetDemerits = dems
//                                            bestYetRoom = rIx
//                                            bestYetSession = sIx
//                                            perfect = (dems == 0)
//                                            //let ps = (perfect ? "perfect":"best yet")
//                                            //print("      \(bestYetDemerits) demerits is \(ps)")
//                                        }
//                                    }
//                                    sIx += 1
//                                }
//                                rIx += 1
//                            }
//                            matches[mIx].roomNumber = bestYetRoom
//                            matches[mIx].sessionNumber = bestYetSession
//                            matches[mIx].demerits = bestYetDemerits
//                            schedule[bestYetRoom][bestYetSession] = mIx
//                            //                        let ds = (bestYetDemerits == 0 ? "": "  (\(bestYetDemerits) demerits)")
//                            //                        print("Match \(mIx) is scheduled in room \(bestYetRoom), session \(bestYetSession) \(ds)")
//                            totalDemerits += bestYetDemerits
//                            if (bestYetDemerits > maxDemerits) {
//                                maxDemerits = bestYetDemerits
//                            }
//                            scheduleCount += 1
//                        }
//                        mIx += 1
//                        if mIx == matchCount {
//                            mIx = 0
//                        }
//                        nextMIx = (mIx != startMIx)
//                    }
//                }
//            }
//        }
//        if attemptCount > 24 {
//            print("Scheduling failed after 25 attempts. Rerun matches and try again.")
//        } else {
//            print("\n>>>>>>>     Max demerits = \(maxDemerits).\n     Total demerits for schedule = \(totalDemerits).")
//        }
//    }
//    
//    func initializeSchedule() {
//        schedule = [[]]  //Outside array is rooms, inside is 6 sessions
//        //        Initaialize schdule
//        var session: [Int] = []
//        
//        for _ in (0..<6) {
//            session.append(99)
//        }
//        schedule[0] = session       //This works. See above
//        for _ in (1..<roomCount) {
//            schedule.append(session)
//        }
//        
//        for var m in matches {
//            m.roomNumber = 99
//            m.sessionNumber = 99
//            m.demerits = 0
//        }
//        
//        //Block number of empty cells
//        if emptyRoomCount > 0 {
//            var rIx = roomCount - 1
//            var sIx = 5
//            for _ in (0..<emptyRoomCount) {
//                schedule[rIx][sIx] = 98
//                rIx -= 1
//                if rIx < iiCount {
//                    rIx = roomCount - 1
//                    sIx -= 1
//                }
//            }
//        }
//    }
//    
//    func matchIsEligibleForRun(_ run: Int, match: Match) -> Bool {
//        var el = false
//        
//        switch run {
//        case 1:
//            el = match.needsII && (abs(match.hoursAhead) > 2)
//        case 2:
//            el = match.needsII && !(abs(match.hoursAhead) > 2)
//        case 3:
//            el = !match.needsII && (abs(match.hoursAhead) > 2)
//        default:        //4
//            el = !match.needsII && !(abs(match.hoursAhead) > 2)
//        }
//        return el
//    }
//
//    func getDemerits(_ mIx: Int, rIx: Int, sIx: Int) -> Int {
//        var demerits = 0
//        
//        demerits += getDemeritsII(mIx, rIx: rIx)
//        demerits += getDemeritsTimeZone(mIx, sIx: sIx)
//        demerits += getDemeritsTeamAdjacent(mIx, sIx: sIx)
//        demerits += getDemeritsTeamSameSession(mIx, sIx: sIx)
//        demerits += getDemeritsSchoolSameSession(mIx, sIx: sIx)
//        
//        return demerits
//    }
//
//    func getDemeritsII(_ mIx: Int, rIx: Int) -> Int {
//        if (matches[mIx].needsII && (rIx > iiCount)) {
//            return demeritsII
//        } else {
//            return 0
//        }
//    }
//    
//    func getDemeritsTimeZone(_ mIx: Int, sIx: Int) -> Int {
//        let hA = matches[mIx].hoursAhead
//        let daySessionNumber = sIx % 4
//        let day = Int(sIx/4)
//        var demerits = 0
//        
//        if (((hA == -3) && (daySessionNumber == 0)) || ((hA == 3) && (daySessionNumber == 3))) {
//            demerits = demeritsTimeZone[day]
//        } else if ((hA == -3) && daySessionNumber == 1) || ((hA == 3) && daySessionNumber == 2) {
//            demerits =  demeritsTimeZone[day] - 1
//        } else if ((hA == -2) && daySessionNumber == 0) || ((hA == 2) && daySessionNumber == 3) {
//            demerits =  demeritsTimeZone[day] - 1
//        }
//        return demerits
//    }
//
//    func getDemeritsSchoolSameSession(_ mIx: Int, sIx: Int) -> Int {
//        let tIxs = matches[mIx].teamsIx
//        var baseSchoolIxs: [Int] = []    //Array of the indices of the two schools
//        for ix in (0...1) {
//            baseSchoolIxs.append( mooters[teams[tIxs[ix]].mooterIxs[0]].schoolIx)
//        }
//        
//        var demerits = 0
//        for room in (0..<roomCount) {
//            let scheduledMatchIx = schedule[room][sIx]
//            if scheduledMatchIx < 90 {
//                let testTeamIxs = matches[scheduledMatchIx].teamsIx
//                var testSchoolIxs: [Int] = []    //Array of the indices of the two schools
//                for ix in (0...1) {
//                    testSchoolIxs.append(mooters[teams[testTeamIxs[ix]].mooterIxs[0]].schoolIx)
//                }
//                for bIx in (0...1) {
//                    for tIx in (0...1) {
//                        if testSchoolIxs.contains(baseSchoolIxs[bIx]){
//                            demerits += demeritsSchoolSameSession
//                            if bIx == tIx {
//                                demerits += demeritsTeamSameSession
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return demerits
//    }
//    
//    func getDemeritsTeamSameSession(_ mIx: Int, sIx: Int) -> Int {
//        let baseTeamsIx = matches[mIx].teamsIx
//        
//        var conflict = false
//        for room in (0..<roomCount) {
//            let testMatchIx = schedule[room][sIx]
//            if testMatchIx < 90 {
//                let testTeamsIx = matches[testMatchIx].teamsIx
//                for side in (0...1) {
//                    if testTeamsIx[side] == baseTeamsIx[side] {
//                        conflict = true
//                        break
//                    }
//                }
//            }
//        }
//        return (conflict ? demeritsTeamSameSession:0)
//    }
//    
//    func getDemeritsTeamAdjacent(_ mIx: Int, sIx: Int) -> Int {
//        let baseTeamsIx = matches[mIx].teamsIx
//        
//        //Check only pertinent sessions
//        var sessionsToCheck: [Int] = []
//        if ((sIx != 0) && (sIx != 4)) {
//            sessionsToCheck.append(sIx - 1)
//        }
//        if ((sIx != 3) && (sIx != 5)) {
//            sessionsToCheck.append(sIx + 1)
//        }
//        
//        var conflict = false
//        for sessionIx in sessionsToCheck {
//            for room in (0..<roomCount) {
//                let testMatchIx = schedule[room][sessionIx]
//                if testMatchIx < 90 {
//                    let testTeamsIx = matches[testMatchIx].teamsIx
//                    for side in (0...1) {
//                        if testTeamsIx[side] == baseTeamsIx[side] {
//                            conflict = true
//                            break
//                        }
//                    }
//                }
//            }
//        }
//        return (conflict ? demeritsTeamAdjacent:0)
//    }
//    
//    func showSchedule() {
//        print("\nSCHEDULE\n###########################")
//        
//        switch segFormat.selectedSegmentIndex {
//        case 0:
//            //Show grid
//            //print("\n\nSchedule grid\n-----------------")
//            for session in (0...5) {
//                var s = ""
//                for room in (0..<roomCount) {
//                    let mIx = schedule[room][session]
//                    let theMatch = matches[mIx]
//                    let teamIxs = theMatch.teamsIx
//                    for ix in (0...1) {
//                        let schoolName = schools[mooters[teams[teamIxs[ix]].mooterIxs[0]].schoolIx].name
//                        // Access the string by the range.
//                        let r = schoolName.startIndex..<schoolName.characters.index(schoolName.startIndex, offsetBy: 3)
//                        let codeName = schoolName[r]
//                        let ii = (theMatch.needsII ? "*":" ")
//                        if ix == 0 {
//                            s = s + "\t\t" + codeName
//                        } else {
//                            s = s + " <\(ii)> " + codeName
//                        }
//                    }
//                    s = s + " \(theMatch.demerits)"
//                }
//                print(s)
//                if session == 1 {
//                    print("\t\t------------------------------------------------------")
//                } else if session == 3 {
//                    print("\t\t======================================================")
//                }
//            }
//        case 1:     //Short
//            for day in (0...1) {
//                print("\nDAY \(day)\n================================")
//                let sessionCount = (day == 0 ? 4:2)
//                for room in (0..<roomCount) {
//                    print("\n  Room \(room)\n  ---------------------")
//                    for session in (0..<sessionCount) {
//                        let sessionIx = (day * 4) + session
//                        let mIx = schedule[room][sessionIx]
//                        var ii = ""
//                        var ms = ""
//                        if (mIx > 90) {
//                            ii = ""
//                            ms = ""
//                        } else {
//                            ii = (matches[mIx].needsII ? "II  ":"    ")
//                            ms = "(Match \(mIx))"
//                        }
//                        print("\n    Session \(session) \(ms)\n    ---------------------")
//                        if mIx > 90 {
//                            print("      Unscheduled")
//                        } else {
//                            let teamIxs = matches[schedule[room][sessionIx]].teamsIx
//                            var schoolNames: [String] = []
//                            for ix in (0...1) {
//                                schoolNames.append(schools[mooters[teams[teamIxs[ix]].mooterIxs[0]].schoolIx].name)
//                            }
//                            print("      \(ii)\(schoolNames[0]) <> \(schoolNames[1])")
//                        }
//                    }
//                }
//            }
//        default:        //3 = Complete format
//            for day in (0...1) {
//                print("\nDAY \(day)\n================================")
//                let sessionCount = (day == 0 ? 4:2)
//                for session in (0..<sessionCount) {
//                    
//                    var lines:[String] = [] //6 lines of printing for each session
//                    for _ in (0...5) {
//                        lines.append("")
//                    }
//                    
//                    for room in (0..<roomCount) {
//                        //Each room adds on to the lines
//                        let sessionIx = (day * 4) + session
//                        let matchIx = schedule[room][sessionIx]
//                        var tIxs: [Int] = []
//                        for t in (0...1) {
//                            tIxs.append(matches[matchIx].teamsIx[t])
//                        }
//                        
//                        var mtrs: [[AMooter]] = [[]]
//                        for tm in (0...1) {
//                            let theTeam = teams[tIxs[tm]]
//                            var tMtrs: [AMooter] = []
//                            for rk in (0...1) {
//                                let theMooter = mooters[theTeam.mooterIxs[rk]]
//                                tMtrs.append(theMooter)
//                            }
//                            if tm == 0 {
//                                mtrs[0] = tMtrs
//                            } else {
//                                mtrs.append(tMtrs)
//                            }
//                        }
//                        
//                        var schoolNames: [String] = []
//                        for tIx in (0...1) {
//                            let theName = schools[mtrs[tIx][0].schoolIx].name
//                            schoolNames.append(theName)
//                        }
//                        
//                        lines[0] += "\t\t" + schoolNames[0]
//                        lines[1] += "\t\t  <> " + schoolNames[1]
//                     }
//                    print("\n  \(lines[0])\n      \(lines[1])")
//                }
//            }
//        }
//    }
//    
//
//    // MARK: Picker view datasource
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return schools.count
//        }
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 25.0
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 300.0
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        
//        var pickerLabel = view as? UILabel
//        
//        if (pickerLabel == nil) {
//            pickerLabel = UILabel()
//            pickerLabel?.font = UIFont(name: "System", size: 12)
//            pickerLabel?.textAlignment = NSTextAlignment.left
//        }
//        let pName = schools[row].name
//        pickerLabel?.text = pName
//        
//        return pickerLabel!
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        hostName = schools[row].name
//        hostProvince = schools[row].province
//        hostTimeZone = provinceTimeZones[hostProvince]!
//        print("Row: \(row): \(hostName), \(hostProvince) - time zone \(hostTimeZone)")
//        
//        btnMakeTeams.isEnabled = true
//    }
//    
//
//}

