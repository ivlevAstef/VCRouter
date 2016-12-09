//
//  VCContentSegue.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public final class VCContentSegue0: VCContentSegue<VCAction0>  {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC)->()
	
	public func config(navigation: UINavigationController, animated: UIViewAnimationOptions? = nil) -> VCContentSegue0 {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func on<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCContentSegue0 {
		return self._on(VC.self, injector: injector)
	}
	
	public func set<VC: UIViewController>(_ type: VC.Type, useNavigation: Bool = true, initializer: Initializer<VC>? = nil) {
		setup { [weak self] in return self?._set(VC.self, useNavigation: useNavigation) { initializer?($0) }() }
	}
	
	public func add<VC: UIViewController>(_ type: VC.Type, initializer: Initializer<VC>? = nil) {
		setup { [weak self] in self?._add(VC.self) { initializer?($0) }() }
	}
	
	public func clean<VC: UIViewController>(_ type: VC.Type, initializer: Initializer<VC>? = nil) {
		setup { [weak self] in return self?._clean(VC.self) { initializer?($0) }() }
	}
}

public final class VCContentSegue1<Arg1>: VCContentSegue<VCAction1<Arg1>> {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC, _ arg1: Arg1)->()
	
	public func config(navigation: UINavigationController, animated: UIViewAnimationOptions? = nil) -> VCContentSegue1<Arg1> {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func on<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> VCContentSegue1<Arg1> {
		return self._on(VC.self, injector: injector)
	}
	
	public func set<VC: UIViewController>(_ type: VC.Type, useNavigation: Bool = true, initializer: @escaping Initializer<VC>) {
		setup { [weak self] (arg1) in self?._set(type, useNavigation: useNavigation) { initializer($0, arg1) }() }
	}
	
	public func add<VC: UIViewController>(_ type: VC.Type, initializer: @escaping Initializer<VC>) {
		setup { [weak self] (arg1) in self?._add(type) { initializer($0, arg1) }() }
	}
	
	public func clean<VC: UIViewController>(_ type: VC.Type, initializer: @escaping Initializer<VC>) {
		setup { [weak self] (arg1) in return self?._clean(VC.self) { initializer($0, arg1) }() }
	}
}

// Implementation

public class VCContentSegue<Action> {
	public typealias Injector<VC: UIViewController> = (_ vc: VC, _ action: Action)->()
	
	init(fabric: VCAutoInjectionFabric) {
		self.fabric = fabric
	}
	
	fileprivate func _config(navigation: UINavigationController, animated: UIViewAnimationOptions?) -> Self {
		self.navigation = navigation
		self.animated = animated
		return self
	}
	
	fileprivate func _on<VC: UIViewController>(_ type: VC.Type, injector: @escaping Injector<VC>) -> Self {
		self.injector = VCInjectorWithAction(injector: injector)
		self.getParent = { [weak self] in return self?.navigation?.topViewController as? VC }
		return self
	}
	
	fileprivate func _set<VC: UIViewController>(_ type: VC.Type, useNavigation: Bool, initializer: @escaping (_ vc: VC) -> ()) -> () -> UIViewController? {
		return { [weak self] in
			guard let strong = self else {
				return nil
			}
			
			if let parent = strong.getParent(), let vc = strong.fabric.newBy(type: type) {
				initializer(vc)
				
				VCControllerActions.Content.set(new: vc, parent: parent, animated: strong.animated, useChildNavigation: useNavigation)
				
				return vc
			}
			return nil
		}
	}
	
	fileprivate func _clean<VC: UIViewController>(_ type: VC.Type, initializer: @escaping (_ vc: VC) -> ()) -> () -> UIViewController? {
		return { [weak self] in
			guard let strong = self else {
				return nil
			}
			
			if let parent = strong.getParent() as? VC {
				initializer(parent)
				VCControllerActions.Content.remove(from: parent)
				
				return parent
			}
			return nil
		}
	}
	
	fileprivate func _add<VC: UIViewController>(_ type: VC.Type, initializer: @escaping (_ vc: VC) -> ()) -> () -> UIViewController? {
		return { [weak self] in
			guard let strong = self else {
				return nil
			}
			
			if let parent = strong.getParent(), let vc = strong.fabric.newBy(type: type) {
				initializer(vc)
				
				VCControllerActions.Content.add(new: vc, parent: parent, animated: strong.animated)
				
				return vc
			}
			return nil
		}
	}
	
	fileprivate func setup(_ action: Action) {
		injector.action = action
		fabric.add(injector: injector)
	}
	
	private var injector: VCInjectorWithAction!

	private var getParent: (() -> (UIViewController?))!
	private let fabric: VCAutoInjectionFabric
	
	private var animated: UIViewAnimationOptions? = nil
	private weak var navigation: UINavigationController? = nil
}
