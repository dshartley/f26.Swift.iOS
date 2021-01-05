//
//  ArtworkCommentsDisplayControlManager.swift
//  f26Controller
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import SFNet
import f26Core
import f26Model
import f26View

/// Manages the ArtworkCommentsDisplay control layer
public class ArtworkCommentsDisplayControlManager: ControlManagerBase {

	// MARK: - Public Stored Properties
	
	public var viewManager:									ArtworkCommentsDisplayViewManager?
	public fileprivate(set) var artworkCommentWrappers: 	[ArtworkCommentWrapper] = [ArtworkCommentWrapper]()
	public var artworkID:									Int = 0
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: ArtworkCommentsDisplayViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
		self.artworkCommentWrappers 	= [ArtworkCommentWrapper]()
	}
	
	
	// MARK: - Public Methods
	
	public func loadArtworkComments(oncomplete completionHandler:@escaping ([ArtworkCommentWrapper]?, Error?) -> Void) {
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadArtworkCommentsFromDataSourceCompletionHandler: (([ArtworkCommentWrapper]?, Error?) -> Void) =
			{
				(items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Call completion handler
					completionHandler(items!, error)
					
				}
				
			}
			
			// Load from data source
			self.loadArtworkCommentsFromDataSource(artworkID: self.artworkID, oncomplete: loadArtworkCommentsFromDataSourceCompletionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(nil, nil)
		}
		
	}
	
	public func getArtworkCommentModelAdministrator() -> ArtworkCommentModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getArtworkCommentModelAdministrator!
	}
	
	public func postComment(oncomplete completionHandler:@escaping (ArtworkCommentWrapper?, Error?) -> Void) {
		
		// Create completion handler
		let postCompletionHandler: ((ArtworkComment?, Error?) -> Void) =
		{
			(item, error) -> Void in
			
			var artworkCommentWrapper: ArtworkCommentWrapper? = nil
			
			if (error == nil && item != nil) {

				// Get the wrapper
				artworkCommentWrapper = item!.toWrapper()
				
				// Prepend to the wrappers array
				self.artworkCommentWrappers.insert(artworkCommentWrapper!, at: 0)
				
				// Update artwork wrapper
				self.updateArtworkWrapperLatestArtworkComment(artworkCommentWrapper: artworkCommentWrapper!)
			
			}
			
			// Call completion handler
			completionHandler(artworkCommentWrapper, error)
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
		
			// Create artworkComment
			let artworkComment: ArtworkComment = self.createArtworkComment()
			
			// Save data
			self.getArtworkCommentModelAdministrator().post(artworkComment: artworkComment, oncomplete: postCompletionHandler)
			
		} else {
			
			// Call completion handler
			completionHandler(nil, nil)
		}

	}
	
	
	// MARK: - Private Methods
	
	fileprivate func createArtworkComment() -> ArtworkComment {
		
		// Create new item
		let artworkComment: ArtworkComment 	= self.getArtworkCommentModelAdministrator().collection!.addItem() as! ArtworkComment
		
		artworkComment.id 					= String(0)
		artworkComment.artworkID 			= self.artworkID
		artworkComment.text 				= self.viewManager!.getComment()
		artworkComment.postedByName 		= self.viewManager!.getPostedByName()
		artworkComment.datePosted 			= Date()
		
		return artworkComment
		
	}
	
	fileprivate func loadArtworkCommentsFromDataSource(artworkID: Int, oncomplete completionHandler:@escaping ([ArtworkCommentWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [ArtworkCommentWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedArtworkCommentsToWrappers()
			}
			
			// Set state
			self.setStateAfterLoad()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoad()
		
		// Load data
		self.getArtworkCommentModelAdministrator().select(byArtworkID: artworkID, oncomplete: loadCompletionHandler)
	}
	
	fileprivate func loadedArtworkCommentsToWrappers() -> [ArtworkCommentWrapper] {
		
		var result:						[ArtworkCommentWrapper]	= [ArtworkCommentWrapper]()
		
		if let collection = self.getArtworkCommentModelAdministrator().collection {
			
			let collection:				ArtworkCommentCollection = collection as! ArtworkCommentCollection
			
			// Go through each item
			for item in collection.items! {

				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: ArtworkCommentWrapper = (item as! ArtworkComment).toWrapper()
					
					result.append(wrapper)

				}
			}
		}
		
		self.artworkCommentWrappers = result
		
		return result
	}	

	fileprivate func updateArtworkWrapperLatestArtworkComment(artworkCommentWrapper: ArtworkCommentWrapper) {
		
		// Find the artwork wrapper
		var artworkWrapper: ArtworkWrapper? = nil
		
		// Go through each item
		for item in ArtworkWrappers.items {
			
			if (item.id == self.artworkID) { artworkWrapper = item }
		}
		
		guard (artworkWrapper != nil) else { return }
		
		// Update the artwork wrapper
		artworkWrapper!.latestArtworkCommentText 			= artworkCommentWrapper.text
		artworkWrapper!.latestArtworkCommentDatePosted 		= artworkCommentWrapper.datePosted
		artworkWrapper!.latestArtworkCommentPostedByName 	= artworkCommentWrapper.postedByName
		artworkWrapper!.numberofArtworkComments 			+= 1
		
		// Merge to cache
		CacheManager.shared.mergeArtworkToCache(from: artworkWrapper!)
		
		// Save to cache
		CacheManager.shared.saveArtworksToCache()
	}
}
