//
//  Device.swift
//  BaseExtension
//
//  Created by wade.hawk on 2018. 5. 22..
//

import Foundation

public struct ScreenSize
{
    public static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    public static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    public static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH,    ScreenSize.SCREEN_HEIGHT)
}

public struct DeviceType
{
    public static let isiPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    public static let isiPhone5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    public static let isiPhone6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    public static let isiPhone6p         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    public static let isiPad              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH   == 1024.0
    public static let isiPadPro          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH   == 1366.0
}
