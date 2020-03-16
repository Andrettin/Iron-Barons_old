import QtQuick 2.14
import QtQuick.Controls 2.5

Item {
	id: character_interface
	width: 320
	height: 640
	
	property var character: null

	PanelBackground {
		anchors.fill: parent
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

	Image {
		id: prowess_icon
		source: "../graphics/icons/items/saber.png"
		width: 32
		height: 32
		anchors.top: parent.top
		anchors.topMargin: 64
		anchors.left: parent.left
		anchors.leftMargin: 16

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			ToolTip.text: tooltip(highlight("Prowess") + "<br><br>The Prowess attribute denotes a character's personal combat ability.")
			ToolTip.visible: containsMouse
			ToolTip.delay: 1000
		}
	}

	Text {
		id: prowess_label
		text: character ? character.prowess : ""
		anchors.verticalCenter: prowess_icon.verticalCenter
		anchors.left: prowess_icon.right
		anchors.leftMargin: 16
		color: "black"
		font.pixelSize: 12
		font.family: "tahoma"
	}

	Text {
		id: traits_label
		text: qsTr("Traits")
		anchors.top: prowess_icon.bottom
		anchors.topMargin: 32
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 12
		font.family: "tahoma"
	}

	Flickable {
		id: trait_area
		anchors.left: parent.left
		anchors.leftMargin: 16
		anchors.right: parent.right
		anchors.rightMargin: 16
		anchors.top: traits_label.bottom
		anchors.topMargin: 8
		height: contentHeight
		contentWidth: trait_grid.width
		contentHeight: trait_grid.height
		clip: true
		interactive: false
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {}

		Grid {
			id: trait_grid
			columns: 7
			columnSpacing: 4
			rowSpacing: 4

			Repeater {
				model: character ? character.traits : []

				Image {
					property var trait: model.modelData

					source: trait.icon_path
					width: 32
					height: 32

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(highlight(trait.name) + (trait.modifier_effects_string !== "" ? "<br><br>" + trait.modifier_effects_string : ""))
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
	}

	Text {
		id: items_label
		text: qsTr("Items")
		anchors.top: trait_area.bottom
		anchors.topMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 12
		font.family: "tahoma"
	}

	Flickable {
		id: item_area
		anchors.left: parent.left
		anchors.leftMargin: 16
		anchors.right: parent.right
		anchors.rightMargin: 16
		anchors.top: items_label.bottom
		anchors.topMargin: 8
		anchors.bottom: close_button.top
		anchors.bottomMargin: 8
		contentWidth: item_grid.width
		contentHeight: item_grid.height
		clip: true
		interactive: false
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {}

		Grid {
			id: item_grid
			columns: 7
			columnSpacing: 4
			rowSpacing: 4

			Repeater {
				model: character ? character.items : []

				Image {
					source: model.modelData.icon_path
					width: 32
					height: 32

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(
							highlight(model.modelData.name)
							+ (model.modelData.modifier_effects_string !== "" ? "<br><br>" + model.modelData.modifier_effects_string : "")
							+ (model.modelData.description !== (model.modelData.identifier + "_desc") ? "<br><br>" + model.modelData.description : "")
						)
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
	}

	PanelButton {
		id: close_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "<font color=\"black\">Close</font>"
		width: 80
		height: 32
		onClicked: metternich.selected_character = null
	}
}
