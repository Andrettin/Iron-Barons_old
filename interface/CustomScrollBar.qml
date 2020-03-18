import QtQuick 2.14
import QtQuick.Controls 2.14

ScrollBar {
	policy: parent.contentHeight > parent.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
	palette {
		mid: "#686868" //normal color for the scrollbar, #bdbdbd is the default
		//"dark" is the palette color used when the scrollbar is pressed. #353637 is the default
	}
}
