//
//  SK4ConfigGenerics.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 値型を管理するためのGenericsクラス
open class SK4ConfigGenerics<ValueType: Equatable>: SK4ConfigValue {

	/// 実際の値
	open var value: ValueType {
		didSet {
			if value == oldValue {
				return
			}

			configAdmin?.onChange(self)

			if changeToCell {
				cell.updateCell()
			}
		}
	}

	/// true: 値が変化したときにCellを更新する
	public var changeToCell = false

	/// 初期化
	public init(title: String, identifier: String? = nil, value: ValueType) {
		self.value = value
		super.init(title: title, identifier: identifier)

		self.defaultValue = string
	}

}

// eof
