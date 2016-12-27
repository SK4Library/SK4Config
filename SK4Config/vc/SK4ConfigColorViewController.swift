//
//  SK4ConfigColorViewController.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// 自作のカラーピッカーで色を選択するためのViewController
class SK4ConfigColorViewController: UIViewController {

	weak var configValue: SK4ConfigValue!

	var colorPicker: SK4ColorPicker!

	override func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトのView
		view.backgroundColor = UIColor.white

		// カラーピッカー
		let picker = SK4ColorPicker()
		picker.addTarget(self, action: #selector(SK4ConfigColorViewController.onChangeColor(_:)), for: .valueChanged)
		view.addSubview(picker)
		colorPicker = picker

		// AutoLayoutを設定
		let maker = SK4AutoLayout(viewController: self)
		maker.addDic(name: "picker", view: picker)

		let wy = UIDevice.isPad ? 500 : 240
		maker.addFormat("V:[topLayoutGuide]-16-[picker(>=\(wy))]")
		maker.addFormat("H:|-[picker]-|")
		view.addConstraints(maker.constraints)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.title = configValue.title

		if let cc = configValue as? SK4ConfigUIColor {
			colorPicker.color = cc.value
		}
	}

	func onChangeColor(_ sender: AnyObject) {
		if let cc = configValue as? SK4ConfigUIColor {
			cc.value = colorPicker.color
		}

		_ = navigationController?.popViewController(animated: true)
	}

}

// eof
