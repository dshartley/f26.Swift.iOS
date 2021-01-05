//
//  Enums.swift
//  f26Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// Specifies model properties
public enum ModelProperties: Int {

	// General
	case id
	
	// artwork
	case artwork_id
	case artwork_name
	case artwork_category
	case artwork_medium
	case artwork_size
	case artwork_year
	case artwork_thumbnailImageFileName
	case artwork_largeImageFileName
	case artwork_comments
	case artwork_displayIndex
	case artwork_numberofLikes
	case artwork_numberofArtworkComments
	case artwork_latestArtworkCommentDatePosted
	case artwork_latestArtworkCommentPostedByName
	case artwork_latestArtworkCommentText
	case artwork_thumbnailImageWidthPixels
	case artwork_thumbnailImageHeightPixels
	
	// artworkComment
	case artworkComment_id
	case artworkComment_artworkID
	case artworkComment_datePosted
	case artworkComment_postedByName
	case artworkComment_postedByEmail
	case artworkComment_text
	
	// award
	case award_id
	case award_category
	case award_year
	case award_text
	case award_imageFileName
	case award_competitionName
	case award_quote
	case award_url

	// newsSnippet
	case newsSnippet_id
	case newsSnippet_category
	case newsSnippet_year
	case newsSnippet_text
	case newsSnippet_datePosted
	case newsSnippet_imageFileName
	
}
