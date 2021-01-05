//
//  Award.swift
//  f26Model
//
//  Created by David on 08/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import f26Core

/// Encapsulates a Award model item
public class Award: ModelItemBase {
	
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
	
	let textKey: String = "text"
	
	/// Gets or sets the text
	public var text: String {
		get {
			
			return self.getProperty(key: textKey)!
		}
		set(value) {
			
			self.setProperty(key: textKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let imagefilenameKey: String = "imagefilename"
	
	/// Gets or sets the imageFileName
	public var imageFileName: String {
		get {
			
			return self.getProperty(key: imagefilenameKey)!
		}
		set(value) {
			
			self.setProperty(key: imagefilenameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let competitionnameKey: String = "competitionname"
	
	/// Gets or sets the competitionName
	public var competitionName: String {
		get {
			
			return self.getProperty(key: competitionnameKey)!
		}
		set(value) {
			
			self.setProperty(key: competitionnameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let quoteKey: String = "quote"
	
	/// Gets or sets the quote
	public var quote: String {
		get {
			
			return self.getProperty(key: quoteKey)!
		}
		set(value) {
			
			self.setProperty(key: quoteKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let urlKey: String = "url"
	
	/// Gets or sets the url
	public var url: String {
		get {
			
			return self.getProperty(key: urlKey)!
		}
		set(value) {
			
			self.setProperty(key: urlKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	public func toWrapper() -> AwardWrapper {
		
		let wrapper = AwardWrapper()
		
		wrapper.id					= Int.init(self.id)!
		
		wrapper.category			= self.category
		wrapper.year				= self.year
		wrapper.text				= self.text
		wrapper.imageFileName		= self.imageFileName
		wrapper.competitionName		= self.competitionName
		wrapper.quote				= self.quote
		wrapper.url					= self.url
		
		return wrapper
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,				value: "0")
		self.doSetProperty(key: categoryKey,		value: "1")
		self.doSetProperty(key: yearKey,			value: "1900")
		self.doSetProperty(key: textKey,			value: "")
		self.doSetProperty(key: imagefilenameKey,	value: "")
		self.doSetProperty(key: competitionnameKey,	value: "")
		self.doSetProperty(key: quoteKey,			value: "")
		self.doSetProperty(key: urlKey,				value: "")
		
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.award_id.rawValue
		endEnumIndex	= ModelProperties.award_url.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]					= ModelProperties.award_id.rawValue
		keys[categoryKey]			= ModelProperties.award_category.rawValue
		keys[yearKey]				= ModelProperties.award_year.rawValue
		keys[textKey]				= ModelProperties.award_text.rawValue
		keys[imagefilenameKey]		= ModelProperties.award_imageFileName.rawValue
		keys[competitionnameKey]	= ModelProperties.award_competitionName.rawValue
		keys[quoteKey]				= ModelProperties.award_quote.rawValue
		keys[urlKey]				= ModelProperties.award_url.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "award"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
		
		// Copy all properties from the specified item
		if let item = item as? Award {
			
			self.id					= item.id
			self.category			= item.category
			self.year				= item.year
			self.text				= item.text
			self.imageFileName		= item.imageFileName
			self.competitionName	= item.competitionName
			self.quote				= item.quote
			self.url				= item.url
			
		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		switch toProperty(propertyEnum: propertyEnum) {
		case .award_text:
			result = self.isValidText(value: value)
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
	
	fileprivate func isValidText(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 250, propertyName: "Text")
		
		return result
	}
	
}


