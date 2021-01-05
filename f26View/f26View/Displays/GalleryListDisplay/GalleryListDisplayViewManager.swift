//
//  GalleryListDisplayViewManager.swift
//  f26View
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f26Core

/// Manages the GalleryListDisplay view layer
public class GalleryListDisplayViewManager: ViewManagerBase {

	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolGalleryListDisplayViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolGalleryListDisplayViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func displayAwards(items: [AwardWrapper]) {
		
		self.viewAccessStrategy!.displayAwards(items: items)
		
	}
	
	public func clearAwards() {
		
		self.viewAccessStrategy!.clearAwards()
		
	}

	public func displayNewsSnippets(items: [NewsSnippetWrapper]) {
		
		self.viewAccessStrategy!.displayNewsSnippets(items: items)
		
	}
	
	public func clearNewsSnippets() {
		
		self.viewAccessStrategy!.clearNewsSnippets()
		
	}
	
}
