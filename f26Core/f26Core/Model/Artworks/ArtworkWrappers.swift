//
//  ArtworkWrappers.swift
//  f26Core
//
//  Created by David on 20/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

/// A singleton class which encapsulates an array of ArtworkWrappers
public class ArtworkWrappers {

	// MARK: - Private Stored Properties
	
	fileprivate var items:							[ArtworkWrapper] = [ArtworkWrapper]()
	fileprivate var hasLoadedAllPreviousItemsYN:	Bool = false
	fileprivate var hasLoadedAllNextItemsYN:		Bool = false
	
	
	// MARK: - Private Static Properties
	
	fileprivate static var singleton:				ArtworkWrappers?
	
	
	// MARK: - Initializers
	
	fileprivate init() {
	}
	
	
	// MARK: - Public Class Computed Properties
	
	public class var items: [ArtworkWrapper] {
		get {
			
			return ArtworkWrappers.getSingleton.items
		}
		set (value) {
			
			ArtworkWrappers.getSingleton.items = value
		}
	}

	public class var hasLoadedAllPreviousItemsYN: Bool {
		get {
			
			return ArtworkWrappers.getSingleton.hasLoadedAllPreviousItemsYN
		}
		set (value) {
			
			ArtworkWrappers.getSingleton.hasLoadedAllPreviousItemsYN = value
		}
	}
	
	public class var hasLoadedAllNextItemsYN: Bool {
		get {
			
			return ArtworkWrappers.getSingleton.hasLoadedAllNextItemsYN
		}
		set (value) {
			
			ArtworkWrappers.getSingleton.hasLoadedAllNextItemsYN = value
		}
	}
	
	
	// MARK: - Private Class Computed Properties
	
	fileprivate class var getSingleton: ArtworkWrappers {
		get {
			
			if (ArtworkWrappers.singleton == nil) {
				ArtworkWrappers.singleton = ArtworkWrappers()
			}
			
			return ArtworkWrappers.singleton!
		}
	}
}
