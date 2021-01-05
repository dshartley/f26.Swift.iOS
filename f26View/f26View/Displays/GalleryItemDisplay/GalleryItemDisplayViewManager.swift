//
//  GalleryItemDisplayViewManager.swift
//  f26View
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f26Core

/// Manages the GalleryItemDisplay view layer
public class GalleryItemDisplayViewManager: ViewManagerBase {
	
	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolGalleryItemDisplayViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolGalleryItemDisplayViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func display(artwork: ArtworkWrapper) {
		
		self.viewAccessStrategy!.display(artwork: artwork)
	}
	
	public func displayNumberofLikes(numberofLikes: Int) {
		
		self.viewAccessStrategy!.displayNumberofLikes(numberofLikes: numberofLikes)
	}
	
	public func clearLatestArtworkComment() {
	
		self.viewAccessStrategy!.clearLatestArtworkComment()
	}
	
	public func displayLatestArtworkComment(text: String, postedByName: String, datePosted: Date) {
		
		self.viewAccessStrategy!.displayLatestArtworkComment(text: text, postedByName: postedByName, datePosted: datePosted)
	}
	
}
