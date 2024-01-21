// Copyright (c) 2024, The Nevocoin developers
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import FontAwesome 1.0

import "./components" as NevocoinComponents
import "./components/effects/" as NevocoinEffects

import nevocoinComponents.Clipboard 1.0
import nevocoinComponents.Wallet 1.0
import nevocoinComponents.WalletManager 1.0
import nevocoinComponents.TransactionHistory 1.0
import nevocoinComponents.TransactionHistoryModel 1.0
import "../js/TxUtils.js" as TxUtils



Rectangle {
    id: upperPanel
    color: NevocoinComponents.Style.blackTheme ? "#222222" : "#EEEEEE"
    property var previousPage

    property int currentAccountIndex: currentWallet ? currentWallet.currentSubaddressAccount : 0

    anchors.left: parent.left
    anchors.right: parent.right
    z: 1

    signal transferClicked()
    signal receiveClicked()
    signal historyClicked()
    signal settingsClicked()

    RowLayout {
        id: menuColumn
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: menuIconRectangle
            Layout.preferredHeight: 50
            Layout.preferredWidth: 40
            color: "transparent"

            Text {
                id: menuIconText
                text: FontAwesome.bars
                font.family: FontAwesome.fontFamilySolid
                font.pixelSize: 24
                color: NevocoinComponents.Style.blackTheme ? "white" : "black"
                font.styleName: "Solid"
                anchors.centerIn: parent
                opacity: 0.75
                visible: true
            }

            MouseArea {
                id: menuIconMouseArea
                anchors.fill: menuIconRectangle
                onClicked: {
                    leftPanel.visible =  !leftPanel.visible
                }
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }

        Rectangle {
            id: connectionStatusIcon
            Layout.preferredHeight: 50
            Layout.preferredWidth: 40
            color: "transparent"
            opacity: {
                if(leftPanel.networkStatus.connected == Wallet.ConnectionStatus_Connected){
                    return 1
                } else {
                    return 0.5
                }
            }

            Image {
                anchors.centerIn: parent
                source: {
                    if(leftPanel.networkStatus.connected == Wallet.ConnectionStatus_Connected) {
                        return "qrc:///images/lightning.png"
                    } else {
                        return "qrc:///images/lightning-white.png"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                            middlePanel.settingsView.settingsStateViewState = "Node";
                            appWindow.showPageRequest("Settings");
                    }
                }
            }
        }

        RowLayout {
            spacing: 0

            ColumnLayout {
                Rectangle {
                    id: sendRect
                    color: "transparent"
                    Layout.preferredHeight: 35
                    Layout.fillWidth: true
                    Layout.minimumWidth: sendText.width

                    NevocoinComponents.TextPlain {
                        id: sendText
                        anchors.centerIn: sendRect
                        font.family: NevocoinComponents.Style.fontRegular.name
                        font.pixelSize: 16
                        font.bold: middlePanel.state == "Transfer" ? true : false
                        text: qsTr("Send") + translationManager.emptyString
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        anchors.fill: sendRect
                        onClicked: {
                            leftPanel.visible = false
                            upperPanel.transferClicked()
                        }
                    }
                }

                Rectangle {
                    visible: middlePanel.state !== "Merchant"
                    Layout.preferredHeight: 3
                    Layout.fillWidth: true
                    color: middlePanel.state !== "Transfer" ? "transparent" : NevocoinComponents.Style.buttonBackgroundColor
                }
            }

            ColumnLayout {
                Rectangle {
                    id: receiveRect
                    color: "transparent"
                    Layout.preferredHeight: 35
                    Layout.fillWidth: true
                    Layout.minimumWidth: receiveText.width

                    NevocoinComponents.TextPlain {
                        id: receiveText
                        anchors.centerIn: receiveRect
                        font.family: NevocoinComponents.Style.fontRegular.name
                        font.pixelSize: 16
                        font.bold: middlePanel.state == "Receive" ? true : false
                        text: qsTr("Receive") + translationManager.emptyString
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        anchors.fill: receiveRect
                        onClicked: {
                            leftPanel.visible = false
                            upperPanel.receiveClicked()
                        }
                    }
                }
                Rectangle {
                    visible: middlePanel.state !== "Merchant"
                    Layout.preferredHeight: 3
                    Layout.fillWidth: true
                    color: middlePanel.state !== "Receive" ? "transparent" : NevocoinComponents.Style.buttonBackgroundColor
                }
            }

            ColumnLayout {

                Rectangle {
                    id: historyRect
                    color: "transparent"
                    Layout.preferredHeight: 35
                    Layout.fillWidth: true
                    Layout.minimumWidth: historyText.width

                    NevocoinComponents.TextPlain {
                        id: historyText
                        anchors.centerIn: historyRect
                        font.family: NevocoinComponents.Style.fontRegular.name
                        font.pixelSize: 16
                        font.bold: middlePanel.state == "History" ? true : false
                        text: qsTr("Transactions") + translationManager.emptyString
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        anchors.fill: historyRect
                        onClicked: {
                            leftPanel.visible = false
                            upperPanel.historyClicked()
                        }
                    }
                }

                Rectangle {
                    visible: middlePanel.state !== "Merchant"
                    Layout.preferredHeight: 3
                    Layout.fillWidth: true
                    color: middlePanel.state !== "History" ? "transparent" : NevocoinComponents.Style.buttonBackgroundColor
                }
            }
        }

        Rectangle {
            id: settingsIconRectangle
            Layout.preferredHeight: 50
            Layout.preferredWidth: 40
            color: "transparent"

            Text {
                id: settingsIconText
                text: FontAwesome.cog
                font.family: FontAwesome.fontFamilySolid
                font.pixelSize: 24
                color: NevocoinComponents.Style.blackTheme ? "white" : "black"
                font.styleName: "Solid"
                anchors.centerIn: parent
                opacity: middlePanel.state == "Settings" ? 1 : 0.75
                visible: true
            }

            MouseArea {
                id: settingsIconMouseArea
                anchors.fill: settingsIconRectangle
                onClicked: {
                    leftPanel.visible = false
                    upperPanel.settingsClicked()
                }
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}