import QtQuick 2.12
import QtQuick.Controls 2.5
import QtPositioning 5.13
import QtLocation 5.13
import Qt.labs.location 1.0

Map {
	id: map
	anchors.fill: parent
	activeMapType: map.supportedMapTypes[1]
	plugin: Plugin {
		name: "osm"

		PluginParameter {
			name: "osm.mapping.offline.directory"
			value: "./map/tiles/"
		}

		PluginParameter {
			name: "osm.mapping.providersrepository.disabled"
			value: true
		}
	}
	color: "transparent"
	zoomLevel: 5

	Component.onCompleted: {
		center = metternich.game.player_character.primary_title.capital_province.center_coordinate
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (metternich.selected_province) {
				metternich.selected_province.selected = false
			}
			if (metternich.selected_holding) {
				metternich.selected_holding.selected = false
			}
		}
	}

	Repeater {
		model: metternich.provinces

		MapItemGroup {
			property var province: modelData

			Repeater {
				model: modelData.geopolygons

				MapPolygon {
					geoShape: modelData
					color: province.terrain.water ? "#0080ff" : province.county.realm.color
					border.color: province.selected ? "yellow" : "black"
					border.width: 2
					smooth: true
					clip: true
					opacity: 0.9

					MouseArea {
						property bool contained_in_shape: false

						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(province.name + (province.county ? "<br><br>Country: " + province.county.realm.titled_name : ""))
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000

						onClicked: {
							if (metternich.selected_holding) {
								metternich.selected_holding.selected = false
							}
							if (province.selectable) {
								province.selected = true
							} else if (metternich.selected_province) {
								metternich.selected_province.selected = false
							}
						}
					}
				}
			}
		}
	}
}
