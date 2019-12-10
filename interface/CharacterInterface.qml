import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: character_interface
	width: 306
	height: 576
	
	property var character: null

	Rectangle {
		id: background
		anchors.fill: parent
		color: "darkGray"
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		//prevent events from propagating below
	}

	Text {
		id: character_name
		text: character ? character.titled_name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Button {
		id: close_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "<font color=\"black\">Close</font>"
		width: 80
		height: 32
		font.pixelSize: 12
		onClicked: metternich.selected_character = null
	}
}
