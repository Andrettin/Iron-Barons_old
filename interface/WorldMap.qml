import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Shapes 1.14
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
		ReligionGroup,
		TradeNode
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
				if (metternich.selected_province !== null) {
					metternich.selected_province.selected = false
				}
				if (metternich.selected_holding !== null) {
					metternich.selected_holding.selected = false
				}
				metternich.selected_character = null
			}
		}

		Repeater {
			model: world ? world.provinces : []
			
			Image {
				property int flag: 0

				x: model.modelData.rect.x
				y: model.modelData.rect.y
				width: model.modelData.rect.width
				height: model.modelData.rect.height
				source: "image://provinces/" + model.modelData.identifier + "?flag=" + flag
				cache: false

				Connections {
					target: model.modelData
					onImageChanged: {
						//the flag is used for the workaround to make the image be reloaded
						if (flag == 0) {
							flag = 1
						} else {
							flag = 0
						}
					}
				}

				MaskedMouseArea {
					anchors.fill: parent
					alphaThreshold: 0.4
					maskSource: parent.source
					ToolTip.text: tooltip(
						model.modelData.name
						+ (model.modelData.county && metternich.map_mode === WorldMap.Mode.Country && model.modelData.county.realm ? "<br><br>Country: " + model.modelData.county.realm.titled_name : "")
						+ (model.modelData.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br><br>De Jure Empire: " + model.modelData.de_jure_empire.name : "")
						+ (model.modelData.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br><br>De Jure Kingdom: " + model.modelData.de_jure_kingdom.name : "")
						+ (model.modelData.de_jure_duchy && metternich.map_mode === WorldMap.Mode.DeJureDuchy ? "<br><br>De Jure Duchy: " + model.modelData.de_jure_duchy.name : "")
						+ (model.modelData.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br><br>Culture: " + model.modelData.culture.name : "")
						+ (model.modelData.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + model.modelData.culture.culture_group.name : "")
						+ (model.modelData.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br><br>Religion: " + model.modelData.religion.name : "")
						+ (model.modelData.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion Group: " + model.modelData.religion.religion_group.name : "")
						+ (metternich.map_mode === WorldMap.Mode.TradeNode && model.modelData.trade_node && model.modelData.owner ? "<br><br>Trade Node: " + model.modelData.trade_node.name : "")
						+ (metternich.map_mode === WorldMap.Mode.TradeNode && model.modelData.trade_node && model.modelData.trade_node.center_of_trade === model.modelData && model.modelData.owner ? "<br>Center of Trade" : "")
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
						metternich.selected_character = null
					}
				}
			}
		}

		Repeater {
			model: world ? world.trade_routes : []

			Shape {
				x: model.modelData.rect.x
				y: model.modelData.rect.y
				width: model.modelData.rect.width
				height: model.modelData.rect.height
				visible: metternich.map_mode === WorldMap.Mode.TradeNode

				ShapePath {
					strokeWidth: 2
					strokeColor: "gold"
					strokeStyle: ShapePath.SolidLine
					capStyle: ShapePath.RoundCap
					joinStyle: ShapePath.RoundJoin
					fillColor: "transparent"
					startX: model.modelData.path_points[0].x
					startY: model.modelData.path_points[0].y
					PathPolyline { path: model.modelData.path_points }
				}
			}
		}
	}
}
