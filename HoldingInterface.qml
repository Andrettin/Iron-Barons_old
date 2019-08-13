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

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		//prevent events from propagating below
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

	Item {
		id: population_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: parent.top
		anchors.topMargin: 48
		anchors.bottom: province_button.top
		anchors.bottomMargin: 8

		Flickable {
			anchors.fill: parent
			contentWidth: population_grid.width
			contentHeight: population_grid.height
			clip: true
			interactive: false
			boundsBehavior: Flickable.StopAtBounds
			ScrollBar.vertical: ScrollBar {}

			Grid {
				id: population_grid
				columns: 1
				columnSpacing: 0
				rowSpacing: 0

				Repeater {
					model: Metternich.selected_holding ? Metternich.selected_holding.population_units : []

					Item {
						width: population_area.width
						height: 32

						Text {
							text: model.modelData.type.name
							anchors.verticalCenter: parent.verticalCenter
							anchors.left: parent.left
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
							font.bold: true
						}

						Text {
							text: model.modelData.culture.name
							anchors.verticalCenter: parent.verticalCenter
							anchors.left: parent.left
							anchors.leftMargin: parent.width / 4 + 12
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
						}

						Text {
							text: model.modelData.religion.name
							anchors.verticalCenter: parent.verticalCenter
							anchors.left: parent.left
							anchors.leftMargin: parent.width / 4 * 2 + 12
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
						}

						Text {
							text: model.modelData.size
							anchors.verticalCenter: parent.verticalCenter
							anchors.right: parent.right
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
						}
					}
				}
			}
		}
	}

	Button {
		id: province_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "Province"
		width: 64
		height: 32
		onClicked: Metternich.selected_holding.selected = false
	}
}
