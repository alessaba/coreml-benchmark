//
//  ViewController.swift
//  benchmark
//
//  Created by Eliot Andres on 9/20/19.
//  Copyright © 2019 Eliot Andres. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

	var inputData: [String] = ["Abby","Betteanne","Catherin","Devin","Eric","Faustina","Casey","Candice","Elon","Daniel","Lincoln","Simone","Jennifer","Justine","Steven"]
	let model = NamesDT()
	let iterations = 250
	var runs : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(startBenchmark), for: .touchUpInside)
        label.text = ""
    }

	@objc func startBenchmark() {
		self.runs = 0
		button.titleLabel?.text = "Loading..."
		button.isEnabled = false
		DispatchQueue.global(qos: .userInitiated).async {
			
			for _ in 0 ..< self.iterations{
				let run = self.benchmark()
				self.runs += run
			}
			DispatchQueue.main.sync{
				self.label.text = String(format: "%.2f", self.runs / Double(self.iterations))
				self.button.titleLabel?.text = "Start"
				self.button.isEnabled = true
			}
			
		}
	}

	func benchmark() -> Double {
		let start = Date()
		
		for i in inputData {
			do {
				//print(i)
				_ = try model.prediction(input: features(from: i))
			} catch let error {
				print(error.localizedDescription)
			}
		}
		
		let end = Date()
		let executionTime = end.timeIntervalSince(start)
		let imagesPerSecond = Double(inputData.count) / executionTime
		
		return imagesPerSecond
	}

}

func features(from string: String) -> [String: Double] {
	guard !string.isEmpty else {
		return [:]
	}
	
	let string = string.lowercased()
	var keys = [String]()
	
	keys.append("first-letter=\(string.prefix(1))")
	keys.append("first2-letters=\(string.prefix(2))")
	keys.append("first3-letters=\(string.prefix(3))")
	keys.append("last-letter=\(string.suffix(1))")
	keys.append("last2-letters=\(string.suffix(2))")
	keys.append("last3-letters=\(string.suffix(3))")
	
	return keys.reduce([String: Double]()) { (result, key) -> [String: Double] in
		var result = result
		result[key] = 1.0
		return result
	}
}
