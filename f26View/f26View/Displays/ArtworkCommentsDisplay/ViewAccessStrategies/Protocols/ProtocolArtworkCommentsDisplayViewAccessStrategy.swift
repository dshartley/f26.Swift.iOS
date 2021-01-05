//
//  ProtocolArtworkCommentsDisplayViewAccessStrategy.swift
//  f26View
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f26Core

/// Defines a class which provides a strategy for accessing the ArtworkCommentsDisplay view
public protocol ProtocolArtworkCommentsDisplayViewAccessStrategy {
	
	// MARK: - Methods
	
	func getPostedByName() -> String
	
	func getComment() -> String
}
