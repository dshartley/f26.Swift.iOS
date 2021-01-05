//
//  ProtocolArtworkCommentModelAccessStrategy.swift
//  f26Model
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Defines a class which provides a strategy for accessing the ArtworkComment model data
public protocol ProtocolArtworkCommentModelAccessStrategy {

	// MARK: - Methods
	
	/// Select items by category
	///
	/// - Parameters:
	///   - category: The category
	///   - collection: The collection
	///   - completionHandler: The completionHandler
	func select(byArtworkID artworkID: Int, collection: ProtocolModelItemCollection, oncomplete completionHandler:@escaping ([Any]?, ProtocolModelItemCollection?, Error?) -> Void)

	/// Post a comment
	///
	/// - Parameter artworkComment: The artworkComment
	/// - completionHandler: The completionHandler
	func post(artworkComment: ArtworkComment, oncomplete completionHandler:@escaping (ArtworkComment?, Error?) -> Void)
	
}
