import QtQuick 2.9

import "." as NevocoinComponents
import "effects/" as NevocoinEffects

Rectangle {
    color: NevocoinComponents.Style.appWindowBorderColor
    height: 1

    NevocoinEffects.ColorTransition {
        targetObj: parent
        blackColor: NevocoinComponents.Style._b_appWindowBorderColor
        whiteColor: NevocoinComponents.Style._w_appWindowBorderColor
    }
}
