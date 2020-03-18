import QtQuick 2.14
import QtQuick.Controls 2.14

ScrollBar {
	policy: parent.contentHeight > parent.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
	palette {
		mid: "gray"
		//"dark" is the palette color used when the scrollbar is pressed
	}
}
