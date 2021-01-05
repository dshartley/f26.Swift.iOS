//
//  GalleryListDisplayViewController.swift
//  f26
//
//  Created by David on 29/05/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import CoreData
import UIKit
import SFView
import SFCore
import f26Core
import f26Model
import f26View
import f26Controller

/// A ViewController for the GalleryListDisplay
class GalleryListDisplayViewController: UIViewController {
	
	// MARK: - Private Stored Properties
	
	fileprivate var controlManager:											GalleryListDisplayControlManager?
	fileprivate var hasViewAppearedYN:										Bool = false
	fileprivate var isDataViewAtBottomZoneYN:								Bool = false
	fileprivate var isInitialLoadCompleteYN:								Bool = false
	fileprivate var isAwardsLoadedYN:										Bool = false
	fileprivate var isNewsSnippetsLoadedYN:									Bool = false
	fileprivate let minNumberofItemsOutOfView:								Int = 4
	fileprivate var dashboardMenuViewIsShownYN:								Bool = false
	fileprivate var viewWillTransitionYN: 									Bool = false
	fileprivate let awardsBarViewMaximumWidth:								CGFloat = 600
	fileprivate let awardsBarViewEqualWidthLayoutConstraintConstant:		CGFloat = -200
	fileprivate let awardsBarViewPadding:									CGFloat = 20
	fileprivate let awardsBarViewContainerViewPadding:						CGFloat = 10
	fileprivate var newsBarViewLeftLayoutConstraintOffset:					CGFloat = 0
	fileprivate var setArtworksCollectionViewRightLayoutConstraintYN:		Bool = false
	fileprivate var artworksCollectionViewRightLayoutConstraintDefault:		CGFloat = 0
	fileprivate var panGestureHelper:										PanGestureHelper?
	fileprivate var screenEdgePanGestureHelper:								PanGestureHelper?
	
	
	// MARK: - Public Stored Properties
	
	@IBOutlet weak var artworksCollectionView:								UICollectionView!
	@IBOutlet weak var artworksCollectionViewRightLayoutConstraint: 		NSLayoutConstraint!
	@IBOutlet weak var newsBarView: 										NewsBarView!
	@IBOutlet weak var newsBarPlaceholderView: 								UIView!
	@IBOutlet weak var newsBarViewLeftLayoutConstraint:						NSLayoutConstraint!
	@IBOutlet weak var newsBarViewWidthLayoutConstraint:					NSLayoutConstraint!
	@IBOutlet weak var newsBarViewPanGestureRecognizer: 					UIPanGestureRecognizer!
	@IBOutlet var screenEdgePanGestureRecogniser: 							UIScreenEdgePanGestureRecognizer!
	@IBOutlet weak var dashboardBarView:									DashboardBarView!
	@IBOutlet weak var dashboardBarPlaceholderView:							UIView!
	@IBOutlet weak var dashboardBarViewHeightLayoutConstraint:				NSLayoutConstraint!
	@IBOutlet weak var dashboardMenuView:									DashboardMenuView!
	@IBOutlet weak var dashboardMenuPlaceholderView:						UIView!
	@IBOutlet weak var dashboardMenuViewTopLayoutConstraint:				NSLayoutConstraint!
	@IBOutlet weak var dashboardMenuViewBottomLayoutConstraint:				NSLayoutConstraint!
	@IBOutlet weak var activityIndicatorView: 								UIView!
	@IBOutlet weak var likedArtworkView: 									UIView!
	@IBOutlet weak var fadeOutView: 										UIView!
	@IBOutlet weak var awardsButtonView: 									UIView!
	@IBOutlet weak var awardsBarView: 										AwardsBarView!
	@IBOutlet weak var awardsBarPlaceholderView: 							UIView!
	@IBOutlet weak var awardsBarViewEqualWidthLayoutConstraint: 			NSLayoutConstraint!
	@IBOutlet weak var awardsBarViewHeightLayoutConstraint: 				NSLayoutConstraint!
	

	// MARK: - Override Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		// DEBUG:
		//SettingsManager.set(bool: false, forKey: "\(SettingsKeys.isSignedInYN)")
		
        // Do any additional setup after loading the view.
		self.setup()
		
