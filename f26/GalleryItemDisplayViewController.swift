//
//  GalleryItemDisplayViewController.swift
//  f26
//
//  Created by David on 29/05/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import UIKit
import SFView
import f26Core
import f26Model
import f26View
import f26Controller

/// A ViewController for the GalleryItemDisplay
public class GalleryItemDisplayViewController: UIViewController {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:											GalleryItemDisplayControlManager?
	fileprivate var panGestureHelper:										PanGestureHelper?
	fileprivate var hideItemDetailViewTimer:								Timer?
	fileprivate var hideSwipeDownMessageViewTimer:							Timer?
	fileprivate var gallerySlideshowView:									GallerySlideshowView?
	fileprivate var latestArtworkCommentContainerViewDefaultWidth:			CGFloat = 240
	fileprivate var viewWillTransitionYN: 									Bool = false
	
	
	// MARK: - Public Static Stored Properties
	
	public fileprivate(set) static var swipeDownMessageViewShownYN:			Bool = false
	
	
	// MARK: - Public Stored Properties
	
	public var delegate:							ProtocolGalleryItemDisplayViewControllerDelegate?
	
	@IBOutlet weak var itemDetailView:										UIView!
	@IBOutlet var panGestureRecognizer:										UIPanGestureRecognizer!
	@IBOutlet var contentView:												UIView!
	@IBOutlet weak var itemNameLabel:										UILabel!
	@IBOutlet weak var itemCommentsLabel:									UILabel!
	@IBOutlet weak var swipeDownMessageView: 								UIView!
	@IBOutlet weak var itemDetailViewHeightConstraint: 						NSLayoutConstraint!
	@IBOutlet weak var itemDetailStackView: 								UIStackView!
	@IBOutlet weak var likeButtonView: 										UIView!
	@IBOutlet weak var commentsButtonView: 									UIView!
	@IBOutlet weak var likedArtworkView: 									UIView!
	@IBOutlet weak var numberofLikesLabel: 									UILabel!
	@IBOutlet weak var fadeOutView: 										UIView!
	@IBOutlet weak var latestArtworkCommentView: 							UIView!
	@IBOutlet weak var latestArtworkCommentTextLabel: 						UILabel!
	@IBOutlet weak var latestArtworkCommentPostedByNameLabel: 				UILabel!
	@IBOutlet weak var latestArtworkCommentDatePostedLabel: 				UILabel!
	@IBOutlet weak var latestArtworkCommentContainerView: 					UIView!
	@IBOutlet weak var latestArtworkCommentContainerViewWidthConstraint: 	NSLayoutConstraint!
	
	
	// MARK: - Override Methods
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.setup()
		
		self.view.layoutIfNeeded()
		
