//
//  ProtocolAwardModelAccessStrategy.swift
//  f26Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the Award model data
public protocol ProtocolAwardModelAccessStrategy {
	
	// MARK: - Methods
	
	/// Select items by category
	///
	/// - Parameters:
	///   - category: The category
	///   - year: The year
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byCategory category: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
}
