//
//  SK4ConfigIndex.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation
import SK4Library

/// 複数の選択肢とIndexを管理するためのクラス
public class SK4ConfigIndex: SK4ConfigGenerics<Int> {

	/// 値と文字列を相互に変換
	override public var string: String {
		get {
			return String(value)
		}

		set {
			value = Int(newValue) ?? -1
		}
	}

	/// 選択肢
	public var textArray = [String]()

	/// 詳細情報
	public var detailArray: [String]?

	/// 現在の選択
	public var selectText: String? {
		get {
			return textArray.safe(value)
		}

		set {
			if let str = newValue, let no = textArray.index(of: str) {
				value = no
			} else {
				value = -1
			}
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil, value: Int) {
		super.init(title: title, identifier: identifier, value: value)

		self.changeToCell = true
		self.cell = SK4ConfigCellChoice()
	}

	/// ランダムに変更
	override public func random() {
		if readOnly == false {
			value = sk4Random(max: textArray.count)
		}
	}
}

// eof
