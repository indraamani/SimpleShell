import Quickshell 

ScriptModel {

    property string inputText: ""

    values: {

        const allEntries = [...DesktopEntries.applications.values]

        if (inputText == "") {
            return allEntries.sort((a,b) => a.name.localeCompare(b.name))
        }

        return allEntries.filter(elem => elem.name.toLowerCase().includes(inputText.toLowerCase())).sort((a,b) => a.name.localeCompare(b.name))
    }
}