		self.checkIsSignedIn()
		self.setupPanGestureHelper()
		self.setupArtworksCollectionView()
		self.setupNewsBarView()
		self.setupDashboardMenuView()
		self.setupDashboardBarView()
		self.setupAwardsBarView()
		self.setupLikedArtworkView()
		self.setupAwardsButtonView()
		self.setupActivityIndicatorView()
		self.setupFadeOutView()
		
    }

	override func viewDidAppear(_ animated: Bool) {
		
		self.hasViewAppearedYN = true

		self.presentActivityIndicatorView(animateYN: false)
		
		self.setAwardsBarViewWidth()
		
		self.loadArtworks(toFillYN: true)
		
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		// Call invalidateLayout to make sure layout is updated
		self.artworksCollectionView.collectionViewLayout.invalidateLayout()

		// When transition complete
		coordinator.animate(alongsideTransition: nil) { _ in
		
			if (self.hasViewAppearedYN) {
				
				// Set newsBarView LeftLayoutConstraint
				self.setNewsBarViewLeftLayoutConstraint()
				
				// Determine default and flag whether to set artworksCollectionView RightLayoutConstraint
				self.setArtworksCollectionViewRightLayoutConstraintDefault()
				self.checkSetArtworksCollectionViewRightLayoutConstraintYN()
				
				// Set artworksCollectionView RightLayoutConstraint
				self.setArtworksCollectionViewRightLayoutConstraint(setToDefaultYN: false)
				
				// Refresh artworksCollectionView layout
				self.refreshArtworksCollectionViewLayout()
				
				// Correct newsBarView scroll position
				self.newsBarView.correctOverScroll()
			}
			
		}
		
		self.viewWillTransitionYN = true

	}

	override func viewDidLayoutSubviews() {
		
		if (!self.hasViewAppearedYN) {
			
			// Determine default and flag whether to set artworksCollectionView RightLayoutConstraint
			self.setArtworksCollectionViewRightLayoutConstraintDefault()
			self.checkSetArtworksCollectionViewRightLayoutConstraintYN()
			
			if (!self.setArtworksCollectionViewRightLayoutConstraintYN && self.controlManager!.isSignedInYN) {
				
				self.setNewsBarViewPresented()
				
			} else {
				
				self.setNewsBarViewHidden()
				
			}
			
		}

		// Refresh awardsBarView
		if (self.viewWillTransitionYN && self.awardsBarView!.isShownYN) {
			
			self.view.layoutIfNeeded()
			
			self.setAwardsBarViewWidth()
			
			self.awardsBarView.refreshView()
			
		}

		self.viewWillTransitionYN = false
		
	}
	
	
	// MARK: - Public Methods
	
	public func setNewsBarViewHidden() {
		
		self.newsBarView.alpha 		= 0
		
		self.newsBarView.isShownYN 	= false
		
		self.setNewsBarViewLeftLayoutConstraint()
		
		self.dashboardBarView.set(newsBarIsSelectedYN: self.newsBarView.isShownYN, animateYN: false)
		
	}
	
	public func setNewsBarViewPresented() {
		
		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		self.newsBarView.alpha = 1
		
		// Set newsBarView LeftLayoutConstraint
		self.newsBarViewLeftLayoutConstraint!.constant	= 0 + self.newsBarViewLeftLayoutConstraintOffset
		
		self.newsBarView.isShownYN = true
		
		self.dashboardBarView.set(newsBarIsSelectedYN: self.newsBarView.isShownYN, animateYN: false)
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func setup() {
		
		self.setupControlManager()
		self.setupModelManager()
		self.setupViewManager()
		
		self.setDebugFlags()
	}
	
	fileprivate func setupControlManager() {
		
		// Setup the control manager
		self.controlManager 			= GalleryListDisplayControlManager()
		
		self.controlManager!.delegate 	= self
		
		// Setup cacheing
		self.controlManager!.setupCacheing(managedObjectContext: self.getCoreDataManagedObjectContext())
		
		// Setup authentication
		self.controlManager!.setupAuthentication()
		
	}
	
	fileprivate func setupModelManager() {
		
		// Set the model manager
		self.controlManager!.set(modelManager: ModelFactory.modelManager)
		
		// Setup the model administrators
		ModelFactory.setupArtworkModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
		ModelFactory.setupAwardModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
		ModelFactory.setupNewsSnippetModelAdministrator(modelManager: self.controlManager!.modelManager! as! ModelManager)
	}
	
	fileprivate func setupViewManager() {
		
		// Create view strategy
		let viewAccessStrategy: GalleryListDisplayViewAccessStrategy = GalleryListDisplayViewAccessStrategy()
		
		viewAccessStrategy.setup(awardsBarView: self.awardsBarView)
		
		// Setup the view manager
		self.controlManager!.viewManager = GalleryListDisplayViewManager(viewAccessStrategy: viewAccessStrategy)
	}
	
	fileprivate func setDebugFlags() {
		
		#if DEBUG
			
			ApplicationFlags.flag(key: "SkipCheckIsConnectedYN", value: false)
			ApplicationFlags.flag(key: "LoadNewsSnippetsDummyDataYN", value: false)
			
		#endif
		
	}
	
	fileprivate func checkIsSignedIn() {
	
		_ = self.controlManager!.checkIsSignedIn()
	}
	
	fileprivate func setupActivityIndicatorView() {
		
		self.activityIndicatorView.alpha 	= 0
	}
	
	fileprivate func setupFadeOutView() {

		self.fadeOutView.alpha 				= 0
	}
	
	fileprivate func getCoreDataManagedObjectContext() -> NSManagedObjectContext
	{
		// Get appDelegate
		let appDelegate:			AppDelegate				= UIApplication.shared.delegate as! AppDelegate
		
		// Get managedObjectContext
		let managedObjectContext:	NSManagedObjectContext	= appDelegate.persistentContainer.viewContext
		
		return managedObjectContext
	}
	
	fileprivate func setupPanGestureHelper() {
		
		// panGestureHelper
		self.panGestureHelper											= PanGestureHelper(gesture: self.newsBarViewPanGestureRecognizer)
		
		self.panGestureHelper!.delegate									= self
	
		self.panGestureHelper?.gestureLeftEnableThresholdYN				= true
		self.panGestureHelper?.gestureLeftCommitThreshold				= 80
		
		// screenEdgePanGestureHelper
		self.screenEdgePanGestureHelper 								= PanGestureHelper(gesture: self.screenEdgePanGestureRecogniser)
		self.screenEdgePanGestureHelper!.delegate 						= self

		self.screenEdgePanGestureHelper?.gestureRightEnableThresholdYN	= true
		self.screenEdgePanGestureHelper?.gestureRightCommitThreshold	= 80
		
	}
	
	fileprivate func setupNewsBarView() {
		
		self.newsBarView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.newsBarPlaceholderView.isHidden	= true
		
	}
	
	fileprivate func setupDashboardBarView() {
		
		self.dashboardBarView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.dashboardBarPlaceholderView.isHidden	= true
	
		self.dashboardBarView.set(year: self.controlManager!.selectedYear)
		self.dashboardBarView.set(daughter: self.controlManager!.selectedDaughter)
		
		self.dashboardBarView.set(newsBarIsSelectedYN: self.newsBarView.isShownYN, animateYN: false)
	}
	
	fileprivate func setupDashboardMenuView() {
	
		self.dashboardMenuView.delegate								= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.dashboardMenuPlaceholderView.isHidden					= true
		
		// Hide dashboardMenuView
		self.dashboardMenuView.isHidden								= true
		
		// Set offset to fit under dashboardBoardBarView
		self.dashboardMenuView.menuViewTopLayoutConstraintOffset	= self.dashboardBarViewHeightLayoutConstraint.constant
		
		// Layout dashboardMenuView to fill superview
		self.dashboardMenuViewTopLayoutConstraint.constant			= 0
		self.dashboardMenuViewBottomLayoutConstraint.constant		= 0
		
		// Populate years and set selected year
		self.dashboardMenuView.populate(years: self.controlManager!.getYears())
		self.dashboardMenuView.set(year: self.controlManager!.selectedYear)
		
	}
	
	fileprivate func setupAwardsBarView() {
		
		self.awardsBarView.delegate				= self
		
		// Hide placeholder view which is just used for view in interface builder
		self.awardsBarPlaceholderView.isHidden	= true
		
		self.awardsBarView.isHidden				= true
		self.awardsBarView.hide(animateYN: false)
		
	}
	
	fileprivate func setupArtworksCollectionView() {
		
		artworksCollectionView!.delegate			= self
		artworksCollectionView!.dataSource			= self
		
		// Set layout delegate
		if let layout = artworksCollectionView?.collectionViewLayout as? SFCollectionViewLayout {
			layout.delegate			= self
			
			layout.minColumnWidth	= 150
			layout.maxColumnWidth	= 200
			layout.cellPadding		= 10
		}

		// Setup collectionView
		self.automaticallyAdjustsScrollViewInsets	= false
		
		artworksCollectionView!.backgroundColor		= UIColor.clear
		artworksCollectionView!.contentInset		= UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

	}
	
	fileprivate func setupAwardsButtonView() {
		
		UIViewHelper.makeCircle(view: self.awardsButtonView)
		
		UIViewHelper.setShadow(view: self.awardsButtonView)
		
		self.awardsButtonView.isHidden 				= true
		
	}
	
	fileprivate func clearArtworksCollectionView(oncomplete completionHandler: ((Error?) -> Void)?) {
		
		// Check items exist
		guard (self.artworksCollectionView.numberOfItems(inSection: 0) > 0) else {
			
			// Call completion handler
			completionHandler?(nil)
			
			return
		}
		
		// Check not scrolling
		self.abortArtworksCollectionViewScroll()
		
		// Create index paths for items to be deleted
		var indexPaths:	[IndexPath] = [IndexPath]()
		let firstIndex:	Int			= 0
		
		for i in 0...self.artworksCollectionView.numberOfItems(inSection: 0) - 1 {
			
			indexPaths.append(IndexPath(item: firstIndex + i, section: 0))
		}
		
		DispatchQueue.main.async(execute: {
			
			self.artworksCollectionView.collectionViewLayout.invalidateLayout()
			
			// Delete layout attributes
			if let layout = self.artworksCollectionView?.collectionViewLayout as? SFCollectionViewLayout {
				layout.deleteAttributes(at: indexPaths)
			}
			
			self.artworksCollectionView.deleteItems(at: indexPaths)
			
			// Call completion handler
			completionHandler?(nil)
		})
		
	}
	
	fileprivate func loadArtworks(toFillYN: Bool) {
		
		// Create completion handler
		let loadArtworksCompletionHandler: (([ArtworkWrapper], Error?) -> Void) =
		{
			(items, error) -> Void in
			
			self.hideActivityIndicatorView()
			
			// Check number of items loaded
			guard (items.count > 0) else {
				
				self.isInitialLoadCompleteYN = true
				
				// Load awards
				self.loadAwards(presentAwardsViewYN: true)
				
				// Load news snippets
				self.loadNewsSnippets()
				
				return
			}
			
			// Create index paths for items to be inserted
			var indexPaths:	[IndexPath] = [IndexPath]()
			let firstIndex:	Int			= ArtworkWrappers.items.count - items.count
		
			for i in 0...items.count - 1 {
				
				indexPaths.append(IndexPath(item: firstIndex + i, section: 0))
			}
			
			// Refresh collection view
			DispatchQueue.main.async(execute: {
				
				// Call invalidateLayout to make sure layout is updated
				self.artworksCollectionView.collectionViewLayout.invalidateLayout()

				self.artworksCollectionView.insertItems(at: indexPaths)
				
				// Check shouldLoadMoreArtworks
				if (toFillYN && self.shouldLoadMoreArtworks()) {
					
					self.loadArtworks(toFillYN: true)
					
				} else {
					
					self.isInitialLoadCompleteYN = true
					
					// Load awards
					self.loadAwards(presentAwardsViewYN: true)
					
					// Load news snippets
					self.loadNewsSnippets()
					
				}
			})
		}
		
		self.controlManager!.loadArtworks(selectItemsAfterPreviousYN: true, oncomplete: loadArtworksCompletionHandler)
	}
	
	fileprivate func shouldLoadMoreArtworks() -> Bool {
		
		// Check state
		guard ( self.hasViewAppearedYN						== true &&
				self.controlManager!.isLoadingDataYN		== false &&
				ArtworkWrappers.hasLoadedAllNextItemsYN		== false) else {
				return false
		}

		var result = false
		
		// Check numberofItemsOutOfView
		if (self.numberofItemsOutOfView() < self.minNumberofItemsOutOfView) {
			result = true
		}
		
		// Check initial load complete
		if (self.isInitialLoadCompleteYN == false && result == false) {
			self.isInitialLoadCompleteYN = true
		}
		
		return result
	}
	
	fileprivate func numberofItemsOutOfView() -> Int {
		
		var result = 0
		
		// Get numberofItemsOutOfView
		var lastVisibleIndexPath: IndexPath?	= nil
		
		for (_, indexPath) in self.artworksCollectionView.indexPathsForVisibleItems.enumerated() {
			
			// Get index path with highest index
			if (lastVisibleIndexPath == nil || indexPath.item > lastVisibleIndexPath!.item) {
				lastVisibleIndexPath = indexPath
			}
		}
		
		if (lastVisibleIndexPath != nil) {
			
			let lastIndex: Int = ArtworkWrappers.items.count - 1
			result = lastIndex - lastVisibleIndexPath!.item
		}

		return result
	}
	
	fileprivate func presentGalleryItemDisplay(artworkID: Int) {
		
		// Create view controller
		let viewController = storyboard?.instantiateViewController(withIdentifier: "GalleryItemDisplay") as? GalleryItemDisplayViewController
		
		viewController!.delegate				= self
		viewController!.modalPresentationStyle	= .overCurrentContext
		
		present(viewController!, animated: true, completion: nil)
		
		// Set initial values
		viewController!.set(selectedArtworkID:				artworkID,
							selectedDaughter:				self.controlManager!.selectedDaughter,
							selectedYear:					self.controlManager!.selectedYear)
		
	}

	fileprivate func presentSignInAlert(onSignInSuccessful completionHandler: ((Error?) -> Void)?) {
		
		// Create completion handler
		let enterTappedCompletionHandler: ((String?) -> Void) =
		{
			(text) -> Void in
			
			if (text != nil && text!.count > 0) {
				
				// Sign in
				self.controlManager!.signIn(password: text!, onSignInSuccessful: completionHandler)
				
			} else {
				
				self.presentSignInAlert(onSignInSuccessful: completionHandler)
				
			}

		}
		
		let alertTitle:     			String = NSLocalizedString("AlertTitleSignIn", comment: "")
		let alertMessage:   			String = NSLocalizedString("AlertMessageSignIn", comment: "")
		
		// Create alertController
		let alertController: 			UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
		
		// Create password textField
		alertController.addTextField { (textField: UITextField) in
			
			textField.placeholder 		= NSLocalizedString("AlertMessageSignInPasswordPlaceholder", comment: "")
			textField.keyboardType 		= .default
			textField.isSecureTextEntry = true
		}
		
		// Create 'Cancel' action
		let cancelAlertActionTitle: 	String = NSLocalizedString("AlertActionTitleCancel", comment: "")
		let cancelAlertAction:			UIAlertAction = UIAlertAction(title: cancelAlertActionTitle, style: .cancel, handler: { (action: UIAlertAction) in
			
			self.dashboardBarView.set(newsBarIsSelectedYN: false, animateYN: true)
			
		})
		alertController.addAction(cancelAlertAction)
		
		// Create 'Enter' action
		let enterAlertActionTitle: 		String = NSLocalizedString("AlertActionTitleEnter", comment: "")
		let enterAlertAction:			UIAlertAction = UIAlertAction(title: enterAlertActionTitle, style: .default, handler: { (action: UIAlertAction) in
			
			// Get textField
			let textField: 				UITextField? = alertController.textFields?.first
			
			// Call completion handler
			enterTappedCompletionHandler(textField?.text)
			
		})
		alertController.addAction(enterAlertAction)
		
		DispatchQueue.main.async {
			
			// Present alertController
			UIViewControllerHelper.getPresentedViewController().present(alertController, animated: true, completion: nil)
			
		}
		
		
	}
	
	fileprivate func switchNewsBarView() {
		
		// Create completion handler
		let signInSuccessfulCompletionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Load news snippets
			self.loadNewsSnippets()
			
			self.presentNewsBarView()
			
		}
		
		// If newsBarView is not shown then show, otherwise hide
		if (!self.newsBarView.isShownYN) {

			if (!self.controlManager!.isSignedInYN) {
				
				// Check signed in
				self.checkIsSignedIn()
				
			}
			
			// If not signed in present sign in alert
			if (!self.controlManager!.isSignedInYN) {
	
				self.presentSignInAlert(onSignInSuccessful: signInSuccessfulCompletionHandler)
				
			} else {
				
				self.presentNewsBarView()
				
			}
			
		}
		else {
			
			self.hideNewsBarView()
			
		}
	}
	
	fileprivate func presentNewsBarView() {
		
		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		self.newsBarView.isShownYN = true
		
		self.doPresentNewsBarViewAnimation(refreshArtworksCollectionViewLayoutYN: true)

	}
	
	fileprivate func hideNewsBarView() {
		
		self.newsBarView.isShownYN = false
		
		self.doHideNewsBarViewAnimation(refreshArtworksCollectionViewLayoutYN: true)
		
	}
	
	fileprivate func doPresentNewsBarViewAnimation(refreshArtworksCollectionViewLayoutYN: Bool) {

		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		self.newsBarView.alpha = 1
		
		UIView.animate(withDuration: 0.3, animations: {
			
			// Set newsBarView LeftLayoutConstraint
			self.newsBarViewLeftLayoutConstraint!.constant	= 0 + self.newsBarViewLeftLayoutConstraintOffset
			
			// Set artworksCollectionView RightLayoutConstraint
			self.setArtworksCollectionViewRightLayoutConstraint(setToDefaultYN: false)
			
			if (refreshArtworksCollectionViewLayoutYN) {
			
				// Call invalidateLayout to make sure layout is updated
				self.artworksCollectionView.collectionViewLayout.invalidateLayout()
				
				// Refresh artworksCollectionView layout
				//self.refreshArtworksCollectionViewLayout()
				
			}
			
			self.view.layoutIfNeeded()
			
		}) { (completedYN) in
			
			if (refreshArtworksCollectionViewLayoutYN) {

				// Refresh artworksCollectionView layout
				self.refreshArtworksCollectionViewLayout()

			}

		}
		
	}
	
	fileprivate func doHideNewsBarViewAnimation(refreshArtworksCollectionViewLayoutYN: Bool) {
		
		UIView.animate(withDuration: 0.3, animations: {

			// Set newsBarView LeftLayoutConstraint
			self.newsBarViewLeftLayoutConstraint!.constant	= (0 + self.newsBarViewLeftLayoutConstraintOffset) - self.newsBarViewWidthLayoutConstraint!.constant
			
			// Set artworksCollectionView RightLayoutConstraint to default value
			self.setArtworksCollectionViewRightLayoutConstraint(setToDefaultYN: true)

			if (refreshArtworksCollectionViewLayoutYN) {
				
				// Call invalidateLayout to make sure layout is updated
				self.artworksCollectionView.collectionViewLayout.invalidateLayout()
				
				// Refresh artworksCollectionView layout
				//self.refreshArtworksCollectionViewLayout()
				
			}
			
			self.view.layoutIfNeeded()
			
		}) { (completedYN) in
	
			self.newsBarView.alpha = 0
			
			if (refreshArtworksCollectionViewLayoutYN) {
				
				// Refresh artworksCollectionView layout
				self.refreshArtworksCollectionViewLayout()
			
			}
			
		}
		
	}
	
	fileprivate func switchDashboardMenuView() {
		
		// If dashboardMenuView is not shown then show, otherwise hide
		if (!self.dashboardMenuViewIsShownYN) {
			
			self.dashboardMenuViewIsShownYN = true
			self.dashboardMenuView.presentMenu()
		}
		else {
			self.dashboardMenuViewIsShownYN = false
			self.dashboardMenuView.dismissMenu()
		}
	}
	
	fileprivate func abortArtworksCollectionViewScroll() {
		
		if (self.artworksCollectionView.isDragging || self.artworksCollectionView.isDecelerating) {
			
			self.artworksCollectionView.setContentOffset(self.artworksCollectionView.contentOffset, animated: false)
		}
	}
	
	fileprivate func createArtworkCollectionViewCell(for dataItem: ArtworkWrapper, at indexPath: IndexPath) -> ArtworkCollectionViewCell {
	
		let cell = self.artworksCollectionView.dequeueReusableCell(withReuseIdentifier: "ArtworkCollectionViewCell", for: indexPath) as! ArtworkCollectionViewCell
		
		cell.delegate = self
		
		// Set the item in the cell
		cell.set(item: dataItem)
		
		// Load thumbnail image
		if (dataItem.thumbnailImageData == nil) {
			self.loadThumbnailImage(for: dataItem, in: cell, indexPath: indexPath)
		}
		
		return cell
		
	}
	
	fileprivate func loadThumbnailImage(for dataItem: ArtworkWrapper, in cell: ArtworkCollectionViewCell, indexPath: IndexPath) {
		
		// Create completion handler
		let loadArtworkThumbnailImageDataCompletionHandler: ((Data?, Error?) -> Void) =
		{
			(data, error) -> Void in
			
			// Set image in cell
			if let data = data {
				
				DispatchQueue.main.async {
					
					cell.set(thumbnailImage: UIImage(data: data)!)
				}
				
			} else {
				
				cell.set(thumbnailImage: nil)
			}
		}
		
		self.controlManager!.loadArtworkThumbnailImageData(for: dataItem, oncomplete: loadArtworkThumbnailImageDataCompletionHandler)
	}
	
	fileprivate func presentActivityIndicatorView(animateYN: Bool) {
		
		if (animateYN) {
			
			// Show view
			UIView.animate(withDuration: 0.3) {
				
				self.activityIndicatorView.alpha 	= 1
			}
			
		} else {
			
			self.activityIndicatorView.alpha 		= 1
		}
		
	}
	
	fileprivate func hideActivityIndicatorView() {
		
		DispatchQueue.main.async {
			
			guard (self.activityIndicatorView.alpha != 0) else { return }
			
			// Hide view
			UIView.animate(withDuration: 0.3) {
				
				self.activityIndicatorView.alpha 	= 0
			}
			
		}
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

	fileprivate func presentArtworkCommentsDisplay(artworkID: Int) {
		
		// Create view controller
		let viewController = storyboard?.instantiateViewController(withIdentifier: "ArtworkCommentsDisplay") as? ArtworkCommentsDisplayViewController
		
		// Set initial values
		viewController!.set(artworkID: artworkID)
		
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
	
	fileprivate func loadAwards(presentAwardsViewYN: Bool) {
		
		guard (!self.isAwardsLoadedYN) else { return }
		
		self.isAwardsLoadedYN = true
		
		// Create completion handler
		let loadAwardsCompletionHandler: (([AwardWrapper], Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in

			guard (items.count > 0) else { return }
			
			DispatchQueue.main.async(execute: {

				self.awardsButtonView.isHidden = false
				
				self.view.layoutIfNeeded()
				
				// Display awards
				self.controlManager!.displayAwards()
	
				if (presentAwardsViewYN) {
					
					self.presentAwardsView()
					
				}
				
			})
		}
		
		DispatchQueue.global().async {
			
			self.controlManager!.loadAwards(oncomplete: loadAwardsCompletionHandler)
		
		}
		
	}
	
	fileprivate func switchAwardsView() {
		
		// If awardsView is not shown then show, otherwise hide
		if (!self.awardsBarView.isShownYN) {
			
			self.presentAwardsView()
			
		}
		else {
			
			self.hideAwardsView()

		}
	}
	
	fileprivate func clearAwardsView() {
		
		self.isAwardsLoadedYN = false
		
		self.hideAwardsView()
		
		self.awardsButtonView.isHidden = true
		
		self.controlManager!.clearAwardsView()
		
	}
	
	fileprivate func presentAwardsView() {
		
		self.awardsBarView.isHidden = false

		self.doAwardsButtonShrinkAnimation()
		self.awardsBarView.present(animateYN: true)
		
	}
	
	fileprivate func hideAwardsView() {
	
		self.doAwardsButtonGrowAnimation()
		self.awardsBarView.hide(animateYN: true)
		
		self.awardsBarView.isHidden = true
	}
	
	fileprivate func doAwardsButtonGrowAnimation() {
		
		UIView.animate(withDuration: 0.2, animations: {
			
			self.awardsButtonView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

			self.view.layoutIfNeeded()

		})
		
	}
	
	fileprivate func doAwardsButtonShrinkAnimation() {
		
		UIView.animate(withDuration: 0.2, animations: {
			
			self.awardsButtonView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			
			self.view.layoutIfNeeded()

		})
		
	}
	
	fileprivate func setAwardsBarViewWidth() {
	
		if (self.traitCollection.horizontalSizeClass != .regular) {
			
			self.awardsBarViewEqualWidthLayoutConstraint.constant = 0
			return
			
		}
		
		self.awardsBarViewEqualWidthLayoutConstraint.constant = self.awardsBarViewEqualWidthLayoutConstraintConstant
		
		
		
		self.view.layoutIfNeeded()
		
		let widthDifference: CGFloat = self.view.frame.size.width - self.awardsBarViewMaximumWidth
		
		if (self.awardsBarView.frame.size.width > self.awardsBarViewMaximumWidth) {
			
			self.awardsBarViewEqualWidthLayoutConstraint.constant = 0 - widthDifference
			
		}

	}
	
	fileprivate func setAwardsBarViewHeight(contentSize: CGSize) {
		
		self.awardsBarViewHeightLayoutConstraint.constant = self.awardsBarViewContainerViewPadding + contentSize.height + self.awardsBarViewContainerViewPadding + self.awardsBarViewPadding
		
	}

	fileprivate func setArtworksCollectionViewRightLayoutConstraintDefault() {
		
		self.artworksCollectionViewRightLayoutConstraintDefault = self.artworksCollectionViewRightLayoutConstraint.constant
		
	}
	
	fileprivate func checkSetArtworksCollectionViewRightLayoutConstraintYN() {
		
		self.setArtworksCollectionViewRightLayoutConstraintYN = false
		
		// If artworksCollectionView width is reduced below width sufficient for 1 column
		if (self.view.frame.size.width - self.newsBarViewWidthLayoutConstraint.constant < 250) {
			
			self.setArtworksCollectionViewRightLayoutConstraintYN = true
			
		}
		
	}
	
	fileprivate func setArtworksCollectionViewRightLayoutConstraint(setToDefaultYN: Bool) {
		
		// Set to default value if setToDefaultYN or newsBarView is not shown
		if (setToDefaultYN || !self.newsBarView.isShownYN) {
			
			self.artworksCollectionViewRightLayoutConstraint.constant = self.artworksCollectionViewRightLayoutConstraintDefault
			
			return
			
		}
		
		if (self.setArtworksCollectionViewRightLayoutConstraintYN) {
			
			self.artworksCollectionViewRightLayoutConstraint.constant = self.artworksCollectionViewRightLayoutConstraintDefault - self.newsBarViewWidthLayoutConstraint.constant
			
		} else {
			
			self.artworksCollectionViewRightLayoutConstraint.constant = self.artworksCollectionViewRightLayoutConstraintDefault
			
		}
		
	}
	
	fileprivate func refreshArtworksCollectionViewLayout() {
		
		// Call invalidateLayout to make sure layout is updated
		self.artworksCollectionView.collectionViewLayout.invalidateLayout()
		
		// Call reloadData to ensure cells are resized
		self.artworksCollectionView.reloadData()
		
	}
	
	fileprivate func loadNewsSnippets() {
		
		// Check isSignedInYN
		guard (self.controlManager!.isSignedInYN) else { return }
		
		guard (!self.isNewsSnippetsLoadedYN) else { return }
		
		self.isNewsSnippetsLoadedYN = true
		
		// Create completion handler
		let loadNewsSnippetsCompletionHandler: (([NewsSnippetWrapper], Error?) -> Void) =
		{
			[unowned self] (items, error) -> Void in
			
			guard (items.count > 0) else { return }
			
			DispatchQueue.main.async(execute: {
	
				self.view.layoutIfNeeded()
				
				// Display news snippets
				self.newsBarView.displayNewsSnippets(items: items)
				
				self.view.layoutIfNeeded()
				
			})
		}
		
		DispatchQueue.global().async {
			
			self.controlManager!.loadNewsSnippets(oncomplete: loadNewsSnippetsCompletionHandler)
			
		}
		
	}
	
	fileprivate func clearNewsSnippetsView() {
		
		self.isNewsSnippetsLoadedYN = false

		self.newsBarView.clearNewsSnippets()
		
		//self.controlManager!.clearNewsSnippetsView()
		
	}
	
	fileprivate func setNewsBarViewLeftLayoutConstraint() {
		
		if (!self.newsBarView.isShownYN) {
			
			// Set newsBarView LeftLayoutConstraint
			self.newsBarViewLeftLayoutConstraint!.constant	= (0 + self.newsBarViewLeftLayoutConstraintOffset) - self.newsBarViewWidthLayoutConstraint!.constant
			
		}
		
	}
	
	
	// MARK: - awardsButton TapGestureRecognizer Methods
	
	@IBAction func awardsButtonTapped(_ sender: Any) {
		
		self.switchAwardsView()
		
	}
	
}

// MARK: - Extension ProtocolMainDisplayControlManagerDelegate

extension GalleryListDisplayViewController: ProtocolGalleryControlManagerBaseDelegate {
	
	// MARK: - Public Methods
	
	public func galleryControlManagerBase(signInFailed sender: GalleryControlManagerBase) {
		
		self.presentSignInAlert(onSignInSuccessful: nil)

	}
	
}

// MARK: - Extension UIScrollViewDelegate

extension GalleryListDisplayViewController: UIScrollViewDelegate {
	
	// Public Methods
	
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		// Check user scrolling
		guard (scrollView.isDragging || scrollView.isDecelerating) else {
			return
		}
		
		// Check state
		guard ( self.isInitialLoadCompleteYN				== true &&
				self.controlManager!.isLoadingDataYN		== false &&
				ArtworkWrappers.hasLoadedAllNextItemsYN		== false) else {
			return
		}
	
		// Check at bottom zone
		let detectBottomZoneHeight:		CGFloat = 150.0 as CGFloat!
		let contentOffset:				CGFloat = scrollView.contentOffset.y
		let maximumOffset:				CGFloat = scrollView.contentSize.height - scrollView.bounds.size.height
		
		if (maximumOffset - contentOffset <= detectBottomZoneHeight)
			&& (maximumOffset - contentOffset != -5.0) {
		
			self.isDataViewAtBottomZoneYN = true
		} else {
			
			self.isDataViewAtBottomZoneYN = false
		}
		
		if (!self.isDataViewAtBottomZoneYN) { return }
		
		// Check should load more
		if (self.shouldLoadMoreArtworks()) {
			
			// Load data
			self.loadArtworks(toFillYN: false)
		}
		
	}
	
}

// MARK: - Extension UICollectionViewDelegate

extension GalleryListDisplayViewController: UICollectionViewDelegate {
	
	// Public Methods
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// Get the item
		let artworkWrapper: ArtworkWrapper	= ArtworkWrappers.items[indexPath.row]
		
		// Create the cell
		let cell = self.createArtworkCollectionViewCell(for: artworkWrapper, at: indexPath)
		
		return cell
	}
	
}

