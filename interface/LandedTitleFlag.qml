import QtQuick 2.12
import QtQuick.Controls 2.5

Image {
	property var landed_title: null

	visible: landed_title !== null
	source: landed_title ? landed_title.flag_path : "image://empty/"
	width: 24
	height: 16
	sourceSize.width: 24
	sourceSize.height: 16

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		ToolTip.text: tooltip(landed_title ? landed_title.titled_name : "")
		ToolTip.visible: containsMouse
		ToolTip.delay: 1000
	}
}
