import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "main.js" as DB

ApplicationWindow
{
    id: appWindow
    property string clBalance
    property string token
    property string name
    property bool networkError: false
    property int jsonerror: 0
    property Item firstPage


    initialPage: Component { Page {
            id: firstPage

            function today() {
                var day = new Date().toLocaleDateString(Qt.locale("cs_CZ"), "yyyy-MM-dd")
                return day;
            }

            function getPeriod() {
                // 1000 * 60 * 60 * 24  = 864e5 = 1 day
                //2592e6 26784e5 (new Date() - 864e5)
                //25056e5 month
                //315576e5 year
                var day = new Date(new Date() - DB.getPeriod()).toLocaleDateString(Qt.locale("cs_CZ"), "yyyy-MM-dd")
                return day;
            }

            function httpRequest(requestType, url, callback, params) {
                var request = new XMLHttpRequest();
                request.onreadystatechange = function() {
                    if (request.readyState === 4) {
                        if (request.status === 200) {
                            callback(request.responseText);
                        } else {
                            callback("error");
                        }
                    }
                }

                request.open(requestType, url);
                console.log("send url", url);
                request.send(params);
            }

            function processData(data) {
                var json = data
                var obj = JSON.parse(json);
                var r="";
                appWindow.clBalance = parseFloat((obj.accountStatement.info.closingBalance - 100).toFixed(3));

                for(var i = 0; i < obj.accountStatement.transactionList.transaction.length; i++) {
                    if (obj.accountStatement.transactionList.transaction[i].column7 === null && obj.accountStatement.transactionList.transaction[i].column16 === null) {
                        r = {
                            "column1": obj.accountStatement.transactionList.transaction[i].column1.value,
                            "column0": obj.accountStatement.transactionList.transaction[i].column0.value,
                            "column14": obj.accountStatement.transactionList.transaction[i].column14.value,
                            "column7": "",
                            "column8": obj.accountStatement.transactionList.transaction[i].column8.value
                        }
                    } else if (obj.accountStatement.transactionList.transaction[i].column7 === null) {
                        r = {
                            "column1": obj.accountStatement.transactionList.transaction[i].column1.value,
                            "column0": obj.accountStatement.transactionList.transaction[i].column0.value,
                            "column14": obj.accountStatement.transactionList.transaction[i].column14.value,
                            "column7": obj.accountStatement.transactionList.transaction[i].column16.value,
                            "column8": obj.accountStatement.transactionList.transaction[i].column8.value
                        }
                    } else {
                        r = {
                            "column1": obj.accountStatement.transactionList.transaction[i].column1.value,
                            "column0": obj.accountStatement.transactionList.transaction[i].column0.value,
                            "column14": obj.accountStatement.transactionList.transaction[i].column14.value,
                            "column7": obj.accountStatement.transactionList.transaction[i].column7.value,
                            "column8": obj.accountStatement.transactionList.transaction[i].column8.value
                        }
                    }
                    myJSModel.append(r)
                }
                indicator.running = false
            }

            function func() {
                myJSModel.clear()
                main()
            }

            function main() {
                if (DB.getActiveToken() === 0) {
                    indicator.running = false
                } else {
                    indicator.running = true
                    token = DB.getActiveToken()
                    name = DB.getActiveTokenName()
                    httpRequest("GET", "https://www.fio.cz/ib_api/rest/periods/"+token+"/"+getPeriod()+"/"+today()+"/transactions.json", processData)
                }
            }

            Component.onCompleted: {
                indicator.running = false
                main()
                appWindow.firstPage = firstPage
            }

            BusyIndicator {
                id: indicator
                running: false
                size: BusyIndicatorSize.Large
                anchors.centerIn: parent
            }

            // To enable PullDownMenu, place our content in a SilicaFlickable
            SilicaFlickable {
                anchors.fill: parent

                PullDownMenu {
                    MenuItem {
                        text: qsTr("O aplikaci")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("About.qml"))
                        }
                    }
                    MenuItem {
                        text: qsTr("Správa tokenů")
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("TokensList.qml"))
                        }
                    }
                    MenuItem {
                        text: qsTr("Aktualizovat")
                        onClicked: {
                            myJSModel.clear()
                            main()
                        }
                    }
                }

                SilicaListView {
                    id:list
                    anchors.fill: parent

                    model: ListModel {
                        id: myJSModel
                    }
                    header: PageHeader {
                        id: header
                        title: appWindow.clBalance + " CZK"
                        description: appWindow.name
                    }

                    delegate: ListItem {
                        id: column
                        width: parent.width
                        contentHeight: Theme.itemSizeExtraLarge

                        Label {
                            id: date
                            text: column0.replace(/\+0100/gi, '').replace(/\+0200/gi, '')
                            width: column.width * 0.50
                            font.pixelSize: Theme.fontSizeSmall
                            truncationMode: TruncationMode.Fade
                            anchors {
                                left: parent.left
                                margins: Theme.horizontalPageMargin
                            }
                        }
                        Label {
                            id: cash
                            text: column1 + " " + column14
                            width: column.width * 0.50
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: Theme.fontSizeSmall
                            truncationMode: TruncationMode.Fade
                            anchors {
                                left: date.right
                                right: parent.right
                                margins: Theme.horizontalPageMargin
                            }
                        }
                        Label {
                            id: name
                            anchors.top: date.bottom
                            anchors.left: date.left
                            text: column7
                            width: column.width * 0.90
                            font.pixelSize: Theme.fontSizeSmall
                            truncationMode: TruncationMode.Elide
                        }
                        Label {
                            id: b
                            anchors.top: name.bottom
                            anchors.left: date.left
                            text: column8
                            width: column.width
                            font.pixelSize: Theme.fontSizeSmall
                            truncationMode: TruncationMode.Fade
                        }
                    } VerticalScrollDecorator {}

                    ViewPlaceholder {
                        enabled: list.count === 0 && DB.getActiveToken() === 0
                        text: qsTr("Je potřeba přidat token.")
                        hintText: qsTr("Pull down pro přidání tokenu")
                    }
                    ViewPlaceholder {
                        enabled: list.count === 0 && DB.getActiveToken() !== 0
                        //text: qsTr("Pravděpodobně se rychle přepnulo mezi účty a v tom případě je potřeba několik vteřin počkat a pak z menu Aktualizovat. Nebo není připojení k internetu.")
                        text: qsTr("Načítá se ...")
                        //hintText: qsTr("Pull down pro aktualizování")
                    }
                }
            }
        }
    }
    cover: CoverBackground {
        CoverPlaceholder {
            id: coverPlaceholder
            text: appWindow.clBalance + " CZK"
            icon.width: Theme.iconSizeLarge
            icon.height: Theme.iconSizeLarge
            icon.source: "/usr/share/icons/hicolor/172x172/apps/harbour-sailfio.png"
        }
        CoverActionList {
            id: coverAction

            CoverAction {
                iconSource: "image://theme/icon-cover-refresh"
                onTriggered: {
                    myJSModel.clear()
                    main()
                }
            }
        }
    }
    allowedOrientations: defaultAllowedOrientations
}

