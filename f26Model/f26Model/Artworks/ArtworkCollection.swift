//
//  ArtworkCollection.swift
//  f26Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel

/// Encapsulates a collection of Artwork items
public class ArtworkCollection: ModelItemCollectionBase {

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
			return "artwork"
		}
	}
	
	public override func getNewItem() -> ProtocolModelItem? {
		
		// Create the new item
		let item: Artwork = Artwork(collection: self,
									storageDateFormatter: self.storageDateFormatter!)
		
		// Set the ID
		item.id = self.getNextID()
		
		return item
		
	}
	
	public override func getNewItem(dataNode:[String: Any],
									fromDateFormatter: DateFormatter) -> ProtocolModelItem? {
		
		// Create the item
		let item: Artwork = self.getNewItem() as! Artwork
		
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
	
	public override func compareItems(by propertyEnum: Int, ascending: Bool, firstItem: ProtocolModelItem, secondItem: ProtocolModelItem) -> Bool {
		
		// Return true if first item should be ordered before second item; otherwise, false
		var result: 		Bool = false
		
		switch propertyEnum {
			
		case ModelProperties.artwork_displayIndex.rawValue:		// displayIndex
			
			result = super.compareItems(byInt: propertyEnum, ascending: ascending, firstItem: firstItem, secondItem: secondItem)
			
		default:
			
			result = super.compareItems(by: propertyEnum, ascending: ascending, firstItem: firstItem, secondItem: secondItem)
			
		}
		
		return result
	}
	
}
