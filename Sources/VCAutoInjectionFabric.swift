//
//  VCAutoInjectionFabric.swift
//  Pods
//
//  Created by Ивлев А.Е. on 10.10.16.
//
//

import Foundation

typealias VCInjector<VC: UIViewController, Action> = (_ vc: VC, _ action: Action)->()
typealias Initializer<VC: UIViewController> = (_ vc: VC)->()

class VCAutoInjectionFabric: VCFabric {
	init(fabric: VCFabric) {
		self.baseFabric = fabric
	}
	
	func add(injector: VCInjectorWithAction) {
		let key = injector.key
		
		if nil == injectors[key] {
			injectors[key] = []
		}
		
		injectors[key]!.append(injector)
	}
	
	func add<VC: UIViewController>(_ type: VC.Type, initializer: @escaping Initializer<UIViewController>) {
		let key = String(describing: VC.self)
		
		if nil == initializers[key] {
			initializers[key] = []
		}
		
		initializers[key]!.append(initializer)
	}
	
	func newBy<T: UIViewController>(type: T.Type) -> T? {
		guard let vc = baseFabric.newBy(type: type) else {
			return nil
		}
		
		let key = String(describing: type)
		
		if let injectors = self.injectors[key] {
			for pair in injectors {
				pair.injector(vc, pair.action)
			}
		}
		
		if let initializers = self.initializers[key] {
			for initializer in initializers {
				initializer(vc)
			}
		}
		
		return vc
	}
	
	private let baseFabric: VCFabric
	private var injectors: [VCInjectorWithAction.Key: [VCInjectorWithAction]] = [:]
	private var initializers: [VCInjectorWithAction.Key: [Initializer<UIViewController>]] = [:]
}

class VCInjectorWithAction {
	typealias Key = String
	
	init<VC: UIViewController, Action>(injector: @escaping VCInjector<VC,Action>) {
		self.injector = { injector($0 as! VC, $1 as! Action) }
		self.key = Key(describing: VC.self)
	}
	
	var action: Any!
	
	fileprivate let key: Key
	fileprivate let injector: VCInjector<UIViewController, Any>
}

