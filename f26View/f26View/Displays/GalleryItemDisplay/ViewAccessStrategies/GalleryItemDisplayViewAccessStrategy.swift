//
//  GalleryItemDisplayViewAccessStrategy.swift
//  f26View
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f26Core

/// A strategy for accessing the GalleryItemDisplay view
public class GalleryItemDisplayViewAccessStrategy {
	
	// MARK: - Private Stored Properties
	
	fileprivate var nameLabel:									UILabel!
	fileprivate var commentsLabel:								UILabel!
	fileprivate var numberofLikesLabel: 						UILabel!
	fileprivate var latestArtworkCommentTextLabel: 				UILabel!
	fileprivate var latestArtworkCommentPostedByNameLabel: 		UILabel!
	fileprivate var latestArtworkCommentDatePostedLabel: 		UILabel!
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(nameLabel:								UILabel,
	                  commentsLabel:							UILabel,
					  numberofLikesLabel: 						UILabel,
					  latestArtworkCommentTextLabel: 			UILabel,
					  latestArtworkCommentPostedByNameLabel: 	UILabel,
					  latestArtworkCommentDatePostedLabel: 		UILabel) {
		
		self.nameLabel								= nameLabel
		self.commentsLabel							= commentsLabel
		self.numberofLikesLabel						= numberofLikesLabel
		self.latestArtworkCommentTextLabel 			= latestArtworkCommentTextLabel
		self.latestArtworkCommentPostedByNameLabel 	= latestArtworkCommentPostedByNameLabel
		self.latestArtworkCommentDatePostedLabel 	= latestArtworkCommentDatePostedLabel
		
	}
	
}

// MARK: - Extension ProtocolGalleryItemDisplayViewAccessStrategy

extension GalleryItemDisplayViewAccessStrategy: ProtocolGalleryItemDisplayViewAccessStrategy {
	
	public func display(artwork: ArtworkWrapper) {
		
		self.nameLabel!.text		= artwork.name
		self.commentsLabel!.text	= artwork.comments
		
		self.displayNumberofLikes(numberofLikes: artwork.numberofLikes)
		
	}
	
	public func displayNumberofLikes(numberofLikes: Int) {
		
		var value: String = ""
		
		if (numberofLikes > 0) { value = String(numberofLikes) }
		
		self.numberofLikesLabel!.text = value
		
	}
	
	public func clearLatestArtworkComment() {
		
		self.latestArtworkCommentTextLabel.text 			= ""
		self.latestArtworkCommentPostedByNameLabel.text 	= ""
		self.latestArtworkCommentDatePostedLabel.text 		= ""
		
	}
	
	public func displayLatestArtworkComment(text: String, postedByName: String, datePosted: Date) {
		
		self.latestArtworkCommentTextLabel.text 			= "\"" + text + "\""
		self.latestArtworkCommentPostedByNameLabel.text 	= postedByName
		
		// Get latestArtworkCommentDatePostedString from dateFormatter
		let dateFormatter									= DateFormatter()
		dateFormatter.dateFormat							= "MMM d, yyyy"
		dateFormatter.timeZone 								= TimeZone(secondsFromGMT: 0)
		
		let latestArtworkCommentDatePostedString 			= dateFormatter.string(from: datePosted)
		
		self.latestArtworkCommentDatePostedLabel.text 		= ", " + latestArtworkCommentDatePostedString
		
	}
}
