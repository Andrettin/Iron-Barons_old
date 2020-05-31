import QtQuick 2.14
import QtQuick.Controls 2.5

PanelButton {
	property var source: "image://empty/"
	width: 36 * scale_factor
	height: 36 * scale_factor

	Image {
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		source: parent.source
		width: sourceSize.width * scale_factor
		height: sourceSize.height * scale_factor
	}
}
