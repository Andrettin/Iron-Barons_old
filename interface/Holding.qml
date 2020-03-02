import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	property variant holding_slot: null
	property variant holding: holding_slot ? holding_slot.holding : null
	property int imageWidth: 64
	property int imageHeight: 64
	width: imageWidth + 32
	height: imageHeight + 32

	Image {
		source: holding ? holding.portrait_path : (holding_slot ? "../graphics/holdings/slot.png" : "image://empty/")
		width: parent.imageWidth
		height: parent.imageHeight
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			ToolTip.text: tooltip(
				(holding ?
					holding.titled_name + "<br>"
					+ (holding.owner ? "<br>Holder: " + holding.owner.titled_name : "")
					+ (holding.settlement ? "<br>Population: " + number_str(holding.population) : "")
				: (holding_slot ? holding_slot.name : ""))
				+ (holding_slot && holding_slot.settlement && holding_slot.holding_size !== 100 ? "<br>Holding Size: " + number_str(holding_slot.holding_size) + "%" : "")
				+ (holding_slot && holding_slot.settlement && holding_slot.megalopolis && holding_slot.terrain ? "<br>Terrain: " + holding_slot.terrain.name : ""))
			ToolTip.visible: containsMouse
			ToolTip.delay: 1000
			onClicked: {
				if (mouse.button == Qt.RightButton) {
					game_view.open_targeted_decision_dialog(holding, this)
				} else {
					if (holding !== null) {
						holding.selected = true
					}
				}
			}
		}

		Image {
			source: holding && holding.commodity ? "../graphics/icons/commodities/" + holding.commodity.identifier + ".png" : "image://empty/"
			anchors.top: parent.top
			anchors.left: parent.left

			MaskedMouseArea {
				enabled: holding && holding.commodity
				anchors.fill: parent
				alphaThreshold: 0.4
				maskSource: parent.source
				ToolTip.text: tooltip(holding && holding.commodity ? holding.name + " produces " + holding.commodity.name : "")
				ToolTip.visible: containsMouse
				ToolTip.delay: 1000
			}
		}
	}
}
