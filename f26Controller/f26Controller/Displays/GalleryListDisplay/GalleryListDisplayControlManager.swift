//
//  GalleryListDisplayControlManager.swift
//  f26Controller
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFController
import f26Core
import f26Model
import f26View

/// Manages the GalleryListDisplay control layer
public class GalleryListDisplayControlManager: GalleryControlManagerBase {

	// MARK: - Private Stored Properties
	
	// MARK: - Public Stored Properties
	
	public var viewManager:	GalleryListDisplayViewManager?

	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: GalleryListDisplayViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager	= viewManager
	}
	
	
	// MARK: - Public Methods
	
	public func clearData() {
	
		self.clearArtworksData()
		self.clearAwardsData()
		self.clearNewsSnippetsData()
		
	}
	
	public func clearArtworksData() {
		
		// Clear the cache
		CacheManager.shared.clearArtworks()
		
		// Clear the wrappers array
		ArtworkWrappers.items							= [ArtworkWrapper]()
		
		ArtworkWrappers.hasLoadedAllPreviousItemsYN		= false
		ArtworkWrappers.hasLoadedAllNextItemsYN			= false
		
		self.getArtworkModelAdministrator().initialise()
		
	}
	
	public func clearAwardsData() {
		
		// Clear the cache
		AwardsCacheManager.shared.clear()
		
		// Clear the wrappers array
		AwardWrappers.items 							= [AwardWrapper]()
		
		self.getAwardModelAdministrator().initialise()
		
	}

	public func clearNewsSnippetsData() {
		
		// Clear the cache
		NewsSnippetsCacheManager.shared.clear()
		
		// Clear the wrappers array
		NewsSnippetWrappers.items 						= [NewsSnippetWrapper]()
		
		self.getNewsSnippetModelAdministrator().initialise()
		
	}
	
	public func deleteLastItem() {
		
		let aw: Artwork = self.getArtworkModelAdministrator().collection?.items?.last as! Artwork
		
		self.getArtworkModelAdministrator().collection?.removeItem(item: aw)
		
		ArtworkWrappers.items.removeLast()

	}

	public func getYears() -> [Int] {
	
		// Get current year
		let date		= Date()
		let calendar	= Calendar.current
		let year:		Int = calendar.component(.year, from: date)
		
		var result		= [Int]()
		
		for i in stride(from: year, through: 2013, by: -1) {
			
			result.append(i)
		}

		// Set selected year
		self.selectedYear = year
		
		return result
	}
	
	public func set(selectedDaughter daughter: Daughters) {
		
		// If changed then clear data
		if (daughter != self.selectedDaughter) { self.clearData() }
			
		self.selectedDaughter = daughter
		
	}
	
	public func set(selectedYear year: Int) {
		
		// If changed then clear data
		if (year != self.selectedYear) { self.clearData() }
		
		self.selectedYear = year
		
	}
	
	public func clearAwardsView() {
		
		self.viewManager!.clearAwards()
		
	}
	
	public func displayAwards() {
		
		self.viewManager!.displayAwards(items: AwardWrappers.items)

	}

	public func clearNewsSnippetsView() {
		
		self.viewManager!.clearNewsSnippets()
		
	}
	
	public func displayNewsSnippets() {
		
		self.viewManager!.displayNewsSnippets(items: NewsSnippetWrappers.items)
		
	}
	
	
	// MARK: - Private Methods

}
