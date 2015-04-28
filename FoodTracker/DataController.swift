//
//  DataController.swift
//  FoodTracker
//
//  Created by Mike Neirinck on 28/04/15.
//  Copyright (c) 2015 mike.neirinck. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
/*
    class func jsonAsUSDAIdAndNameSearchResults (json: NSDictionary) -> [(name: String, idValue: String)] {
        
        var usdaItemsSearchResults: [(name: String, idValue: String)] = []
        var searchResult: (name: String, idValue: String)
        
        if json["hits"] != nil {
            let results: [AnyObject] = json["hits"]! as [AnyObject]
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    let idValue:String = itemDictionary["_id"]! as String
                    if itemDictionary["fields"] != nil {
                        let fieldsDictionary: NSDictionary = itemDictionary["fields"]! as NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            let name: String = fieldsDictionary["item_name"]! as String
                            searchResult = (name: name, idValue: idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        return usdaItemsSearchResults
    }
*/
    func saveUSDAItemForId(idValue: String, json: NSDictionary) {
        
        if json["hits"] != nil {
            let results: [AnyObject] = json["hits"] as [AnyObject]
            for itemDictionary in results {
                
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue {
                
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    let itemDictionaryId: String = itemDictionary["_id"]! as String
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    requestForUSDAItem.predicate = predicate
                    var error: NSError?
                    var items = managedObjectContext.executeFetchRequest(requestForUSDAItem, error: &error)
                    
                    if items?.count != 0 {
                        // The item is already saved
                        return
                    } else {
                        println("Let's save this to CoreData!")
                        
                        let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext)
                        var usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                        usdaItem.idValue = itemDictionary["_id"]! as String
                    }
                }
            }
        }
    }
    

       
   
    class func jsonAsUSDAIdAndNameSearchResults (json: NSDictionary) -> [(name: String, idValue: String)] {
        
        var usdaItemsSearchResults: [(name: String, idValue: String)] = []
        var searchResult: (name: String, idValue: String)
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            for itemDictionary in results {
                let fields: NSDictionary = (itemDictionary["_id"]? as NSDictionary)["_fields"]? as NSDictionary
                let name:String? = fields["item_name"] as? String
                let idValue:String? = itemDictionary["_id"]? as? String
                if (name? != nil && idValue? != nil) {
                    searchResult = (name: name!, idValue: idValue!)
                    usdaItemsSearchResults += [searchResult]
                }
            }
        }
        return usdaItemsSearchResults
    }


}
