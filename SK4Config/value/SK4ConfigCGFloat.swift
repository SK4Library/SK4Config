//
//  SK4ConfigCGFloat.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// CGFloat型の設定を管理するためのクラス
open class SK4ConfigCGFloat: SK4ConfigGenerics<CGFloat> {

	/// 文字列への変換で使用するフォーマット
	public var convertFormat = "%0.2f"

	/// 値と文字列を相互に変換
	override open var string: String {
		get {
			return String(format: convertFormat, Double(value))
		}

		set {
			let val = Double(newValue) ?? 0
			value = CGFloat(val)
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil, value: CGFloat) {
		super.init(title: title, identifier: identifier, value: value)
	}

}

// eof
