//
//  main.swift
//  Panagram
//
//  Created by Frascella Claudio on 8/7/17.
//  Copyright © 2017 TeamDecano. All rights reserved.
//

import Foundation

let panagram = Panagram()
//panagram.staticMode()

if CommandLine.argc < 2 {
    //TODO: Handle interactive mode
    panagram.interactiveMode()
} else {
    panagram.staticMode()
}


