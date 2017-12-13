//
//  StringConstants.swift
//  WebimClientLibrary_Example
//
//  Created by Nikita Lazarev-Zubov on 19.10.17.
//  Copyright © 2017 Webim. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

let REFRESH_CONTROL_TEXT = NSAttributedString(string: NSLocalizedString("Loading messages...",
                                                                        comment: ""))

enum Avatar: String {
    case ACCESSIBILITY_LABEL = "Sender avatar image"
    case ACCESSIBILITY_HINT_FOR_OPERATOR = "Shows rating dialog."
}

enum FileMessage: String {
    case FILE_UNAVAILABLE = "File is unavailable."
}

enum LeftButton: String {
    case ACCESSIBILITY_LABEL = "Choose file"
    case ACCESSIBILITY_HINT = "Shows image picker to choose an image to send."
}

enum RatingDialog: String {
    case ACTION_BUTTON_TITLE = "Rate"
    case CANCEL_BUTTON_TITLE = "Cancel"
    
    case ACTION_BUTTON_ACCESSIBILITY_HINT = "Rates operator with chosen rating."
    case CANCEL_BUTTON_ACCESSIBILITY_HINT = "Closes rating dialog."
}

enum SendFileErrorMessage: String {
    case TITLE = "File sending failed"
    
    case BUTTON_TITLE = "OK"
    case BUTTON_ACCESSIBILITY_HINT = "Closes dialog."
    
    // Error messages.
    case FILE_SIZE_EXCEEDED = "File is too large."
    case FILE_TYPE_NOT_ALLOWED = "File type is not supported."
}

enum SessionCreationErrorDialog: String {
    case BUTTON_TITLE = "OK"
    case BUTTON_ACCESSIBILITY_HINT = "Closes dialog."
    
    case TITLE = "Session creation failed"
    case MESSAGE = "Account that is used to create session is blocked. Please contact Webim support or use another one."
}

enum SettingsErrorDialog: String {
    case BUTTON_TITLE = "OK"
    case BUTTON_ACCESSIBILITY_HINT = "Closes dialog."
    
    case TITLE = "Invalid account settings"
    case WRONG_ACCOUNT_NAME_MESSAGE = "Account name can't be empty."
    case WRONG_LOCATION_MESSAGE = "Location can't be empty."
}

enum ShowFileDialog: String {
    case BUTTON_TITLE = "OK"
    
    // Message.
    case INVALID_IMAGE_FORMAT = "Image format is not valid."
    case INVALID_IMAGE_LINK = "Image link is not valid."
    case NOT_IMAGE = "Preview is not available."
    
    case ACCESSIBILITY_HINT = "Closes file preview."
}
