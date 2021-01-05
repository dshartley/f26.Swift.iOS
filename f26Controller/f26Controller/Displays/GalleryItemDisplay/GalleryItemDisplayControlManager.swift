//
//  GalleryItemDisplayControlManager.swift
//  f26Controller
//
//  Created by David on 19/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import f26Core
import f26Model
import f26View

/// Manages the GalleryItemDisplay control layer
public class GalleryItemDisplayControlManager: GalleryControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public var viewManager:	GalleryItemDisplayViewManager?
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: GalleryItemDisplayViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager	= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func displaySelectedArtwork() {
		
		guard (self.selectedArtwork != nil) else { return }
		
		self.displayLatestArtworkComment()
		
		self.viewManager!.display(artwork: self.selectedArtwork!)
	}
	
	public func displayNumberofLikes() {
		
		guard (self.selectedArtwork != nil) else { return }
		
		self.viewManager!.displayNumberofLikes(numberofLikes: self.selectedArtwork!.numberofLikes)
		
	}
	
	public func displayLatestArtworkComment() {
		
		guard (self.selectedArtwork != nil) else { return }
		
		if (self.selectedArtwork!.latestArtworkCommentText.count > 0) {
			
			self.viewManager!.displayLatestArtworkComment(	text: self.selectedArtwork!.latestArtworkCommentText, postedByName: self.selectedArtwork!.latestArtworkCommentPostedByName, datePosted: self.selectedArtwork!.latestArtworkCommentDatePosted)
			
		} else {
		
			self.viewManager!.clearLatestArtworkComment()
			
		}

	}
	
}
