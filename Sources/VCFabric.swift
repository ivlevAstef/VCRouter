//
//  VCFabric.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public protocol VCFabric {
	func newBy<T: UIViewController>(type: T.Type) -> T?
}

public final class VCFabricByMethod: VCFabric {
	public typealias NewMethodType = (_ type: UIViewController.Type) -> (UIViewController?)
	
	public init(fabricMethod: @escaping NewMethodType) {
		self.fabricMethod = fabricMethod
	}
	
	public func newBy<T: UIViewController>(type: T.Type) -> T? {
		return fabricMethod(type) as? T
	}
	
	private let fabricMethod: NewMethodType
}
