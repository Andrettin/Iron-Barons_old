import QtQuick 2.14
import QtQuick.Controls 2.5

PanelButton {
	property var source: "image://empty/"
	width: 36
	height: 36

	Image {
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		source: parent.source
	}
}
