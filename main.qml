import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import MaskedMouseArea 1.0

Window {
	visible: true
	width: 640
	height: 480
	title: qsTr("Iron Barons")
	flags: Qt.FramelessWindowHint
	visibility: "Maximized"
	//visibility: "FullScreen"

	Map {
		id: map
		x: -3596
		y: -584
	}

	Item {
		id: top_bar
		anchors.top: parent.top
		anchors.right: parent.right
		width: 178 + 43 + 162
		height: 72

		Image {
			id: top_bar_background_right
			anchors.top: parent.top
			anchors.right: parent.right
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_right_bg_right.dds"
		}

		Image {
			id: top_bar_background_middle
			anchors.top: parent.top
			anchors.right: top_bar_background_right.left
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_right_bg_extension.dds"
		}

		Image {
			id: top_bar_background_left
			anchors.top: parent.top
			anchors.right: top_bar_background_middle.left
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_right_bg_left.dds"
		}

		Item {
			id: date_area
			anchors.top: parent.top
			anchors.topMargin: 40
			anchors.left: parent.left
			anchors.leftMargin: 71
			width: 259
			height: 24

			Image {
				id: date_background
				anchors.top: parent.top
				anchors.left: parent.left
				source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_date_pause_medium.dds"
			}

			Text {
				id: date
				text: Metternich.game.current_date_string
				anchors.top: parent.top
				anchors.topMargin: 4
				anchors.left: parent.left
				anchors.leftMargin: 7 + 3
				color: "white"
				font.pixelSize: 12
				font.family: "tahoma"
			}
		}
	}

	ProvinceInterface {
		id: province_interface
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		visible: Metternich.selected_province !== null
	}

	/*
	Item {
		id: holding_building
		width: 320
		height: 35

		AnimatedSprite {
			id: building_background
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/buildview_listitem.dds"
			running: false
			frameCount: 3
			currentFrame: 1
		}

		Text {
			id: building_name
			text: "University"
			x: 35
			height: 32
			verticalAlignment: Text.AlignVCenter
			color: "white"
			font.pointSize: 12
			font.family: "tahoma"
		}
	}
	*/
}
