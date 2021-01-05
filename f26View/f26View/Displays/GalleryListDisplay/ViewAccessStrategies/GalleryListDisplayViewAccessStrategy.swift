//
//  GalleryListDisplayViewAccessStrategy.swift
//  f26View
//
//  Created by David on 09/08/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f26Core

/// A strategy for accessing the GalleryListDisplay view
public class GalleryListDisplayViewAccessStrategy {

	// MARK: - Private Stored Properties
	
	fileprivate weak var awardsBarView: ProtocolAwardsBarView?
	
	
	// MARK: - Initializers
	
	public init() {
		
	}
	
	
	// MARK: - Public Methods
	
	public func setup(awardsBarView: ProtocolAwardsBarView) {
		
		self.awardsBarView = awardsBarView
		
	}
	
}

// MARK: - Extension ProtocolGalleryListDisplayViewAccessStrategy

extension GalleryListDisplayViewAccessStrategy: ProtocolGalleryListDisplayViewAccessStrategy {

	// MARK: - Methods
	
	public func displayAwards(items: [AwardWrapper]) {
		
		self.awardsBarView!.displayAwards(items: items)
		
	}
	
	public func clearAwards() {
		
		self.awardsBarView!.clearAwards()
		
	}

	public func displayNewsSnippets(items: [NewsSnippetWrapper]) {
		
		//self.awardsBarView!.displayAwards(items: items)
		
	}
	
	public func clearNewsSnippets() {
		
		//self.awardsBarView!.clearAwards()
		
	}
	
}
