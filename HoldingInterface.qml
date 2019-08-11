import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: holding_interface
	anchors.fill: parent

	Rectangle {
		id: province_background
		anchors.fill: parent
		color: "darkGray"
	}

	Text {
		id: holding_name
		text: Metternich.selected_holding ? Metternich.selected_holding.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Button {
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "Province"
		width: 64
		height: 32
		onClicked: Metternich.selected_holding.selected = false
	}
}
