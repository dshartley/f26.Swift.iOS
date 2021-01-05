//
//  GallerySlideshowDeck.swift
//  f26
//
//  Created by David on 07/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit

/// Specifies deck names
public enum DeckNames {
	case left
	case center
	case right
}

/// Specifies deck index positions
public enum DeckIndexPositions {
	case top
	case bottom
}

public class GallerySlideshowDeck {

	// MARK: - Public Stored Properties
	
	public var name:								DeckNames = .left
	public fileprivate(set) var items				= [GallerySlideshowItemView]()
	public fileprivate(set) var leadingPosition:	CGFloat	= 0
	public var isFullYN:							Bool = false
	public var isEmptyYN:							Bool = true
	

	// MARK: - Initializers
	
	private init() {
	}
	
	public init(name: DeckNames, width: CGFloat) {
		
		self.name	= name
	}
	
	
	// MARK: - Public Methods
	
	public func clear() {
		
		// Go through each slideshow item
		for (_, item) in self.items.enumerated() {
			
			item.clear()
		}
		
		self.isEmptyYN	= true
		self.isFullYN	= false
	}
	
	public func getTopItem() -> GallerySlideshowItemView? {
	
		guard (self.items.count > 0) else { return nil }
		
		return self.items.first
	}
	
	public func pop(position: DeckIndexPositions) -> GallerySlideshowItemView? {
		
		guard (self.items.count > 0) else { return nil }
		
		var result: GallerySlideshowItemView? = nil
		
		if (position == .top) {
			
			result = self.items.first
			self.items.removeFirst()
			
		} else if (position == .bottom) {
			
			result = self.items.last
			self.items.removeLast()
			
		}
		
		result?.deck = nil
		
		return result
	}
	
	public func push(item: GallerySlideshowItemView, position: DeckIndexPositions) {
		
		item.deck = self
		
		if (item.dataItem != nil) { self.isEmptyYN = false }
		
		// Set item leading constant
		item.set(leadingConstant: self.leadingPosition)
		
		if (position == .top) {
			
			self.items.insert(item, at: 0)
			
		} else if (position == .bottom) {
			
			self.items.append(item)
		}
	}
	
	public func set(leadingPosition: CGFloat) {
		
		self.leadingPosition = leadingPosition
		
		// Go through each item
		for (_, item) in self.items.enumerated() {
			
			item.set(leadingConstant: leadingPosition)
		}
	}
	
	public func setLeadingPositions() {
		
		// Go through each item
		for (_, item) in self.items.enumerated() {
			
			item.leadingConstraint?.constant = self.leadingPosition
		}
	}
	
	public func setSlideshowIndexes() {
		
		// Go through each item
		for (index, item) in self.items.enumerated() {
			
			var slideshowIndex = index
			
			if (self.name == .left) {
				slideshowIndex = (0 - (slideshowIndex + 1))
			} else if (self.name == .right) {
				slideshowIndex = (0 + (slideshowIndex + 1))
			}
			
			item.slideshowIndex = slideshowIndex
		}
		
	}
	
}