// MARK: - Extension UICollectionViewDataSource

extension GalleryListDisplayViewController: UICollectionViewDataSource {
	
	// Public Methods
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return ArtworkWrappers.items.count
	}

}

// MARK: - Extension SFProtocolCollectionViewLayoutDelegate

extension GalleryListDisplayViewController: SFProtocolCollectionViewLayoutDelegate {
	
	// Public Methods
	
	func collectionView(collectionView:UICollectionView, heightForCellAtIndexPath indexPath:NSIndexPath, withWidth:CGFloat) -> CGFloat {

		// Get the item
		let artworkWrapper: ArtworkWrapper	= ArtworkWrappers.items[indexPath.row]
		
		// Calculate cell height
		let result: 		CGFloat = self.heightForCell(of: artworkWrapper, withWidth: withWidth)
		
		return result
	}
	
	func setCustomAttributes(attributes: SFCollectionViewLayoutAttributes) {
		
		// TODO:
	}
	
	
	// MARK: - Private Methods
	
	fileprivate func heightForCell(of artworkWrapper: ArtworkWrapper, withWidth width: CGFloat) -> CGFloat {
		
		var result: 							CGFloat = 0
		
		// itemDetailViewHeight
		let itemDetailViewHeight: 				CGFloat = self.heightForItemDetailView(of: artworkWrapper, withWidth: width)

		artworkWrapper.itemDetailViewHeight 	= itemDetailViewHeight
		result += itemDetailViewHeight
		
		// Check latestArtworkCommentText
		if (artworkWrapper.latestArtworkCommentText.count > 0) {
			
			// margin = 10
			result += 10
			
			// itemLatestArtworkCommentViewHeight
			let itemLatestArtworkCommentViewHeight: 			CGFloat = self.heightForItemLatestArtworkCommentView(of: artworkWrapper, withWidth: width)
			
			artworkWrapper.itemLatestArtworkCommentViewHeight 	= itemLatestArtworkCommentViewHeight
			result += itemLatestArtworkCommentViewHeight

		}
		
		return result
	}
	
