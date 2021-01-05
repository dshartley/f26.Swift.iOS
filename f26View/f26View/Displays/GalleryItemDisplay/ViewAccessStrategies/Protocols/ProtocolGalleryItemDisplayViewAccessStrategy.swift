//
//  ProtocolGalleryItemDisplayViewAccessStrategy.swift
//  f26View
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f26Core

/// Defines a class which provides a strategy for accessing the GalleryItemDisplay view
public protocol ProtocolGalleryItemDisplayViewAccessStrategy {
	
	// MARK: - Methods
	
	/// Display artwork
	///
	func display(artwork: ArtworkWrapper)
	
	func displayNumberofLikes(numberofLikes: Int)
	
	func clearLatestArtworkComment()
	
	func displayLatestArtworkComment(text: String, postedByName: String, datePosted: Date)
	
}
