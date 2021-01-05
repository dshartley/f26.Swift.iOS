//
//  ProtocolAwardsBarViewViewAccessStrategy.swift
//  f26View
//
//  Created by David on 09/12/2017.
//  Copyright © 2017 com.smartfoundation. All rights reserved.
//

import UIKit
import f26Core

/// Defines a class which provides a strategy for accessing the AwardsBarView view
public protocol ProtocolAwardsBarViewViewAccessStrategy {
	
	// MARK: - Methods
	
	func displayAwards(items: [AwardWrapper])
	
}
