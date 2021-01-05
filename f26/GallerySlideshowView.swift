//
//  GallerySlideshowView.swift
//  f26
//
//  Created by David on 05/09/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFView
import f26Core

/// A view class for a GallerySlideshowView
public class GallerySlideshowView: UIView {

	// MARK: - Private Stored Properties
	
	fileprivate var panGestureHelper:		PanGestureHelper?
	fileprivate var currentDataIndex:		Int = 0
	fileprivate var slideshowItems:			[GallerySlideshowItemView]?
	fileprivate var currentSlideshowItem:	GallerySlideshowItemView?
	fileprivate var isPanningYN:			Bool = false
	fileprivate var isAwaitingPreloadYN:	Bool = false
	fileprivate let numberofItemsInDeck:	Int = 3
	fileprivate var leftDeck:				GallerySlideshowDeck?
	fileprivate var centerDeck:				GallerySlideshowDeck?
	fileprivate var rightDeck:				GallerySlideshowDeck?
	

	// MARK: - Public Stored Properties
	
	public var delegate:					ProtocolGallerySlideshowViewDelegate?

	@IBOutlet var contentView:				UIView!
	@IBOutlet var panGestureRecognizer:		UIPanGestureRecognizer!
	
	
	// MARK: - Public Computed Properties
	