	fileprivate func heightForItemDetailView(of artworkWrapper: ArtworkWrapper, withWidth width: CGFloat) -> CGFloat {
		
		var result: CGFloat = 0

		// margin = 0
		result += 0
		
		// thumbnailImage height
		result += self.heightForThumbnailImage(of: artworkWrapper, withWidth: width)
		
		// margin = 5
		result += 5
		
		// nameLabel height
		result += self.heightForNameLabel(of: artworkWrapper, withWidth: width)
		
		// margin = 5
		result += 5
		
		// height of button stack view = 20
		result += 20
		
		// margin = 5
		result += 5
		
		return result
	}

	fileprivate func heightForItemLatestArtworkCommentView(of artworkWrapper: ArtworkWrapper, withWidth width: CGFloat) -> CGFloat {
		
		var result: CGFloat = 0
		
		// latestCommentLabel height
		result += self.heightForLatestArtworkCommentLabel(of: artworkWrapper, withWidth: width)
		
		// margin = 5
		result += 5
		
		// postedBy, datePosted height = 15
		result += 15
		
		// margin = 5
		result += 5
		
		// seeAllComments = 15
		result += 15
		
		return result
	}
	
	fileprivate func heightForThumbnailImage(of artworkWrapper: ArtworkWrapper, withWidth width: CGFloat) -> CGFloat {
	
		// Default height is thumbnailImageHeightPixels
		var height:				CGFloat = artworkWrapper.thumbnailImageHeightPixels
		
		// Get aspect ratio
		let aspectRatio:		CGFloat = artworkWrapper.thumbnailImageWidthPixels / artworkWrapper.thumbnailImageHeightPixels
		
		// If thumbnailImageWidthPixels fills cell.thumbnailImageView then determine height using aspectRatio
		if (artworkWrapper.thumbnailImageWidthPixels >= width) {
			
			height = width / aspectRatio
		}
		
		artworkWrapper.thumbnailImageDisplayHeight = height
		
		return height
	}
	
