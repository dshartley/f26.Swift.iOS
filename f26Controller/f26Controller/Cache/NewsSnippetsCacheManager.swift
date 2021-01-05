//
//  NewsSnippetsCacheManager.swift
//  f26Controller
//
//  Created by David on 05/04/2018.
//  Copyright © 2018 com.smartfoundation. All rights reserved.
//

import CoreData
import SFController
import f26Core
import f26Model

/// Manages cacheing for NewsSnippets model data
public class NewsSnippetsCacheManager: CacheManagerBase {
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:		NewsSnippetsCacheManager?
	
	
	// MARK: - Public Stored Properties
	
	public fileprivate(set) var year:		Int = 0
	public fileprivate(set) var category:	ArtworkCategoryTypes = .elena
	
	
	// MARK: - Initializers
	
	fileprivate override init() {
		super.init()
		
		self.entityName = "NewsSnippets"
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var shared: NewsSnippetsCacheManager {
		get {
			
			if (NewsSnippetsCacheManager.singleton == nil) {
				NewsSnippetsCacheManager.singleton = NewsSnippetsCacheManager()
			}
			
			return NewsSnippetsCacheManager.singleton!
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
		
		self.collection	= NewsSnippetCollection()
		
	}
	
	public override func setAttributes(cacheData: NSManagedObject) {
		
		// Set year
		cacheData.setValue(self.year, forKeyPath: "year")
		
		// Set category
		cacheData.setValue(self.category.rawValue, forKeyPath: "category")
		
	}
	
}