	public var selected: ArtworkWrapper? {
		get {
			guard (self.currentSlideshowItem != nil) else { return nil }
			
			return self.currentSlideshowItem!.dataItem
		}
	}
	
	
	// MARK: - Initializers
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.setup()
	}
	

	// MARK: - Public Methods
	
	public func setDeckPositions(deckWidth: CGFloat) {
		
		self.calculateDeckPositions(deckWidth: deckWidth)
	}
	
	public func setup() {
		
		self.setupContentView()
		self.setupPanGestureHelper()
		self.setupDecks()
	}
	
	public func clear() {
		
		self.currentSlideshowItem = nil
		
		// Clear decks
		self.leftDeck!.clear()
		self.centerDeck!.clear()
		self.rightDeck!.clear()
		
		// Go through each slideshow item
		if (self.slideshowItems != nil) {
			for (_, item) in self.slideshowItems!.enumerated() {
				
				item.clear()
			}
		}

	}
	
	public func set(currentDataIndex: Int) {
	
		var currentDataIndex = currentDataIndex
		
		self.clear()

		// Check currentDataIndex is valid
		if (currentDataIndex > ArtworkWrappers.items.count - 1) {
			currentDataIndex = 0
		}
		
		self.currentDataIndex		= currentDataIndex
		
		// Populate decks
		self.populateItems(of: self.centerDeck!)
		self.populateItems(of: self.leftDeck!)
		self.populateItems(of: self.rightDeck!)

		// Set currentSlideshowItem
		self.currentSlideshowItem	= self.centerDeck!.getTopItem()
		
	}
	
	public func preloadPrevious(dataItems: [ArtworkWrapper]) {
		
		// Reset current data index
		self.currentDataIndex += dataItems.count
		
		// Populate items of left deck
		self.populateItems(of: self.leftDeck!)
		
		self.isAwaitingPreloadYN = false
	}

	public func preloadNext(dataItems: [ArtworkWrapper]) {
		
		// Populate items of right deck
		self.populateItems(of: self.rightDeck!)
		
		self.isAwaitingPreloadYN = false
	}
	
	public func set(gestureUpCommitThreshold: CGFloat) {
		
		self.panGestureHelper?.gestureUpEnableThresholdYN		= true
		self.panGestureHelper?.gestureUpCommitThreshold			= gestureUpCommitThreshold
	}
	
	public func set(gestureDownCommitThreshold: CGFloat) {
		
		self.panGestureHelper?.gestureDownEnableThresholdYN		= true
		self.panGestureHelper?.gestureDownCommitThreshold		= gestureDownCommitThreshold
	}
	
	public func set(gestureRightCommitThreshold: CGFloat) {
		
		self.panGestureHelper?.gestureRightEnableThresholdYN	= true
		self.panGestureHelper?.gestureRightCommitThreshold		= gestureRightCommitThreshold
	}
	
	public func set(gestureLeftCommitThreshold: CGFloat) {
		
		self.panGestureHelper?.gestureLeftEnableThresholdYN		= true
		self.panGestureHelper?.gestureLeftCommitThreshold		= gestureLeftCommitThreshold
	}
	
	public func cancelPreload() {
	
		self.isAwaitingPreloadYN = false
	}
	
	public func next() {
		
		// Check if right deck is empty
		if (self.rightDeck!.isEmptyYN) { return }
		
		self.currentDataIndex += 1
		
		self.switchCurrentItem(onDeck: self.leftDeck!, offDeck: self.rightDeck!)
	}
	
	public func previous() {
		
		// Check if left deck is empty
		if (self.leftDeck!.isEmptyYN) { return }
		
		self.currentDataIndex -= 1
		
		self.switchCurrentItem(onDeck: self.rightDeck!, offDeck: self.leftDeck!)
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setupContentView() {
		
		// Load xib
		Bundle.main.loadNibNamed("GallerySlideshowView", owner: self, options: nil)
		
		self.contentView.frame = self.bounds
		
		self.addSubview(contentView)
		
		self.contentView.layoutIfNeeded()
		
		self.contentView.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
		self.contentView.translatesAutoresizingMaskIntoConstraints = false

		// Create autolayout constraints
		// leadingConstraint
		let leadingConstraint	= NSLayoutConstraint(item: self.contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		
		// trailingConstraint
		let trailingConstraint	= NSLayoutConstraint(item: self.contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
		
		// topConstraint
		let topConstraint		= NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
		
		// bottomConstraint
		let bottomConstraint	= NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)

		self.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])

	}

	fileprivate func setupPanGestureHelper() {
		
		self.panGestureHelper				= PanGestureHelper(gesture: self.panGestureRecognizer)
		
		self.panGestureHelper!.delegate		= self
	}
	
	fileprivate func setupDecks() {
		
		// Get deck width and height
		let deckWidth:		CGFloat	= self.contentView!.frame.width

		// Create decks
		self.leftDeck				= GallerySlideshowDeck(name: .left, width: deckWidth)
		self.centerDeck				= GallerySlideshowDeck(name: .center, width: deckWidth)
		self.rightDeck				= GallerySlideshowDeck(name: .right, width: deckWidth)
		
		// Calculate deck positions
		self.calculateDeckPositions(deckWidth: deckWidth)
		
		// Populate decks
		var item: GallerySlideshowItemView? = nil
		
		for index in 1...self.numberofItemsInDeck {
			
			// Add item to left deck
			item = self.createSlideshowItem(from: nil)
			item!.slideshowIndex = (0 - index)
			self.leftDeck!.push(item: item!, position: .bottom)
			
			// Add item to right deck
			item = self.createSlideshowItem(from: nil)
			item!.slideshowIndex = (0 + index)
			self.rightDeck!.push(item: item!, position: .bottom)
		}
		
		// Add item to center deck
		item = self.createSlideshowItem(from: nil)
		item!.slideshowIndex = 0
		self.centerDeck!.push(item: item!, position: .top)

	}
	
	fileprivate func calculateDeckPositions(deckWidth: CGFloat) {
		
		// Get spacing/margins
		let deckSpacing: CGFloat = 10
		
		// Determine leading position of left deck
		self.leftDeck!.set(leadingPosition: 0 - deckSpacing - deckWidth)
		
		// Determine leading position of center deck
		self.centerDeck!.set(leadingPosition: 0)
		
		// Determine leading position of right deck
		self.rightDeck!.set(leadingPosition: 0 + deckWidth + deckSpacing)
	}
	
	fileprivate func createSlideshowItem(from dataItem: ArtworkWrapper?) -> GallerySlideshowItemView {
		
		// Create a slideshow item
		let item = GallerySlideshowItemView(frame: self.contentView.bounds)
		
		item.delegate = self
		
		if (dataItem != nil) {
		
			item.set(dataItem: dataItem!)
		}
		
		// Add GallerySlideshowItemView to contentView
		self.contentView.addSubview(item)
		
		item.autoresizingMask	= [.flexibleHeight, .flexibleWidth]
		item.translatesAutoresizingMaskIntoConstraints = false

		// Create autolayout constraints
		// widthConstraint
		let widthConstraint			= NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 1, constant: 0)
		
		// topConstraint
		let topConstraint			= NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0)
		
		// bottomConstraint
		let bottomConstraint		= NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0)

		item.set(widthConstraint: widthConstraint)
		
		// centerYConstraint
		let centerYConstraint		= NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
		
		// leadingConstraint
		let dummyLeadingConstraint	= NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
		
		self.contentView.addConstraints([topConstraint, bottomConstraint, centerYConstraint, dummyLeadingConstraint, widthConstraint])
		
		item.leadingConstraint = dummyLeadingConstraint
		
		// Store in slideshowItems
		self.slideshowItems?.append(item)
		
		return item
	}
	
	fileprivate func slide(item: GallerySlideshowItemView, by translation: CGPoint) {
		
		item.leadingConstraint?.constant = item.deck!.leadingPosition + translation.x
	}

	fileprivate func populateItems(of deck: GallerySlideshowDeck) {
		
		// Get data items from delegate
		let dataItems = self.delegate?.gallerySlideshowView(dataItems: self)
		
		deck.isEmptyYN	= true
		deck.isFullYN	= true
		
		// Go through each slideshow item
		for (_, slideshowItem) in deck.items.enumerated() {
			
			// Check if slideshow item is empty
			if (slideshowItem.dataItem == nil) {
				
				// Determine data index
				let dataIndex = self.currentDataIndex + slideshowItem.slideshowIndex
				
				var dataItem: ArtworkWrapper? = nil
				
				// Check data item exists for the data index
				if (dataIndex >= 0 && dataItems!.count - 1 >= dataIndex) {
					
					dataItem = dataItems![dataIndex]
				}
				
				if (dataItem != nil) {
					
					// Set the item in the slideshowItem
					slideshowItem.set(dataItem: dataItem!)
					
					// Load large image
					if (dataItem!.largeImageData == nil) {
						self.loadLargeImage(for: dataItem!, in: slideshowItem)
					}
					
					deck.isEmptyYN = false	// Not empty because item is populated
					
				} else {
					
					deck.isFullYN = false	// Not full because item is unpopulated
					return
				}
			} else {
				
				deck.isEmptyYN = false		// Not empty because item is populated
			}
		}

	}

	fileprivate func loadLargeImage(for dataItem: ArtworkWrapper, in slideshowItem: GallerySlideshowItemView) {
		
		// Create completion handler
		let largeImageDataForItemCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			// Set image in slideshowItem
			if let data = data {
				
				slideshowItem.set(largeImage: UIImage(data: data)!)
				
			} else {
				
				slideshowItem.set(largeImage: nil)
			}
		}
		
		self.delegate!.gallerySlideshowView(sender: self, largeImageDataForItem: dataItem, oncomplete: largeImageDataForItemCompletionHandler)
		
	}

	fileprivate func switchCurrentItem(onDeck: GallerySlideshowDeck, offDeck: GallerySlideshowDeck) {
		
		// Get followingSlideshowItem from 'off' deck top
		let followingSlideshowItem = offDeck.getTopItem()
		
		UIView.animate(withDuration: 0.3, animations: {
			
			// Move current slideshow item
			self.currentSlideshowItem!.leadingConstraint!.constant		= onDeck.leadingPosition
			
			// Move following slideshow item
			followingSlideshowItem!.leadingConstraint!.constant			= self.centerDeck!.leadingPosition
			
			self.contentView.layoutIfNeeded()
			
		}) { (completed) in
			
			// Rearrange items
			self.doRearrangeItems(onDeck: onDeck, offDeck: offDeck)
			
			// Check preload
			self.checkPreload(into: offDeck)
			
			// Notify the delegate
			self.delegate?.gallerySlideshowView(sender: self, itemChanged: self.currentSlideshowItem!.dataItem!)
		}
	}
	
	fileprivate func doRearrangeItems(onDeck: GallerySlideshowDeck, offDeck: GallerySlideshowDeck) {
		
		// Pop current slideshow item from center deck top
		self.currentSlideshowItem		= self.centerDeck!.pop(position: .top)
		
		// Push current slideshow item to 'on' deck top
		onDeck.push(item: self.currentSlideshowItem!, position: .top)
		
		// Pop following slideshow item from 'off' deck top
		self.currentSlideshowItem		= offDeck.pop(position: .top)
		
		// Push following slideshow item on center deck top
		self.centerDeck!.push(item: self.currentSlideshowItem!, position: .top)
		
		// Pop recycled slideshow item from 'on' deck bottom
		let recycledSlideshowItem		= onDeck.pop(position: .bottom)
		
		recycledSlideshowItem!.clear()
		
		// Push recycled slideshow item to 'off' deck bottom
		offDeck.push(item: recycledSlideshowItem!, position: .bottom)
		
		// Set slideshow indexes
		self.currentSlideshowItem?.slideshowIndex = 0
		self.leftDeck!.setSlideshowIndexes()
		self.rightDeck!.setSlideshowIndexes()
		
		// Populate items of 'off' deck
		self.populateItems(of: offDeck)
		
	}
	
	fileprivate func checkPreload(into deck: GallerySlideshowDeck) {
		
		// Check if deck is not full
		if (!deck.isFullYN && !self.isAwaitingPreloadYN) {
			
			self.isAwaitingPreloadYN = true
			
			if (deck.name == .left) {
				
				self.delegate?.gallerySlideshowView(preloadPrevious: self)
				
			} else if (deck.name == .right) {
				
				self.delegate?.gallerySlideshowView(preloadNext: self)
				
			}
		}
	}
	
	
	// MARK: - UITapGestureRecognizer Methods
	
	@IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
	
		guard (self.currentSlideshowItem != nil) else { return }
		
		// Notify the delegate
		self.delegate?.gallerySlideshowView(sender: self, itemTapped: self.currentSlideshowItem!.dataItem!)
	}

}

