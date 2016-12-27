//
//  SK4ConfigCellDate.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// Dateを選択
public class SK4ConfigCellDate: SK4ConfigCell {

	/// 初期化
	override public init() {
		super.init()
		accessoryType = .disclosureIndicator
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable?.dateViewController.configValue = configValue
		return configTable?.dateViewController
	}

}

// eof
