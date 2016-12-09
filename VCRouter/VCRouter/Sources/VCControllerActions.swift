//
//  VCControllerActions.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 13.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public final class VCControllerActions {
	public final class Content {
		public static func remove(from parent: UIViewController) {
			for child in parent.childViewControllers {
				child.willMove(toParentViewController: nil)
				child.view.removeFromSuperview()
				child.removeFromParentViewController()
			}
		}
		
		public static func add(new: UIViewController, parent: UIViewController) {
			parent.addChildViewController(new)
			new.view.frame = parent.view.bounds
			parent.view.insertSubview(new.view, at: 0)
			new.didMove(toParentViewController: parent)
		}
		
		public static func animation(parent: UIViewController, new: UIViewController, old: UIViewController, options: UIViewAnimationOptions, completion: ((_ completed: Bool)->())?) {
			parent.addChildViewController(new)
			
			new.view.frame = parent.view.bounds
			new.view.frame.origin.x += parent.view.bounds.width
			
			parent.transition(from: old, to: new, duration: 0.25, options: options, animations: {
				new.view.frame = parent.view.bounds
			}, completion: completion)
		}
		
		public static func set(new: UIViewController, parent: UIViewController, animated: UIViewAnimationOptions?, useChildNavigation: Bool) {
			if let animated = animated, let old = parent.childViewControllers.last {
				animation(parent: parent, new: new, old: old, options: animated) { _ in
					remove(from: parent)
				}
				
			} else {
				remove(from: parent)
				add(new: new, parent: parent)
			}
			
			if useChildNavigation {
				parent.title = new.title
				parent.navigationItem.titleView = new.navigationItem.titleView
			}
		}
		
		public static func add(new: UIViewController, parent: UIViewController, animated: UIViewAnimationOptions?) {
			if let animated = animated, let old = parent.childViewControllers.last {
				animation(parent: parent, new: new, old: old, options: animated, completion: nil)
				
			} else {
				add(new: new, parent: parent)
			}
		}
	}
	
	public static func find<VC: UIViewController>(on navigation: UINavigationController) -> (UIViewController, VC)? {
		var find: (([UIViewController]) -> [UIViewController])!
		find = { viewControllers in
			for vc in viewControllers.reversed() {
				if type(of: vc) == VC.self, let foundVC = vc as? VC {
					return [foundVC]
				}
				
				var stack = find(vc.childViewControllers)
				if !stack.isEmpty {
					stack.append(vc)
					return stack
				}
			}
			return []
		}
		
		let stack = find(navigation.viewControllers)
		if stack.isEmpty {
			return nil
		}
		
		if 1 == stack.count {
			return (stack[0], stack[0] as! VC)
		}
		
		return (stack.last!, stack.first as! VC)
	}
	
	public static func removeTo<VC: UIViewController>(_ type: VC.Type, in list: [UIViewController]) -> [UIViewController] {
		let reversedList = list.reversed()
		if let index = reversedList.index(where: { type(of: $0) == VC.self }) {
			let distance = reversedList.distance(from: reversedList.startIndex, to: index)
			
			var result = list
			result.removeLast(distance)
			return result
		}
		
		return list
	}

}