// MARK: - Extension ProtocolPanGestureHelperDelegate

extension GallerySlideshowView: ProtocolPanGestureHelperDelegate {
	
	// MARK: - Public Methods
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {

		self.isPanningYN = false
		
		// Notify the delegate
		self.delegate?.gallerySlideshowView(for: gesture, panningStartedWith: attributes)
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		guard (	self.currentSlideshowItem != nil &&
				(attributes.direction == .left || attributes.direction == .right)) else {
			
			// Notify the delegate
			self.delegate?.gallerySlideshowView(for: gesture, panningContinuedWith: attributes)
			
			return
		}
		
		// Get translation
		let t							= gesture.translation(in: self.contentView)
	
		// Get followingSlideshowItem
		var followingSlideshowItem:		GallerySlideshowItemView? = nil
		
		self.isPanningYN				= true
		
		if (t.x < 0) {
			
			// Check if right deck is empty
			if (self.rightDeck!.isEmptyYN) { self.isPanningYN = false }
			
			// Get following slideshow item from right deck
			if (self.isPanningYN) { followingSlideshowItem = self.rightDeck!.getTopItem() }
			
			// Ensure all items at correct position
			self.leftDeck!.setLeadingPositions()
			
		} else {
			
			// Check if left deck is empty
			if (self.leftDeck!.isEmptyYN) { self.isPanningYN = false }
			
			// Get following slideshow item from left deck
			if (self.isPanningYN) { followingSlideshowItem	= self.leftDeck!.getTopItem() }
			
			// Ensure all items at correct position
			self.rightDeck!.setLeadingPositions()
			
		}
		
		if (!self.isPanningYN) { return }
		
		// Move current slideshow item
		self.slide(item: self.currentSlideshowItem!, by: t)
		
		// Move following slideshow item
		self.slide(item: followingSlideshowItem!, by: t)
		
		// Notify the delegate
		self.delegate?.gallerySlideshowView(for: gesture, panningContinuedWith: attributes)
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
	
		// Notify the delegate
		self.delegate?.gallerySlideshowView(for: gesture, panningStoppedWith: attributes)
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		guard (attributes.direction == .left || attributes.direction == .right) else {
			
			// Notify the delegate
			self.delegate?.gallerySlideshowView(for: gesture, panningStoppedWith: attributes)
			
			return
		}
		
		guard (	self.currentSlideshowItem != nil) else { return }
		

		
		// Get translation
		let t = gesture.translation(in: self.contentView)
		
		if ((t.x < 0 && !self.rightDeck!.isEmptyYN) ||
			(t.x >= 0 && !self.leftDeck!.isEmptyYN)) {
			
			// Notify the delegate
			self.delegate?.gallerySlideshowView(for: gesture, panningStoppedAfterThresholdWith: attributes)
			
		}
		
		if (t.x < 0) {

			self.next()
			
		} else {
			
			self.previous()
		}

	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		guard (attributes.direction == .left || attributes.direction == .right) else {
			
			// Notify the delegate
			self.delegate?.gallerySlideshowView(for: gesture, panningStoppedWith: attributes)
			
			return
		}
		
		guard (	self.currentSlideshowItem != nil) else { return }
		
		// Get translation
		let t							= gesture.translation(in: self.contentView)
		
		// Get followingSlideshowItem
		var followingSlideshowItem:		GallerySlideshowItemView? = nil
		
		if (t.x < 0) {
			
			followingSlideshowItem		= self.rightDeck!.getTopItem()
			
		} else {
			
			followingSlideshowItem		= self.leftDeck!.getTopItem()
			
		}
	
		UIView.animate(withDuration: 0.3, animations: {
			
			// Move current slideshow item
			self.currentSlideshowItem!.leadingConstraint!.constant		= self.centerDeck!.leadingPosition
			
			// Move following slideshow item
			followingSlideshowItem!.leadingConstraint!.constant			= followingSlideshowItem!.deck!.leadingPosition

			self.contentView.layoutIfNeeded()
			
		})

	}
	
}

// MARK: - Extension ProtocolGallerySlideshowItemViewDelegate

extension GallerySlideshowView: ProtocolGallerySlideshowItemViewDelegate {

	// MARK: - Public Methods
	
	public func checkIsConnected() -> Bool {
		
		guard (self.delegate != nil) else { return false }
		
		return self.delegate!.checkIsConnected()
		
	}
}
