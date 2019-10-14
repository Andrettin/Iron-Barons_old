import QtQuick 2.12
import QtQuick.Controls 2.5
import QtPositioning 5.13
import QtLocation 5.13
import Qt.labs.location 1.0

Map {
	id: map
	anchors.fill: parent
//	activeMapType: map.supportedMapTypes[1]
	copyrightsVisible: false
	plugin: Plugin {
//		name: "osm"
		name: "itemsoverlay"

		/*
		PluginParameter {
			name: "osm.mapping.offline.directory"
			value: "./map/tiles/"
		}

		PluginParameter {
			name: "osm.mapping.providersrepository.disabled"
			value: true
		}
		*/
	}
	color: "black"
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
					color: province.selected ? "yellow" : (province.terrain.water ? "#0080ff" : province.county.realm.color)
					border.color: "black"
					border.width: 2
					smooth: true
					clip: true
					//opacity: 0.9

					ProvinceMouseArea {
						province: parent.parent.province
						anchors.fill: parent
					}
				}
			}
		}
	}

	Repeater {
		model: metternich.river_provinces

		MapItemGroup {
			property var province: modelData

			Repeater {
				model: modelData.geopaths

				MapItemGroup {
					property int path_width: map.zoomLevel - 3

					visible: map.zoomLevel >= 5

					//border
					MapPolyline {
						geoShape: modelData
						line.color: "black"
						line.width: path_width + 4
						smooth: true
						clip: true
						//opacity: 0.9

						ProvinceMouseArea {
							province: parent.parent.parent.province
							anchors.fill: parent
						}
					}

					MapPolyline {
						geoShape: modelData
						line.color: "#0080ff"
						line.width: path_width
						smooth: true
						clip: true
						//opacity: 0.9
					}
				}
			}
		}
	}
}
