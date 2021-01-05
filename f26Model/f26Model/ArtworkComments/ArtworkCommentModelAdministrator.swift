//
//  ArtworkCommentModelAdministrator.swift
//  f26Model
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Manages ArtworkComment data
public class ArtworkCommentModelAdministrator: ModelAdministratorBase {
	
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
	
	public func select(byArtworkID artworkID: Int, oncomplete completionHandler:@escaping ([Any]?, Error?) -> Void) {
		
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
		(self.modelAccessStrategy as! ProtocolArtworkCommentModelAccessStrategy).select(byArtworkID: artworkID, collection: self.collection!, oncomplete: selectCompletionHandler)
	}
	
	public func post(artworkComment: ArtworkComment, oncomplete completionHandler:@escaping (ArtworkComment?, Error?) -> Void) {
		
		(self.modelAccessStrategy as! ProtocolArtworkCommentModelAccessStrategy).post(artworkComment: artworkComment, oncomplete: completionHandler)
	}
	
	
	// MARK: - Override Methods
	
	public override func newCollection() -> ProtocolModelItemCollection? {
		
		return ArtworkCommentCollection(modelAdministrator: self,
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

