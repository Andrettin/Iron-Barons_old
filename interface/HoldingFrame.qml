import QtQuick 2.14
import QtQuick.Controls 2.5

Item {
	readonly property string holding_frame_border_image_path: "../graphics/interface/holding_frame_border_silver.png"
	readonly property string holding_frame_middle_image_path: "../graphics/interface/holding_frame_middle_silver.png"
	readonly property int border_part_width: 33
	readonly property int border_part_height: 17
	readonly property int border_part_right: holding_frame.width - border_part_height
	readonly property int border_part_bottom: holding_frame.height - border_part_height
	readonly property int middle_part_width: 1
	readonly property int middle_part_height: 17
	readonly property int middle_part_count: (holding_frame.width - (border_part_width * 2)) / middle_part_width
	readonly property int middle_part_right: holding_frame.width - middle_part_height
	readonly property int middle_part_bottom: holding_frame.height - middle_part_height

	id: holding_frame

	Image {
		source: holding_frame_border_image_path
		x: 0
		y: 0
	}

	Image {
		source: holding_frame_border_image_path
		rotation: 90
		x: border_part_right - 8
		y: 0 + 8
	}

	Image {
		source: holding_frame_border_image_path
		rotation: 180
		x: holding_frame.width - border_part_width
		y: border_part_bottom
	}

	Image {
		source: holding_frame_border_image_path
		rotation: 270
		x: 0 - 8
		y: holding_frame.height - border_part_width + 8
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		x: holding_frame.width - border_part_width
		y: 0
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		rotation: 90
		x: border_part_right - 8
		y: holding_frame.height - border_part_width + 8
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		rotation: 180
		x: 0
		y: border_part_bottom
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		rotation: 270
		x: 0 - 8
		y: 0 + 8
	}

	Repeater {
		model: middle_part_count

		Image {
			source: holding_frame_middle_image_path
			x: border_part_width + (index * middle_part_width)
			y: 0
		}
	}

	Repeater {
		model: middle_part_count

		Image {
			source: holding_frame_middle_image_path
			x: middle_part_right + 8
			y: border_part_width + (index * middle_part_width) - 8
			rotation: 90
		}
	}

	Repeater {
		model: middle_part_count

		Image {
			source: holding_frame_middle_image_path
			rotation: 180
			x: border_part_width + (index * middle_part_width)
			y: middle_part_bottom
		}
	}

	Repeater {
		model: middle_part_count

		Image {
			source: holding_frame_middle_image_path
			rotation: 270
			x: 0 + 8
			y: border_part_width + (index * middle_part_width) - 8
		}
	}
}
