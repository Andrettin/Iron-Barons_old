import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick3D 1.14

View3D {
	id: map_view

	function moveLeft(pixels) {
		camera.position.x -= pixels
	}

	function moveRight(pixels) {
		camera.position.x += pixels
	}

	function moveUp(pixels) {
		camera.position.y += pixels
	}

	function moveDown(pixels) {
		camera.position.y -= pixels
	}

	environment: SceneEnvironment {
		clearColor: "transparent"
		backgroundMode: SceneEnvironment.Color
		multisampleAAMode: SceneEnvironment.X4
	}

	OrthographicCamera {
		id: camera
		position: Qt.vector3d(0, 0, Math.max(map_view.width, map_view.height) * -1)
		rotation: Qt.vector3d(0, 0, 0)

		onPositionChanged: {
			mouse_area.on_mouse_pos_changed(mouse_area.mouseX, mouse_area.mouseY)
		}
	}

	DirectionalLight {
		position: Qt.vector3d(0, 0, -1000)
		rotation: Qt.vector3d(0, 0, 0)
	}

	Repeater3D { //orbits
		model: metternich.worlds

		Model {
			visible: model.modelData.orbit_center !== null

			position: model.modelData.orbit_center ? Qt.vector3d(model.modelData.orbit_center.cosmic_map_pos.x, model.modelData.orbit_center.cosmic_map_pos.y * -1, 0) : Qt.vector3d(0, 0, 0)
			scale: Qt.vector3d(model.modelData.distance_from_orbit_center * 2 / 100.0, model.modelData.distance_from_orbit_center * 2 / 100.0, 0.1) //the pixel size of the sphere model is by default c. 100x100
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
			property string tooltip_text: world.name + "<br><br>Type: " + world.type.name

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
					diffuseMap: world.type.star ? null : world_texture
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
			hovered_object = result.objectHit;
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

		CustomToolTip {
			text: parent.hovered_object ? tooltip(parent.hovered_object.tooltip_text) : ""
			visible: parent.containsMouse && parent.hovered_object !== null
			delay: 1000
			x: parent.hovered_object ? (camera.mapToViewport(parent.hovered_object.position).x * map_view.width) - (width / 2) : 0
			y: parent.hovered_object ? (camera.mapToViewport(parent.hovered_object.position).y * map_view.height) - height - (parent.hovered_object.world.cosmic_size / 2) - 8 : 0
		}
	}
}
