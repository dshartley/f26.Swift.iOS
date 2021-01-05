//
//  ArtworkModelAdministrator.swift
//  f26Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages Artwork data
public class ArtworkModelAdministrator: ModelAdministratorBase {

	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(modelAccessStrategy:			ProtocolModelAccessStrategy,
						 modelAdministratorProvider:	ProtocolModelAdministratorProvider,
						 storageDateFormatter:			DateFormatter) {
		super.init(modelAccessStrategy: modelAccessStrategy,
				   modelAdministratorProvider: modelAdministratorProvider,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods
	
	public func select(byCategory category: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()

		// Create completion handler
		let selectCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in

			self.doAfterLoad()

			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}

		// Load the data
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).select(byCategory: category, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byCategory category: Int, year: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).select(byCategory: category, year: year, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func select(byPreviousArtworkID id: Int, category: Int, year: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).select(byPreviousArtworkID: id, category: category, year: year, numberofItemsToLoad: numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func getYearsByCategory(category: Int, oncomplete completionHandler:@escaping ([Int]?, Error?) -> Void) {
		
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).getYearsByCategory(category: category, oncomplete: completionHandler)
	}
	
	public func addLike(id: Int) {
		
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).addLike(id: id)
	}
	
	public func selectSlideShowArtworks(byID id: Int, preloadPreviousYN: Bool, preloadNextYN: Bool, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).selectSlideShowArtworks(byID: id, preloadPreviousYN: preloadPreviousYN, preloadNextYN: preloadNextYN, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func selectSlideShowArtworkNext(byID id: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).selectSlideShowArtworkNext(byID: id, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func selectSlideShowArtworkPrevious(byID id: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
		self.setupCollection()
		
		// Create completion handler
		let selectCompletionHandler: (([Any]?, ProtocolModelItemCollection?, Error?) -> Void) =
		{
			(data, collection, error) -> Void in
			
			self.doAfterLoad()
			
			// Call the completion handler
			completionHandler(self.collection!.dataDocument, nil)
		}
		
		// Load the data
		(self.modelAccessStrategy as! ProtocolArtworkModelAccessStrategy).selectSlideShowArtworkPrevious(byID: id, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return ArtworkCollection(modelAdministrator: self,
								 storageDateFormatter: self.storageDateFormatter!)
	}
	
	public override func setupForeignKeys() {
		
		// No foreign keys
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func doLoadDataTables(data: [Any], oncomplete completionHandler:@escaping (Error?) -> Void) {
		
		// Fill the [ForeignKeyItem] collection
		if (data.count >= 2) {
			//let fkiModelAdministrator: ProtocolModelAdministrator = self.modelAdministratorProvider!.getModelAdministrator(key: "ForeignKeyTable")!
			
			//if (fkiModelAdministrator != nil) {
			//fkiModelAdministrator.load(data: [data[0]], oncomplete: completionHandler)
			//}
		}
	}
	
}
