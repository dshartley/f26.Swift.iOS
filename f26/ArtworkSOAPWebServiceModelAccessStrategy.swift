//
//  ArtworkSOAPWebServiceModelAccessStrategy.swift
//  f26
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSerialization
import SFNet
import f26Model

/// A strategy for accessing the Artwork model data using SOAP Web Services
public class ArtworkSOAPWebServiceModelAccessStrategy: ModelAccessStrategyBase {
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: "Artworks")
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func getProcessResponse(oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) -> ((NSMutableData?, Error?) -> Void) {
		
		// Create completion handler
		let processResponse: ((NSMutableData?, Error?) -> Void) =
		{
			(mutableData, error) -> Void in
			
			if (mutableData != nil) {
				
				// Get XML String
				let s:		NSString?		= NSString(data: mutableData! as Data, encoding: String.Encoding.utf8.rawValue)
				
				// Get data as JSON Dictionary
				let data:	[String:Any]?	= JSONHelper.xmlToJSON(xmlString: s! as String)

				// Call completion handler
				completionHandler(data, nil)
				
			} else if error != nil {
				
				// Call completion handler
				completionHandler(nil, error)
			}
		}
		
		return processResponse
	}
	
	fileprivate func processWebServiceResponse(soapResponse: [String:Any]) -> [Any]? {
		
		var returnData: [Any] = [Any]()
		
		// Get the data string
		let envelope:	[String:Any]?	= soapResponse["soap:Envelope"] as? [String:Any]
		let body:		[String:Any]?	= envelope?["soap:Body"] as? [String:Any]
		let response:	[String:Any]?	= body?["LoadArtWorksByPreviousArtworkIDResponse"] as? [String:Any]
		let result:		[String:Any]?	= response?["LoadArtWorksByPreviousArtworkIDResult"] as? [String:Any]
		let dataString:	String?			= result?["text"] as? String
		
		// Check dataString not nil
		guard (dataString != nil) else {
			
			return nil
		}
		
		// Convert the data string to JSON dictionary
		let dataJSON:	[String:Any]?	= JSONHelper.stringToJSON(jsonString: dataString!) as? [String:Any]
		
		// Create model items
		let items:		[Any]?			= dataJSON!["Items"] as? [Any]
		
		// Go through each item
		for (_, item) in items!.enumerated() {
			
			let item = item as! [String:Any]
			
			// Create the data item
			var dataItem				= [String: Any]()
			
			// Get the id
			let id:				Int		= item["ID"] as! Int
			dataItem["ID"] = String(id)
			
			
			// Get the parameters
			let parameters:		[Any]?	= item["Params"] as? [Any]
			
			// Go through each parameter
			for (_, parameter) in parameters!.enumerated() {
				
				let parameter = parameter as! [String:Any]
				
				// Get key
				let key:		String	= parameter["Key"] as! String
				
				// Get value
				let value:		String	= parameter["Value"] as! String
				
				
				// Put the property in the item
				dataItem[key.lowercased()] = value
			}
			
			// Add the item to the array
			returnData.append(dataItem)
			
		}
		
		return returnData
	}
	
	
	// MARK: - Dummy Data Methods
	
	public func selectDummy(byPreviousArtworkID id: Int, category: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		var returnData		= [Any]()
		
		let soapResponse	= NSLocalizedString("text", tableName: "ArtworksDummySOAPResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]?	= JSONHelper.stringToJSON(jsonString: soapResponse) as? [String:Any]
		
		returnData			= self.processWebServiceResponse(soapResponse: data!)!
		
		var collection		= collection
		
		// Fill the collection with the loaded data
		collection = self.fillCollection(collection: collection, data: returnData)!
		
		
		// Get the correct number of items from the collection
		returnData = self.doSelectDummyArtworksFromCollection(byPreviousArtworkID: id, numberofItemsToLoad: numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, collection: collection)
		
		// Refill the collection with the filtered data
		collection.clear()
		collection = self.fillCollection(collection: collection, data: returnData)!
		
		// Call the completion handler
		completionHandler(returnData, collection, nil)
		
	}
	
	public func doSelectDummyArtworksFromCollection(byPreviousArtworkID: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection) -> [Any] {
		
		var result: [Any] = [Any]()
		
		// Find the item
		var itemFoundIndex: Int		= 0
		var isFoundYN:		Bool	= false
		
		// Check byPreviousArtworkID is specified
		if (byPreviousArtworkID > 0) {
			
			var item:		Artwork?	= nil
			
			// Go through each item until isFoundYN
			while (!isFoundYN && itemFoundIndex <= collection.items!.count - 1) {
				
				item = (collection.items![itemFoundIndex] as! Artwork)
				
				// Check item id
				if (item!.id == String(byPreviousArtworkID)) {
					
					isFoundYN = true
					
				} else {
					
					itemFoundIndex += 1
				}
			}
			
			// Check isFoundYN
			if (!isFoundYN) { return result }
		}
		
		var itemsToAdd:		Int			= numberofItemsToLoad
		var item:			Artwork?	= nil
		var itemData:		Any?		= nil
		
		var itemIndex:		Int			= 0
		
		// Check if item found
		if (isFoundYN) {
			
			// Set item index to item before or after the found item
			if (selectItemsAfterPreviousYN) {
				
				itemIndex = itemFoundIndex + 1
				
			} else {
				
				itemIndex = itemFoundIndex - 1
			}
		}
		
		while (itemsToAdd > 0 && itemIndex >= 0 && itemIndex <= collection.items!.count - 1) {
			
			// Get the item
			item		= (collection.items![itemIndex] as! Artwork)
			
			// Get itemData
			itemData	= item?.dataNode! as Any
			
			if (selectItemsAfterPreviousYN) {
				
				// Append to data
				result.append(itemData!)
				
				itemIndex += 1
				
			} else {
				
				// Prepend to data
				result.insert(itemData!, at: 0)
				
				itemIndex -= 1
			}
			
			itemsToAdd -= 1
		}
		
		return result
	}
	
}