	fileprivate func heightForNameLabel(of artworkWrapper: ArtworkWrapper, withWidth width: CGFloat) -> CGFloat {
		
		let width			= width - 10	// Margin in storyboard (ie. 5 either side)
		let topMargin		= CGFloat(0)
		let bottomMargin	= CGFloat(0)
		let font 			= UIFont.systemFont(ofSize: 14, weight: .regular)
	
		// Determine textHeight
		let textRect		= NSString(string: artworkWrapper.name).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
		let textHeight		= ceil(textRect.height)
		
		// Determine label height
		let labelHeight		= topMargin + textHeight + bottomMargin
		
		return labelHeight
	}
	
	fileprivate func heightForLatestArtworkCommentLabel(of artworkWrapper: ArtworkWrapper, withWidth width: CGFloat) -> CGFloat {
		
		let width			= width - 10		// Margin in storyboard (ie. 0 either side)
		let topMargin		= CGFloat(0)
		let bottomMargin	= CGFloat(0)
		let font 			= UIFont.systemFont(ofSize: 12, weight: .regular)
		
		// Determine textHeight
		let textRect		= NSString(string: artworkWrapper.latestArtworkCommentText).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
		let textHeight		= ceil(textRect.height)
		
		// Determine label height
		let labelHeight		= topMargin + textHeight + bottomMargin
		
		return labelHeight
	}
	
}

