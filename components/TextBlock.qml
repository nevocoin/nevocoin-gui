import QtQuick 2.9

import "../components" as NevocoinComponents

TextEdit {
    color: NevocoinComponents.Style.defaultFontColor
    font.family: NevocoinComponents.Style.fontRegular.name
    selectionColor: NevocoinComponents.Style.textSelectionColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
