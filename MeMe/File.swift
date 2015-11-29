//
//  File.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/28/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText:String?
    let bottomText:String?
    let originlImage:UIImage?
    let memeImage:UIImage?
    
    init(tText:String, bText:String, oImage:UIImage, meme:UIImage){
        topText = tText
        bottomText = bText
        originlImage = oImage
        memeImage = meme
    }
}