// MARK: - Extension ProtocolArtworkCollectionViewCellDelegate

extension GalleryListDisplayViewController: ProtocolArtworkCollectionViewCellDelegate {
	
	// Public Methods
	
	public func artworkCollectionViewCell(cell:ArtworkCollectionViewCell, didTapThumbnailImage image: UIImageView) {

		self.presentGalleryItemDisplay(artworkID: cell.item!.id)
	}
	
	public func artworkCollectionViewCell(cell: ArtworkCollectionViewCell, didTapLikeButton item: ArtworkWrapper, oncomplete completionHandler:@escaping () -> Void) {
		
		// Check is connected
		guard (self.controlManager!.checkIsConnected()) else { return }
		
		// Present 'liked artwork' view
		self.presentLikedArtworkView()
		
		// Like artwork
		self.controlManager!.likeArtwork(for: item)
		
		// Call the completion handler
		completionHandler()
	}
	
	public func artworkCollectionViewCell(cell:ArtworkCollectionViewCell, didTapCommentsButton item: ArtworkWrapper) {
		
		self.presentArtworkCommentsDisplay(artworkID: item.id)
	}
	
}

// MARK: - Extension ProtocolNewsBarViewDelegate

extension GalleryListDisplayViewController: ProtocolNewsBarViewDelegate {

