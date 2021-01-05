//
//  ProtocolGalleryListDisplayViewAccessStrategy.swift
//  f26View
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import f26Core

/// Defines a class which provides a strategy for accessing the GalleryListDisplay view
public protocol ProtocolGalleryListDisplayViewAccessStrategy {

	// MARK: - Methods
	
	func displayAwards(items: [AwardWrapper])
	
	func clearAwards()

	func displayNewsSnippets(items: [NewsSnippetWrapper])
	
	func clearNewsSnippets()
	
}
