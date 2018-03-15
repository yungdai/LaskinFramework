//
//  HTTPManager.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-09-26.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public protocol HTTPDelegate: class {
    //func getJSONFromUrl(_ url: URL) -> Bool
    var gotData: Bool { get set }
    var failedLoading: Bool { get set }
    var dataTask: URLSessionTask { get set }
    var jsonData: Payload? { get set }
}


// enum to handle responses from the HTTP requests
public enum Response {
    
    case httpResponse(statusCode: Int)
    case networkError(Int)
}


public class HTTPManager: NSObject {
    
    public weak var delegate: HTTPDelegate?
    public let defaultSession = URLSession(configuration: .default)
    
    // typealising Payload makes it easier to remember than [String: AnyObjecti]
    public var isLoading = false
    
    // optional: You can turn this class into a shared instance to store the JSON data to retrive it directly from his object.
    //     static let sharedInstace = HTTPManager()
    
    // load the JSON Parser process the calls into a JSON Object that's is a Payload object
    public let jsonParser = JSONParser()
    
    public var jsonData: Payload?
    public var isLoggedIntoWordPress: Bool = false
//
//        {
//        didSet{
//            if isLoggedIntoWordPress {
//
//            }
//        }
//    }
    public var gotFormidableData: Bool = false {
        didSet {
            
            if gotFormidableData {
                
                self.delegate?.dataTask.cancel()
            }
        }
    }
    
    
    public func completeSecondaryConnection(_ url: URL, with session: URLSession ) -> Bool {
        
        self.delegate?.dataTask =  defaultSession.dataTask(with: url, completionHandler:  {
            
            // ensure there is no retained self
            [unowned self]
            
            // complete handler required variables
            data, response, error in
            
            // respond to errors
            let resp = self.processResponse(HandlerResponse(response, error))
            
            // easier to read way of processing the resposes as a case
            switch (resp) {
            case .httpResponse(statusCode: 200):
                print("Successfully got reponse back from the Laskin Formidable API")
                
                if let data = data,
                    let jsonDictionary = self.jsonParser.parseJSON(json: data) {
                    
                    self.jsonData = jsonDictionary
                    // make sure that the code run on the self.gotData listener is run on the mainqueue and not this thread for the URLSession
                    DispatchQueue.main.async {
                        self.delegate?.jsonData = jsonDictionary
                        self.delegate?.gotData = true
                        return self.gotFormidableData = true
                    }
                }
                break
            case .networkError(-999):
                print("Failure! \(String(describing: error))")
                // responding to the the failure
                DispatchQueue.main.async {
                    
                    self.delegate?.failedLoading = true
                }
                break
            default:
                break
            }
            
        })
        
        // keep the dataTask going
        self.delegate?.dataTask.resume()
        
        // stop the task if it fails
        if (self.delegate?.failedLoading)! || (self.gotFormidableData == true) {
            self.delegate?.dataTask.cancel()
        }
        
        // keep making calls until you've either gotten data or you cannot run http calls anymore.  You might want to put a counter to how many times you can make this call.
        return self.gotFormidableData
    }
    
    
    public func getDataFromLaskinWebsite(url: URL, laskinURL: URL) -> Bool {
        
        // set up the URLSession.sahred thread to session
        let session = URLSession.shared
        
        self.delegate?.dataTask =  defaultSession.dataTask(with: url, completionHandler:  {
            
            // ensure there is no retained self
            [unowned self]
            
            // complete handler required variables
            data, response, error in
            
            // respond to errors
            let resp = self.processResponse(HandlerResponse(response, error))
            
            // easier to read way of processing the resposes as a case
            switch (resp) {
            case .httpResponse(statusCode: 200):
                print("Successfully got reponse back from the HTTP Server")
                
                // report that you got a connection to the wordpress site
                DispatchQueue.main.async {
                    
                    self.isLoggedIntoWordPress = true
                //self.delegate?.gotData =
                
//                     self.completeSecondaryConnection(laskinURL, with: session)
                    
                 }
                break
            case .networkError(-999):
                print("Failure! \(String(describing: error))")
                // responding to the the failure
                DispatchQueue.main.async {
                    
                    self.delegate?.failedLoading = true
                }
                break
            default:
                break
            }
            
        })
        
        // keep the dataTask going
        self.delegate?.dataTask.resume()
        
        // stop the task if it fails
        if (self.delegate?.failedLoading)! {
            self.delegate?.dataTask.cancel()
        }
        
        // keep making calls until you've either gotten data or you cannot run http calls anymore.  You might want to put a counter to how many times you can make this call.
        return (self.delegate?.gotData)!
        
    }
    
    
    
    public func processResponse(_ handlerResponse: HandlerResponse) -> Response  {
        
        var resp: Response = .httpResponse(statusCode: 0)
        
        let error = handlerResponse.error
        let response = handlerResponse.response
        
        
        if let error = error as NSError?, error.code == -999 {
            resp = .networkError(error.code)
            
        } else if let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 {
            
            resp = .httpResponse(statusCode: httpResponse.statusCode)
        } else {
            
            // if there is a failure in the response you will want to make sure that you are able to send failure call to run calls to shut down the queue and other possible running calls
            print("Failure! \(String(describing: response))")
            
            DispatchQueue.main.async {
                self.delegate?.failedLoading = true
            }
        }
        
        return resp
    }
    
    public func getJSONFromUrl(url: URL) -> Bool {
        
        // set up the URLSession.sahred thread to session
        let session = URLSession.shared
        
        self.delegate?.dataTask =  session.dataTask(with: url, completionHandler:  {
            
            // ensure there is no retained self
            [unowned self]
            
            // complete handler required variables
            data, response, error in
            
            // respond to errors
            let resp = self.processResponse(HandlerResponse(response, error))
            
            // easier to read way of processing the resposes as a case
            switch resp {
            case .httpResponse(statusCode: 200):
                print("Successfully got reponse back from the HTTP Server")
                
                // take the data and use the JSON Parser to copy the jsonDictionary into the jsonData variable
                if let data = data,
                    let jsonDictionary = self.jsonParser.parseJSON(json: data) {
                    
                    self.jsonData = jsonDictionary
                    
                    // make sure that the code run on the self.gotData listener is run on the mainqueue and not this thread for the URLSession
                    DispatchQueue.main.async {
                        
                        self.delegate?.gotData = true
                        self.delegate?.dataTask.cancel()
                    }
                }
                break
            case .networkError(-999):
                print("Failure! \(String(describing: error))")
                // responding to the the failure
                DispatchQueue.main.async {
                    
                    self.delegate?.failedLoading = true
                }
                
                break
            default:
                break
            }
            
        })
        
        // keep the dataTask going
        self.delegate?.dataTask.resume()
        
        // stop the task if it fails
        if (self.delegate?.failedLoading)! {
            self.delegate?.dataTask.cancel()
        }
        
        // keep making calls until you've either gotten data or you cannot run http calls anymore.  You might want to put a counter to how many times you can make this call.
        return (self.delegate?.gotData)!
        
    }
}

//// adding data sessions delegate functions so I can catch and make new sessions better.
//
//extension HTTPManager: NSURLConnectionDataDelegate, URLSessionDataDelegate {
//
//
//}

