import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "main.js" as DB

Page {
    id: tokenPage

    function main() {
        myJSModel.clear()
        DB.getList()
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Odstranit token")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("TokenRemove.qml"))
                }
            }
            MenuItem {
                text: qsTr("Přidat token")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("TokenAdd.qml"))
                    dialog.accepted.connect(function() {
                        main()})
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: list
            width: tokenPage.width
            spacing: Theme.paddingExtraSmall

            PageHeader {
                title: qsTr("Seznam tokenů")
            }

            ListModel {
                id: myJSModel
            }

            ComboBox {
                id: cb1
                label: "Aktivní token: "
                currentIndex: DB.getActiveToken()

                menu: ContextMenu {
                    Repeater {
                        model: myJSModel
                        delegate: MenuItem {
                            text: name
                        }
                    }
                }
                onCurrentIndexChanged: {
                    DB.updateAll()
                    DB.updateActive(1,myJSModel.get(currentIndex).name)
                    firstPage.func()
                }

            }

            ComboBox {
                id: cb2
                label: "Výpis - období"

                menu: ContextMenu {
                    MenuItem { text: "1 měsíc" }
                    MenuItem { text: "3 měsíce" }
                    MenuItem { text: "1/2 roku" }
                    MenuItem { text: "1 rok" }
                }
                currentIndex: DB.getPeriodIndex()

                onCurrentIndexChanged: {
                    var period;
                    var pindex;
                    switch (cb2.currentIndex)
                    {
                    case 0: period = "25056e5"; pindex = 0; break;
                    case 1: period = "7776e6"; pindex = 1; break;
                    case 2: period = "157788e5"; pindex = 2; break;
                    case 3: period = "315576e5"; pindex = 3; break;
                    }
                    DB.updatePeriod(period, pindex)
                    firstPage.func()
                }
            }
            Component.onCompleted: {
                main()
            }
        }
    }
}

