//
//  ArtworkCommentWrapper.swift
//  f26Core
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A wrapper for a ArtworkComment model item
public class ArtworkCommentWrapper {
	
	// MARK: - Public Stored Properties
	
	public var id:				Int = 0
	public var artworkID:		Int = 0
	public var datePosted:		Date = Date()
	public var postedByName:	String = ""
	public var postedByEmail:	String = ""
	public var text:			String = ""
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
}

