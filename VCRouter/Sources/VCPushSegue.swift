//
//  VCPushSegue.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public final class VCPushSegue0: VCPushSegue<VCAction0> {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC)->()
	
	public func config(navigation: UINavigationController, animated: Bool) -> VCPushSegue0 {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func from<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCPushSegue0 {
		return _from(VC.self, injector: injector)
	}
	
	public func to<VC: UIViewController>(_ type: VC.Type, initializer: Initializer<VC>? = nil) {
		setup { [weak self] in return self?._to(VC.self) { initializer?($0) }() }
	}
}

public final class VCPushSegue1<Arg1>: VCPushSegue<VCAction1<Arg1>> {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC, _ arg1: Arg1)->()
	
	public func config(navigation: UINavigationController, animated: Bool) -> VCPushSegue1<Arg1> {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func from<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCPushSegue1<Arg1> {
		return _from(VC.self, injector: injector)
	}
	
	public func to<VC: UIViewController>(_ type: VC.Type, initializer: @escaping Initializer<VC>) {
		setup { [weak self] (arg1) in return self?._to(VC.self) { initializer($0, arg1) }() }
	}
}

// Implementation

public class VCPushSegue<Action> {
	public typealias Injector<VC: UIViewController> = (_ vc: VC, _ action: Action)->()
	
	init(fabric: VCAutoInjectionFabric) {
		self.fabric = fabric
	}
	
	fileprivate func _config(navigation: UINavigationController, animated: Bool) -> Self {
		self.navigation = navigation
		self.animated = animated
		return self
	}
	
	fileprivate func _from<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> Self {
		self.injector = VCInjectorWithAction(injector: injector)
		return self
	}
	
	fileprivate func _to<VC: UIViewController>(_ type: VC.Type, initializer: @escaping (_ vc: VC) -> ()) -> () -> UIViewController? {
		return { [weak self] in
			if let navigation = self?.navigation, let vc = self?.fabric.newBy(type: type), let animated = self?.animated {
				initializer(vc)
				navigation.pushViewController(vc, animated: animated)
				return vc
			}

			return nil
		}
	}
	
	fileprivate func setup(action: Action) {
		injector.action = action
		fabric.add(injector: injector)
	}
	
	private var injector: VCInjectorWithAction!
	private let fabric: VCAutoInjectionFabric
	private weak var navigation: UINavigationController? = nil
	private var animated: Bool = true
}
