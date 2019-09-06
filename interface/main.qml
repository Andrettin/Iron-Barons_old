import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Window {
	id: window
	visible: true
	width: 640
	height: 480
	title: qsTr("Iron Barons")
	flags: Qt.FramelessWindowHint
	visibility: "Maximized"
	//visibility: "FullScreen"

	//function to format tooltip text
	function tooltip(text) {
		return "<font color=\"white\">" + text + "</font>"
	}

	//function to format numbers with two decimal places
	function centesimal(number, always_use_sign = false) {
		var abs_number = Math.abs(number)
		var src_number_string = ""
		src_number_string += abs_number
		var dest_number_string = ""
		if (always_use_sign && number >= 0) {
			dest_number_string += "+"
		} else if (number < 0) {
			dest_number_string += "-"
		}
		if (abs_number < 100) {
			dest_number_string += "0."
		} else {
			dest_number_string += src_number_string.slice(0, src_number_string.length - 2) + "."
		}
		if (abs_number < 10) {
			dest_number_string += "0"
		}
		dest_number_string += src_number_string.slice(src_number_string.length - 2)
		return dest_number_string
	}

	function start_game() {
		var component = Qt.createComponent("GameView.qml");
		component.createObject(window);
	}

	Connections {
		target: metternich.game
		onRunningChanged: start_game()
	}

	Text {
		id: loading_message
		visible: !metternich.game.running
		text: metternich.loading_message
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		color: "black"
		font.pixelSize: 12
		font.family: "tahoma"
	}
}
