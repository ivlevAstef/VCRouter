//
//  VCUserSegue.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 13.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public final class VCUserSegue0: VCUserSegue<VCAction0> {
	public typealias Perform = (_ fabric: VCFabric)->(UIViewController?)
	
	public func on<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCUserSegue0 {
		return _on(VC.self, injector: injector)
	}
	
	public func perform(action: @escaping Perform) {
		setup { [weak self] in return self?._perform { action($0) }() }
	}
}

public final class VCUserSegue1<Arg1>: VCUserSegue<VCAction1<Arg1>> {
	public typealias Perform = (_ fabric: VCFabric, _ arg1: Arg1)->(UIViewController?)
	
	public func on<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCUserSegue1<Arg1> {
		return _on(VC.self, injector: injector)
	}
	
	public func perform(action: @escaping Perform) {
		setup { [weak self] (arg1) in return self?._perform { action($0, arg1) }() }
	}
}

// Implementation

public class VCUserSegue<Action> {
	public typealias Injector<VC: UIViewController> = (_ vc: VC, _ action: Action)->()
	
	init(fabric: VCAutoInjectionFabric) {
		self.fabric = fabric
	}
	
	fileprivate func _on<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> Self {
		self.injector = VCInjectorWithAction(injector: injector)
		return self
	}
	
	fileprivate func _perform(action: @escaping (_ fabric: VCFabric)->(UIViewController?)) -> () -> UIViewController? {
		return { [weak self] in
			if let fabric = self?.fabric {
				return action(fabric)
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
}
