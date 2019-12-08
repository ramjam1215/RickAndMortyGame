//
//  LearnToPlayView.swift
//  CorcoranJames_Final
//
//  Created by Jimmy Corcoran on 3/15/19.
//  Copyright © 2019 Jimmy Corcoran. All rights reserved.
//

import UIKit

class LearnToPlayView: UIView
{

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect)
     {
        // Drawing code
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setLineWidth(2);
            let dash : [CGFloat] = [6, 2];
            context.setLineDash(phase: 0, lengths: dash);
            context.move(to: CGPoint(x: 0.0, y: rect.size.height * 0.5));
            context.addLine(to: CGPoint(x: 0.0, y: rect.size.height * -0.5));
            context.strokePath();
        }
     }
    

}
