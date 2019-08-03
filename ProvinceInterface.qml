import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: province_interface
	width: 348
	height: 624

	Image {
		id: province_background
		source: "file:///" + Metternich.asset_import_path + "/gfx/interface/province_bg.dds"
	}

	MouseArea {
		anchors.fill: parent
		//prevent events from propagating below
	}

	Text {
		id: province_name
		text: Metternich.selected_province ? Metternich.selected_province.name : ""
		anchors.top: parent.top
		anchors.topMargin: 15
		anchors.left: parent.left
		anchors.leftMargin: 81
		color: "white"
		font.pixelSize: 14
		font.family: "tahoma"
	}

	Item {
		id: kingdom_area
		x: 17
		y: 267
		width: 153
		height: 32

		Text {
			id: province_de_jure_kingdom
			text: Metternich.selected_province ? Metternich.selected_province.county.de_jure_liege_title.de_jure_liege_title.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 31
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: duchy_area
		x: 17
		y: 300
		width: 153
		height: 32

		Text {
			id: province_de_jure_duchy
			text: Metternich.selected_province ? Metternich.selected_province.county.de_jure_liege_title.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 31
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: culture_area
		x: 17
		y: 333
		width: 153
		height: 13

		Text {
			id: culture_label
			text: qsTr("Culture")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_culture
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.culture.identifier) : ""
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
		id: religion_area
		x: 17
		y: 347
		width: 153
		height: 13

		Text {
			id: religion_label
			text: qsTr("Religion")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_religion
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.religion.identifier) : ""
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

	Item {
		id: capital_holding
		anchors.top: parent.top
		anchors.topMargin: 93
		anchors.right: parent.right
		anchors.rightMargin: 35
		width: 108
		height: 112

		Image {
			source: Metternich.selected_province ? "./placeholder_" + Metternich.selected_province.capital_holding.type.identifier + ".png" : "image://empty/"
			width: 92
			height: 96
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				ToolTip.text: Metternich.selected_province ? Metternich.selected_province.capital_holding.name : ""
				ToolTip.visible: containsMouse
				ToolTip.delay: 1000
			}
		}
	}

	Item {
		id: holding_area
		anchors.left: parent.left
		anchors.leftMargin: 9
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		width: 325
		height: 211

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
						width: 107
						height: 105

						Image {
							source: "./placeholder_" + model.modelData.type.identifier + ".png"
							width: 69
							height: 72
							anchors.horizontalCenter: parent.horizontalCenter
							anchors.bottom: parent.bottom
							anchors.bottomMargin: 16

							MouseArea {
								anchors.fill: parent
								hoverEnabled: true
								ToolTip.text: model.modelData.name
								ToolTip.visible: containsMouse
								ToolTip.delay: 1000
							}
						}
					}
				}
			}
		}
	}
}