		self.setupItemDetailView()
		self.setupCommentsButtonView()
		self.setupLikeButtonView()
		self.setupLikedArtworkView()
		self.setupLatestArtworkCommentView()
		self.setupSwipeDownMessageView()
		self.setupGallerySlideshowView()
		self.setupPanGestureHelper()
		self.setupFadeOutView()
		
	}
	
	override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		self.viewWillTransitionYN = true
	
		self.gallerySlideshowView!.setDeckPositions(deckWidth: size.width)
		
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		
		// Present latest artwork comment view
		self.presentLatestArtworkCommentView()
		
	}
	
	public override func viewDidLayoutSubviews() {
		
		// Refresh latestArtworkCommentView
		if (self.viewWillTransitionYN) {
			
			self.view.layoutIfNeeded()
			
			self.setLatestArtworkCommentViewSize()
			
		}
		
		self.viewWillTransitionYN = false
		
	}
	
	
	// MARK: - Public Methods
	
	public func set(selectedArtworkID: Int, selectedDaughter: Daughters, selectedYear: Int) {

		self.controlManager!.selectedDaughter	= selectedDaughter
		self.controlManager!.selectedYear		= selectedYear
		
		// Find currentDataIndex for selectedArtworkID
		var currentDataIndex:	Int = -1
		var index:				Int = 0

		while (currentDataIndex == -1 && index <= ArtworkWrappers.items.count - 1) {
			
			if (ArtworkWrappers.items[index].id == selectedArtworkID) {
				
				// Set selectedArtwork
				self.controlManager!.selectedArtwork = ArtworkWrappers.items[index]
				
				self.controlManager!.displaySelectedArtwork()
				
				// Set itemDetailView height
				self.setItemDetailViewHeight()
				
				currentDataIndex = index
			}
			
			index += 1
		}
		
		// Setup gallerySlideshowView
		self.gallerySlideshowView!.set(currentDataIndex: currentDataIndex)
		
		// Show swipeDownMessageView
		if (!GalleryItemDisplayViewController.swipeDownMessageViewShownYN) { self.presentSwipeDownMessageView() }
		
		// Show itemDetailView
		self.presentItemDetailView()
		
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager = GalleryItemDisplayControlManager()
		
		// Setup cacheing
		self.controlManager!.setupCacheing(managedObjectContext: self.getCoreDataManagedObjectContext())
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		//ModelFactory.setupArtworkModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: GalleryItemDisplayViewAccessStrategy = GalleryItemDisplayViewAccessStrategy()
		
		viewAccessStrategy.setup(nameLabel:								self.itemNameLabel,
		                         commentsLabel:							self.itemCommentsLabel,
								 numberofLikesLabel: 					self.numberofLikesLabel,
								 latestArtworkCommentTextLabel: 		self.latestArtworkCommentTextLabel,
								 latestArtworkCommentPostedByNameLabel:	self.latestArtworkCommentPostedByNameLabel,
								 latestArtworkCommentDatePostedLabel: self.latestArtworkCommentDatePostedLabel)
		
		// Setup the view manager
		self.controlManager!.viewManager = GalleryItemDisplayViewManager(viewAccessStrategy: viewAccessStrategy)
	}

	fileprivate func setupCommentsButtonView() {
		
		UIViewHelper.makeCircle(view: self.commentsButtonView)
		
		UIViewHelper.setShadow(view: self.commentsButtonView)
		
	}
	
	fileprivate func setupLikeButtonView() {
		
		UIViewHelper.makeCircle(view: self.likeButtonView)
		
		UIViewHelper.setShadow(view: self.likeButtonView)
		
	}
	
	fileprivate func getCoreDataManagedObjectContext() -> NSManagedObjectContext
	{
		// Get appDelegate
		let appDelegate:			AppDelegate				= UIApplication.shared.delegate as! AppDelegate
		
		// Get managedObjectContext
		let managedObjectContext:	NSManagedObjectContext	= appDelegate.persistentContainer.viewContext
		
		return managedObjectContext
	}
	
	fileprivate func setupItemDetailView() {
		
		// Hide view
		self.itemDetailView.alpha = 0
	}

	fileprivate func setupFadeOutView() {
		
		self.fadeOutView.alpha 				= 0
	}
	
	fileprivate func setupSwipeDownMessageView() {

		// Hide view
		self.swipeDownMessageView.alpha = 0
	}
	
	fileprivate func presentItemDetailView() {
		
		// Reset timer
		if self.hideItemDetailViewTimer != nil {
			self.hideItemDetailViewTimer?.invalidate()
		}
		
		// Show view
		UIView.animate(withDuration: 0.2) {
			self.itemDetailView.alpha = 1
		}
		
		// Set timer to hide view
		self.hideItemDetailViewTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideItemDetailViewTimerAction(_:)), userInfo: nil, repeats: false)
		
	}
	
	fileprivate func presentSwipeDownMessageView() {
		
		guard (GalleryItemDisplayViewController.swipeDownMessageViewShownYN == false) else { return }
		
		GalleryItemDisplayViewController.swipeDownMessageViewShownYN = true
		
		// Reset timer
		if self.hideSwipeDownMessageViewTimer != nil {
			self.hideSwipeDownMessageViewTimer?.invalidate()
		}
		
		// Show view
		UIView.animate(withDuration: 0.2) {
			self.swipeDownMessageView.alpha = 1
		}
		
		// Set timer to hide view
		self.hideSwipeDownMessageViewTimer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(hideSwipeDownMessageViewTimerAction(_:)), userInfo: nil, repeats: false)
		
	}
	
	fileprivate func setupGallerySlideshowView() {
		
		// Create gallerySlideshowView
		self.gallerySlideshowView	= GallerySlideshowView(frame: self.contentView.bounds)

		// Add gallerySlideshowView to contentView
		self.contentView.addSubview(self.gallerySlideshowView!)
		
		self.gallerySlideshowView!.autoresizingMask			= [.flexibleHeight, .flexibleWidth]
		self.gallerySlideshowView!.translatesAutoresizingMaskIntoConstraints = false
		
		// Create autolayout constraints
		// leadingConstraint
		let leadingConstraint	= NSLayoutConstraint(item: self.gallerySlideshowView!, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)

		// trailingConstraint
		let trailingConstraint	= NSLayoutConstraint(item: self.gallerySlideshowView!, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0)

		// topConstraint
		let topConstraint		= NSLayoutConstraint(item: self.gallerySlideshowView!, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0)

		// bottomConstraint
		let bottomConstraint	= NSLayoutConstraint(item: self.gallerySlideshowView!, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0)
		
		self.contentView.addConstraints([leadingConstraint, topConstraint, trailingConstraint, bottomConstraint])
		
		// Setup gallerySlideshowView
		self.gallerySlideshowView!.delegate				= self

		self.gallerySlideshowView!.set(gestureRightCommitThreshold: 50)
		self.gallerySlideshowView!.set(gestureLeftCommitThreshold: 50)
		self.gallerySlideshowView!.set(gestureDownCommitThreshold: 50)
	}
	
	fileprivate func setupPanGestureHelper() {
		
		self.panGestureHelper = PanGestureHelper(gesture: self.panGestureRecognizer)
		
		self.panGestureHelper!.delegate							= self
		
		self.panGestureHelper!.gestureDownEnableThresholdYN		= true
		self.panGestureHelper!.gestureDownCommitThreshold		= 150
	}
	
	@objc fileprivate func hideItemDetailViewTimerAction(_ sender:Timer) {
		
		// Hide view
		UIView.animate(withDuration: 0.3) {
			self.itemDetailView.alpha = 0
		}
	}

	@objc fileprivate func hideSwipeDownMessageViewTimerAction(_ sender:Timer) {
		
		// Hide view
		UIView.animate(withDuration: 0.3) {
			self.swipeDownMessageView.alpha = 0
		}
	}
	
	fileprivate func setItemDetailViewHeight() {
		
		self.view.layoutIfNeeded()
		
		// Get contentHeight from itemDetailStackView
		let contentHeight: 	CGFloat = self.itemDetailStackView.frame.size.height
		
		let marginTop: 		CGFloat = 40	// Spacing below status bar
		let marginBottom: 	CGFloat = 20	// Set in storyboard
		
		self.itemDetailViewHeightConstraint.constant = marginTop + contentHeight + marginBottom
	}

	fileprivate func setupLikedArtworkView() {
		
		self.likedArtworkView.layer.cornerRadius 	= 10.0;
		self.likedArtworkView.layer.borderWidth 	= 1.0;
		self.likedArtworkView.layer.borderColor 	= UIColor.clear.cgColor
		self.likedArtworkView.layer.masksToBounds 	= true;
		
		// Hide view
		self.likedArtworkView.alpha 				= 0
		
	}
	
	fileprivate func presentLikedArtworkView() {
		
		self.likedArtworkView.alpha = 0
		
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
			
			self.likedArtworkView.alpha = 1
			
		}) { (completed) in
			
			UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
				
				self.likedArtworkView.alpha = 0
				
			}, completion: nil)
			
		}
		
	}
	
	fileprivate func presentArtworkCommentsDisplay() {
		
		guard (self.controlManager!.selectedArtwork != nil) else { return }
		
		// Create view controller
		let viewController = storyboard?.instantiateViewController(withIdentifier: "ArtworkCommentsDisplay") as? ArtworkCommentsDisplayViewController
		
		// Set initial values
		viewController!.set(artworkID: self.controlManager!.selectedArtwork!.id)
		
		viewController!.delegate				= self
		viewController!.modalPresentationStyle	= .overCurrentContext
		
		self.presentFadeOutView()
		
		present(viewController!, animated: true, completion: nil)
		
	}
	
	fileprivate func presentFadeOutView() {
		
		// Show view
		UIView.animate(withDuration: 0.1) {
			
			self.fadeOutView.alpha = 1
		}
		
	}
	
	fileprivate func hideFadeOutView() {
		
		// Hide view
		UIView.animate(withDuration: 0.1) {
			
			self.fadeOutView.alpha = 0
		}
		
	}
	
	fileprivate func setupLatestArtworkCommentView() {
		
		//UIViewHelper.setShadow(view: self.latestArtworkCommentContainerView)
		
		self.latestArtworkCommentView.layer.cornerRadius 	= 10.0;
		self.latestArtworkCommentView.layer.borderWidth 	= 1.0;
		self.latestArtworkCommentView.layer.borderColor 	= UIColor.clear.cgColor
		self.latestArtworkCommentView.layer.masksToBounds 	= true;
		
		// Hide view
		self.latestArtworkCommentContainerView.alpha 		= 0
		
	}
	
	fileprivate func presentLatestArtworkCommentView() {
		
		guard (self.controlManager!.selectedArtwork!.latestArtworkCommentText.count > 0) else { return }
		guard (self.latestArtworkCommentContainerView.alpha == 0) else { return }
		
		self.setLatestArtworkCommentViewSize()
		
		self.latestArtworkCommentContainerView.alpha 		= 0
		self.latestArtworkCommentContainerView.transform 	= CGAffineTransform(scaleX: 0.001, y: 0.001)
		self.latestArtworkCommentContainerView.alpha 		= 1
		
		UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			
			self.latestArtworkCommentContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
			
		}) { _ in
			
			self.latestArtworkCommentContainerView.transform = CGAffineTransform.identity
			
		}
		
	}
	
	fileprivate func hideLatestArtworkCommentView() {
		
		guard (self.latestArtworkCommentContainerView.alpha == 1) else { return }
		
		UIView.animate(withDuration: 0.1) {
			
			self.latestArtworkCommentContainerView.alpha 	= 0
			
		}
		
	}
	
	fileprivate func setLatestArtworkCommentViewSize() {
		
		guard (self.controlManager!.selectedArtwork!.latestArtworkCommentText.count > 0) else { return }
		
		let latestArtworkCommentViewPadding:					CGFloat = 10
		let quoteBubblePointImageViewHeight:					CGFloat = 18
		let postedByNameLabelTopSpacing: 						CGFloat = 5
		let postedByNameLabelHeight:							CGFloat = 18
		let latestArtworkCommentContainerViewBottomSpacing:		CGFloat = 20
		
		// Get default label width
		var labelWidth: 			CGFloat = self.latestArtworkCommentContainerViewDefaultWidth - latestArtworkCommentViewPadding - latestArtworkCommentViewPadding
		
		// Get height from top of latestArtworkCommentContainerView to bottom of view
		let heightFromLatestArtworkCommentContainerViewTop:		CGFloat = self.view.frame.size.height -  self.latestArtworkCommentContainerView.frame.origin.y
		
		// Get available label height
		let availableLabelHeight: 	CGFloat = heightFromLatestArtworkCommentContainerViewTop - latestArtworkCommentContainerViewBottomSpacing - latestArtworkCommentViewPadding - postedByNameLabelHeight - postedByNameLabelTopSpacing - latestArtworkCommentViewPadding - quoteBubblePointImageViewHeight
		
		// Get required label height for default label width
		let requiredLabelHeight: 	CGFloat = UILabelHelper.getHeightToFit(label: self.latestArtworkCommentTextLabel, maxWidth: labelWidth)
		
		// Check required label height less than available label height
		if (requiredLabelHeight > availableLabelHeight) {
			
			// Get required label width for available label height
			labelWidth = UILabelHelper.getWidthToFit(label: self.latestArtworkCommentTextLabel, maxHeight: availableLabelHeight)
			
		}
		
		// Get latestArtworkCommentContainerViewMaxWidth
		let latestArtworkCommentContainerViewMaxWidth: CGFloat = self.view.frame.size.width - 30
		
		// Set width layout constraint
		self.latestArtworkCommentContainerViewWidthConstraint.constant = min((labelWidth + latestArtworkCommentViewPadding + latestArtworkCommentViewPadding), latestArtworkCommentContainerViewMaxWidth)
		
		self.view.layoutIfNeeded()
		
	}
	
	
	// MARK: - commentsButton TapGestureRecognizer Methods
	
	@IBAction func commentsButtonTapped(_ sender: Any) {
		
		self.presentArtworkCommentsDisplay()
		
	}
	
	
	// MARK: - likeButton TapGestureRecognizer Methods
	
	@IBAction func likeButtonTapped(_ sender: Any) {
		
		// Check is connected
		guard (self.controlManager!.checkIsConnected()) else { return }
		
		// Present 'liked artwork' view
		self.presentLikedArtworkView()
		
		// Like artwork
		self.controlManager!.likeArtwork()
		
		self.controlManager!.displayNumberofLikes()
		
	}

	
	// MARK: - latestArtworkCommentView TapGestureRecognizer Methods
	
	@IBAction func latestArtworkCommentViewTapped(_ sender: Any) {
		
		// Hide latest artwork comment view
		self.hideLatestArtworkCommentView()
		
	}
	
}


