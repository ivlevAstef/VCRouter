//
//  VCAction.swift
//  SbisTasks
//
//  Created by Ивлев А.Е. on 10.10.16.
//  Copyright © 2016 Tensor. All rights reserved.
//

public typealias VCAction0 = ()->(UIViewController?)

public typealias VCAction1<Arg1> = (_ arg1: Arg1)->(UIViewController?)
public typealias VCAction2<Arg1, Arg2> = (_ arg1: Arg1, _ arg2: Arg2)->(UIViewController?)
public typealias VCAction3<Arg1, Arg2, Arg3> = (_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3)->(UIViewController?)
