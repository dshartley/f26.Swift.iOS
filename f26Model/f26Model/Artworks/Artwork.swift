//
//  Artwork.swift
//  f26Model
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import f26Core

/// Encapsulates a Artwork model item
public class Artwork: ModelItemBase {

	// MARK: - Initializers
	
	private override init() {
		super.init()
	}
	
	public override init(collection: ProtocolModelItemCollection,
						 storageDateFormatter: DateFormatter) {
		super.init(collection: collection,
				   storageDateFormatter: storageDateFormatter)
	}
	
	
	// MARK: - Public Methods

	let nameKey: String = "name"
	
	/// Gets or sets the name
	public var name: String {
		get {
			
			return self.getProperty(key: nameKey)!
		}
		set(value) {
			
			self.setProperty(key: nameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let categoryKey: String = "category"
	
	/// Gets or sets the category
	public var category: ArtworkCategoryTypes {
		get {
			let i = Int(self.getProperty(key: categoryKey)!)!
			
			return ArtworkCategoryTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: categoryKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	let mediumKey: String = "medium"
	
	/// Gets or sets the medium
	public var medium: ArtworkMediumTypes {
		get {
			let i = Int(self.getProperty(key: mediumKey)!)!
			
			return ArtworkMediumTypes(rawValue: i)!
		}
		set(value) {
			
			let i = value.rawValue
			
			self.setProperty(key: mediumKey, value: String(i), setWhenInvalidYN: false)
		}
	}
	
	let sizeKey: String = "size"
	
	/// Gets or sets the size
	public var size: String {
		get {
			
			return self.getProperty(key: sizeKey)!
		}
		set(value) {
			
			self.setProperty(key: sizeKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let yearKey: String = "year"
	
	/// Gets or sets the year
	public var year: Int {
		get {
			
			return Int(self.getProperty(key: yearKey)!)!
		}
		set(value) {
			
			self.setProperty(key: yearKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let thumbnailimagefilenameKey: String = "thumbnailimagefilename"
	
	/// Gets or sets the thumbnailImageFileName
	public var thumbnailImageFileName: String {
		get {
			
			return self.getProperty(key: thumbnailimagefilenameKey)!
		}
		set(value) {
			
			self.setProperty(key: thumbnailimagefilenameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let largeimagefilenameKey: String = "largeimagefilename"
	
	/// Gets or sets the largeImageFileName
	public var largeImageFileName: String {
		get {
			
			return self.getProperty(key: largeimagefilenameKey)!
		}
		set(value) {
			
			self.setProperty(key: largeimagefilenameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let commentsKey: String = "comments"
	
	/// Gets or sets the comments
	public var comments: String {
		get {
			
			return self.getProperty(key: commentsKey)!
		}
		set(value) {
			
			self.setProperty(key: commentsKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let displayindexKey: String = "displayindex"
	
	/// Gets or sets the displayIndex
	public var displayIndex: Int {
		get {
			
			return Int(self.getProperty(key: displayindexKey)!)!
		}
		set(value) {
			
			self.setProperty(key: displayindexKey, value: String(value), setWhenInvalidYN: false)
		}
	}

	let numberoflikesKey: String = "numberoflikes"
	
	/// Gets or sets the numberofLikes
	public var numberofLikes: Int {
		get {
			
			return Int(self.getProperty(key: numberoflikesKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberoflikesKey, value: String(value), setWhenInvalidYN: false)
		}
	}

	let numberofartworkcommentsKey: String = "numberofartworkcomments"
	
	/// Gets or sets the numberofArtworkComments
	public var numberofArtworkComments: Int {
		get {
			
			return Int(self.getProperty(key: numberofartworkcommentsKey)!)!
		}
		set(value) {
			
			self.setProperty(key: numberofartworkcommentsKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let latestartworkcommentdatepostedKey: String = "latestartworkcommentdateposted"
	
	/// Gets or sets the latestArtworkCommentDatePosted
	public var latestArtworkCommentDatePosted: Date {
		get {
			
			var result: 				Date? = nil
			
			let dateString				= self.getProperty(key: latestartworkcommentdatepostedKey)!

			let dateFormatter			= DateFormatter()
			dateFormatter.dateFormat	= "dd-MM-yyyy"
			dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
			
			result = dateFormatter.date(from:dateString)

			guard (result != nil) else { return Date() }
			
			return result!
		}
		set(value) {
			
			let dateFormatter			= DateFormatter()
			dateFormatter.dateFormat	= "dd-MM-yyyy"
			dateFormatter.timeZone 		= TimeZone(secondsFromGMT: 0)
			
			let dateString 				= dateFormatter.string(from: value)
			
			self.setProperty(key: latestartworkcommentdatepostedKey, value: dateString, setWhenInvalidYN: false)
		}
	}

	let latestartworkcommentpostedbynameKey: String = "latestartworkcommentpostedbyname"
	
	/// Gets or sets the latestArtworkCommentPostedByName
	public var latestArtworkCommentPostedByName: String {
		get {
			
			return self.getProperty(key: latestartworkcommentpostedbynameKey)!
		}
		set(value) {
			
			self.setProperty(key: latestartworkcommentpostedbynameKey, value: value, setWhenInvalidYN: false)
		}
	}

	let latestartworkcommenttextKey: String = "latestartworkcommenttext"
	
	/// Gets or sets the latestArtworkCommentText
	public var latestArtworkCommentText: String {
		get {
			
			return self.getProperty(key: latestartworkcommenttextKey)!
		}
		set(value) {
			
			self.setProperty(key: latestartworkcommenttextKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let thumbnailimagewidthpixelsKey: String = "thumbnailimagewidthpixels"
	
	/// Gets or sets the thumbnailImageWidthPixels
	public var thumbnailImageWidthPixels: Int {
		get {
			
			return Int(self.getProperty(key: thumbnailimagewidthpixelsKey)!)!
		}
		set(value) {
			
			self.setProperty(key: thumbnailimagewidthpixelsKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let thumbnailimageheightpixelsKey: String = "thumbnailimageheightpixels"
	
	/// Gets or sets the thumbnailImageHeightPixels
	public var thumbnailImageHeightPixels: Int {
		get {
			
			return Int(self.getProperty(key: thumbnailimageheightpixelsKey)!)!
		}
		set(value) {
			
			self.setProperty(key: thumbnailimageheightpixelsKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	public func clone(wrapper: ArtworkWrapper) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
			
		self.id									= String(wrapper.id)
		self.name								= wrapper.name
		self.category							= wrapper.category
		self.medium								= wrapper.medium
		self.size								= wrapper.size
		self.year								= wrapper.year
		self.thumbnailImageFileName				= wrapper.thumbnailImageFileName
		self.largeImageFileName					= wrapper.largeImageFileName
		self.comments							= wrapper.comments
		self.displayIndex						= wrapper.displayIndex
		self.numberofLikes						= wrapper.numberofLikes
		self.numberofArtworkComments			= wrapper.numberofArtworkComments
		self.latestArtworkCommentDatePosted		= wrapper.latestArtworkCommentDatePosted
		self.latestArtworkCommentPostedByName	= wrapper.latestArtworkCommentPostedByName
		self.latestArtworkCommentText			= wrapper.latestArtworkCommentText
		self.thumbnailImageWidthPixels			= Int(wrapper.thumbnailImageWidthPixels)
		self.thumbnailImageHeightPixels			= Int(wrapper.thumbnailImageHeightPixels)
		
		self.doValidationsYN = doValidationsYN
		
	}
	
	public func toWrapper() -> ArtworkWrapper {
		
		let wrapper = ArtworkWrapper()
		
		wrapper.id									= Int.init(self.id)!
		wrapper.name								= self.name
		wrapper.category							= self.category
		wrapper.medium								= self.medium
		wrapper.size								= self.size
		wrapper.year								= self.year
		wrapper.thumbnailImageFileName				= self.thumbnailImageFileName
		wrapper.largeImageFileName					= self.largeImageFileName
		wrapper.comments							= self.comments
		wrapper.displayIndex						= self.displayIndex
		wrapper.numberofLikes						= self.numberofLikes
		wrapper.numberofArtworkComments				= self.numberofArtworkComments
		wrapper.latestArtworkCommentDatePosted		= self.latestArtworkCommentDatePosted
		wrapper.latestArtworkCommentPostedByName	= self.latestArtworkCommentPostedByName
		wrapper.latestArtworkCommentText			= self.latestArtworkCommentText
		wrapper.thumbnailImageWidthPixels			= CGFloat(self.thumbnailImageWidthPixels)
		wrapper.thumbnailImageHeightPixels			= CGFloat(self.thumbnailImageHeightPixels)
		
		return wrapper
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,									value: "0")
		self.doSetProperty(key: nameKey,								value: "")
		self.doSetProperty(key: categoryKey,							value: "1")
		self.doSetProperty(key: mediumKey,								value: "1")
		self.doSetProperty(key: sizeKey,								value: "")
		self.doSetProperty(key: yearKey,								value: "1900")
		self.doSetProperty(key: thumbnailimagefilenameKey,				value: "")
		self.doSetProperty(key: largeimagefilenameKey,					value: "")
		self.doSetProperty(key: commentsKey,							value: "")
		self.doSetProperty(key: displayindexKey,						value: "0")
		self.doSetProperty(key: numberoflikesKey,						value: "0")
		self.doSetProperty(key: numberofartworkcommentsKey,				value: "0")
		self.doSetProperty(key: latestartworkcommentdatepostedKey,		value: "1/1/1900")
		self.doSetProperty(key: latestartworkcommentpostedbynameKey,	value: "")
		self.doSetProperty(key: latestartworkcommenttextKey,			value: "")
		self.doSetProperty(key: thumbnailimagewidthpixelsKey,			value: "0")
		self.doSetProperty(key: thumbnailimageheightpixelsKey,			value: "0")
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.artwork_id.rawValue
		endEnumIndex	= ModelProperties.artwork_thumbnailImageHeightPixels.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]									= ModelProperties.artwork_id.rawValue
		keys[nameKey]								= ModelProperties.artwork_name.rawValue
		keys[categoryKey]							= ModelProperties.artwork_category.rawValue
		keys[mediumKey]								= ModelProperties.artwork_medium.rawValue
		keys[sizeKey]								= ModelProperties.artwork_size.rawValue
		keys[yearKey]								= ModelProperties.artwork_year.rawValue
		keys[thumbnailimagefilenameKey]				= ModelProperties.artwork_thumbnailImageFileName.rawValue
		keys[largeimagefilenameKey]					= ModelProperties.artwork_largeImageFileName.rawValue
		keys[commentsKey]							= ModelProperties.artwork_comments.rawValue
		keys[displayindexKey]						= ModelProperties.artwork_displayIndex.rawValue
		keys[numberoflikesKey]						= ModelProperties.artwork_numberofLikes.rawValue
		keys[numberofartworkcommentsKey]			= ModelProperties.artwork_numberofArtworkComments.rawValue
		keys[latestartworkcommentdatepostedKey]		= ModelProperties.artwork_latestArtworkCommentDatePosted.rawValue
		keys[latestartworkcommentpostedbynameKey]	= ModelProperties.artwork_latestArtworkCommentPostedByName.rawValue
		keys[latestartworkcommenttextKey]			= ModelProperties.artwork_latestArtworkCommentText.rawValue
		keys[thumbnailimagewidthpixelsKey]		= ModelProperties.artwork_thumbnailImageWidthPixels.rawValue
		keys[thumbnailimageheightpixelsKey]		= ModelProperties.artwork_thumbnailImageHeightPixels.rawValue
	}
	
	public override var dataType: String {
		get {
			return "artwork"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
		
		// Copy all properties from the specified item
		if let item = item as? Artwork {
			
			self.id									= item.id
			self.name								= item.name
			self.category							= item.category
			self.medium								= item.medium
			self.size								= item.size
			self.year								= item.year
			self.thumbnailImageFileName				= item.thumbnailImageFileName
			self.largeImageFileName					= item.largeImageFileName
			self.comments							= item.comments
			self.displayIndex						= item.displayIndex
			self.numberofLikes						= item.numberofLikes
			self.numberofArtworkComments			= item.numberofArtworkComments
			self.latestArtworkCommentDatePosted		= item.latestArtworkCommentDatePosted
			self.latestArtworkCommentPostedByName	= item.latestArtworkCommentPostedByName
			self.latestArtworkCommentText			= item.latestArtworkCommentText
			self.thumbnailImageWidthPixels			= item.thumbnailImageWidthPixels
			self.thumbnailImageHeightPixels			= item.thumbnailImageHeightPixels
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		switch toProperty(propertyEnum: propertyEnum) {
		case .artwork_latestArtworkCommentPostedByName:
			result = self.isValidLatestArtworkCommentPostedByName(value: value)
			break
			
		case .artwork_latestArtworkCommentText:
			result = self.isValidLatestArtworkCommentText(value: value)
			break
			
		default:
			break
		}
		
		return result
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func toProperty(propertyEnum: Int) -> ModelProperties {
		
		return ModelProperties(rawValue: propertyEnum)!
	}
	
	
	// MARK: - Validations
	
	fileprivate func isValidLatestArtworkCommentPostedByName(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 50, propertyName: "LatestArtworkCommentPostedByName")
		
		return result
	}
	
	fileprivate func isValidLatestArtworkCommentText(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 250, propertyName: "LatestArtworkCommentText")
		
		return result
	}
	
}