// MARK: - Extension ProtocolPanGestureHelperDelegate

extension GalleryItemDisplayViewController: ProtocolPanGestureHelperDelegate {
	
	// MARK: - Public Methods
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {

	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		// Check if moving down
		if (attributes.direction == .down) {
			
			// Move view position
			self.view.frame = CGRect(x: 0, y: attributes.currentTouchPoint.y - attributes.initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {

	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {

		// Check if moving down
		if (attributes.direction == .down) {
			
			// Notify the delegate
			self.delegate?.galleryItemDisplayViewController(didDismiss: self)
			
			// Dismiss view
			dismiss(animated: true, completion: nil)
		}
		
		// Check if moving left or right
		if (attributes.direction == .left || attributes.direction == .right) {
			
			// Hide latest artwork comment view
			self.hideLatestArtworkCommentView()
			
		}
		
	}

	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {

		// Check if moving down
		if (attributes.direction == .down) {
			
			// Reset view position
			UIView.animate(withDuration: 0.3, animations: {
				
				self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
				
			})
		}
	}
	
}

// MARK: - Extension ProtocolGallerySlideshowViewDelegate

extension GalleryItemDisplayViewController: ProtocolGallerySlideshowViewDelegate {

	public func gallerySlideshowView(dataItems sender: GallerySlideshowView) -> [ArtworkWrapper] {
		
		return ArtworkWrappers.items
	}
	
	public func gallerySlideshowView(sender: GallerySlideshowView, itemChanged item: ArtworkWrapper) {
		
		// Set selectedArtwork
		self.controlManager!.selectedArtwork = item
		
		self.controlManager!.displaySelectedArtwork()
		
		// Set itemDetailView height
		self.setItemDetailViewHeight()
		
		// Show itemDetailView
		self.presentItemDetailView()
		
		// Present latest artwork comment view
		self.presentLatestArtworkCommentView()
		
	}

	public func gallerySlideshowView(sender: GallerySlideshowView, itemTapped item: ArtworkWrapper) {
	
		self.presentItemDetailView()
	}

	public func gallerySlideshowView(sender: GallerySlideshowView, largeImageDataForItem item: ArtworkWrapper, oncomplete completionHandler:@escaping (Data?, Error?) -> Void) {
		
		// Create completion handler
		let loadArtworkLargeImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			// Call completion handler
			completionHandler(data, error)
		}
		
		self.controlManager!.loadArtworkLargeImageData(for: item, oncomplete: loadArtworkLargeImageDataCompletionHandler)

	}
	
	public func gallerySlideshowView(preloadPrevious sender: GallerySlideshowView) {
		
		// Create completion handler
		let loadArtworksCompletionHandler: (([ArtworkWrapper], Error?) -> Void) =
		{
			(items, error) -> Void in
			
			print("preloadPrevious!")
			
			self.gallerySlideshowView!.preloadPrevious(dataItems: items)
		}
		
		// Check if hasLoadedAllPreviousItemsYN
		if (ArtworkWrappers.hasLoadedAllPreviousItemsYN) {
		
			self.gallerySlideshowView!.cancelPreload()
			return
		}
		
		self.controlManager!.loadArtworks(selectItemsAfterPreviousYN: false, oncomplete: loadArtworksCompletionHandler)
	}
	
	public func gallerySlideshowView(preloadNext sender: GallerySlideshowView) {
		
		// Create completion handler
		let loadArtworksCompletionHandler: (([ArtworkWrapper], Error?) -> Void) =
		{
			(items, error) -> Void in
			
			print("preloadNext!")
			
			self.gallerySlideshowView!.preloadNext(dataItems: items)
		}
		
		// Check if hasLoadedAllNextItemsYN
		if (ArtworkWrappers.hasLoadedAllNextItemsYN) {
			
			self.gallerySlideshowView!.cancelPreload()
			return
		}
		
		self.controlManager!.loadArtworks(selectItemsAfterPreviousYN: true, oncomplete: loadArtworksCompletionHandler)
		
	}
	
	public func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		self.panGestureHelper(for: gesture, panningStartedWith: attributes)
	}

	public func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
	
		self.panGestureHelper(for: gesture, panningContinuedWith: attributes)
	}

	public func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {

		self.panGestureHelper(for: gesture, panningStoppedAfterThresholdWith: attributes)
	}

	public func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		self.panGestureHelper(for: gesture, panningStoppedBeforeThresholdWith: attributes)
	}

