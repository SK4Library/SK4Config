//
//  SK4ConfigCellSwitch.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// 設定をUISwitchで選択
public class SK4ConfigCellSwitch: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let ctrlFrame = CGRect(x: 251, y: 6, width: 51, height: 31)
	}

	let targetAction = SK4TargetAction()

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
		let sw = UISwitch(frame: Const.ctrlFrame)
		sw.tag = Const.ctrlTag
		sw.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
		cell.contentView.addSubview(sw)
		return cell
	}

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title

		let sw = cell.contentView.viewWithTag(Const.ctrlTag) as! UISwitch
		sw.removeAllTarget()

		targetAction.setup(control: sw, event: .valueChanged) { [weak self] sender in
			let sw = sender as! UISwitch
			self?.configValue.string = SK4ConfigBool.boolToString(sw.isOn)
		}

		sw.isOn = SK4ConfigBool.stringToBool(configValue.string)
		sw.isEnabled = !readOnly
	}

}

// eof
