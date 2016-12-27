//
//  SK4ConfigUIColor.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// UIColor型の設定を管理するためのクラス
public class SK4ConfigUIColor: SK4ConfigGenerics<UIColor> {

	/// 値と文字列を相互に変換
	override public var string: String {
		get {
			return value.toString()
		}

		set {
			value = UIColor.fromString(newValue)
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil, value: UIColor) {
		super.init(title: title, identifier: identifier, value: value)

		self.changeToCell = true
		self.cell = SK4ConfigCellColor()
	}

	/// ランダムに変更
	override public func random() {
		if readOnly == false {
			value = .random
		}
	}

}

// eof
