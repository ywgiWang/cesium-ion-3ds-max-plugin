struct cesiumPlugin
(
    PLUGINDIRECTORY,
    VISITWEBSITE,
    SERVERGETTOKEN,
    SERVERDIRECTORY,
    CLIENT_ID = "62",
    REDIRECT_ADDRESS = @"http://localhost:5000/",
    cesiumMenuName = "Export to Cesium ion...",
    tokenLocation,
    progressFilePath,
    uploadCounter = 0,
    uploadWidget,
    fn createMenu =
    (
        local mainMenu = menuMan.getMainMenuBar()
        local notFound = true
        local fileMenu
        for i = 1 to mainMenu.numItems() while notFound do
        (
            fileMenu = mainMenu.getItem(i)
            if fileMenu.getTitle() == "&File" then notFound = false
        )
        local newMenu = false
        fileMenu = fileMenu.getSubMenu()
        if (notFound == false) then
        (
            notFound = true
            local exportMenu
            for i = 1 to fileMenu.numItems() while notFound do
            (
                exportMenu = fileMenu.getItem(i)
                if exportMenu.getTitle() == "&Export" then notFound = false
            )
            if classOf exportMenu == MixinInterface then
            (
                exportMenu = exportMenu.getSubMenu()
                notFound = true
                for i = 1 to exportMenu.numItems() while notFound do
                (
                    item = exportMenu.getItem(i)
                    if item.getTitle() == cesiumMenuName then notFound = false
                )
                if notFound then
                (
                    local myAction = menuMan.createActionItem "exportButton" "mxs docs"
                    exportMenu.addItem myAction (exportMenu.numItems()+1)
                    menuMan.updateMenuBar()
                )
            )
            else
            (
                newMenu = true
            )
        )
        else
        (
            newMenu = true
        )
        if (newMenu) then
        (
            local menu = menuMan.findMenu "&Cesium ion"
            if (menu == undefined) then
            (
                menu = menuMan.createMenu "&Cesium ion"
                local myAction = menuMan.createActionItem "exportButton" "mxs docs"
                menu.addItem myAction -1
                subMenu = menuMan.createSubMenuItem "&Cesium ion" menu
                mainMenu.addItem subMenu (mainMenu.numItems())
                menuMan.updateMenuBar()
            )
        )

    ),
    fn init =
    (
            VISITWEBSITE = "C#.exe website";

            local path = getSourceFileName()
            path = getFilenamePath path
            path = substring path 1 (path.count-1)
            PLUGINDIRECTORY = getFilenamePath path
            SERVERDIRECTORY = PLUGINDIRECTORY + @"C#\"
            tokenLocation = (GetDir #plugcfg_ln + "\\cesiumIonToken")
            SERVERGETTOKEN = "C#.exe" + " gettoken " + CLIENT_ID + " " + REDIRECT_ADDRESS + " \"" + tokenLocation + "\""
            local tmpFiles = getFiles (GetDir #temp + "\\cesiumion*.fbx")
            for f in tmpFiles do (deleteFile f)
            tmpFiles = getFiles (GetDir #temp + "\\progress*.log")
            for f in tmpFiles do (deleteFile f)
    )
)

cesiumInstance = cesiumPlugin()
cesiumInstance.init()

-- create a menu

macroScript exportButton
    category: "mxs docs"
    buttonText: cesiumInstance.cesiumMenuName
    toolTip: "Publish the current 3ds Max file to your Cesium ion account."
(
    local tokenFile = openFile cesiumInstance.tokenLocation mode:"r"
    if tokenFile == undefined then
    (
        HiddenDOSCommand cesiumInstance.SERVERGETTOKEN startpath:cesiumInstance.SERVERDIRECTORY donotwait:true
    )
    else
    (
        close tokenFile
        free tokenFile
    )

    createDialog cesiumFloater modal:true
)
