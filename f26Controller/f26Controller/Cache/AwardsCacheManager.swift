//
//  AwardsCacheManager.swift
//  f26Controller
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import SFController
import f26Core
import f26Model

/// Manages cacheing for Awards model data
public class AwardsCacheManager: CacheManagerBase {

	// MARK: - Private Static Properties
	
	fileprivate static var singleton:		AwardsCacheManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var year:		Int = 0
	public fileprivate(set) var category:	ArtworkCategoryTypes = .elena
	
	
	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
		
		self.entityName = "Awards"
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: AwardsCacheManager {
		get {
			
			if (AwardsCacheManager.singleton == nil) {
				AwardsCacheManager.singleton = AwardsCacheManager()
			}
			
			return AwardsCacheManager.singleton!
		}
	}
	
	
	// MARK: - Public Methods
	
	public func set(year: Int, category: ArtworkCategoryTypes) {
		
		self.year 		= year
		self.category 	= category
		
		// Set predicate
		self.predicate = NSPredicate(format: "year == %@ AND category == %@", argumentArray: [year, String(category.rawValue)])
		
	}
	
	
	// MARK: - Override Methods
	
	public override func initialiseCacheData() {
		
		self.collection	= AwardCollection()
		
	}
	
	public override func setAttributes(cacheData: NSManagedObject) {
		
		// Set year
		cacheData.setValue(self.year, forKeyPath: "year")
		
		// Set category
		cacheData.setValue(self.category.rawValue, forKeyPath: "category")
		
	}
	
}