	// Public Methods
	
}

// MARK: - Extension ProtocolDashboardMenuViewDelegate

extension GalleryListDisplayViewController: ProtocolDashboardMenuViewDelegate {
	
	// Public Methods
	
	public func dashboardMenuView(didDismiss sender: DashboardMenuView) {
		
		self.dashboardMenuViewIsShownYN = false
	}
	
	public func dashboardMenuView(sender: DashboardMenuView, didSelectDaughter daughter: Daughters) {
		
		// Create completion handler
		let completionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Reload artworks
			self.loadArtworks(toFillYN: true)
		}
		
		// Check daughter has changed
		if (daughter != self.controlManager!.selectedDaughter) {
			
			self.presentActivityIndicatorView(animateYN: true)
			
			// Store selected daughter. This clears data
			self.controlManager!.set(selectedDaughter: daughter)
			
			// Set daughter in dashboard bar
			self.dashboardBarView.set(daughter: daughter)
			
			// Clear awards view
			self.clearAwardsView()
			
			// Clear news snippets view
			self.clearNewsSnippetsView()
			
			// Clear artworks view
			self.clearArtworksCollectionView(oncomplete: completionHandler)
			
		}
		
	}
	
	public func dashboardMenuView(sender: DashboardMenuView, didSelectYear year: Int) {
		
		// Create completion handler
		let completionHandler: ((Error?) -> Void) =
		{
			(error) -> Void in
			
			// Reload artworks
			self.loadArtworks(toFillYN: true)
		}
		
		// Check year has changed
		if (year != self.controlManager!.selectedYear) {
			
			self.presentActivityIndicatorView(animateYN: true)
			
			// Store selected year. This clears data
			self.controlManager!.set(selectedYear: year)
			
			// Set year in dashboard bar
			self.dashboardBarView.set(year: year)
			
			// Clear awards view
			self.clearAwardsView()
			
			// Clear news snippets view
			self.clearNewsSnippetsView()
			
			// Clear artworks view
			self.clearArtworksCollectionView(oncomplete: completionHandler)
			
		}
	}
	
}

