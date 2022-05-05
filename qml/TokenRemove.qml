import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "main.js" as DB

Page {
    id: page
    //property int choose
    property int id_txt

    SilicaFlickable {
        anchors.fill: parent

        SilicaListView {
            id:list

            anchors.fill: parent

            model: ListModel {
                id: myJSModel
            }
            header: PageHeader {
                id: header
                title: qsTr("Seznam nepoužívaných tokenů")
            }

            delegate: ListItem {
                id: column
                width: parent.width

                Label {
                    text: name
                    font.pixelSize: Theme.fontSizeMedium
                    anchors {
                        left: parent.left
                        margins: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Odstranit")
                        onClicked: {
                            id_txt = list.model.get(index).id
                            deleteRemorse.execute("Deleting "+list.model.get(index).name)
                        }
                    }
                }
            }

            Component.onCompleted: {
                DB.getListNonActiveTokens()
            }
            RemorsePopup {
                id: deleteRemorse
                onTriggered: {
                    DB.deleteFavorite(id_txt)
                    myJSModel.clear()
                    DB.getListNonActiveTokens()
                }
            }
        }
    }
}

