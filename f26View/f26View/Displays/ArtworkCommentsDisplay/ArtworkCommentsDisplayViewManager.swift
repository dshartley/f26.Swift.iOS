//
//  ArtworkCommentsDisplayViewManager.swift
//  f26View
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFView
import f26Core

/// Manages the GalleryItemDisplay view layer
public class ArtworkCommentsDisplayViewManager: ViewManagerBase {

	// MARK: - Private Stored Properties
	
	fileprivate var viewAccessStrategy: ProtocolArtworkCommentsDisplayViewAccessStrategy?
	
	
	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public init(viewAccessStrategy: ProtocolArtworkCommentsDisplayViewAccessStrategy) {
		super.init()
		
		self.viewAccessStrategy = viewAccessStrategy
	}
	
	
	// MARK: - Public Methods
	
	public func getPostedByName() -> String {
		
		return self.viewAccessStrategy!.getPostedByName()
	}
	
	public func getComment() -> String {
		
		return self.viewAccessStrategy!.getComment()
	}
	
}
