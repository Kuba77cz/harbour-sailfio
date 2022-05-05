import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "main.js" as DB

 Dialog {
     property int choose

     function send() {
        if (DB.getActiveToken() === 0) {
            DB.addToken(newToken.text, name.text, 1)
        } else {
            DB.addToken(newToken.text, name.text, 0)
        }
        firstPage.main()
     }

     Column {
         width: parent.width

         DialogHeader { }

         TextField {
             id: name
             label: "Název"
             placeholderText: "Vaše pojmenování tokenu, např. hlavní nebo spořící"
             width: page.width
             focus: true

             EnterKey.enabled: text.length > 0
         }
         TextField {
             id: newToken
             label: "Token"
             placeholderText: "Token"
             width: page.width
             focus: true

             EnterKey.enabled: text.length > 0

             EnterKey.onClicked: {
                 send()
             }
         }
     }

     onDone: {
         if (result == DialogResult.Accepted) {
             send()
         }
     }
 }
