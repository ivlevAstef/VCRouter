//
//  VCRouter.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

import UIKit

open class VCRouter: NSObject {
	public init(fabric: VCFabric) {
		self.fabric = VCAutoInjectionFabric(fabric: fabric)
	}
	
	fileprivate func add<T>(segue: T) -> T {
		refs.append(segue)
		return segue
	}
	
	private var refs: [Any] = []
	fileprivate let fabric: VCAutoInjectionFabric
}

public extension VCRouter {
	public func initializer<VC: UIViewController>(_ type: VC.Type, initializer: @escaping (_ vc: VC)->()) {
		fabric.add(VC.self, initializer: { initializer($0 as! VC) })
	}
}

public extension VCRouter {
	public func root() -> VCRootSegue0 {
		return add(segue: VCRootSegue0(fabric: fabric))
	}
	
	public func root<Arg1>(withParams: Arg1.Type) -> VCRootSegue1<Arg1> {
		return add(segue: VCRootSegue1<Arg1>(fabric: fabric))
	}
}

public extension VCRouter {
	public func push() -> VCPushSegue0 {
		return add(segue: VCPushSegue0(fabric: fabric))
	}
	
	public func push<Arg1>(withParams: Arg1.Type) -> VCPushSegue1<Arg1> {
		return add(segue: VCPushSegue1<Arg1>(fabric: fabric))
	}
}

public extension VCRouter {
	public func content() -> VCContentSegue0 {
		return add(segue: VCContentSegue0(fabric: fabric))
	}
	
	public func content<Arg1>(withParams: Arg1.Type) -> VCContentSegue1<Arg1> {
		return add(segue: VCContentSegue1<Arg1>(fabric: fabric))
	}
}

public extension VCRouter {
	public func pop() -> VCPopSegue0 {
		return add(segue: VCPopSegue0(fabric: fabric))
	}
	
	public func pop<Arg1>(withParams: Arg1.Type) -> VCPopSegue1<Arg1> {
		return add(segue: VCPopSegue1<Arg1>(fabric: fabric))
	}
}

public extension VCRouter {
	public func user() -> VCUserSegue0 {
		return add(segue: VCUserSegue0(fabric: fabric))
	}
	
	public func user<Arg1>(withParams: Arg1.Type) -> VCUserSegue1<Arg1> {
		return add(segue: VCUserSegue1<Arg1>(fabric: fabric))
	}
}
