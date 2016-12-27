//
//  SK4ConfigCellDirectory.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 設定の階層構造を表示　※SK4ConfigAdmin専用
class SK4ConfigCellDirectory: SK4ConfigCell {
	override init() {
		super.init()

		accessoryType = .disclosureIndicator
	}

	override func nextViewController() -> UIViewController? {
		configTable?.dirViewController.configAdmin = configValue as? SK4ConfigAdmin
		configTable?.dirViewController.subDir = true
		return configTable?.dirViewController
	}

}

// eof
