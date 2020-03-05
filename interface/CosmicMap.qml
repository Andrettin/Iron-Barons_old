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
			property string tooltip_text: system.name + " System<br>"
			+ (system.duchy && metternich.map_mode === WorldMap.Mode.Country && system.duchy.realm ? "<br>Realm: " + system.duchy.realm.titled_name : "")
			+ (system.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br>De Jure Empire: " + system.de_jure_empire.name : "")
			+ (system.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br>De Jure Kingdom: " + system.de_jure_kingdom.name : "")
			+ (system.ethereal ? "<br>Ethereal" : "")
			+ "<br>Astrocoordinate: (" + map_view.get_mouse_pos_astrocoordinate_x() + ", " + map_view.get_mouse_pos_astrocoordinate_y() + ")"

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

	Repeater3D { //the worlds themselves
		model: metternich.worlds

		Model {
			property var world: model.modelData
			property string tooltip_text: world.name + "<br>"
			+ (world.star_system ? "<br>Star System: " + world.star_system.name : "")
			+ "<br>Type: " + world.type.name
			+ (world.county && metternich.map_mode === WorldMap.Mode.Country && world.county.realm ? "<br>Realm: " + world.county.realm.titled_name : "")
			+ (world.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br>De Jure Empire: " + world.de_jure_empire.name : "")
			+ (world.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br>De Jure Kingdom: " + world.de_jure_kingdom.name : "")
			+ (world.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture: " + world.culture.name : "")
			+ (world.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + world.culture.culture_group.name : "")
			+ (world.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion: " + world.religion.name : "")
			+ (world.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion Group: " + world.religion.religion_group.name : "")
			+ "<br>Astrocoordinate: (" + Math.round(world.cosmic_map_pos.x) + ", " + Math.round(world.cosmic_map_pos.y) + ")"

			function get_tooltip_x() {
				return map_view.get_view_pos(position).x
			}

			function get_tooltip_y() {
				return map_view.get_view_pos(position).y - (world.cosmic_size / 2)
			}

			function is_valid_tooltip_pos(pos) {
				return true
			}

			function click() {
				if (world.selectable) {
					game_view.selected_world = world
				} else {
					game_view.selected_world = null
				}
			}

			function get_color(world_type) {
				if (world_type === "blue_giant_star" || world_type === "blue_dwarf_star") {
					return "blue"
				} else if (world_type === "class_a_giant_star" || world_type === "class_a_dwarf_star" || world_type === "blue_white_giant_star" || world_type === "blue_white_dwarf_star") {
					return "lightblue"
				} else if (world_type === "orange_giant_star" || world_type === "orange_dwarf_star") {
					return "orange"
				} else if (world_type === "red_giant_star" || world_type === "red_dwarf_star") {
					return "orange"
				} else if (world_type === "yellow_giant_star" || world_type === "yellow_dwarf_star") {
					return "yellow"
				} else if (world_type === "yellow_white_giant_star" || world_type === "yellow_white_dwarf_star") {
					return "lightyellow"
				}

				return "white"
			}


			position: Qt.vector3d(world.cosmic_map_pos.x, world.cosmic_map_pos.y * -1, 0)
			scale: Qt.vector3d(world.cosmic_size / 100.0, world.cosmic_size / 100.0, world.cosmic_size / 100.0) //the pixel size of the sphere model is by default c. 100x100
			rotation: Qt.vector3d(-45, Math.random(360), world.orbit_center ? 24 * world.orbit_position.x * -1 : 0)
			source: "#Sphere"
			pickable: true
			visible: world.orbit_center || world.astrocoordinate.isValid

			materials: [
				DefaultMaterial {
					diffuseColor: get_color(world.type.identifier)
					diffuseMap: world.star ? null : world_texture
				}
			]

			Texture {
				id: world_texture
				source: world.texture_path
			}
		}
	}
}
