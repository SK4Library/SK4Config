//
//  SK4ConfigCellColorIndex.swift
//  SK4Config
//
//  Created by See.Ku on 2016/04/17.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIColorを指定された候補の中から選択
public class SK4ConfigCellColorIndex: SK4ConfigCell {

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title
		cell.detailTextLabel?.text = "　　　　"
		cell.accessoryType = readOnly ? .none : .disclosureIndicator
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable?.choiceViewController.configValue = configValue
		return configTable?.choiceViewController
	}

	/// Cellが表示される
	override public func willDisplayCell(_ cell: UITableViewCell) {
		if let cv = configValue as? SK4ConfigIndex, let str = cv.selectText {
			cell.detailTextLabel?.backgroundColor = UIColor.fromString(str)
		}
	}
	
}

// eof
