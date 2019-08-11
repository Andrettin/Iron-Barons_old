import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: province_interface
	width: 306
	height: 576

	Rectangle {
		id: province_background
		anchors.fill: parent
		color: "darkGray"
	}

	MouseArea {
		anchors.fill: parent
		//prevent events from propagating below
	}

	Text {
		id: province_name
		text: Metternich.selected_province ? Metternich.selected_province.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Item {
		id: capital_holding
		anchors.top: parent.top
		anchors.topMargin: 48
		anchors.horizontalCenter: parent.horizontalCenter
		width: 160
		height: 160

		Image {
			source: Metternich.selected_province ? "./graphics/holdings/" + Metternich.selected_province.capital_holding.type.identifier + ".png" : "image://empty/"
			width: 128
			height: 128
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				ToolTip.text: tooltip(Metternich.selected_province ? Metternich.selected_province.capital_holding.name + "<br><br>Holder: " + Metternich.selected_province.capital_holding.barony.holder.full_name + "<br>Population: " + Metternich.selected_province.capital_holding.population : "")
				ToolTip.visible: containsMouse
				ToolTip.delay: 1000
				onClicked: Metternich.selected_province.capital_holding.selected = true
			}
		}
	}

	Item {
		id: empire_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: capital_holding.bottom
		anchors.topMargin: 48

		Text {
			id: de_jure_empire_label
			text: qsTr("De Jure Empire")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_de_jure_empire
			text: Metternich.selected_province ? Metternich.selected_province.county.de_jure_liege_title.de_jure_liege_title.de_jure_liege_title.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: kingdom_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: empire_area.bottom
		anchors.topMargin: 16

		Text {
			id: de_jure_kingdom_label
			text: qsTr("De Jure Kingdom")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_de_jure_kingdom
			text: Metternich.selected_province ? Metternich.selected_province.county.de_jure_liege_title.de_jure_liege_title.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: duchy_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: kingdom_area.bottom
		anchors.topMargin: 16

		Text {
			id: de_jure_duchy_label
			text: qsTr("De Jure Duchy")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_de_jure_duchy
			text: Metternich.selected_province ? Metternich.selected_province.county.de_jure_liege_title.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: culture_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: duchy_area.bottom
		anchors.topMargin: 16

		Text {
			id: culture_label
			text: qsTr("Culture")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_culture
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.culture.identifier) : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				ToolTip.text: tooltip(Metternich.selected_province ? qsTr(Metternich.selected_province.culture.identifier) + " (" + qsTr(Metternich.selected_province.culture.culture_group.identifier) + ")" : "")
				ToolTip.visible: containsMouse
				ToolTip.delay: 1000
			}
		}
	}

	Item {
		id: religion_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: culture_area.bottom
		anchors.topMargin: 16

		Text {
			id: religion_label
			text: qsTr("Religion")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_religion
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.religion.identifier) : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: population_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: religion_area.bottom
		anchors.topMargin: 16

		Text {
			id: population_label
			text: qsTr("Population")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_population
			text: Metternich.selected_province ? Metternich.selected_province.population : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	/*
	Item {
		id: supply_area
		x: 17
		y: 361
		width: 153
		height: 13

		Text {
			id: supply_label
			text: qsTr("Supply")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_supply
			text: "10.0K"
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.right: parent.right
			anchors.rightMargin: 5
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: revolt_risk_area
		x: 17
		y: 375
		width: 153
		height: 13

		Text {
			id: revolt_risk_label
			text: qsTr("Revolt Risk")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_revolt_risk
			text: "0.0%"
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.right: parent.right
			anchors.rightMargin: 5
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}
	*/

	Item {
		id: holding_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		width: 290
		height: 193

		Flickable {
			anchors.fill: parent
			contentWidth: holding_grid.width
			contentHeight: holding_grid.height
			clip: true
			interactive: false
			boundsBehavior: Flickable.StopAtBounds
			ScrollBar.vertical: ScrollBar {}

			Grid {
				id: holding_grid
				columns: 3
				columnSpacing: 1
				rowSpacing: 1

				Repeater {
					model: Metternich.selected_province ? Metternich.selected_province.holdings : []

					Item {
						visible: model.modelData !== Metternich.selected_province.capital_holding
						width: 96
						height: 96

						Image {
							source: "./graphics/holdings/" + model.modelData.type.identifier + ".png"
							width: 64
							height: 64
							anchors.horizontalCenter: parent.horizontalCenter
							anchors.verticalCenter: parent.verticalCenter

							MouseArea {
								anchors.fill: parent
								hoverEnabled: true
								ToolTip.text: tooltip(model.modelData.name + "<br><br>Holder: " + model.modelData.barony.holder.full_name + "<br>Population: " + model.modelData.population)
								ToolTip.visible: containsMouse
								ToolTip.delay: 1000
								onClicked: model.modelData.selected = true
							}
						}
					}
				}
			}
		}
	}

	HoldingInterface {
		visible: Metternich.selected_holding !== null
	}
}
