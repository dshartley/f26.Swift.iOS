//
//  CacheManager.swift
//  f26Controller
//
//  Created by David on 19/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFSerialization
import f26Core
import f26Model

/// Manages cacheing
public class CacheManager {

	// MARK: - Private Stored Properties
	
	fileprivate var managedObjectContext:		NSManagedObjectContext? = nil
	fileprivate var year:						Int = 0
	fileprivate var category:					ArtworkCategoryTypes = .elena
	
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:			CacheManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var collection:		ArtworkCollection? = nil

	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: CacheManager {
		get {
			
			if (CacheManager.singleton == nil) {
				CacheManager.singleton = CacheManager()
			}
			
			return CacheManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func clearArtworks() {
		
		self.collection	= nil
	}
	
	public func set(managedObjectContext: NSManagedObjectContext) {
		
		self.managedObjectContext = managedObjectContext
	}
	
	public func loadArtworksFromCache(category: ArtworkCategoryTypes, year: Int) -> [Any] {
		
		var result = [Any]()
		
		guard (self.managedObjectContext != nil) else { return result }
		
		self.category	= category
		self.year		= year
		
		// Fetch data
		let artworksData: NSManagedObject? = self.doFetchArtworksDataFromCache(category: category, year: year)
		
		if let artworksData = artworksData {
			
			// Get dataString
			if let dataString = artworksData.value(forKeyPath: "dataString") as? String {
				
				// Deserialize the data
				let dataDictionary: [String:Any]? = JSONHelper.stringToJSON(jsonString: dataString) as? [String:Any]
				
				if (dataDictionary != nil && dataDictionary!.count > 0) {
					
					// Add data element to result
					result = dataDictionary!["artworks"] as! [Any]
				}
				
			}
		}
		
		// Create collection
		self.loadedArtworksDataToCollection(data: result)
		
		return result
	}
	
	public func selectArtworks(byPreviousArtworkID: Int, numberofItemsToLoad: Int, selectItemsAfterPreviousYN: Bool) -> [Any] {
		
		var result: [Any] = [Any]()
		
		guard (self.collection != nil) else { return result }
		
		// Find the item
		var itemFoundIndex: Int		= 0
		var isFoundYN:		Bool	= false
		
		// Check byPreviousArtworkID is specified
		if (byPreviousArtworkID > 0) {
			
			var item:		Artwork?	= nil
			
			// Go through each item until isFoundYN
			while (!isFoundYN && itemFoundIndex <= self.collection!.items!.count - 1) {
				
				item = (self.collection!.items![itemFoundIndex] as! Artwork)
				
				// Check item id
				if (item!.id == String(byPreviousArtworkID)) {

					isFoundYN = true
					
				} else {
					
					itemFoundIndex += 1
				}
			}
			
			// Check isFoundYN
			if (!isFoundYN) { return result }
		}
		
		var itemsToAdd:		Int			= numberofItemsToLoad
		var item:			Artwork?	= nil
		var itemData:		Any?		= nil
		
		
		var itemIndex:		Int			= 0
		
		// Check if item found
		if (isFoundYN) {
			
			// Set item index to item before or after the found item
			if (selectItemsAfterPreviousYN) {
				
				itemIndex = itemFoundIndex + 1
				
			} else {
				
				itemIndex = itemFoundIndex - 1
			}
		}
		
		while (itemsToAdd > 0 && itemIndex >= 0 && itemIndex <= self.collection!.items!.count - 1) {
			
			// Get the item
			item		= (self.collection!.items![itemIndex] as! Artwork)
			
			// Get itemData
			itemData	= item?.dataNode! as Any
			
			if (selectItemsAfterPreviousYN) {
				
				// Append to data
				result.append(itemData!)
				
				itemIndex += 1
				
			} else {
				
				// Prepend to data
				result.insert(itemData!, at: 0)
				
				itemIndex -= 1
			}
			
			itemsToAdd -= 1
		}
		
		return result
	}
	
	public func saveArtworksToCache() {
		
		guard (	self.managedObjectContext != nil
				&& self.year > 0) else { return }
		
		// Fetch data
		var artworksData:			NSManagedObject?			= self.doFetchArtworksDataFromCache(category: self.category, year: self.year)
		
		// Check artworksData is nil
		if (artworksData == nil) {
			
			// Get artworksEntity
			let artworksEntity:		NSEntityDescription			= NSEntityDescription.entity(forEntityName: "Artworks", in: managedObjectContext!)!
			
			// Create new data item
			artworksData = NSManagedObject(entity: artworksEntity, insertInto: managedObjectContext!)
			
			// Set year
			artworksData!.setValue(self.year, forKeyPath: "year")
			
			// Set category
			artworksData!.setValue(self.category.rawValue, forKeyPath: "category")
		}
		
		// Serialize the data
		let dataDictionary:		[String:Any]	= ["artworks" : self.collection!.dataDocument]
		let dataString:			String			= JSONHelper.JSONToString(json: dataDictionary)!
		
		// Set dataString
		artworksData!.setValue(dataString, forKeyPath: "dataString")
		
		// Save data
		do {
			try managedObjectContext!.save()
			
		} catch _ as NSError {
			// Not required
		}
		
	}
	
	public func saveImageToCache(imageData: Data, fileName: String) {
		
		let fileManager: FileManager = FileManager.default
		
		do {
			let documentDirectoryUrl:	URL	= try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
			let fileUrl:				URL = documentDirectoryUrl.appendingPathComponent(fileName)
			
			try imageData.write(to: fileUrl)
			
		} catch {
			// Not required
		}
		
	}
	
	public func loadImageFromCache(with fileName: String) -> Data? {
		
		var result:			Data?			= nil
		
		let fileManager:	FileManager		= FileManager.default
		
		do {
			let documentDirectoryUrl:	URL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
			let fileUrl:				URL	= documentDirectoryUrl.appendingPathComponent(fileName)
			
			result = fileManager.contents(atPath: fileUrl.path)
			
		} catch {
			// Not required
		}
		
		return result
	}
	
	public func mergeArtworkToCache(from source: ArtworkWrapper) {

		guard (self.collection != nil) else { return }

		var cacheItem: 	Artwork? = nil

		if (cacheItem == nil) {

			// Create new item
			cacheItem 	= self.collection!.addItem() as? Artwork
		}

		// Update item
		cacheItem!.clone(wrapper: source)

	}
	
	public func mergeArtworksToCache(from source: ArtworkCollection) {
		
		guard (self.collection != nil) else { return }
		
		var cacheItem: 	Artwork? = nil
		var sortYN: 	Bool = false
		
		// Go through each source item
		for sourceItem in source.items! {

			if (sourceItem.status != .deleted && sourceItem.status != .obsolete) {
				
				// Find cache item
				cacheItem = self.collection!.getItem(id: sourceItem.id) as? Artwork
				
				if (cacheItem == nil) {
					
					// Create new item
					cacheItem 		= self.collection!.addItem() as? Artwork
				}
				
				if (cacheItem!.displayIndex != (sourceItem as! Artwork).displayIndex) {
					sortYN = true
				}
				
				// Update item
				cacheItem!.clone(item: sourceItem)
				
			} else {
				
				// Remove item
				self.collection!.removeItem(id: sourceItem.id)
			}

		}
		
		// Check if sortYN
		if (sortYN) {
			
			// Sort the collection
			_ = self.collection!.sortBy(propertyEnum: ModelProperties.artwork_displayIndex.rawValue, ascending: false)
		}
	}
	
	public func deleteAllArtworksFromCache() {
		
		guard (	self.managedObjectContext != nil) else { return }
		
		// Setup fetchRequest
		let fetchRequest:			NSFetchRequest			= NSFetchRequest<NSManagedObject>(entityName: "Artworks")
		
		// Fetch data
		var fetchResult:			[NSManagedObject]?		= nil
		
		do {
			fetchResult	= try self.managedObjectContext!.fetch(fetchRequest)
			
		} catch _ as NSError {
			// Error
		}
		
		// Go through each item
		for (_, item) in fetchResult!.enumerated() {
			
			// Delete item
			self.managedObjectContext!.delete(item)
		}
		
		do {
			try self.managedObjectContext!.save()
			
		} catch _ as NSError {
			// Error
		}
	}

	
	// MARK: - Private Methods
	
	fileprivate func doFetchArtworksDataFromCache(category: ArtworkCategoryTypes, year: Int) -> NSManagedObject? {
		
		var result:			NSManagedObject?	= nil
		
		// Setup fetchRequest
		let fetchRequest:	NSFetchRequest		= NSFetchRequest<NSManagedObject>(entityName: "Artworks")
		
		let predicate:		NSPredicate			= NSPredicate(format: "year == %@ AND category == %@", argumentArray: [year, String(category.rawValue)])
		
		fetchRequest.predicate = predicate
		
		// Fetch data
		var fetchResult:	[NSManagedObject]?	= nil
		
		do {
			fetchResult	= try self.managedObjectContext!.fetch(fetchRequest)
			
		} catch _ as NSError {
			// Not required
		}
		
		if (fetchResult != nil && fetchResult!.count > 0) {
			
			// Get first item from result
			result = fetchResult!.first
			
		}
		
		return result
	}
	
	fileprivate func loadedArtworksDataToCollection(data: [Any]?) {
		
		// Create artwork collection
		self.collection	= ArtworkCollection()
		
		guard (data != nil) else { return }
		
		// Go through each node in the data
		for dataNode in data! {
			
			let dataNode = dataNode as! [String : Any]
			
			// Create the item
			let item: Artwork = self.collection!.getNewItem(dataNode: dataNode, fromDateFormatter: DateFormatter())! as! Artwork

			// Include items that are not deleted or obsolete
			if (item.status != .deleted && item.status != .obsolete) {
				
				// Add the item to the collection
				self.collection!.addItem(item: item)
			}
		}

	}

}
