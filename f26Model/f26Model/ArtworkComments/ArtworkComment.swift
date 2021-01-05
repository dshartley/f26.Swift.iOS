//
//  ArtworkComment.swift
//  f26Model
//
//  Created by David on 25/10/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import SFModel
import SFCore
import f26Core

/// Encapsulates a ArtworkComment model item
public class ArtworkComment: ModelItemBase {
	
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
	
	let artworkidKey: String = "artworkid"
	
	/// Gets or sets the artworkID
	public var artworkID: Int {
		get {
			
			return Int(self.getProperty(key: artworkidKey)!)!
		}
		set(value) {
			
			self.setProperty(key: artworkidKey, value: String(value), setWhenInvalidYN: false)
		}
	}
	
	let datepostedKey: String = "dateposted"
	
	/// Gets or sets the datePosted
	public var datePosted: Date {		
		get {
			
			let dateString = self.getProperty(key: datepostedKey)!
			
			return DateHelper.getDate(fromString: dateString, fromDateFormatter: self.storageDateFormatter!)
			
		}
		set(value) {
			
			self.setProperty(key: datepostedKey, value: self.getStorageDateString(fromDate: value), setWhenInvalidYN: false)
		}
	}
	
	let postedbynameKey: String = "postedbyname"
	
	/// Gets or sets the postedByName
	public var postedByName: String {
		get {
			
			return self.getProperty(key: postedbynameKey)!
		}
		set(value) {
			
			self.setProperty(key: postedbynameKey, value: value, setWhenInvalidYN: false)
		}
	}
	
	let postedbyemailKey: String = "postedbyemail"
	
	/// Gets or sets the postedByEmail
	public var postedByEmail: String {
		get {
			
			return self.getProperty(key: postedbyemailKey)!
		}
		set(value) {
			
			self.setProperty(key: postedbyemailKey, value: value, setWhenInvalidYN: false)
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
	
	public func toWrapper() -> ArtworkCommentWrapper {
		
		let wrapper = ArtworkCommentWrapper()
		
		wrapper.id				= Int.init(self.id)!
		wrapper.artworkID		= self.artworkID
		wrapper.datePosted		= self.datePosted
		wrapper.postedByName	= self.postedByName
		wrapper.postedByEmail	= self.postedByEmail
		wrapper.text			= self.text

		return wrapper
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseDataNode() {
		
		// Setup the node data
		
		self.doSetProperty(key: idKey,				value: "0")
		self.doSetProperty(key: artworkidKey,		value: "0")
		self.doSetProperty(key: datepostedKey,		value: "1/1/1900")
		self.doSetProperty(key: postedbynameKey,	value: "")
		self.doSetProperty(key: postedbyemailKey,	value: "")
		self.doSetProperty(key: textKey,			value: "")
	}
	
	public override func initialiseDataItem() {
		
		// Setup foreign key dependency helpers
	}
	
	public override func initialisePropertyIndexes() {
		
		// Define the range of the properties using the enum values
		
		startEnumIndex	= ModelProperties.artworkComment_id.rawValue
		endEnumIndex	= ModelProperties.artworkComment_text.rawValue
		
	}
	
	public override func initialisePropertyKeys() {
		
		// Populate the dictionary of property keys
		
		keys[idKey]				= ModelProperties.artworkComment_id.rawValue
		keys[artworkidKey]		= ModelProperties.artworkComment_artworkID.rawValue
		keys[datepostedKey]		= ModelProperties.artworkComment_datePosted.rawValue
		keys[postedbynameKey]	= ModelProperties.artworkComment_postedByName.rawValue
		keys[postedbyemailKey]	= ModelProperties.artworkComment_postedByEmail.rawValue
		keys[textKey]			= ModelProperties.artworkComment_text.rawValue
		
	}
	
	public override var dataType: String {
		get {
			return "artworkComment"
		}
	}
	
	public override func clone(item: ProtocolModelItem) {
		
		// Validations should not be performed when cloning the item
		let doValidationsYN: Bool = self.doValidationsYN
		self.doValidationsYN = false
		
		// Copy all properties from the specified item
		if let item = item as? ArtworkComment {
			
			self.id					= item.id
			self.artworkID			= item.artworkID
			self.datePosted			= item.datePosted
			self.postedByName		= item.postedByName
			self.postedByEmail		= item.postedByEmail
			self.text				= item.text

		}
		
		self.doValidationsYN = doValidationsYN
	}
	
	public override func isValid(propertyEnum: Int, value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = ValidationResultTypes.passed
		
		// Perform validations for the specified property
		switch toProperty(propertyEnum: propertyEnum) {
		case .artworkComment_postedByName:
			result = self.isValidPostedByName(value: value)
			break
			
		case .artworkComment_text:
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
	
	fileprivate func isValidPostedByName(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 50, propertyName: "PostedByName")
		
		return result
	}
	
	fileprivate func isValidText(value: String) -> ValidationResultTypes {
		
		var result: ValidationResultTypes = .passed
		
		result = self.checkMaxLength(value: value, maxLength: 250, propertyName: "Text")
		
		return result
	}
	
}

