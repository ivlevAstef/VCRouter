//
//  VCPopSegue.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public final class VCPopSegue0: VCPopSegue<VCAction0> {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC)->()
	
	public func config(navigation: UINavigationController, animated: Bool) -> VCPopSegue0 {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func from<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCPopSegue0 {
		return _from(VC.self, injector: injector)
	}
	
	public func to<VC: UIViewController>(_ type: VC.Type, initializer: Initializer<VC>? = nil) {
		setup { [weak self] in self?._to(VC.self) { initializer?($0) }() }
	}
	
	public func with(initializer: @escaping Initializer<UIViewController>) {
		setup { [weak self] in self?._with { initializer($0) }() }
	}
	
	public func finally() {
		setup { [weak self] in self?._with{_ in}() }
	}
}

public final class VCPopSegue1<Arg1>: VCPopSegue<VCAction1<Arg1>> {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC, _ arg1: Arg1)->()
	
	public func config(navigation: UINavigationController, animated: Bool) -> VCPopSegue1<Arg1> {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func from<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCPopSegue1<Arg1> {
		return _from(VC.self, injector: injector)
	}
	
	public func to<VC: UIViewController>(_ type: VC.Type, initializer: @escaping Initializer<VC>) {
		setup { [weak self] (arg1) in self?._to(VC.self) { initializer($0, arg1) }() }
	}
	
	public func with(initializer: @escaping Initializer<UIViewController>) {
		setup { [weak self] (arg1) in self?._with { initializer($0, arg1) }() }
	}
	
	public func finally() {
		setup { [weak self] (arg1) in self?._with{_ in}() }
	}
}

// Implementation

public class VCPopSegue<Action> {
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
			if let navigation = self?.navigation, let animated = self?.animated {
				if let findResult: (UIViewController, VC) = VCControllerActions.find(on: navigation) {
					initializer(findResult.1)
					_ = navigation.popToViewController(findResult.0, animated: animated)
					return findResult.1
				}
				
			}
			return nil
		}
	}
	
	fileprivate func _with(initializer: @escaping (_ vc: UIViewController) -> ()) -> () -> UIViewController? {
		return { [weak self] in
			if let navigation = self?.navigation, let animated = self?.animated {
				_ = navigation.popViewController(animated: animated)
				if let vc = self?.navigation?.viewControllers.last {
					initializer(vc)
					return vc
				}
			}
			return nil
		}
	}
	
	fileprivate func setup(action: Action) {
		if !isSetup {
			injector.action = action
			fabric.add(injector: injector)
			
			isSetup = true
		}
	}
	
	private var isSetup: Bool = false
	
	private var injector: VCInjectorWithAction!
	private let fabric: VCAutoInjectionFabric
	private weak var navigation: UINavigationController? = nil
	private var animated: Bool = true
}
