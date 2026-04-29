import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
  id: root
  color: "#090a0b"

  property string defaultUser: config.defaultUser ? config.defaultUser : ""
  property string backgroundPath: config.background ? config.background : "/usr/share/hypr/wall0.png"
  property date now: new Date()

  property real panelWidth: Math.round(Math.max(420, Math.min(width * 0.24, 560)))
  property real panelPadding: Math.round(Math.max(24, panelWidth * 0.07))

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.now = new Date()
  }

  function tryLogin() {
    feedback.text = "Validando..."
    feedback.color = "#f5f5f7"
    sddm.login(defaultUser, passwordInput.text, sessionBox.index)
  }

  Connections {
    target: sddm

    function onLoginSucceeded() {
      feedback.text = "Entrando..."
      feedback.color = "#b8f7c8"
    }

    function onLoginFailed() {
      feedback.text = "Contrasena incorrecta"
      feedback.color = "#ff8a8a"
      passwordInput.text = ""
      passwordInput.focus = true
    }

    function onInformationMessage(message) {
      feedback.text = message
      feedback.color = "#ffb4b4"
    }
  }

  Image {
    anchors.fill: parent
    source: root.backgroundPath
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    cache: true
    smooth: true
  }

  Rectangle {
    anchors.fill: parent
    color: "#3b000000"
  }

  Rectangle {
    id: panel
    width: root.panelWidth
    height: content.implicitHeight + (root.panelPadding * 2)
    x: Math.round((root.width - width) / 2)
    y: Math.round((root.height - height) / 2)
    radius: 26
    antialiasing: true
    color: "#5ef4f4f6"
    border.width: 1
    border.color: "#66ffffff"

    Rectangle {
      anchors.fill: parent
      anchors.margins: 1
      radius: 25
      antialiasing: true
      color: "#26000000"
    }

    Column {
      id: content
      x: root.panelPadding
      y: root.panelPadding
      width: parent.width - root.panelPadding * 2
      spacing: 12

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDateTime(root.now, "hh:mm")
        color: "#ffffff"
        renderType: Text.NativeRendering
        style: Text.Raised
        styleColor: "#33000000"
        font.bold: true
        font.pixelSize: Math.round(Math.max(70, Math.min(root.height * 0.095, 112)))
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Qt.formatDateTime(root.now, "dddd d MMMM")
        color: "#f2f2f5"
        renderType: Text.NativeRendering
        font.pixelSize: Math.round(Math.max(22, Math.min(root.height * 0.026, 34)))
        font.weight: Font.DemiBold
        font.capitalization: Font.Capitalize
      }

      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: defaultUser
        color: "#ececf1"
        renderType: Text.NativeRendering
        font.pixelSize: 20
        font.weight: Font.Medium
      }

      Rectangle {
        width: parent.width
        height: 52
        radius: 26
        antialiasing: true
        color: "#33242a31"
        border.width: 1
        border.color: passwordInput.activeFocus ? "#d9ffffff" : "#66ffffff"

        TextInput {
          id: passwordInput
          anchors.fill: parent
          anchors.leftMargin: 18
          anchors.rightMargin: 18
          color: "#ffffff"
          selectionColor: "#66a6d8ff"
          selectedTextColor: "#ffffff"
          echoMode: TextInput.Password
          font.pixelSize: 20
          font.weight: Font.Medium
          renderType: TextInput.NativeRendering
          verticalAlignment: TextInput.AlignVCenter
          focus: true

          Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              root.tryLogin()
              event.accepted = true
            }
          }
        }
      }

      Rectangle {
        id: loginBtn
        width: parent.width
        height: 50
        radius: 25
        antialiasing: true
        color: loginMouse.pressed ? "#1f2328" : "#2b3138"
        border.width: 1
        border.color: "#66ffffff"

        Text {
          anchors.centerIn: parent
          text: "Login"
          color: "#ffffff"
          renderType: Text.NativeRendering
          font.pixelSize: 18
          font.weight: Font.DemiBold
        }

        MouseArea {
          id: loginMouse
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: root.tryLogin()
        }
      }

      Text {
        id: feedback
        width: parent.width
        text: " "
        horizontalAlignment: Text.AlignHCenter
        color: "#f5f5f7"
        renderType: Text.NativeRendering
        font.pixelSize: 14
      }

      Row {
        id: actionRow
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 22

        Repeater {
          model: [
            { icon: "⏻", label: "Shutdown", action: "poweroff" },
            { icon: "↻", label: "Reboot", action: "reboot" },
            { icon: "⏾", label: "Suspend", action: "suspend" },
            { icon: "☾", label: "Hibernate", action: "hibernate" }
          ]

          Column {
            spacing: 5

            Rectangle {
              width: 40
              height: 40
              radius: 20
              antialiasing: true
              color: actionMouse.pressed ? "#40ffffff" : "#26ffffff"
              border.width: 1
              border.color: "#55ffffff"

              Text {
                anchors.centerIn: parent
                text: modelData.icon
                color: "#ffffff"
                renderType: Text.NativeRendering
                font.pixelSize: 18
              }

              MouseArea {
                id: actionMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  if (modelData.action === "poweroff") sddm.powerOff()
                  else if (modelData.action === "reboot") sddm.reboot()
                  else if (modelData.action === "suspend") sddm.suspend()
                  else if (modelData.action === "hibernate") sddm.hibernate()
                }
              }
            }

            Text {
              width: 40
              horizontalAlignment: Text.AlignHCenter
              text: modelData.label
              color: "#f0f0f3"
              renderType: Text.NativeRendering
              font.pixelSize: 11
            }
          }
        }
      }

      ComboBox {
        id: sessionBox
        model: sessionModel
        index: sessionModel.lastIndex
        width: parent.width
        height: 36
        color: "#25242a31"
        borderColor: "#44ffffff"
        focusColor: "#66ffffff"
        hoverColor: "#44ffffff"
        textColor: "#f5f5f7"
        menuColor: "#15181c"
        font.pixelSize: 13
        arrowIcon: Qt.resolvedUrl("images/ic_arrow_drop_down_white_24px.svg")
        arrowColor: "#d1d1d6"
      }
    }
  }
}