	public func gallerySlideshowView(for gesture:UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
		// Check if moving down
		if (attributes.direction == .down) {
			
			// Check verticalDistance
			if (attributes.verticalDistance >= self.panGestureHelper!.gestureDownCommitThreshold) {
				
				self.panGestureHelper(for: gesture, panningStoppedAfterThresholdWith: attributes)
				
			} else {
				
				self.panGestureHelper(for: gesture, panningStoppedBeforeThresholdWith: attributes)
			}
			
		} else {
			
			self.panGestureHelper(for: gesture, panningStoppedWith: attributes)
		}
		
	}

	public func checkIsConnected() -> Bool {
		
		guard (self.controlManager != nil) else { return false }
		
		return self.controlManager!.checkIsConnected()
	}

}

// MARK: - Extension ProtocolArtworkCommentsDisplayViewControllerDelegate

extension GalleryItemDisplayViewController: ProtocolArtworkCommentsDisplayViewControllerDelegate {
	
	// MARK: - Methods
	
	public func artworkCommentsDisplayViewController(didDismiss sender: ArtworkCommentsDisplayViewController) {
		
		self.hideFadeOutView()
		
	}
	
	public func artworkCommentsDisplayViewController(didPostComment sender: ArtworkCommentsDisplayViewController) {
		
		// Display latest comment
		self.controlManager!.displayLatestArtworkComment()
		
		self.presentLatestArtworkCommentView()
		
	}
	
}