// MARK: - Extension ProtocolArtworkModelAccessStrategy

extension ArtworkSOAPWebServiceModelAccessStrategy: ProtocolArtworkModelAccessStrategy {
	
	// MARK: - Public Methods
	
	public func select(byCategory category: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Not required
	}
	
	public func select(byCategory category: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
	
		// Not required
	}

	public func select(byPreviousArtworkID id: Int, category: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// DEBUG: 
//		self.selectDummy(byPreviousArtworkID: id, category: category, year: year, numberofItemsToLoad: numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, collection: collection, oncomplete: completionHandler)
//
//		return
		
		//////////
		
		
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, Error?) -> Void) =
		{
			(response, error) -> Void in
			
			var data: [Any]? 	= nil
			var collection 		= collection
			
			// Check response not nil
			if (response != nil) {

				// Process the response data
				data = self.processWebServiceResponse(soapResponse: response!)

				if (data != nil) {

					// Fill the collection with the loaded data
					collection = self.fillCollection(collection: collection, data: data!)!
				}
			}

			// Call the completion handler
			completionHandler(data, collection, error)
		}
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, Error?) -> Void) = getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create webServiceHelper
		let webServiceHelper:		WebServiceHelper = WebServiceHelper(processResponse: processResponse, mode: WebServiceHelperMode.CompletionHandler)
		
		// Get the Url
		let urlString: 				String = NSLocalizedString("loadArtworksSOAPUrl", tableName: "SOAPRequestConfig", comment: "")
		
		// Setup the SOAP message
		let soapMessageTemplate: 	String = NSLocalizedString("loadArtworksSOAPRequest", tableName: "SOAPRequestConfig", comment: "")
		let soapMessage: 			String = String(format: soapMessageTemplate, String(BoolHelper.toInt(value: selectItemsAfterPreviousYN)),
			String(id),
			String(category),
			String(year),
			String(numberofItemsToLoad))
		
		// Call web service
		webServiceHelper.call(urlString: urlString, soapMessage: soapMessage)
		
	}
	
	public func getYearsByCategory(category: Int, oncomplete completionHandler:@escaping ([Int]?, Error?) -> Void) {
		
		// TODO:
	}
	
	public func addLike(id: Int) {
		
		// Create processResponse
		let processResponse: ((NSMutableData?, Error?) -> Void) =
		{
			(mutableData, error) -> Void in
			
			// Not required
		}
		
		// Create webServiceHelper
		let webServiceHelper:	WebServiceHelper = WebServiceHelper(processResponse: processResponse, mode: WebServiceHelperMode.CompletionHandler)
		
		// Get the Url
		let urlString: 				String = NSLocalizedString("addLikeSOAPUrl", tableName: "SOAPRequestConfig", comment: "")
		
		// Setup the SOAP message
		let soapMessageTemplate: 	String = NSLocalizedString("addLikeSOAPRequest", tableName: "SOAPRequestConfig", comment: "")
		let soapMessage: 			String = String(format: soapMessageTemplate, String(id))
		
		// Call web service
		webServiceHelper.call(urlString: urlString, soapMessage: soapMessage)
		
	}

	public func selectSlideShowArtworks(byID id: Int, preloadPreviousYN: Bool, preloadNextYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// TODO:
	}

	public func selectSlideShowArtworkNext(byID id: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// TODO:
	}

	public func selectSlideShowArtworkPrevious(byID id: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// TODO:
	}
	
}
