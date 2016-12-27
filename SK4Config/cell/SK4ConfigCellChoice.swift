//
//  SK4ConfigCellChoice.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 複数の選択肢から1つを選択
public class SK4ConfigCellChoice: SK4ConfigCell {

	/// 詳細情報を表示するスタイル
	public var cellStyle = UITableViewCellStyle.default

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title

		if configValue.readOnly {
			cell.accessoryType = .none
		} else {
			cell.accessoryType = .disclosureIndicator
		}

		if let cv = configValue as? SK4ConfigIndex {
			cell.detailTextLabel?.text = cv.selectText
		}
	}

	/// 移動先のViewController
	override public func nextViewController() -> UIViewController? {
		configTable?.choiceViewController.configValue = configValue
		return configTable?.choiceViewController
	}
}

// eof
