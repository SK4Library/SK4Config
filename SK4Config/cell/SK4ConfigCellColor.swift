//
//  SK4ConfigCellColor.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIColorを選択
public class SK4ConfigCellColor: SK4ConfigCell {

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title
		cell.detailTextLabel?.text = "　　　　"
		cell.accessoryType = readOnly ? .none : .disclosureIndicator
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable?.colorViewController.configValue = configValue
		return configTable?.colorViewController
	}

	/// Cellが表示される
	override public func willDisplayCell(_ cell: UITableViewCell) {
		if let cv = configValue as? SK4ConfigUIColor {
			cell.detailTextLabel?.backgroundColor = cv.value
		}
	}
}

// eof
