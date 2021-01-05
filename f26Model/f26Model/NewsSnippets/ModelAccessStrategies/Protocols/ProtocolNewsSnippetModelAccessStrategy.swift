//
//  ProtocolNewsSnippetModelAccessStrategy.swift
//  f26Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import f26Core

/// Defines a class which provides a strategy for accessing the NewsSnippet model data
public protocol ProtocolNewsSnippetModelAccessStrategy {
	
	// MARK: - Methods
	
	/// Select items by category
	///
	/// - Parameters:
	///   - category: The category
	///   - year: The year
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byCategory category: ArtworkCategoryTypes, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([String:Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
