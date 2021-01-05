//
//  NewsSnippetRESTWebAPIModelAccessStrategy.swift
//  f26
//
//  Created by David on 03/02/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import SFCore
import SFModel
import SFSocial
import SFSerialization
import SFNet
import f26Core
import f26Model

/// A strategy for accessing the NewsSnippet model data using a REST Web API
public class NewsSnippetRESTWebAPIModelAccessStrategy: RESTWebAPIModelAccessStrategyBase {

	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(connectionString: String,
						 storageDateFormatter: DateFormatter) {
		super.init(connectionString: connectionString,
				   storageDateFormatter: storageDateFormatter,
				   tableName: "NewsSnippets")
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func runQuery(byCategory category: ArtworkCategoryTypes, year: Int, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		#if DEBUG
			
			if (ApplicationFlags.flag(key: "LoadNewsSnippetsDummyDataYN")) {
				
				self.selectDummy(byCategory: category, year: year, into: collection, oncomplete: completionHandler)
				
				return
				
			}

		#endif
			
		// Create processResponse completion handler
		let processResponseCompletionHandler: (([String:Any]?, URLResponse?, Error?) -> Void) =
		{
			(data, response, error) -> Void in	// [weak self]
			
			// Call the completion handler
			completionHandler(data, error)
		}
		
		// Create processResponse
		let processResponse: 		((NSMutableData?, URLResponse?, Error?) -> Void) = self.getProcessResponse(oncomplete: processResponseCompletionHandler)
		
		// Create restApiHelper
		let restApiHelper: 			RESTApiHelper = RESTApiHelper(processResponse: processResponse, mode: RESTApiHelperMode.CompletionHandler)

		// Get the Url
		var urlString: 				String = NSLocalizedString("NewsSnippetsSelectByCategoryYearUrl", tableName: "RESTWebAPIConfig", comment: "")
		urlString 					= String(format: urlString, String(category.rawValue), String(year))
		
		// Call the REST Api
		restApiHelper.call(urlString: urlString, httpMethod: .GET, data: nil)
		
	}

	
	// MARK: - Override Methods
	

	// MARK: - Dummy Data Methods
	
	fileprivate func selectDummy(byCategory category: ArtworkCategoryTypes, year: Int, into collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, Error?) -> Void) {
		
		let responseString	= NSLocalizedString("byCategoryYear", tableName: "NewsSnippetsDummyRESTWebAPIResponse", comment: "")
		
		// Convert the response to JSON dictionary
		let data:			[String:Any]? = JSONHelper.stringToJSON(jsonString: responseString) as? [String:Any]
		
		// Process the data
		let returnData:		[String:Any]? = self.processRESTWebAPIResponse(responseData: data!)
		
		// Call the completion handler
		completionHandler(returnData, nil)
		
	}

}

// MARK: - Extension ProtocolNewsSnippetModelAccessStrategy

extension NewsSnippetRESTWebAPIModelAccessStrategy: ProtocolNewsSnippetModelAccessStrategy {

	// MARK: - Public Methods
	
	public func select(byCategory category: ArtworkCategoryTypes, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler: @escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void) {
		
		// Create completion handler
		let runQueryCompletionHandler: (([String:Any]?, Error?) -> Void) = self.getRunQueryCompletionHandler(collection: collection, oncomplete: completionHandler)
		
		// Run the query
		self.runQuery(byCategory: category, year: year, into: collection, oncomplete: runQueryCompletionHandler)
		
	}

}
