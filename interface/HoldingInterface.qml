import QtQuick 2.12
import QtQuick.Controls 2.5
import QtCharts 2.3

Item {
	id: holding_interface
	anchors.fill: parent

	Rectangle {
		id: holding_background
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
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: parent.top
		anchors.topMargin: 64

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
			id: holding_population
			text: Metternich.selected_holding ? Metternich.selected_holding.population : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: population_growth_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: population_area.bottom
		anchors.topMargin: 16

		Text {
			id: population_growth_label
			text: qsTr("Population Growth (monthly)")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: holding_population_growth
			text: Metternich.selected_holding ? (centesimal(Metternich.selected_holding.population_growth) + "%") : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: population_capacity_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: population_growth_area.bottom
		anchors.topMargin: 16

		Text {
			id: population_capacity_label
			text: qsTr("Population Capacity")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: holding_population_capacity
			text: Metternich.selected_holding ? Metternich.selected_holding.population_capacity : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	ChartView {
		id: population_type_chart
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 16
		anchors.left: parent.left
		anchors.leftMargin: 32
		width: 64
		height: 64
		margins.top: 2
		margins.bottom: 2
		margins.left: 2
		margins.right: 2
		legend.visible: false
		backgroundColor: holding_background.color
		antialiasing: true
		ToolTip.delay: 1000

		PieSeries {
			id: population_type_pie_series
			size: 0.95

			onHovered: {
				if (state == true) {
					population_type_chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
					population_type_chart.ToolTip.visible = true
				} else {
					population_type_chart.ToolTip.visible = false
				}
			}
		}

		function update_population_type_chart() {
			population_type_pie_series.clear()

			if (Metternich.selected_holding === null) {
				return
			}

			var population_per_type = Metternich.selected_holding.get_population_per_type()
			for (var i = 0; i < population_per_type.length; i++) {
				var type = population_per_type[i].type
				var population = population_per_type[i].population
				var pie_slice = population_type_pie_series.append(type.name, population)
				//pie_slice.color = type.color
				pie_slice.borderColor = "black"
			}
		}

		Connections {
			target: Metternich.selected_holding
			ignoreUnknownSignals: true //as there may be no selected holding
			onPopulationProportionsChanged: population_type_chart.update_population_type_chart()
		}

		Connections {
			target: Metternich
			onSelectedHoldingChanged: population_type_chart.update_population_type_chart()
		}
	}

	ChartView {
		id: culture_chart
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		width: 64
		height: 64
		margins.top: 2
		margins.bottom: 2
		margins.left: 2
		margins.right: 2
		legend.visible: false
		backgroundColor: holding_background.color
		antialiasing: true
		ToolTip.delay: 1000

		PieSeries {
			id: culture_pie_series
			size: 0.95

			onHovered: {
				if (state == true) {
					culture_chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
					culture_chart.ToolTip.visible = true
				} else {
					culture_chart.ToolTip.visible = false
				}
			}
		}

		function update_culture_chart() {
			culture_pie_series.clear()

			if (Metternich.selected_holding === null) {
				return
			}

			var population_per_culture = Metternich.selected_holding.get_population_per_culture()
			for (var i = 0; i < population_per_culture.length; i++) {
				var culture = population_per_culture[i].culture
				var population = population_per_culture[i].population
				var pie_slice = culture_pie_series.append(culture.name, population)
				pie_slice.color = culture.color
				pie_slice.borderColor = "black"
			}
		}

		Connections {
			target: Metternich.selected_holding
			ignoreUnknownSignals: true //as there may be no selected holding
			onPopulationProportionsChanged: culture_chart.update_culture_chart()
		}

		Connections {
			target: Metternich
			onSelectedHoldingChanged: culture_chart.update_culture_chart()
		}
	}

	ChartView {
		id: religion_chart
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 16
		anchors.right: parent.right
		anchors.rightMargin: 32
		width: 64
		height: 64
		margins.top: 2
		margins.bottom: 2
		margins.left: 2
		margins.right: 2
		legend.visible: false
		backgroundColor: holding_background.color
		antialiasing: true
		ToolTip.delay: 1000

		PieSeries {
			id: religion_pie_series
			size: 0.95

			onHovered: {
				if (state == true) {
					religion_chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
					religion_chart.ToolTip.visible = true
				} else {
					religion_chart.ToolTip.visible = false
				}
			}
		}

		function update_religion_chart() {
			religion_pie_series.clear()

			if (Metternich.selected_holding === null) {
				return
			}

			var population_per_religion = Metternich.selected_holding.get_population_per_religion()
			for (var i = 0; i < population_per_religion.length; i++) {
				var religion = population_per_religion[i].religion
				var population = population_per_religion[i].population
				var pie_slice = religion_pie_series.append(religion.name, population)
				//pie_slice.color = religion.color
				pie_slice.borderColor = "black"
			}
		}

		Connections {
			target: Metternich.selected_holding
			ignoreUnknownSignals: true //as there may be no selected holding
			onPopulationProportionsChanged: religion_chart.update_religion_chart()
		}

		Connections {
			target: Metternich
			onSelectedHoldingChanged: religion_chart.update_religion_chart()
		}
	}

	BuildingInterface {
		id: building_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 96
		anchors.bottom: province_button.top
		anchors.bottomMargin: 8
	}

	HoldingPopulationUnitInterface {
		id: population_unit_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 96
		anchors.bottom: province_button.top
		anchors.bottomMargin: 8
		visible: false
	}

	Button {
		id: buildings_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: province_button.left
		anchors.rightMargin: 8
		text: "<font color=\"black\">Buildings</font>"
		width: 80
		height: 32
		visible: !building_area.visible
		font.pixelSize: 12
		onClicked: {
			building_area.visible = true
			population_unit_area.visible = false
		}
	}

	Button {
		id: population_units_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: province_button.left
		anchors.rightMargin: 8
		text: "<font color=\"black\">Population</font>"
		width: 80
		height: 32
		font.pixelSize: 12
		visible: !population_unit_area.visible
		onClicked: {
			population_unit_area.visible = true
			building_area.visible = false
		}
	}

	Button {
		id: province_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "<font color=\"black\">Province</font>"
		width: 80
		height: 32
		font.pixelSize: 12
		onClicked: Metternich.selected_holding.selected = false
	}
}
