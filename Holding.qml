import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	property variant holding: null
	property int imageWidth: 64
	property int imageHeight: 64
	width: imageWidth + 32
	height: imageHeight + 32

	Image {
		source: holding ? "./graphics/holdings/" + holding.type.identifier + ".png" : "image://empty/"
		width: parent.imageWidth
		height: parent.imageHeight
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			ToolTip.text: tooltip(holding ? holding.name + "<br><br>Holder: " + holding.barony.holder.full_name + "<br>Population: " + holding.population : "")
			ToolTip.visible: containsMouse
			ToolTip.delay: 1000
			onClicked: holding.selected = true
		}

		Image {
			source: holding && holding.commodity ? "./graphics/icons/commodities/" + holding.commodity.identifier + ".png" : "image://empty/"
			anchors.top: parent.top
			anchors.left: parent.left

			MouseArea {
				enabled: holding && holding.commodity
				anchors.fill: parent
				hoverEnabled: enabled
				ToolTip.text: tooltip(holding && holding.commodity ? holding.name + " produces " + holding.commodity.name : "")
				ToolTip.visible: containsMouse
				ToolTip.delay: 1000
			}
		}
	}
}