// MARK: - Extension ProtocolDashboardBarViewDelegate

extension GalleryListDisplayViewController: ProtocolDashboardBarViewDelegate {
	
	// Public Methods
	
	public func dashboardBarView(sender: DashboardBarView, daughterChanged daughter: Daughters) {
		
		if (!hasViewAppearedYN) { return }
		
		// TODO:
	}
	
	public func dashboardBarView(sender: DashboardBarView, yearChanged year: Int) {
		
		if (!hasViewAppearedYN) { return }
		
		// TODO:
	}
	
	public func dashboardBarView(sender: DashboardBarView, daughterButtonTapped daughter: Daughters) {
		
		self.switchDashboardMenuView()
	}
	
	public func dashboardBarView(sender: DashboardBarView, yearButtonTapped year: Int) {

		self.switchDashboardMenuView()
	}

	public func dashboardBarView(sender: DashboardBarView, newsBarButtonTapped newsBarIsSelectedYN: Bool) {
		
		self.switchNewsBarView()
		
	}
	
}

// MARK: - Extension ProtocolAwardsBarViewDelegate

extension GalleryListDisplayViewController: ProtocolAwardsBarViewDelegate {
	
	// Public Methods
	
	public func awardsBarView(didSetContentSize sender: AwardsBarView, size: CGSize) {
		
		self.setAwardsBarViewHeight(contentSize: size)
		
	}
	
}

// MARK: - Extension ProtocolGalleryItemDisplayViewControllerDelegate

extension GalleryListDisplayViewController: ProtocolGalleryItemDisplayViewControllerDelegate {

	// MARK: - Methods
	
	public func galleryItemDisplayViewController(didDismiss sender: GalleryItemDisplayViewController) {
		
		self.artworksCollectionView.reloadData()
	}
	
}

// MARK: - Extension ProtocolArtworkCommentsDisplayViewControllerDelegate

extension GalleryListDisplayViewController: ProtocolArtworkCommentsDisplayViewControllerDelegate {
	
	// MARK: - Methods
	
	public func artworkCommentsDisplayViewController(didDismiss sender: ArtworkCommentsDisplayViewController) {
		
		self.hideFadeOutView()
	}
	
	public func artworkCommentsDisplayViewController(didPostComment sender: ArtworkCommentsDisplayViewController) {
		
		self.artworksCollectionView.reloadData()
	}
	
}

// MARK: - Extension ProtocolPanGestureHelperDelegate

extension GalleryListDisplayViewController: ProtocolPanGestureHelperDelegate {

	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStartedWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .right) {		// Check if moving right
			
			// Call invalidateLayout to make sure layout is updated
			self.artworksCollectionView.collectionViewLayout.invalidateLayout()
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningContinuedWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .left) {		// Check if moving left
			
			if (!self.newsBarView.isShownYN) { return }
			
			// Get distance moved
			let distanceMovedLeft: CGFloat = attributes.initialTouchPoint.x - attributes.currentTouchPoint.x
			
			// Check distance moved is not to the right
			if (distanceMovedLeft < 0) { return }
			
			// Move view position
			self.newsBarViewLeftLayoutConstraint!.constant	= (0 + self.newsBarViewLeftLayoutConstraintOffset) - distanceMovedLeft
			
			self.view.layoutIfNeeded()

		} else if (attributes.direction == .right) {	// Check if moving right
			
			if (!self.controlManager!.isSignedInYN) { return }
			if (self.newsBarView.isShownYN) { return }
			if (self.newsBarViewLeftLayoutConstraint!.constant >= (0 + self.newsBarViewLeftLayoutConstraintOffset)) { return }
		
			self.newsBarView.alpha = 1
			
			// Get distance moved
			let distanceMovedRight: CGFloat = attributes.currentTouchPoint.x - attributes.initialTouchPoint.x
			
			// Check distance moved is not to the left
			if (distanceMovedRight < 0) { return }
			
			// Move view position
			self.newsBarViewLeftLayoutConstraint!.constant	= ((0 + self.newsBarViewLeftLayoutConstraintOffset) - self.newsBarViewWidthLayoutConstraint!.constant) + distanceMovedRight
			
			self.view.layoutIfNeeded()
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedWith attributes: PanGestureAttributes) {
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedAfterThresholdWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .left) {			// Check if moving left
			
			if (!self.newsBarView.isShownYN) { return }
			
			self.dashboardBarView.set(newsBarIsSelectedYN: false, animateYN: true)
			
			// Hide news bar
			self.hideNewsBarView()

		} else if (attributes.direction == .right) {	// Check if moving right
			
			if (self.newsBarView.isShownYN) { return }
			
			self.dashboardBarView.set(newsBarIsSelectedYN: true, animateYN: true)
			
			// Present news bar
			self.presentNewsBarView()
			
		}
		
	}
	
	public func panGestureHelper(for gesture: UIPanGestureRecognizer, panningStoppedBeforeThresholdWith attributes: PanGestureAttributes) {
		
		if (attributes.direction == .left) {			// Check if moving left
			
			if (!self.newsBarView.isShownYN) { return }

			// Reset view position
			self.doPresentNewsBarViewAnimation(refreshArtworksCollectionViewLayoutYN: false)

		} else if (attributes.direction == .right) {	// Check if moving right
			
			if (self.newsBarView.isShownYN) { return }
			
			// Reset view position
			self.doHideNewsBarViewAnimation(refreshArtworksCollectionViewLayoutYN: false)
			
		}
		
	}
	
}

