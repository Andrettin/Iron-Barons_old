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

	Image {
		id: dueling_icon
		source: "../graphics/icons/items/heater_shield.png"
		width: 32
		height: 32
		anchors.top: parent.top
		anchors.topMargin: 64
		anchors.left: parent.left
		anchors.leftMargin: 16

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			ToolTip.text: tooltip("Dueling<br><br>The Dueling attribute denotes a character's personal combat ability.")
			ToolTip.visible: containsMouse
			ToolTip.delay: 1000
		}
	}

	Text {
		id: dueling_label
		text: character ? character.dueling : ""
		anchors.verticalCenter: dueling_icon.verticalCenter
		anchors.left: dueling_icon.right
		anchors.leftMargin: 16
		color: "black"
		font.pixelSize: 12
		font.family: "tahoma"
	}

	Text {
		id: traits_label
		text: qsTr("Traits")
		anchors.top: dueling_icon.bottom
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
		anchors.bottom: close_button.top
		anchors.bottomMargin: 8
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
					source: model.modelData.icon_path
					width: 32
					height: 32

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(model.modelData.name + (model.modelData.modifier_effects_string !== "" ? "<br><br>" + model.modelData.modifier_effects_string : ""))
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
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
