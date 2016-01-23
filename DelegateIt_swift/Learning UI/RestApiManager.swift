//
//  RestAPI.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON
import Socket_IO_Client_Swift
import CWStatusBarNotification


class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    let notification = CWStatusBarNotification()
    
    //var localTestServerURL:String = "http://192.168.99.100:8000"
    //var testServerURL:String = "http://test-gator-api.elasticbeanstalk.com"
    
    //Change URL FOR Testing
    //var RESTURL:String = localTestServerURL
    
    
    func loginUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String) {
        // Setup the session to make REST POST call
        print("logging in")
        let postEndpoint: String = "http://192.168.99.100:8000/core/login/customer"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
    
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Read the JSON
            do {
                print("---A---")
                print(data)
                if(data == nil){
                    print("Error")
                }
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print("-----")
                    let json = JSON(jsonDictionary)
                    let result = json["result"].stringValue
                    print(json)
                    
                    
                    // Parse the JSON to get the IP
                    //let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //let result = jsonDictionary["result"] as! Int
                    
                    //print(jsonDictionary)
                    
                    print(json["result"].stringValue)
                    print(json["customer"]["uuid"].stringValue)
                    print(first_name)
                    print(last_name)
                    
                    if(result == "0"){
                        print("User is ballin")
                        //var getUUID:[NSString] = output
                        //print(getUUID)
                        
                        print("-----A------")
                        
                        let uuidTotal = json["customer"]["uuid"].stringValue  //jsonDictionary['uuid'] as! String
                        print(uuidTotal)
                        let token = json["token"].stringValue //jsonDictionary["token"] as! String
                        print(token)
                        self.getUser(uuidTotal, token: token) //CHANGE
                        mainInstance.setToken(token)
                        //save data (token)
                        
                    }
                    else if(result == "10"){
                        print("User is not created")
                        self.createUser(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email)
                    }
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
        
        
        
        
        // Make the POST call and handle it in a completion handler
        /*
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
        
            //let output = NSString(data:data!, encoding: NSUTF8StringEncoding)
            print("-----")
            print(data)
            
        // Read the JSO
            
        let json = JSON(postParams)
        let result = json["result"].intValue
        print(json["uuid"].stringValue)
        print("-------")
            
            
        // Print what we got from the call
        // Parse the JSON to get the IP
        //let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        //let result = jsonDictionary["result"] as! Int
            
        if(result == 0){
            print("User is ballin")
            //var getUUID:[NSString] = output
            //print(getUUID)
                
            let uuidTotal = json["uuid"].stringValue  //jsonDictionary['uuid'] as! String
            //print(uuidTotal)
            let token = json["result"].stringValue //jsonDictionary["token"] as! String
            //self.getUser(uuidTotal, token: token) //CHANGE
            //mainInstance.setToken(token)
            //save data (token)
                
        }
        else if(result == 10){
            print("User is not created")
            self.createUser(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email)
            }
        print("Got data")
        //Result 10 means to create a new user
        //Result 0 is good
        }).resume()
        */
    }
    
    func createUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String) {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://192.168.99.100:8000" + "/core/customer"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        //Actual User
        let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken,"first_name":first_name,"last_name":last_name,"email":email,"phone_number":"15555555551"]
        
        
        //Test User
        //let postParams : [String: String] = ["fbuser_id":"123413948026148","fbuser_token":"CAANG1yne7NcBAFWZCQ1YMudJZBQeOLMaY8YQ28aQrYfPksmXSCFIavQ0vjRbywpqtioW6zvkJX57PFKimGHnOCuu3BD9yXCQTogfYHcGR3qvg8bpCxYodKkZAB4hnQ0m8scmmeHl4qSym9AGZBxo3jVKTuH7c9JXcrnXJ3FobVZBhab0tVnt4H3kTBNip51o1tOY3IOZChSOATsRGQcsqU","first_name":first_name,"last_name":last_name,"email":email,"phone_number":"1111111111"]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("User created")
                        self.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email)
                    }
                    else if(result == 2){
                        print("User alread exists")
                    }
                    
                    print("Got data")
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
        }).resume()
    }
    
    
    
    func getUser(uuid:String,token:String) {
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        print(uuid)
        print(token)
        let postEndpoint: String = "http://192.168.99.100:8000/core/customer/" + uuid + "?token=" + token
        print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print("-----")
                    let json = JSON(jsonDictionary)
                    let result = json["result"].stringValue
                    print(json)
                
                    let first_name = json["customer"]["first_name"].stringValue
                    var email = ""
                    if(json["customer"]["email"] != nil){
                        email = json["customer"]["email"].stringValue
                    }
                    
                    let last_name = json["customer"]["last_name"].stringValue
                    let phone_number = json["customer"]["phone_number"].stringValue
                    let uuid = json["customer"]["uuid"].stringValue
                    var active_transaction_uuids = json["customer"]["active_transaction_uuids"].arrayValue.map { $0.string!}
                    print(active_transaction_uuids)
                    //let active_transaction_uuids = ["Hello"]
                    let activeCount = active_transaction_uuids.count
                    
                    
                    mainInstance.setValues(first_name,last_name:last_name,uuid:uuid,active_transaction_uuids:active_transaction_uuids,activeCount:activeCount,email:email,phone_number:phone_number)
                    
                    var index:Int
                    
                    for index = 0; index < active_transaction_uuids.count; index++ {
                        self.getTransaction(active_transaction_uuids[index], token: mainInstance.token)
                    }
                    self.startSockets()
                    

                    
                    
                    
                    
                    print("Got data")
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    

    func createTransaction(uuid:String,token:String,newMessage:String) -> String {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/transaction?token=" + token
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        var result:Int = -1
        var transactionUUID:String = ""
        
        //Actual User
        let postParams : [String: String] = ["customer_uuid":uuid,"customer_platform_type":"ios"]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("Transaction created")
                        transactionUUID = jsonDictionary["uuid"] as! String
                        print(transactionUUID)
                        self.sendMessage(transactionUUID,token: mainInstance.token,message: newMessage)
                    }
                    print("Got data")
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
        
        if(result == 0){
            return transactionUUID
        }
        return ""
    }
    
    
    func getTransaction(transactionUUID:String,token:String) {
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        print(token)
        let postEndpoint: String = "http://192.168.99.100:8000/core/transaction/" + transactionUUID + "?token=" + token
        print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print("-----")
                    let json = JSON(jsonDictionary)
                    let result = json["result"].stringValue
                    print(json)
                    print("Got data")
                    
                    print("--------")
                    
                    
                    mainInstance.active_transaction_uuids2.append(transaction(dataInput: json))
                    
                    
                    print("--------")
                
                    
                    
                    
                    //print(mainInstance.active_transaction_uuids2[0].first_name)
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    
    func sendMessage(transactionUUID:String,token:String,message:String) -> Int {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/send_message/" + transactionUUID + "?token=" + token
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        var result:Int = -1
        
        //Actual User
        let postParams : [String: String] = ["type":"text","content":message,"from_customer":"true"]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("Message Sent")
                        mainInstance.addMessage()
                        let nextMessage:String = mainInstance.getMessages()
                        if(nextMessage != ""){
                            self.sendMessage(mainInstance.currentTransaction.transactionUUID,token: mainInstance.token,message: nextMessage)
                        }
                    }
                    print("Got data")
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
        
        if(result == 0){
            return 1
        }
        return 0
    }
    
    func updateUser(userProfileUpdate:String,updatedInformation:String) {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/customer/" + mainInstance.uuid + "?token=" + mainInstance.token
        print(postEndpoint)
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        var result:Int = -1
        
        var updatedType = "email"
        
        if(userProfileUpdate == "FIRST NAME"){
            updatedType = "first_name"
        }else if(userProfileUpdate == "LAST NAME"){
            updatedType = "last_name"
        }
        
        //Actual User
        let postParams : [String: String] = [updatedType:updatedInformation]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("Message Sent")
                    }
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
    }
    
    
    func startSockets() {
        let socket = SocketIOClient(socketURL: "http://test-gator-api.elasticbeanstalk.com:8060", options: [.Log(false), .ForcePolling(false)])
        
        socket.on("connect") {data, ack in
            print("socket connected")
            var index = 0
            for index = 0; index < mainInstance.active_transaction_uuids.count; index++ {
                socket.on(mainInstance.active_transaction_uuids[index]) {data, ack in
                    let json = JSON(data)
                    var messageContent = json[0]["messages"][json[0]["messages"].count - 1]["content"]
                    print(json[0]["uuid"].stringValue)
                    print(messageContent)
                    
                    mainInstance.active_transaction_uuids2[mainInstance.getIndex(json[0]["uuid"].stringValue)] = transaction(dataInput: json)
                    
                    print("----")
                    print(json[0]["uuid"].stringValue)
                    print(mainInstance.active_transaction_uuids2[mainInstance.getIndex(json[0]["uuid"].stringValue)].lastMessage)
                    
                    //self.notification.notificationStyle = .NavigationBarNotification
                    
                    self.notification.notificationTappedBlock = {
                        print("notification tapped")
                        // more code here
                    }
                    self.notification.notificationLabelBackgroundColor = UIColor.blueColor()
                    self.notification.displayNotificationWithMessage("NEW MESSAGE: \(messageContent)", completion: nil)
                }
                socket.emit("register_transaction", ["transaction_uuid": mainInstance.active_transaction_uuids[index]])
            }
        }
        socket.connect()
    }
    
    
    func plusOne() -> Int{
        return 1
    }
    
}