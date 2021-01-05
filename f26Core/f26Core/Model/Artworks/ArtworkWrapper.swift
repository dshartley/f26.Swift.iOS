//
//  ArtworkWrapper.swift
//  f26Core
//
//  Created by David on 11/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A wrapper for a Artwork model item
public class ArtworkWrapper {

	// MARK: - Public Stored Properties
	
	public var id:									Int = 0
	public var name:								String = ""
	public var category:							ArtworkCategoryTypes = .elena
	public var medium:								ArtworkMediumTypes = .paint
	public var size:								String = ""
	public var year:								Int = 0
	public var thumbnailImageFileName:				String = ""
	public var thumbnailImageData:					Data? = nil
	public var thumbnailImageDisplayHeight:			CGFloat = 0
	public var largeImageFileName:					String = ""
	public var largeImageData:						Data? = nil
	public var comments:							String = ""
	public var displayIndex:						Int = 0
	public var numberofLikes:						Int = 0
	public var numberofArtworkComments:				Int = 0
	public var latestArtworkCommentDatePosted:		Date = Date()
	public var latestArtworkCommentPostedByName:	String = ""
	public var latestArtworkCommentText:			String = ""
	public var thumbnailImageWidthPixels:			CGFloat = 0
	public var thumbnailImageHeightPixels:			CGFloat = 0

	public var itemDetailViewHeight: 				CGFloat = 0
	public var itemLatestArtworkCommentViewHeight: 	CGFloat = 0
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}
