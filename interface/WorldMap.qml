import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: map
	width: map_terrain.width
	height: map_terrain.height

	property var world: null

	enum Mode {
		Country,
		DeJureEmpire,
		DeJureKingdom,
		DeJureDuchy,
		Culture,
		CultureGroup,
		Religion,
		ReligionGroup
	}

	function moveLeft(pixels) {
		map.x += pixels * map.scale
	}

	function moveRight(pixels) {
		map.x -= pixels * map.scale
	}

	function moveUp(pixels) {
		map.y += pixels * map.scale
	}

	function moveDown(pixels) {
		map.y -= pixels * map.scale
	}

	Image {
		id: map_terrain
		source: world ? world.cache_path + "/provinces.png" : "image://empty/"

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
			model: world ? world.provinces : []
			Image {
				x: model.modelData.rect.x
				y: model.modelData.rect.y
				width: model.modelData.rect.width
				height: model.modelData.rect.height
				source: "image://provinces/" + model.modelData.identifier
				cache: false

				Connections {
					target: model.modelData
					onImageChanged: {
						var old_source = source
						source = "image://empty/"
						source = old_source
					}
				}

				MaskedMouseArea {
					anchors.fill: parent
					alphaThreshold: 0.4
					maskSource: parent.source
					ToolTip.text: tooltip(
						model.modelData.name
						+ (model.modelData.county ? "<br>" : "")
						+ (model.modelData.county && metternich.map_mode === WorldMap.Mode.Country ? "<br>Country: " + model.modelData.county.realm.titled_name : "")
						+ (model.modelData.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br>De Jure Empire: " + model.modelData.de_jure_empire.name : "")
						+ (model.modelData.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br>De Jure Kingdom: " + model.modelData.de_jure_kingdom.name : "")
						+ (model.modelData.de_jure_duchy && metternich.map_mode === WorldMap.Mode.DeJureDuchy ? "<br>De Jure Duchy: " + model.modelData.de_jure_duchy.name : "")
						+ (model.modelData.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture: " + model.modelData.culture.name : "")
						+ (model.modelData.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + model.modelData.culture.culture_group.name : "")
						+ (model.modelData.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion: " + model.modelData.religion.name : "")
						+ (model.modelData.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion Group: " + model.modelData.religion.religion_group.name : "")
					)
					ToolTip.visible: containsMouse
					ToolTip.delay: 1000
					onClicked: {
						if (metternich.selected_holding) {
							metternich.selected_holding.selected = false
						}
						if (model.modelData.selectable) {
							model.modelData.selected = true
						} else if (metternich.selected_province) {
							metternich.selected_province.selected = false
						}
					}
				}
			}
		}
	}
}
