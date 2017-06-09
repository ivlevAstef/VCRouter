//
//  VCRootSegue.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public final class VCRootSegue0: VCRootSegue {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC)->()
	
	public func config(navigation: UINavigationController, animated: Bool) -> VCRootSegue0 {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func set<VC: UIViewController>(_ type: VC.Type, initializer: Initializer<VC>? = nil) -> VCAction0 {
		return { [weak self] in self?._set(VC.self) { initializer?($0) }() }
	}
}

public final class VCRootSegue1<Arg1>: VCRootSegue {
	public typealias Initializer<VC: UIViewController> = (_ vc: VC, _ arg1: Arg1)->()
	
	public func config(navigation: UINavigationController, animated: Bool) -> VCRootSegue1<Arg1> {
		return _config(navigation: navigation, animated: animated)
	}
	
	public func set<VC: UIViewController>(_ type: VC.Type, initializer: @escaping Initializer<VC>) -> VCAction1<Arg1> {
		return { [weak self] (arg1) in self?._set(VC.self) { initializer($0, arg1) }() }
	}
}

// Implementation

public class VCRootSegue {
	init(fabric: VCFabric) {
		self.fabric = fabric
	}
	
	fileprivate func _config(navigation: UINavigationController, animated: Bool) -> Self {
		self.navigation = navigation
		self.animated = animated
		return self
	}
	
	fileprivate func _set<VC: UIViewController>(_ type: VC.Type, initializer: @escaping (_ vc: VC) -> ()) -> () -> UIViewController? {
		return { [weak self] in
			if let navigation = self?.navigation, let vc = self?.fabric.newBy(type: type), let animated = self?.animated {
				initializer(vc)
				navigation.setViewControllers([vc], animated: animated)
				return vc
			}
			return nil
		}
	}
	
	private let fabric: VCFabric
	private weak var navigation: UINavigationController? = nil
	private var animated: Bool = true
}
