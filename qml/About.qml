import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: contactsPage
    property bool largeScreen: Screen.width > 540


    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column
            width: contactsPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("O aplikaci")
            }

            Label {
                text: qsTr("SailFio")
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraLarge*1.5
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: isLandscape ? (largeScreen ? "/usr/share/icons/hicolor/172x172/apps/harbour-sailfio.png" : "/usr/share/icons/hicolor/86x86/apps/harbour-sailfio.png") : (largeScreen ? "/usr/share/icons/hicolor/172x172/apps/harbour-sailfio.png" : "/usr/share/icons/hicolor/128x128/apps/harbour-sailfio.png")
                width: parent.width *0.2
                height: width
            }

            Label {
                text: qsTr("Verze 1.0")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: qsTr("Author: ") + "Kuba77"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                text: qsTr("Tato aplikace potřebuje ke svému fungování token, který je potřeba si vygenerovat v internetovém bankovnictví Fio banky.<br><br>Máte-li více účtů, můžete si vygenerovat a do aplikace přidat více tokenů a pak mezi nimi přepínat.<br><br>Pokud několikrát rychle přepnete mezi účty je možné, že se přehled transakcí nenačte a je nutné několik vteřin počkat a pak z menu Aktualizovat (jde o limit API).")
                color: Theme.secondaryHighlightColor
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                horizontalAlignment: TextInput.AlignHCenter
                width: parent.width*0.8
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Tato aplikace je opensource: <a href=\"https://github.com/Kuba77cz/harbour-sailfio\">Github</a>";
                color: Theme.secondaryHighlightColor
                onLinkActivated: Qt.openUrlExternally(link)
            }

        }
    }
}
