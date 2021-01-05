//
//  GalleryControlManagerBase.swift
//  f26Controller
//
//  Created by David on 10/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFCore
import SFController
import SFNet
import SFSecurity
import SFSerialization
import f26Core
import f26Model

/// A base class for classes which manage the gallery control layer
public class GalleryControlManagerBase: ControlManagerBase  {

	// MARK: - Private Stored Properties
	
	fileprivate let numberofItemsToLoad:					Int					= 4
	fileprivate var isLoadingAwardsDataYN:					Bool				= false
	fileprivate var isLoadingNewsSnippetsDataYN:			Bool				= false
	fileprivate let artworkImagesUrlRoot:					String = "http:/www.davidhartleyart.com/Images/ArtWorks/"
	fileprivate let awardImagesUrlRoot:						String = "http:/www.davidhartleyart.com/Images/Awards/"
	fileprivate let newsSnippetImagesUrlRoot:				String = "http:/www.davidhartleyart.com/Images/NewsSnippets/"
	fileprivate var onSignInSuccessfulCompletionHandler: 	((Error?) -> Void)? = nil
	
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:								ProtocolGalleryControlManagerBaseDelegate?
	public var selectedArtwork:								ArtworkWrapper?		= nil
	public var previousArtworkID:							Int					= 0
	public var selectedDaughter:							Daughters			= .elena
	public var selectedYear:								Int					= 2013
	public fileprivate(set) var isSignedInYN: 				Bool = false
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager) {
		super.init(modelManager: modelManager)

	}
	
	
	// MARK: - Public Methods
	
	public func setupCacheing(managedObjectContext:	NSManagedObjectContext) {
		
		CacheManager.shared.set(managedObjectContext: managedObjectContext)
		AwardsCacheManager.shared.set(managedObjectContext: managedObjectContext)
		NewsSnippetsCacheManager.shared.set(managedObjectContext: managedObjectContext)
		
	}
	
	
	// MARK: - Public Methods
	
	public func checkIsSignedIn() -> Bool {
	
		self.isSignedInYN = self.isSignedInYN()

		return self.isSignedInYN
		
	}
	
	public func signIn(password: String, onSignInSuccessful completionHandler: ((Error?) -> Void)?) {
		
		// If a completionHandler is specified then set it, otherwise retain the existing completionHandler
		if (completionHandler != nil) {
			
			self.onSignInSuccessfulCompletionHandler = completionHandler
			
		}
		
		let email = ""	// Not required
		
		// Sign in
		AuthenticationManager.shared.signIn(withEmail: email, password: password)
	}
	
	public override func onSignInSuccessful(userProperties: UserProperties) {
		
		self.isSignedInYN = true
		
		// Call completion handler
		self.onSignInSuccessfulCompletionHandler?(nil)
		
	}
	
	public override func onSignInFailed(userProperties: UserProperties?,
										error: 			Error?,
										code: 			AuthenticationErrorCodes?) {
		
		self.isSignedInYN = false
		
		// Notify the delegate
		self.delegate?.galleryControlManagerBase(signInFailed: self)
		
	}
	
	
	// MARK: - Artworks
	
	public func loadArtworks(selectItemsAfterPreviousYN: Bool, oncomplete completionHandler:@escaping ([ArtworkWrapper], Error?) -> Void) {

		// Get category
		let category: ArtworkCategoryTypes = self.getArtworkCategory(from: self.selectedDaughter)
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadArtworksFromDataSourceCompletionHandler: (([ArtworkWrapper]?, Error?) -> Void) =
			{
				(items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Get the collection
					if let collection = self.getArtworkModelAdministrator().collection as? ArtworkCollection {
						
						// Merge to cache
						CacheManager.shared.mergeArtworksToCache(from: collection)
					}
					
					// Save to cache
					CacheManager.shared.saveArtworksToCache()
					
					// Call completion handler
					completionHandler(items!, error)
					
				} else {
					
					// Load from cache
					self.loadArtworksFromCache(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, category: category, year: self.selectedYear, oncomplete: completionHandler)
					
				}

			}
			
			// Load from cache
			if (CacheManager.shared.collection == nil) {
				let _: [Any] = CacheManager.shared.loadArtworksFromCache(category: category, year: self.selectedYear)
			}
			
			// Load from data source
			self.loadArtworksFromDataSource(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, category: category, year: self.selectedYear, oncomplete: loadArtworksFromDataSourceCompletionHandler)
			
		} else {

			// Load from cache
			self.loadArtworksFromCache(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, category: category, year: self.selectedYear, oncomplete: completionHandler)

		}
		
	}
	
	public func getArtworkModelAdministrator() -> ArtworkModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getArtworkModelAdministrator!
	}

	public func loadArtworkThumbnailImageData(for item: ArtworkWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.thumbnailImageFileName
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in

			if (imageData != nil) {
				
				item.thumbnailImageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					CacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
			
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.artworkImagesUrlRoot, oncomplete: loadImageDataCompletionHandler)
		
	}
	
	public func loadArtworkLargeImageData(for item: ArtworkWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.largeImageFileName
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in
			
			if (imageData != nil) {
				
				item.largeImageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					CacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.artworkImagesUrlRoot, oncomplete: loadImageDataCompletionHandler)
		
	}

	public func likeArtwork() {
		
		guard (self.selectedArtwork != nil) else { return }
		
		self.likeArtwork(for: self.selectedArtwork!)
		
	}
	
	public func likeArtwork(for item: ArtworkWrapper) {
		
		// Check is connected
		guard (self.checkIsConnected()) else { return }
		
		// Add like
		self.getArtworkModelAdministrator().addLike(id: item.id)
		
		// Update item
		item.numberofLikes += 1
		
		// Update the item in the cache
		if let collection = CacheManager.shared.collection {
			
			let artwork: Artwork? = collection.getItem(id: String(item.id)) as? Artwork
			
			if let artwork = artwork {
				
				artwork.numberofLikes = item.numberofLikes
				
				// Save to cache
				CacheManager.shared.saveArtworksToCache()
			}
		}
	}
	
	
	// MARK: - Awards
	
	public func loadAwards(oncomplete completionHandler:@escaping ([AwardWrapper], Error?) -> Void) {
		
		// Get category
		let category: ArtworkCategoryTypes = self.getArtworkCategory(from: self.selectedDaughter)
		
		// Create completion handler
		let loadAwardsCompletionHandler: (([AwardWrapper]?, Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in
			
			if (items != nil && error == nil) {
				
				// Load images
				self.loadAwardsImages(items: items!, oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(items!, error)
				
			}
			
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
		
			// Create completion handler
			let loadAwardsFromDataSourceCompletionHandler: (([AwardWrapper]?, Error?) -> Void) =
			{
				[unowned self] (items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Get the collection
					if let collection = self.getAwardModelAdministrator().collection as? AwardCollection {
						
						// Merge to cache
						AwardsCacheManager.shared.mergeToCache(from: collection)
					}
					
					// Save to cache
					AwardsCacheManager.shared.saveToCache()
					
					// Call completion handler
					loadAwardsCompletionHandler(items!, error)
					
				} else {
					
					// Load from cache
					self.loadAwardsFromCache(category: category, year: self.selectedYear, oncomplete: loadAwardsCompletionHandler)
					
				}
				
			}
		
			// Load from cache
			if (AwardsCacheManager.shared.collection == nil) {
				
				// Setup the cache
				AwardsCacheManager.shared.set(year: self.selectedYear, category: self.getArtworkCategory(from: self.selectedDaughter))
				
				AwardsCacheManager.shared.loadFromCache()
			}
		
			// Load from data source
			self.loadAwardsFromDataSource(category: category, year: self.selectedYear, oncomplete: loadAwardsFromDataSourceCompletionHandler)
			
		} else {

			// Load from cache
			self.loadAwardsFromCache(category: category, year: self.selectedYear, oncomplete: loadAwardsCompletionHandler)

		}
		
	}
	
	public func getAwardModelAdministrator() -> AwardModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getAwardModelAdministrator!
	}
	
	public func loadAwardImageData(for item: AwardWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.imageFileName
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in
			
			if (imageData != nil && UIImage(data: imageData!) != nil) {
				
				item.imageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					AwardsCacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
			
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.awardImagesUrlRoot, oncomplete: loadImageDataCompletionHandler)
		
	}
	

	// MARK: - NewsSnippets
	
	public func loadNewsSnippets(oncomplete completionHandler:@escaping ([NewsSnippetWrapper], Error?) -> Void) {
		
		// Get category
		let category: ArtworkCategoryTypes = self.getArtworkCategory(from: self.selectedDaughter)
		
		// Create completion handler
		let loadNewsSnippetsCompletionHandler: (([NewsSnippetWrapper]?, Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in
			
			if (items != nil && error == nil) {
				
				// Load images
				self.loadNewsSnippetsImages(items: items!, oncomplete: completionHandler)
				
			} else {
				
				// Call completion handler
				completionHandler(items!, error)
				
			}
			
		}
		
		// Check is connected
		if (self.checkIsConnected()) {
			
			// Create completion handler
			let loadNewsSnippetsFromDataSourceCompletionHandler: (([NewsSnippetWrapper]?, Error?) -> Void) =
			{
				[unowned self] (items, error) -> Void in
				
				if (items != nil && error == nil) {
					
					// Get the collection
					if let collection = self.getNewsSnippetModelAdministrator().collection as? NewsSnippetCollection {
						
						// Merge to cache
						NewsSnippetsCacheManager.shared.mergeToCache(from: collection)
					}
					
					// Save to cache
					NewsSnippetsCacheManager.shared.saveToCache()
					
					// Call completion handler
					loadNewsSnippetsCompletionHandler(items!, error)
					
				} else {
					
					// Load from cache
					self.loadNewsSnippetsFromCache(category: category, year: self.selectedYear, oncomplete: loadNewsSnippetsCompletionHandler)
					
				}
				
			}
			
			// Load from cache
			if (NewsSnippetsCacheManager.shared.collection == nil) {
				
				// Setup the cache
				NewsSnippetsCacheManager.shared.set(year: self.selectedYear, category: self.getArtworkCategory(from: self.selectedDaughter))
				
				NewsSnippetsCacheManager.shared.loadFromCache()
			}
			
			// Load from data source
			self.loadNewsSnippetsFromDataSource(category: category, year: self.selectedYear, oncomplete: loadNewsSnippetsFromDataSourceCompletionHandler)
			
		} else {
			
			// Load from cache
			self.loadNewsSnippetsFromCache(category: category, year: self.selectedYear, oncomplete: loadNewsSnippetsCompletionHandler)
			
		}
		
	}
	
	public func getNewsSnippetModelAdministrator() -> NewsSnippetModelAdministrator {
		
		return (self.modelManager! as! ModelManager).getNewsSnippetModelAdministrator!
	}
	
	public func loadNewsSnippetImageData(for item: NewsSnippetWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		let fileName: String	= item.imageFileName
		
		guard (fileName.count > 0) else {
			
			// Call completion handler
			completionHandler(nil, nil)
			return
			
		}
		
		// Create completion handler
		let loadImageDataCompletionHandler: ((Bool, Data?) -> Void) =
		{
			(isCachedYN, imageData) -> Void in
			
			if (imageData != nil && UIImage(data: imageData!) != nil) {
				
				item.imageData = imageData
				
				if (!isCachedYN) {
					
					// Save to cache
					NewsSnippetsCacheManager.shared.saveImageToCache(imageData: imageData!, fileName: fileName)
				}
				
			} else {
				// Error
			}
			
			// Call completion handler
			completionHandler(imageData, nil)
			
		}
		
		// Load image data
		self.loadImageData(fileName: fileName, urlRoot: self.newsSnippetImagesUrlRoot, oncomplete: loadImageDataCompletionHandler)
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func loadAwardsImages(items: [AwardWrapper], oncomplete completionHandler:@escaping ([AwardWrapper], Error?) -> Void) {
		
		var loadAwardImageDataResultCount: Int = 0
		
		// Create completion handler
		let loadAwardImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in

			loadAwardImageDataResultCount += 1
			
			// Call completion handler
			if (loadAwardImageDataResultCount >= items.count) {
				
				completionHandler(items, nil)
				
			}

		}

		// Go through each item
		for item in items {

			// Load image data
			self.loadAwardImageData(for: item, oncomplete: loadAwardImageDataCompletionHandler)

		}
		
	}
	
	fileprivate func loadNewsSnippetsImages(items: [NewsSnippetWrapper], oncomplete completionHandler:@escaping ([NewsSnippetWrapper], Error?) -> Void) {
		
		var loadNewsSnippetImageDataResultCount: Int = 0
		
		// Create completion handler
		let loadNewsSnippetImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			loadNewsSnippetImageDataResultCount += 1
			
			// Call completion handler
			if (loadNewsSnippetImageDataResultCount >= items.count) {
				
				completionHandler(items, nil)
				
			}
			
		}
		
		// Go through each item
		for item in items {
			
			// Load image data
			self.loadNewsSnippetImageData(for: item, oncomplete: loadNewsSnippetImageDataCompletionHandler)
			
		}
		
	}
	
	fileprivate func loadImageData(fileName: String, urlRoot: String, oncomplete completionHandler:@escaping (Bool, Data?) -> Void) {
		
		var imageData: Data? = nil
		
		// Load image from cache
		imageData = CacheManager.shared.loadImageFromCache(with: fileName)
		
		if (imageData != nil) {
			
			let isCachedYN: Bool = true
			
			// Call completion handler
			completionHandler(isCachedYN, imageData)
			
		} else {
			
			// Load image from URL
			self.loadImageDataFromUrl(fileName: fileName, urlRoot: urlRoot, oncomplete: completionHandler)
		}
	}
	
	fileprivate func loadImageDataFromUrl(fileName: String, urlRoot: String, oncomplete completionHandler:@escaping (Bool, Data?) -> Void) {
		
		guard (self.checkIsConnected()) else {
			
			// Call completion handler
			completionHandler(false, nil)
			
			return
		}
		
		let url:		URL					= URL(string: urlRoot + fileName)!
		let session:	URLSession			= URLSession.shared
		let request:	URLRequest			= URLRequest(url: url)
		
		let task:		URLSessionDataTask	= session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
			
			if let data = data {
				
				let isCachedYN: Bool = false
				
				// Call completion handler
				completionHandler(isCachedYN, data)
			}
			
		})
		
		task.resume()
	}
	
	fileprivate func getArtworkCategory(from daughter: Daughters) -> ArtworkCategoryTypes {
		
		var result: ArtworkCategoryTypes = .elena
		
		if (self.selectedDaughter == .sofia) {
			result = .sofia
		}
		
		return result
	}
	
	fileprivate func setStateBeforeLoad(selectItemsAfterPreviousYN: Bool) {
		
		self.isLoadingDataYN									= true
		self.previousArtworkID									= 0
		
		if (selectItemsAfterPreviousYN) {
			
			ArtworkWrappers.hasLoadedAllNextItemsYN				= true
			self.previousArtworkID								= ArtworkWrappers.items.last?.id ?? 0
			
			// Check previousArtworkID is 0
			if (self.previousArtworkID == 0) {
				ArtworkWrappers.hasLoadedAllPreviousItemsYN		= true
			}
			
		} else {
			
			ArtworkWrappers.hasLoadedAllPreviousItemsYN			= true
			self.previousArtworkID								= ArtworkWrappers.items.first?.id ?? 0
			
			// Check previousArtworkID is 0
			if (self.previousArtworkID == 0) {
				ArtworkWrappers.hasLoadedAllNextItemsYN			= true
			}
		}
	}
	
	
	// MARK: - Artworks
	
	fileprivate func loadArtworksFromDataSource(selectItemsAfterPreviousYN: Bool, category: ArtworkCategoryTypes, year: Int, oncomplete completionHandler:@escaping ([ArtworkWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [ArtworkWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedArtworksToWrappers(appendYN: selectItemsAfterPreviousYN)
			}

			// Set state
			self.setStateAfterLoad()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoad(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN)

		// Load data
		self.getArtworkModelAdministrator().select(byPreviousArtworkID: self.previousArtworkID, category: category.rawValue, year: year, numberofItemsToLoad: self.numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN, oncomplete: loadCompletionHandler)
	}
	
	fileprivate func loadArtworksFromCache(selectItemsAfterPreviousYN: Bool, category: ArtworkCategoryTypes, year: Int, oncomplete completionHandler:@escaping ([ArtworkWrapper], Error?) -> Void) {
		
		// Check cache is loaded
		if (CacheManager.shared.collection == nil) {
			
			// Load from cache
			let _: [Any] = CacheManager.shared.loadArtworksFromCache(category: self.getArtworkCategory(from: self.selectedDaughter), year: self.selectedYear)
		}
		
		// Set state
		self.setStateBeforeLoad(selectItemsAfterPreviousYN: selectItemsAfterPreviousYN)
		
		// Select items from the cache
		let cacheData: [Any] = CacheManager.shared.selectArtworks(byPreviousArtworkID: self.previousArtworkID, numberofItemsToLoad: self.numberofItemsToLoad, selectItemsAfterPreviousYN: selectItemsAfterPreviousYN)
		
		// Put loaded data into the model administrator collection
		self.getArtworkModelAdministrator().load(data: cacheData)
		
		// Copy items to wrappers array
		let result: [ArtworkWrapper] = self.loadedArtworksToWrappers(appendYN: selectItemsAfterPreviousYN)

		// Set state
		self.setStateAfterLoad()
		
		// Call completion handler
		completionHandler(result, nil)
		
	}

	fileprivate func loadedArtworksToWrappers(appendYN: Bool) -> [ArtworkWrapper] {
		
		var result:						[ArtworkWrapper]	= [ArtworkWrapper]()
		
		if let collection = self.getArtworkModelAdministrator().collection {
			
			let collection:				ArtworkCollection	= collection as! ArtworkCollection
			
			var numberofItemsAdded:		Int = 0
			
			// Go through each item
			for item in collection.items! {
				
				// Check not added more items than numberofItemsToLoad
				if (numberofItemsAdded < self.numberofItemsToLoad) {
					
					// Include items that are not deleted or obsolete
					if (item.status != .deleted && item.status != .obsolete) {
						
						// Get item wrapper
						let wrapper: ArtworkWrapper = (item as! Artwork).toWrapper()
						
						result.append(wrapper)
						
						numberofItemsAdded += 1
					}					
					
				}

			}
			
			if (!appendYN && result.count > 0) {
			
				// Prepend to artwork wrappers
				ArtworkWrappers.items.insert(contentsOf: result, at: 0)
				
				// Check number of items in result
				if (result.count >= self.numberofItemsToLoad) { ArtworkWrappers.hasLoadedAllPreviousItemsYN = false }

			} else if (appendYN && result.count > 0) {
				
				// Append to artwork wrappers
				ArtworkWrappers.items.append(contentsOf: result)
				
				// Check number of items in result
				if (result.count >= self.numberofItemsToLoad) { ArtworkWrappers.hasLoadedAllNextItemsYN = false }

			}

		}
		
		return result
	}
	
	
	// MARK: - Awards
	
	fileprivate func setStateBeforeLoadAwards() {
		
		self.isLoadingAwardsDataYN = true

	}

	fileprivate func setStateAfterLoadAwards() {
		
		self.isLoadingAwardsDataYN = false
		
	}
	
	fileprivate func loadAwardsFromDataSource(category: ArtworkCategoryTypes, year: Int, oncomplete completionHandler:@escaping ([AwardWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [AwardWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedAwardsToWrappers()
			}
			
			// Set state
			self.setStateAfterLoadAwards()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoadAwards()
		
		// Load data
		self.getAwardModelAdministrator().select(byCategory: category.rawValue, year: year, oncomplete: loadCompletionHandler)
		
	}
	
	fileprivate func loadAwardsFromCache(category: ArtworkCategoryTypes, year: Int, oncomplete completionHandler:@escaping ([AwardWrapper], Error?) -> Void) {
		
		// Check cache is loaded
		if (AwardsCacheManager.shared.collection == nil) {
			
			// Setup the cache
			AwardsCacheManager.shared.set(year: self.selectedYear, category: self.getArtworkCategory(from: self.selectedDaughter))
			
			// Load from cache
			AwardsCacheManager.shared.loadFromCache()
		}
		
		// Set state
		self.setStateBeforeLoadAwards()
		
		// Select items from the cache
		let cacheData: [Any] = AwardsCacheManager.shared.select()
		
		// Put loaded data into the model administrator collection
		self.getAwardModelAdministrator().load(data: cacheData)
		
		let result: [AwardWrapper] = self.loadedAwardsToWrappers()

		// Set state
		self.setStateAfterLoadAwards()
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
	fileprivate func loadedAwardsToWrappers() -> [AwardWrapper] {
		
		var result:						[AwardWrapper]	= [AwardWrapper]()
		
		if let collection = self.getAwardModelAdministrator().collection {
			
			let collection:				AwardCollection	= collection as! AwardCollection

			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: AwardWrapper = (item as! Award).toWrapper()
					
					result.append(wrapper)

				}
				
			}
			
			if (result.count > 0) {
				
				// Append to wrappers
				AwardWrappers.items.append(contentsOf: result)
				
			}
			
		}
		
		return result
	}

	
	// MARK: - NewsSnippets
	
	fileprivate func setStateBeforeLoadNewsSnippets() {
		
		self.isLoadingNewsSnippetsDataYN = true
		
	}
	
	fileprivate func setStateAfterLoadNewsSnippets() {
		
		self.isLoadingNewsSnippetsDataYN = false
		
	}
	
	fileprivate func loadNewsSnippetsFromDataSource(category: ArtworkCategoryTypes, year: Int, oncomplete completionHandler:@escaping ([NewsSnippetWrapper]?, Error?) -> Void) {
		
		// Create completion handler
		let loadCompletionHandler: (([Any]?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			var result: [NewsSnippetWrapper]? = nil
			
			if (data != nil && error == nil) {
				
				// Copy items to wrappers array
				result = self.loadedNewsSnippetsToWrappers()
			}
			
			// Set state
			self.setStateAfterLoadNewsSnippets()
			
			// Call completion handler
			completionHandler(result, error)
		}
		
		// Set state
		self.setStateBeforeLoadNewsSnippets()
		
		// Load data
		self.getNewsSnippetModelAdministrator().select(byCategory: category, year: year, oncomplete: loadCompletionHandler)
		
	}
	
	fileprivate func loadNewsSnippetsFromCache(category: ArtworkCategoryTypes, year: Int, oncomplete completionHandler:@escaping ([NewsSnippetWrapper], Error?) -> Void) {
		
		// Check cache is loaded
		if (NewsSnippetsCacheManager.shared.collection == nil) {
			
			// Setup the cache
			NewsSnippetsCacheManager.shared.set(year: self.selectedYear, category: self.getArtworkCategory(from: self.selectedDaughter))
			
			// Load from cache
			NewsSnippetsCacheManager.shared.loadFromCache()
		}
		
		// Set state
		self.setStateBeforeLoadNewsSnippets()
		
		// Select items from the cache
		let cacheData: [Any] = NewsSnippetsCacheManager.shared.select()
		
		// Put loaded data into the model administrator collection
		self.getNewsSnippetModelAdministrator().load(data: cacheData)
		
		let result: [NewsSnippetWrapper] = self.loadedNewsSnippetsToWrappers()
		
		// Set state
		self.setStateAfterLoadNewsSnippets()
		
		// Call completion handler
		completionHandler(result, nil)
		
	}
	
	fileprivate func loadedNewsSnippetsToWrappers() -> [NewsSnippetWrapper] {
		
		var result:						[NewsSnippetWrapper]	= [NewsSnippetWrapper]()
		
		if let collection = self.getNewsSnippetModelAdministrator().collection {
			
			let collection:				NewsSnippetCollection	= collection as! NewsSnippetCollection
			
			// Go through each item
			for item in collection.items! {
				
				// Include items that are not deleted or obsolete
				if (item.status != .deleted && item.status != .obsolete) {
					
					// Get item wrapper
					let wrapper: NewsSnippetWrapper = (item as! NewsSnippet).toWrapper()
					
					result.append(wrapper)
					
				}
				
			}
			
			if (result.count > 0) {
				
				// Append to wrappers
				NewsSnippetWrappers.items.append(contentsOf: result)
				
			}
			
		}
		
		return result
	}

}
