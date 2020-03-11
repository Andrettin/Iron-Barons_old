import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Shapes 1.14
import QtQuick3D 1.14
import QtQuick3D.Materials 1.14

Node {
	id: cosmic_map

	Repeater3D { //star system territories
//		model: metternich.star_systems
		model: metternich.cosmic_duchies //using all star systems is consuming too much memory due to the 2D shape texture

		Model {
			//property var system: model.modelData
			property var system: model.modelData.star_system
			property real bounding_width: system.territory_bounding_rect.width
			property real bounding_height: system.territory_bounding_rect.height
			property real bounding_size: Math.max(bounding_width, bounding_height)
			property int tooltip_update_counter: 0
			property string tooltip_text: system.name + " System<br>"
			+ (system.duchy && metternich.map_mode === WorldMap.Mode.Country && system.duchy.realm ? "<br>Realm: " + system.duchy.realm.titled_name : "")
			+ (system.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br>De Jure Empire: " + system.de_jure_empire.name : "")
			+ (system.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br>De Jure Kingdom: " + system.de_jure_kingdom.name : "")
			+ (system.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture: " + system.culture.name : "")
			+ (system.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + system.culture.group.name : "")
			+ (system.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion: " + system.religion.name : "")
			+ (system.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion Group: " + system.religion.religion_group.name : "")
			+ (system.ethereal ? "<br>Ethereal" : "")
			+ "<br>Astrocoordinate: (" + map_view.get_mouse_pos_astrocoordinate_x() + ", " + map_view.get_mouse_pos_astrocoordinate_y() + ")"
			+ (tooltip_update_counter ? "" : "")

			function get_tooltip_x() {
				return map_view.get_tooltip_x()
			}

			function get_tooltip_y() {
				return map_view.get_tooltip_y()
			}

			//whether a position within the object is a valid tooltip position
			function is_valid_tooltip_pos(normalized_pos) {
				var x_offset = (bounding_size - bounding_width) / 2
				var y_offset = (bounding_size - bounding_height) / 2
				var pos = Qt.point(normalized_pos.x * bounding_size - x_offset, normalized_pos.y * bounding_size - y_offset)
				return territory_shape.contains(pos)
			}

			function click() {
				game_view.selected_world = null
			}

			visible: system.territory_polygon.length > 0
			position: Qt.vector3d(system.territory_bounding_rect.x + (bounding_width / 2), (system.territory_bounding_rect.y + (bounding_height / 2)) * -1, 1)
			scale: Qt.vector3d(bounding_size / 100.0, bounding_size / 100.0, 0.1)
			source: "#Cube"
			pickable: true

			materials: [
				DefaultMaterial {
					diffuseMap: territory_texture
					opacityMap: territory_texture
				}
			]

			Texture {
				id: territory_texture
				sourceItem: Rectangle {
					id: territory_rect
					x: -10000 //hide it from view
					y: -10000
					width: bounding_size
					height: bounding_size
					color: "transparent"
					layer.enabled: true

					Shape {
						id: territory_shape
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.verticalCenter: parent.verticalCenter
						width: bounding_width
						height: bounding_height
						containsMode: Shape.FillContains

						ShapePath {
							strokeWidth: 2
							strokeColor: "black"
							strokeStyle: ShapePath.SolidLine
							capStyle: ShapePath.RoundCap
							joinStyle: ShapePath.RoundJoin
							fillColor: Qt.rgba(system.map_mode_color.r, system.map_mode_color.g, system.map_mode_color.b, 0.5)
							fillRule: ShapePath.WindingFill
							PathPolyline { path: system.territory_polygon }
						}
					}
				}
			}
		}
	}

	Repeater3D { //orbits
		model: metternich.worlds

		Model {
			visible: model.modelData.orbit_center !== null

			position: model.modelData.orbit_center ? Qt.vector3d(model.modelData.orbit_center.cosmic_map_pos.x, model.modelData.orbit_center.cosmic_map_pos.y * -1, 0) : Qt.vector3d(0, 0, 0)
			scale: Qt.vector3d(model.modelData.distance_from_orbit_center * 2 / 100.0, model.modelData.distance_from_orbit_center * 2 / 100.0, 0.1)
			source: "#Cube"

			materials: [
				DefaultMaterial {
					diffuseMap: orbit_texture
					opacityMap: orbit_texture
				}
			]

			Texture {
				id: orbit_texture
				sourceItem: Rectangle {
					id: orbit_rect
					x: -10000 //hide it from view
					y: -10000
					width: model.modelData.distance_from_orbit_center * 2
					height: model.modelData.distance_from_orbit_center * 2
					color: "transparent"
					border.color: "blue"
					border.width: 1.5
					radius: width * 0.5
					layer.enabled: true
				}

				flipV: true
			}
		}
	}

	//the worlds themselves
	Repeater3D {
		model: metternich.worlds

		WorldModel {
			world: model.modelData
		}
	}
}
