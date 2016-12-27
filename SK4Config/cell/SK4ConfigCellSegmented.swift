//
//  SK4ConfigCellSegmented.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// 設定をUISegmentedControlで選択
public class SK4ConfigCellSegmented: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let paddingRight: CGFloat = 10
	}

	let targetAction = SK4TargetAction()

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
		let seg = UISegmentedControl()
		seg.tag = Const.ctrlTag
		seg.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
		cell.contentView.addSubview(seg)
		return cell
	}

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title

		guard let index = configValue as? SK4ConfigIndex else { return }

		let seg = cell.contentView.viewWithTag(Const.ctrlTag) as! UISegmentedControl
		seg.removeAllTarget()

		targetAction.setup(control: seg, event: .valueChanged) { [weak self] sender in
			if let index = self?.configValue as? SK4ConfigIndex {
				index.value = seg.selectedSegmentIndex
			}
		}

		// コントロールの中身をセット
		seg.removeAllSegments()
		for (i, val) in index.textArray.enumerated() {
			seg.insertSegment(withTitle: val, at: i, animated: false)
		}

		seg.selectedSegmentIndex = index.value
		seg.isEnabled = !readOnly
		seg.sizeToFit()

		// 位置を調整しておく
		let cs = cell.contentView.bounds.size
		let ss = seg.bounds.size
		seg.frame.origin.x = cs.width - ss.width - Const.paddingRight
		seg.frame.origin.y = 8
	}

}

// eof
