import Quickshell 

ScriptModel {

    property string inputText: ""

    values: {

        const allEntries = [...DesktopEntries.applications.values]

        if (inputText == "") {
            return allEntries
        }

        return allEntries.filter(elem => elem.name.toLowerCase().includes(inputText.toLowerCase()))
    }
}
