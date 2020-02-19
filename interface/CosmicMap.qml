import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Shapes 1.14
import QtQuick3D 1.14

View3D {
	id: map_view

	function move_left(pixels) {
		var x = camera.position.x - pixels
		if (x < camera.min_x) {
			x = camera.min_x
		}
		camera.position.x = x
	}

	function move_right(pixels) {
		var x = camera.position.x + pixels
		if (x > camera.max_x) {
			x = camera.max_x
		}
		camera.position.x = x
	}

	function move_up(pixels) {
		var y = camera.position.y + pixels
		if (y > camera.max_y) {
			y = camera.max_y
		}
		camera.position.y = y
	}

	function move_down(pixels) {
		var y = camera.position.y - pixels
		if (y < camera.min_y) {
			y = camera.min_y
		}
		camera.position.y = y
	}

	function zoom_in() {
	}

	function zoom_out() {
	}

	function get_mouse_pos_astrocoordinate_x() {
		return Math.round(camera.mapFromViewport(Qt.vector3d(mouse_area.mouseX / map_view.width, mouse_area.mouseY / map_view.height, 0)).x)
	}

	function get_mouse_pos_astrocoordinate_y() {
		return Math.round(camera.mapFromViewport(Qt.vector3d(mouse_area.mouseX / map_view.width, mouse_area.mouseY / map_view.height, 0)).y) * -1
	}

	function get_tooltip_x() {
		return mouse_area.mouseX
	}

	function get_tooltip_y() {
		return mouse_area.mouseY
	}

	environment: SceneEnvironment {
		clearColor: "transparent"
		backgroundMode: SceneEnvironment.Color
		multisampleAAMode: SceneEnvironment.X4
	}

	OrthographicCamera {
		id: camera

		property real min_x: metternich.cosmic_map_bounding_rect.left + (map_view.width / 2)
		property real max_x: metternich.cosmic_map_bounding_rect.right - (map_view.width / 2)
		property real min_y: (metternich.cosmic_map_bounding_rect.bottom * -1) + (map_view.height / 2)
		property real max_y: (metternich.cosmic_map_bounding_rect.top * -1) - (map_view.height / 2)

		position: Qt.vector3d(0, 0, Math.max(map_view.width, map_view.height) * -1)
		rotation: Qt.vector3d(0, 0, 0)
		frustumCullingEnabled: true

		onPositionChanged: {
			mouse_area.on_mouse_pos_changed(mouse_area.mouseX, mouse_area.mouseY)
		}
	}

	DirectionalLight {
		position: Qt.vector3d(0, 0, -1000)
		rotation: Qt.vector3d(0, 0, 0)
	}

	Repeater3D { //star system territories
		model: metternich.star_systems

		Model {
			property var system: model.modelData
			property string tooltip_text: system.name + " System<br>"
			+ (system.ethereal ? "<br>Ethereal" : "")
			+ "<br>Astrocoordinate: (" + get_mouse_pos_astrocoordinate_x() + ", " + get_mouse_pos_astrocoordinate_y() + ")"
			property real bounding_width: system.territory_bounding_rect.width
			property real bounding_height: system.territory_bounding_rect.height
			property real bounding_size: Math.max(bounding_width, bounding_height)

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

			visible: system.territory_polygon.length > 0
			position: Qt.vector3d(system.territory_bounding_rect.x + (bounding_width / 2), (system.territory_bounding_rect.y + (bounding_height / 2)) * -1, 1)
			scale: Qt.vector3d(bounding_size / 100.0, bounding_size / 100.0, 0.1)
			source: "#Cube"
			pickable: true

			materials: [
				DefaultMaterial {
					diffuseMap: Texture {
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
									strokeColor: system.color
									strokeStyle: ShapePath.SolidLine
									capStyle: ShapePath.RoundCap
									joinStyle: ShapePath.RoundJoin
									fillColor: Qt.rgba(system.color.r, system.color.g, system.color.b, 0.5)
									fillRule: ShapePath.WindingFill
									PathPolyline { path: system.territory_polygon }
								}
							}
						}
					}
					opacityMap: Texture {
						sourceItem: territory_rect
					}
				}
			]
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
					diffuseMap: Texture {
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
					opacityMap: Texture {
						sourceItem: orbit_rect
					}
				}
			]
		}
	}

	Repeater3D { //the worlds themselves
		model: metternich.worlds

		Model {
			property var world: model.modelData
			property string tooltip_text: world.name + "<br>"
			+ (world.star_system ? "<br>Star System: " + world.star_system.name : "")
			+ "<br>Type: " + world.type.name
			+ "<br>Astrocoordinate: (" + Math.round(world.cosmic_map_pos.x) + ", " + Math.round(world.cosmic_map_pos.y) + ")"

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

			function get_tooltip_x() {
				return camera.mapToViewport(position).x * map_view.width
			}

			function get_tooltip_y() {
				return (camera.mapToViewport(position).y * map_view.height) - (world.cosmic_size / 2)
			}

			function is_valid_tooltip_pos(pos) {
				return true
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

			Component.onCompleted: {
				if (world.orbit_center === null) {
					console.info(world.name + " Position: " + world.cosmic_map_pos)
				}
			}
		}
	}

	MouseArea {
		id: mouse_area
		property var hovered_object: null

		function on_mouse_pos_changed(mouse_x, mouse_y) {
			var result = map_view.pick(mouse_x, mouse_y)
			var hit_object = result.objectHit

			tooltip_timer.restart() //restart the tooltip delay (always restart when moving the mouse)

			if (hit_object !== null && !hit_object.is_valid_tooltip_pos(result.uvPosition)) {
				hit_object = null
			}

			if (hit_object !== tooltip_timer.delayed_hovered_object) {
				tooltip_timer.delayed_hovered_object = hit_object;
			}
		}

		anchors.fill: map_view
		hoverEnabled: true
		onPositionChanged: {
			on_mouse_pos_changed(mouse.x, mouse.y)
		}
		onClicked: {
			if (metternich.selected_province !== null) {
				metternich.selected_province.selected = false
			}
			if (metternich.selected_holding !== null) {
				metternich.selected_holding.selected = false
			}
			metternich.selected_character = null
		}

		Timer {
			property var delayed_hovered_object: null

			id: tooltip_timer
			interval: 1000
			onTriggered: {
				mouse_area.hovered_object = delayed_hovered_object
			}
		}

		CustomToolTip {
			id: custom_tooltip
			text: tooltip(mouse_area.hovered_object ? mouse_area.hovered_object.tooltip_text
				: "Astrocoordinate: ("
				+ get_mouse_pos_astrocoordinate_x() + ", "
				+ get_mouse_pos_astrocoordinate_y() + ")")
			visible: mouse_area.containsMouse && !tooltip_timer.running
			delay: 0
			x: (mouse_area.hovered_object ? mouse_area.hovered_object.get_tooltip_x() : get_tooltip_x()) - (width / 2)
			y: (mouse_area.hovered_object ? mouse_area.hovered_object.get_tooltip_y() : get_tooltip_y()) - height - 8
		}
	}
}
