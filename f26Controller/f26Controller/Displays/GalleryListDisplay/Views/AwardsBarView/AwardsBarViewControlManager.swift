//
//  AwardsBarViewControlManager.swift
//  f26Controller
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import SFController
import f26View
import f26Model
import f26Core

/// Manages the AwardsBarView control layer
public class AwardsBarViewControlManager: ControlManagerBase {
	
	// MARK: - Public Stored Properties
	
	public weak var delegate:		ProtocolAwardsBarViewControlManagerDelegate?
	public var viewManager:			AwardsBarViewViewManager?
	
	
	// MARK: - Private Stored Properties
	
	
	// MARK: - Initializers
	
	public override init() {
		super.init()
	}
	
	public init(modelManager: ModelManager, viewManager: AwardsBarViewViewManager) {
		super.init(modelManager: modelManager)
		
		self.viewManager				= viewManager
	}
	
	
	// MARK: - Public Methods
	
	
	// MARK: - Override Methods

	
}
