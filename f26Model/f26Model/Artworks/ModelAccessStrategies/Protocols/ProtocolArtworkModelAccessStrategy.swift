//
//  ProtocolArtworkModelAccessStrategy.swift
//  f26Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the Artwork model data
public protocol ProtocolArtworkModelAccessStrategy {

	// MARK: - Methods
	
	/// Select items by category
	///
	/// - Parameters:
	///   - category: The category
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byCategory category: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	/// Select items by category and year
	///
	/// - Parameters:
	///   - category: The category
	///   - year: The year
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byCategory category: Int, year: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	/// Select items by previousArtworkID, category and year
	///
	/// - Parameters:
	///	  - id: The id
	///   - category: The category
	///   - year: The year
	///   - numberofItemsToLoad: The numberofItemsToLoad
	///   - selectItemsAfterPreviousYN: The selectItemsAfterPreviousYN
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byPreviousArtworkID id: Int, category: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)
	
	/// Get the years for the category
	///
	/// - Parameter category: The category
	func getYearsByCategory(category: Int, oncomplete completionHandler:@escaping ([Int]?, Error?) -> Void)
	
	/// Add a like
	///
	/// - Parameter id: The id
	func addLike(id: Int)
	
	/// Select slideshow artworks by id
	///
	/// - Parameters:
	///   - id: The id
	///   - preloadPreviousYN: The preloadPreviousYN
	///   - preloadNextYN: The preloadNextYN
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func selectSlideShowArtworks(byID id: Int, preloadPreviousYN: Bool, preloadNextYN: Bool, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	/// Select next slideshow artwork by id
	///
	/// - Parameters:
	///   - id: The id
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func selectSlideShowArtworkNext(byID id: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	/// Select previous slideshow artwork by id
	///
	/// - Parameters:
	///   - id: The id
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func selectSlideShowArtworkPrevious(byID id: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)
}
