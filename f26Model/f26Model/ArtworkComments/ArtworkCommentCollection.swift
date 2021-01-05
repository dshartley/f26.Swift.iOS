//
//  ArtworkCommentCollection.swift
//  f26Model
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Encapsulates a collection of ArtworkComment items
public class ArtworkCommentCollection: ModelItemCollectionBase {
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public override init(modelAdministrator: 	ProtocolModelAdministrator,
						 storageDateFormatter: 	DateFormatter) {
		super.init(modelAdministrator: modelAdministrator,
				   storageDateFormatter: storageDateFormatter)
	}
	
	public override init(dataDocument:			[[String : Any]],
						 modelAdministrator: 	ProtocolModelAdministrator,
						 fromDateFormatter: 	DateFormatter,
						 storageDateFormatter: 	DateFormatter) {
		super.init(dataDocument: dataDocument,
				   modelAdministrator: modelAdministrator,
				   fromDateFormatter: fromDateFormatter,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Override Methods
	
	public override var dataType: String {
		get {
			return "artworkComment"
		}
	}
	
	public override func getNewItem() -> ProtocolModelItem? {
		
		// Create the new item
		let item: ArtworkComment = ArtworkComment(collection: self,
												  storageDateFormatter: self.storageDateFormatter!)
		
		// Set the ID
		item.id = self.getNextID()
		
		return item
		
	}
	
	public override func getNewItem(dataNode:[String: Any],
									fromDateFormatter: DateFormatter) -> ProtocolModelItem? {
		
		// Create the item
		let item: ArtworkComment = self.getNewItem() as! ArtworkComment
		
		// Go through each property
		for property in dataNode {
			
			// Set the property in the item
			item.setProperty(key: property.key,
							 value: String(describing: property.value),
							 setWhenInvalidYN: false,
							 fromDateFormatter: fromDateFormatter)
		}
		
		return item
	}
	
}

