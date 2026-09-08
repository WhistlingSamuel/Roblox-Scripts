--// CONNECTEYES TOOL HUB
--// LocalScript
--// Full Fixed Version
--
--// TOOLS
--// 1. Super Cool Wrench
--// 2. Building Tools
--// 3. Fork3X
--// 4. Blue Bucket
--
--// Each tool has:
--// GET + AUTO-TP
--
--// ADMIN PADS
--// 10 Pads
--// TP + AUTO-TP
--
--// HD WHITELISTER
--
--// CLIENT CONTROLS
--// Mesh Hider
--// Anti-Pause
--// Wrench C Mover
--
--// X / CLOSE:
--// Cancels all running systems and restores client changes

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--============================================================
-- CONFIG
--============================================================

local BUCKET_ID = "25162389"

local WRENCH_NAME = "super cool wrench"
local BUILDING_NAME = "Building Tools"
local FORK3X_NAME = "Fork3X"

local MAX_ADMIN_PADS = 10

local NORMAL_SIZE = UDim2.fromOffset(280, 330)
local MINIMIZED_SIZE = UDim2.fromOffset(280, 30)

--============================================================
-- SHUTDOWN STATE
--============================================================

local HubClosed = false

local Connections = {}

local function AddConnection(Connection)
    if Connection then
        table.insert(Connections, Connection)
    end
    return Connection
end

local function DisconnectAll()
    for _, Connection in ipairs(Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    table.clear(Connections)
end

--============================================================
-- REMOVE OLD HUB
--============================================================

local OldHub = PlayerGui:FindFirstChild("ConnectEyesToolHub")

if OldHub then
    OldHub:Destroy()
end

--============================================================
-- REQUEST COMMAND
--============================================================

local RequestCommand = nil

local HDAdminClient =
    ReplicatedStorage:FindFirstChild("HDAdminClient")

if HDAdminClient then

    local Signals =
        HDAdminClient:FindFirstChild("Signals")

    if Signals then
        RequestCommand =
            Signals:FindFirstChild("RequestCommand")
    end
end

--============================================================
-- GENERAL HELPERS
--============================================================

local function FindPart(Object)

    if not Object then
        return nil
    end

    if Object:IsA("BasePart") then
        return Object
    end

    if Object:IsA("Model") and Object.PrimaryPart then
        return Object.PrimaryPart
    end

    return Object:FindFirstChildWhichIsA(
        "BasePart",
        true
    )
end

local function TeleportToPart(Part)

    if HubClosed then
        return false
    end

    local Character =
        LocalPlayer.Character

    local Root =
        Character
        and Character:FindFirstChild("HumanoidRootPart")

    if not Root or not Part then
        return false
    end

    return pcall(function()

        Root.CFrame =
            Part.CFrame +
            Vector3.new(0, 3, 0)

    end)
end

--============================================================
-- TOOL SEARCH
--============================================================

local function FindDroppedTool(ToolName)

    local Character =
        LocalPlayer.Character

    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        if HubClosed then
            return nil
        end

        if Object:IsA("Tool")
        and Object.Name:lower() == ToolName:lower() then

            if not Character
            or not Object:IsDescendantOf(Character) then

                return Object
            end
        end
    end

    return nil
end

local function GetTool(ToolName)

    if HubClosed then
        return nil
    end

    local Character =
        LocalPlayer.Character

    -- CHARACTER
    if Character then

        local Tool =
            Character:FindFirstChild(ToolName)

        if Tool and Tool:IsA("Tool") then
            return Tool
        end

        for _, Object in ipairs(
            Character:GetChildren()
        ) do

            if Object:IsA("Tool")
            and Object.Name:lower() == ToolName:lower() then

                return Object
            end
        end
    end

    -- BACKPACK
    local Backpack =
        LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack then

        local Tool =
            Backpack:FindFirstChild(ToolName)

        if Tool and Tool:IsA("Tool") then
            return Tool
        end

        for _, Object in ipairs(
            Backpack:GetChildren()
        ) do

            if Object:IsA("Tool")
            and Object.Name:lower() == ToolName:lower() then

                return Object
            end
        end
    end

    -- WORKSPACE
    return FindDroppedTool(ToolName)
end

--============================================================
-- SCREEN GUI
--============================================================

local ScreenGui =
    Instance.new("ScreenGui")

ScreenGui.Name =
    "ConnectEyesToolHub"

ScreenGui.ResetOnSpawn =
    false

ScreenGui.IgnoreGuiInset =
    true

ScreenGui.Parent =
    PlayerGui

--============================================================
-- MAIN
--============================================================

local Main =
    Instance.new("Frame")

Main.Size =
    NORMAL_SIZE

Main.Position =
    UDim2.new(
        0.5,
        -140,
        0.5,
        -165
    )

Main.BackgroundColor3 =
    Color3.fromRGB(45, 45, 45)

Main.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

Main.BorderSizePixel =
    2

Main.Active =
    true

Main.Parent =
    ScreenGui

--============================================================
-- TITLE BAR
--============================================================

local Top =
    Instance.new("Frame")

Top.Size =
    UDim2.new(1, 0, 0, 30)

Top.BackgroundColor3 =
    Color3.fromRGB(30, 30, 30)

Top.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

Top.BorderSizePixel =
    1

Top.Active =
    true

Top.Parent =
    Main

local Logo =
    Instance.new("TextLabel")

Logo.Size =
    UDim2.fromOffset(34, 30)

Logo.BackgroundColor3 =
    Color3.fromRGB(65, 65, 65)

Logo.BorderSizePixel =
    0

Logo.Text =
    "CE"

Logo.TextColor3 =
    Color3.new(1, 1, 1)

Logo.Font =
    Enum.Font.SourceSansBold

Logo.TextSize =
    14

Logo.Parent =
    Top

local Title =
    Instance.new("TextLabel")

Title.Position =
    UDim2.fromOffset(40, 0)

Title.Size =
    UDim2.new(1, -100, 1, 0)

Title.BackgroundTransparency =
    1

Title.Text =
    "ConnectEyes Hub"

Title.TextColor3 =
    Color3.new(1, 1, 1)

Title.Font =
    Enum.Font.SourceSans

Title.TextSize =
    15

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.Parent =
    Top

--============================================================
-- MINIMIZE
--============================================================

local Minimize =
    Instance.new("TextButton")

Minimize.Position =
    UDim2.new(1, -60, 0, 3)

Minimize.Size =
    UDim2.fromOffset(25, 24)

Minimize.BackgroundColor3 =
    Color3.fromRGB(65, 65, 65)

Minimize.BorderSizePixel =
    0

Minimize.Text =
    "−"

Minimize.TextColor3 =
    Color3.new(1, 1, 1)

Minimize.Font =
    Enum.Font.SourceSansBold

Minimize.TextSize =
    18

Minimize.Parent =
    Top

--============================================================
-- CLOSE
--============================================================

local Close =
    Instance.new("TextButton")

Close.Position =
    UDim2.new(1, -30, 0, 3)

Close.Size =
    UDim2.fromOffset(25, 24)

Close.BackgroundColor3 =
    Color3.fromRGB(65, 65, 65)

Close.BorderSizePixel =
    0

Close.Text =
    "X"

Close.TextColor3 =
    Color3.new(1, 1, 1)

Close.Font =
    Enum.Font.SourceSansBold

Close.TextSize =
    14

Close.Parent =
    Top

--============================================================
-- TABS
--============================================================

local Tabs =
    Instance.new("Frame")

Tabs.Position =
    UDim2.fromOffset(5, 35)

Tabs.Size =
    UDim2.new(1, -10, 0, 45)

Tabs.BackgroundTransparency =
    1

Tabs.Parent =
    Main

local function CreateTab(Text, X, Width)

    local Button =
        Instance.new("TextButton")

    Button.Position =
        UDim2.fromOffset(X, 0)

    Button.Size =
        UDim2.fromOffset(Width, 23)

    Button.BackgroundColor3 =
        Color3.fromRGB(65, 65, 65)

    Button.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Button.BorderSizePixel =
        1

    Button.Text =
        Text

    Button.TextColor3 =
        Color3.new(1, 1, 1)

    Button.Font =
        Enum.Font.SourceSans

    Button.TextSize =
        11

    Button.Parent =
        Tabs

    return Button
end

local ToolsTab =
    CreateTab("Tools", 0, 63)

local AdminTab =
    CreateTab("Admin", 66, 63)

local HDTab =
    CreateTab("HD", 132, 63)

local ClientTab =
    CreateTab("Client", 198, 63)

--============================================================
-- PAGES
--============================================================

local Pages = {}

local function CreatePage()

    local Page =
        Instance.new("Frame")

    Page.Position =
        UDim2.fromOffset(5, 85)

    Page.Size =
        UDim2.new(1, -10, 1, -90)

    Page.BackgroundColor3 =
        Color3.fromRGB(35, 35, 35)

    Page.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Page.BorderSizePixel =
        1

    Page.Visible =
        false

    Page.Parent =
        Main

    table.insert(Pages, Page)

    return Page
end

local ToolsPage =
    CreatePage()

local AdminPage =
    CreatePage()

local HDPage =
    CreatePage()

local ClientPage =
    CreatePage()

--============================================================
-- PAGE SYSTEM
--============================================================

local Minimized = false
local CurrentPage = ToolsPage

local function ShowPage(Page)

    if HubClosed then
        return
    end

    CurrentPage =
        Page

    for _, P in ipairs(Pages) do
        P.Visible = false
    end

    if not Minimized then
        Page.Visible = true
    end
end

AddConnection(ToolsTab.MouseButton1Click:Connect(function()
    ShowPage(ToolsPage)
end))

AddConnection(AdminTab.MouseButton1Click:Connect(function()
    ShowPage(AdminPage)
end))

AddConnection(HDTab.MouseButton1Click:Connect(function()
    ShowPage(HDPage)
end))

AddConnection(ClientTab.MouseButton1Click:Connect(function()
    ShowPage(ClientPage)
end))

--============================================================
-- MINIMIZE SYSTEM
--============================================================

local function SetMinimized(Value)

    if HubClosed then
        return
    end

    Minimized =
        Value

    if Minimized then

        Tabs.Visible =
            false

        for _, Page in ipairs(Pages) do
            Page.Visible = false
        end

        Main.Size =
            MINIMIZED_SIZE

        Minimize.Text =
            "+"

    else

        Main.Size =
            NORMAL_SIZE

        Tabs.Visible =
            true

        for _, Page in ipairs(Pages) do
            Page.Visible = false
        end

        if CurrentPage then
            CurrentPage.Visible = true
        end

        Minimize.Text =
            "−"
    end
end

AddConnection(Minimize.MouseButton1Click:Connect(function()
    SetMinimized(not Minimized)
end))

--============================================================
-- DRAGGING
--============================================================

local Dragging = false
local DragStart
local StartPos

AddConnection(Top.InputBegan:Connect(function(Input)

    if HubClosed then
        return
    end

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1

    or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position

        AddConnection(Input.Changed:Connect(function()

            if Input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false
            end
        end))
    end
end))

AddConnection(UIS.InputChanged:Connect(function(Input)

    if HubClosed or not Dragging then
        return
    end

    if Input.UserInputType ==
        Enum.UserInputType.MouseMovement

    or Input.UserInputType ==
        Enum.UserInputType.Touch then

        local Delta =
            Input.Position - DragStart

        Main.Position =
            UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,

                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
    end
end))

--============================================================
-- TOOLS PAGE
--============================================================

local ToolsTitle =
    Instance.new("TextLabel")

ToolsTitle.Position =
    UDim2.fromOffset(8, 7)

ToolsTitle.Size =
    UDim2.new(1, -16, 0, 22)

ToolsTitle.BackgroundTransparency =
    1

ToolsTitle.Text =
    "Tools"

ToolsTitle.TextColor3 =
    Color3.new(1, 1, 1)

ToolsTitle.Font =
    Enum.Font.SourceSansBold

ToolsTitle.TextSize =
    17

ToolsTitle.TextXAlignment =
    Enum.TextXAlignment.Left

ToolsTitle.Parent =
    ToolsPage

local ToolsInfo =
    Instance.new("TextLabel")

ToolsInfo.Position =
    UDim2.fromOffset(8, 28)

ToolsInfo.Size =
    UDim2.new(1, -16, 0, 18)

ToolsInfo.BackgroundTransparency =
    1

ToolsInfo.Text =
    "Tool availability"

ToolsInfo.TextColor3 =
    Color3.fromRGB(180, 180, 180)

ToolsInfo.Font =
    Enum.Font.SourceSans

ToolsInfo.TextSize =
    11

ToolsInfo.TextXAlignment =
    Enum.TextXAlignment.Left

ToolsInfo.Parent =
    ToolsPage

--============================================================
-- TOOL ROW CREATOR
--============================================================

local function CreateToolRow(Index, DisplayName)

    local Row =
        Instance.new("Frame")

    Row.Position =
        UDim2.fromOffset(
            8,
            50 + ((Index - 1) * 48)
        )

    Row.Size =
        UDim2.new(1, -16, 0, 42)

    Row.BackgroundColor3 =
        Color3.fromRGB(45, 45, 45)

    Row.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Row.BorderSizePixel =
        1

    Row.Parent =
        ToolsPage

    local Name =
        Instance.new("TextLabel")

    Name.Position =
        UDim2.fromOffset(7, 2)

    Name.Size =
        UDim2.new(1, -145, 0, 18)

    Name.BackgroundTransparency =
        1

    Name.Text =
        DisplayName

    Name.TextColor3 =
        Color3.new(1, 1, 1)

    Name.Font =
        Enum.Font.SourceSansBold

    Name.TextSize =
        12

    Name.TextXAlignment =
        Enum.TextXAlignment.Left

    Name.Parent =
        Row

    local Status =
        Instance.new("TextLabel")

    Status.Position =
        UDim2.fromOffset(7, 21)

    Status.Size =
        UDim2.new(1, -145, 0, 15)

    Status.BackgroundTransparency =
        1

    -- IMPORTANT:
    -- No "CHECKING..." anymore.
    Status.Text =
        "NOT FOUND"

    Status.TextColor3 =
        Color3.fromRGB(170, 170, 170)

    Status.Font =
        Enum.Font.SourceSans

    Status.TextSize =
        10

    Status.TextXAlignment =
        Enum.TextXAlignment.Left

    Status.Parent =
        Row

    -- GET BUTTON
    local Get =
        Instance.new("TextButton")

    Get.Position =
        UDim2.new(1, -138, 0, 4)

    Get.Size =
        UDim2.fromOffset(60, 34)

    Get.BackgroundColor3 =
        Color3.fromRGB(70, 70, 70)

    Get.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Get.Text =
        "GET"

    Get.TextColor3 =
        Color3.new(1, 1, 1)

    Get.Font =
        Enum.Font.SourceSansBold

    Get.TextSize =
        11

    Get.Parent =
        Row

    -- AUTO-TP BUTTON
    local Auto =
        Instance.new("TextButton")

    Auto.Position =
        UDim2.new(1, -73, 0, 4)

    Auto.Size =
        UDim2.fromOffset(65, 34)

    Auto.BackgroundColor3 =
        Color3.fromRGB(70, 70, 70)

    Auto.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Auto.Text =
        "AUTO OFF"

    Auto.TextColor3 =
        Color3.new(1, 1, 1)

    Auto.Font =
        Enum.Font.SourceSansBold

    Auto.TextSize =
        10

    Auto.Parent =
        Row

    return {
        Row = Row,
        Name = Name,
        Status = Status,
        Get = Get,
        Auto = Auto,
        AutoEnabled = false,
        LastTP = 0
    }
end

local WrenchRow =
    CreateToolRow(
        1,
        "Super Cool Wrench"
    )

local BuildingRow =
    CreateToolRow(
        2,
        "Building Tools"
    )

local ForkRow =
    CreateToolRow(
        3,
        "Fork3X"
    )

local BucketRow =
    CreateToolRow(
        4,
        "Blue Bucket"
    )

local ToolRows = {
    {
        Row = WrenchRow,
        ToolName = WRENCH_NAME,
        Label = "Super Cool Wrench"
    },
    {
        Row = BuildingRow,
        ToolName = BUILDING_NAME,
        Label = "Building Tools"
    },
    {
        Row = ForkRow,
        ToolName = FORK3X_NAME,
        Label = "Fork3X"
    }
}

local ToolsStatus =
    Instance.new("TextLabel")

ToolsStatus.Position =
    UDim2.fromOffset(8, 244)

ToolsStatus.Size =
    UDim2.new(1, -16, 0, 35)

ToolsStatus.BackgroundColor3 =
    Color3.fromRGB(20, 20, 20)

ToolsStatus.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

ToolsStatus.BorderSizePixel =
    1

ToolsStatus.Text =
    "Ready."

ToolsStatus.TextColor3 =
    Color3.fromRGB(190, 190, 190)

ToolsStatus.Font =
    Enum.Font.SourceSans

ToolsStatus.TextSize =
    11

ToolsStatus.TextWrapped =
    true

ToolsStatus.Parent =
    ToolsPage

--============================================================
-- TOOL TELEPORT
--============================================================

local function TeleportToolToPlayer(Tool, Label)

    if HubClosed or not Tool then
        return false
    end

    local Character =
        LocalPlayer.Character

    local Root =
        Character
        and Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then

        ToolsStatus.Text =
            "Character not ready."

        return false
    end

    if Tool:IsDescendantOf(LocalPlayer) then

        ToolsStatus.Text =
            Label ..
            " is already yours."

        return true
    end

    local Handle =
        Tool:FindFirstChild(
            "Handle",
            true
        )

    if Handle
    and Handle:IsA("BasePart") then

        local Success =
            pcall(function()

                Handle.CFrame =
                    Root.CFrame +
                    Vector3.new(0, 3, 0)

            end)

        if Success then

            ToolsStatus.Text =
                Label ..
                " teleported to you!"

            return true
        end
    end

    local Part =
        Tool:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    if Part then

        local Success =
            pcall(function()

                Part.CFrame =
                    Root.CFrame +
                    Vector3.new(0, 3, 0)

            end)

        if Success then

            ToolsStatus.Text =
                Label ..
                " teleported to you!"

            return true
        end
    end

    ToolsStatus.Text =
        Label ..
        " has no movable part."

    return false
end

local function ActivateTool(ToolName, Label)

    if HubClosed then
        return nil
    end

    ToolsStatus.Text =
        "Searching for " ..
        Label ..
        "..."

    local Tool =
        GetTool(ToolName)

    if not Tool then

        ToolsStatus.Text =
            Label ..
            " not found."

        return nil
    end

    TeleportToolToPlayer(
        Tool,
        Label
    )

    return Tool
end

--============================================================
-- TOOL GET BUTTONS
--============================================================

AddConnection(WrenchRow.Get.MouseButton1Click:Connect(
    function()

        ActivateTool(
            WRENCH_NAME,
            "Super Cool Wrench"
        )

    end
))

AddConnection(BuildingRow.Get.MouseButton1Click:Connect(
    function()

        ActivateTool(
            BUILDING_NAME,
            "Building Tools"
        )

    end
))

AddConnection(ForkRow.Get.MouseButton1Click:Connect(
    function()

        ActivateTool(
            FORK3X_NAME,
            "Fork3X"
        )

    end
))

--============================================================
-- BLUE BUCKET GET
--============================================================

AddConnection(BucketRow.Get.MouseButton1Click:Connect(
    function()

        if HubClosed then
            return
        end

        if not RequestCommand then

            ToolsStatus.Text =
                "HD Admin RequestCommand not found."

            return
        end

        ToolsStatus.Text =
            "Getting Blue Bucket..."

        local Success =
            pcall(function()

                RequestCommand:InvokeServer(
                    ";gear me " ..
                    BUCKET_ID ..
                    ".1"
                )

            end)

        if Success then

            ToolsStatus.Text =
                "Blue Bucket command sent."

        else

            ToolsStatus.Text =
                "Bucket command failed."
        end
    end
))

--============================================================
-- TOOL AUTO-TP
--============================================================

local function ToggleToolAuto(
    Data,
    ToolName,
    Label
)

    Data.AutoEnabled =
        not Data.AutoEnabled

    if Data.AutoEnabled then

        Data.Auto.Text =
            "AUTO ON"

    else

        Data.Auto.Text =
            "AUTO OFF"
    end
end

AddConnection(WrenchRow.Auto.MouseButton1Click:Connect(
    function()
        ToggleToolAuto(
            WrenchRow,
            WRENCH_NAME,
            "Super Cool Wrench"
        )
    end
))

AddConnection(BuildingRow.Auto.MouseButton1Click:Connect(
    function()
        ToggleToolAuto(
            BuildingRow,
            BUILDING_NAME,
            "Building Tools"
        )
    end
))

AddConnection(ForkRow.Auto.MouseButton1Click:Connect(
    function()
        ToggleToolAuto(
            ForkRow,
            FORK3X_NAME,
            "Fork3X"
        )
    end)
)

AddConnection(BucketRow.Auto.MouseButton1Click:Connect(
    function()

        BucketRow.AutoEnabled =
            not BucketRow.AutoEnabled

        if BucketRow.AutoEnabled then

            BucketRow.Auto.Text =
                "AUTO ON"

        else

            BucketRow.Auto.Text =
                "AUTO OFF"
        end
    end
))

--============================================================
-- TOOL AVAILABILITY
--============================================================

local function UpdateToolAvailability()

    if HubClosed then
        return
    end

    local Wrench =
        GetTool(WRENCH_NAME)

    local Building =
        GetTool(BUILDING_NAME)

    local Fork3X =
        GetTool(FORK3X_NAME)

    if Wrench then
        WrenchRow.Status.Text =
            "FOUND"
    else
        WrenchRow.Status.Text =
            "NOT FOUND"
    end

    if Building then
        BuildingRow.Status.Text =
            "FOUND"
    else
        BuildingRow.Status.Text =
            "NOT FOUND"
    end

    if Fork3X then
        ForkRow.Status.Text =
            "FOUND"
    else
        ForkRow.Status.Text =
            "NOT FOUND"
    end

    BucketRow.Status.Text =
        "HD GEAR"

    ToolsInfo.Text =
        "Wrench • BTools • Fork3X • Bucket"
end

--============================================================
-- ADMIN PAGE
--============================================================

local AdminTitle =
    Instance.new("TextLabel")

AdminTitle.Position =
    UDim2.fromOffset(8, 7)

AdminTitle.Size =
    UDim2.new(1, -16, 0, 22)

AdminTitle.BackgroundTransparency =
    1

AdminTitle.Text =
    "Admin Pads"

AdminTitle.TextColor3 =
    Color3.new(1, 1, 1)

AdminTitle.Font =
    Enum.Font.SourceSansBold

AdminTitle.TextSize =
    17

AdminTitle.TextXAlignment =
    Enum.TextXAlignment.Left

AdminTitle.Parent =
    AdminPage

local AdminInfo =
    Instance.new("TextLabel")

AdminInfo.Position =
    UDim2.fromOffset(8, 29)

AdminInfo.Size =
    UDim2.new(1, -16, 0, 20)

AdminInfo.BackgroundTransparency =
    1

AdminInfo.Text =
    "0/10 FOUND"

AdminInfo.TextColor3 =
    Color3.fromRGB(180, 180, 180)

AdminInfo.Font =
    Enum.Font.SourceSans

AdminInfo.TextSize =
    11

AdminInfo.TextXAlignment =
    Enum.TextXAlignment.Left

AdminInfo.Parent =
    AdminPage

local AdminScroll =
    Instance.new("ScrollingFrame")

AdminScroll.Position =
    UDim2.fromOffset(5, 52)

AdminScroll.Size =
    UDim2.new(1, -10, 1, -57)

AdminScroll.BackgroundTransparency =
    1

AdminScroll.BorderSizePixel =
    0

AdminScroll.ScrollBarThickness =
    4

AdminScroll.CanvasSize =
    UDim2.new(
        0,
        0,
        0,
        MAX_ADMIN_PADS * 49
    )

AdminScroll.ScrollingDirection =
    Enum.ScrollingDirection.Y

AdminScroll.Parent =
    AdminPage

--============================================================
-- ADMIN ROWS
--============================================================

local AdminRows = {}

for i = 1, MAX_ADMIN_PADS do

    local Row =
        Instance.new("Frame")

    Row.Position =
        UDim2.fromOffset(
            4,
            (i - 1) * 49
        )

    Row.Size =
        UDim2.new(1, -8, 0, 43)

    Row.BackgroundColor3 =
        Color3.fromRGB(45, 45, 45)

    Row.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Row.BorderSizePixel =
        1

    Row.Parent =
        AdminScroll

    local Name =
        Instance.new("TextLabel")

    Name.Position =
        UDim2.fromOffset(6, 1)

    Name.Size =
        UDim2.fromOffset(65, 18)

    Name.BackgroundTransparency =
        1

    Name.Text =
        "Pad " .. i

    Name.TextColor3 =
        Color3.new(1, 1, 1)

    Name.Font =
        Enum.Font.SourceSansBold

    Name.TextSize =
        12

    Name.TextXAlignment =
        Enum.TextXAlignment.Left

    Name.Parent =
        Row

    local Status =
        Instance.new("TextLabel")

    Status.Position =
        UDim2.fromOffset(6, 20)

    Status.Size =
        UDim2.new(1, -100, 0, 17)

    Status.BackgroundTransparency =
        1

    Status.Text =
        "NOT FOUND"

    Status.TextColor3 =
        Color3.fromRGB(170, 170, 170)

    Status.Font =
        Enum.Font.SourceSans

    Status.TextSize =
        10

    Status.TextXAlignment =
        Enum.TextXAlignment.Left

    Status.Parent =
        Row

    local TP =
        Instance.new("TextButton")

    TP.Position =
        UDim2.new(1, -78, 0, 4)

    TP.Size =
        UDim2.fromOffset(34, 34)

    TP.BackgroundColor3 =
        Color3.fromRGB(70, 70, 70)

    TP.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    TP.Text =
        "TP"

    TP.TextColor3 =
        Color3.new(1, 1, 1)

    TP.Font =
        Enum.Font.SourceSansBold

    TP.TextSize =
        11

    TP.Parent =
        Row

    local Auto =
        Instance.new("TextButton")

    Auto.Position =
        UDim2.new(1, -40, 0, 4)

    Auto.Size =
        UDim2.fromOffset(34, 34)

    Auto.BackgroundColor3 =
        Color3.fromRGB(70, 70, 70)

    Auto.BorderColor3 =
        Color3.fromRGB(0, 0, 0)

    Auto.Text =
        "OFF"

    Auto.TextColor3 =
        Color3.new(1, 1, 1)

    Auto.Font =
        Enum.Font.SourceSansBold

    Auto.TextSize =
        10

    Auto.Parent =
        Row

    AdminRows[i] = {
        Row = Row,
        Name = Name,
        Status = Status,
        TP = TP,
        Auto = Auto,

        Part = nil,
        Giver = nil,

        AutoEnabled = false,
        LastTP = 0
    }
end

--============================================================
-- ADMIN GIVER SCANNER
--============================================================

local function GetAdminGivers()

    local Results = {}

    local WrenchObjs =
        workspace:FindFirstChild(
            "WrenchObjs"
        )

    if not WrenchObjs then
        return Results
    end

    for _, Object in ipairs(
        WrenchObjs:GetDescendants()
    ) do

        if HubClosed then
            return Results
        end

        if Object.Name:lower() ==
            "admingiver" then

            table.insert(
                Results,
                Object
            )
        end
    end

    return Results
end

local function RefreshAdminPads()

    if HubClosed then
        return
    end

    local Givers =
        GetAdminGivers()

    for i = 1, MAX_ADMIN_PADS do

        local Data =
            AdminRows[i]

        local Giver =
            Givers[i]

        Data.Giver =
            Giver

        Data.Part =
            FindPart(Giver)

        if Giver and Data.Part then

            Data.Status.Text =
                "FOUND"

        elseif Giver then

            Data.Status.Text =
                "NO PART"

        else

            Data.Status.Text =
                "NOT FOUND"
        end
    end

    AdminInfo.Text =
        "FOUND " ..
        math.min(
            #Givers,
            MAX_ADMIN_PADS
        ) ..
        "/" ..
        MAX_ADMIN_PADS
end

--============================================================
-- ADMIN BUTTONS
--============================================================

for i = 1, MAX_ADMIN_PADS do

    local Data =
        AdminRows[i]

    AddConnection(Data.TP.MouseButton1Click:Connect(
        function()

            if HubClosed then
                return
            end

            if Data.Part then

                if TeleportToPart(
                    Data.Part
                ) then

                    Data.Status.Text =
                        "TELEPORTED"
                end

            else

                Data.Status.Text =
                    "NOT FOUND"
            end
        end
    ))

    AddConnection(Data.Auto.MouseButton1Click:Connect(
        function()

            if HubClosed then
                return
            end

            Data.AutoEnabled =
                not Data.AutoEnabled

            if Data.AutoEnabled then

                Data.Auto.Text =
                    "ON"

            else

                Data.Auto.Text =
                    "OFF"
            end
        end
    ))
end

--============================================================
-- HD WHITELISTER
--============================================================

local HDTitle =
    Instance.new("TextLabel")

HDTitle.Position =
    UDim2.fromOffset(8, 7)

HDTitle.Size =
    UDim2.new(1, -16, 0, 22)

HDTitle.BackgroundTransparency =
    1

HDTitle.Text =
    "HD Whitelister"

HDTitle.TextColor3 =
    Color3.new(1, 1, 1)

HDTitle.Font =
    Enum.Font.SourceSansBold

HDTitle.TextSize =
    17

HDTitle.TextXAlignment =
    Enum.TextXAlignment.Left

HDTitle.Parent =
    HDPage

local PrefixLabel =
    Instance.new("TextLabel")

PrefixLabel.Position =
    UDim2.fromOffset(8, 40)

PrefixLabel.Size =
    UDim2.fromOffset(48, 22)

PrefixLabel.BackgroundTransparency =
    1

PrefixLabel.Text =
    "Prefix:"

PrefixLabel.TextColor3 =
    Color3.new(1, 1, 1)

PrefixLabel.Font =
    Enum.Font.SourceSans

PrefixLabel.TextSize =
    12

PrefixLabel.TextXAlignment =
    Enum.TextXAlignment.Left

PrefixLabel.Parent =
    HDPage

local Prefix =
    Instance.new("TextBox")

Prefix.Position =
    UDim2.fromOffset(60, 39)

Prefix.Size =
    UDim2.new(1, -68, 0, 23)

Prefix.BackgroundColor3 =
    Color3.fromRGB(25, 25, 25)

Prefix.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

Prefix.TextColor3 =
    Color3.new(1, 1, 1)

Prefix.Text =
    ";"

Prefix.Font =
    Enum.Font.SourceSans

Prefix.TextSize =
    12

Prefix.ClearTextOnFocus =
    false

Prefix.Parent =
    HDPage

local GearLabel =
    Instance.new("TextLabel")

GearLabel.Position =
    UDim2.fromOffset(8, 70)

GearLabel.Size =
    UDim2.fromOffset(48, 22)

GearLabel.BackgroundTransparency =
    1

GearLabel.Text =
    "Gear ID:"

GearLabel.TextColor3 =
    Color3.new(1, 1, 1)

GearLabel.Font =
    Enum.Font.SourceSans

GearLabel.TextSize =
    12

GearLabel.TextXAlignment =
    Enum.TextXAlignment.Left

GearLabel.Parent =
    HDPage

local GearID =
    Instance.new("TextBox")

GearID.Position =
    UDim2.fromOffset(60, 69)

GearID.Size =
    UDim2.new(1, -68, 0, 23)

GearID.BackgroundColor3 =
    Color3.fromRGB(25, 25, 25)

GearID.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

GearID.TextColor3 =
    Color3.new(1, 1, 1)

GearID.PlaceholderText =
    "Gear ID"

GearID.Text =
    ""

GearID.Font =
    Enum.Font.SourceSans

GearID.TextSize =
    12

GearID.ClearTextOnFocus =
    false

GearID.Parent =
    HDPage

local MakeButton =
    Instance.new("TextButton")

MakeButton.Position =
    UDim2.fromOffset(8, 100)

MakeButton.Size =
    UDim2.new(1, -16, 0, 34)

MakeButton.BackgroundColor3 =
    Color3.fromRGB(70, 70, 70)

MakeButton.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

MakeButton.Text =
    "MAKE GEAR"

MakeButton.TextColor3 =
    Color3.new(1, 1, 1)

MakeButton.Font =
    Enum.Font.SourceSansBold

MakeButton.TextSize =
    13

MakeButton.Parent =
    HDPage

local Processing =
    Instance.new("TextLabel")

Processing.Position =
    UDim2.fromOffset(8, 142)

Processing.Size =
    UDim2.new(1, -16, 0, 34)

Processing.BackgroundColor3 =
    Color3.fromRGB(20, 20, 20)

Processing.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

Processing.Text =
    ""

Processing.TextColor3 =
    Color3.fromRGB(190, 190, 190)

Processing.Font =
    Enum.Font.SourceSans

Processing.TextSize =
    11

Processing.Parent =
    HDPage

AddConnection(MakeButton.MouseButton1Click:Connect(
    function()

        if HubClosed then
            return
        end

        local PrefixText =
            Prefix.Text

        local ID =
            GearID.Text

        if PrefixText == ""
        or ID == "" then

            Processing.Text =
                "Enter a prefix and gear ID."

            return
        end

        if not RequestCommand then

            Processing.Text =
                "RequestCommand not found."

            return
        end

        Processing.Text =
            "Applying..."

        local Command =
            PrefixText ..
            "gear me " ..
            ID ..
            ".1"

        local Success =
            pcall(function()

                RequestCommand:InvokeServer(
                    Command
                )

            end)

        if Success then

            Processing.Text =
                "Command sent."

        else

            Processing.Text =
                "Command failed."
        end
    end
))

--============================================================
-- CLIENT CONTROLS
--============================================================

local ClientTitle =
    Instance.new("TextLabel")

ClientTitle.Position =
    UDim2.fromOffset(8, 7)

ClientTitle.Size =
    UDim2.new(1, -16, 0, 22)

ClientTitle.BackgroundTransparency =
    1

ClientTitle.Text =
    "Client Controls"

ClientTitle.TextColor3 =
    Color3.new(1, 1, 1)

ClientTitle.Font =
    Enum.Font.SourceSansBold

ClientTitle.TextSize =
    17

ClientTitle.TextXAlignment =
    Enum.TextXAlignment.Left

ClientTitle.Parent =
    ClientPage

local ClientStatus =
    Instance.new("TextLabel")

ClientStatus.Position =
    UDim2.fromOffset(8, 34)

ClientStatus.Size =
    UDim2.new(1, -16, 0, 25)

ClientStatus.BackgroundColor3 =
    Color3.fromRGB(20, 20, 20)

ClientStatus.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

ClientStatus.Text =
    "Client controls ready."

ClientStatus.TextColor3 =
    Color3.fromRGB(190, 190, 190)

ClientStatus.Font =
    Enum.Font.SourceSans

ClientStatus.TextSize =
    11

ClientStatus.Parent =
    ClientPage

local MeshButton =
    Instance.new("TextButton")

MeshButton.Position =
    UDim2.fromOffset(8, 68)

MeshButton.Size =
    UDim2.new(1, -16, 0, 37)

MeshButton.BackgroundColor3 =
    Color3.fromRGB(65, 65, 65)

MeshButton.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

MeshButton.Text =
    "Mesh Hider: OFF"

MeshButton.TextColor3 =
    Color3.new(1, 1, 1)

MeshButton.Font =
    Enum.Font.SourceSansBold

MeshButton.TextSize =
    12

MeshButton.Parent =
    ClientPage

local PauseButton =
    Instance.new("TextButton")

PauseButton.Position =
    UDim2.fromOffset(8, 112)

PauseButton.Size =
    UDim2.new(1, -16, 0, 37)

PauseButton.BackgroundColor3 =
    Color3.fromRGB(65, 65, 65)

PauseButton.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

PauseButton.Text =
    "Anti-Pause: OFF"

PauseButton.TextColor3 =
    Color3.new(1, 1, 1)

PauseButton.Font =
    Enum.Font.SourceSansBold

PauseButton.TextSize =
    12

PauseButton.Parent =
    ClientPage

local CButton =
    Instance.new("TextButton")

CButton.Position =
    UDim2.fromOffset(8, 156)

CButton.Size =
    UDim2.new(1, -16, 0, 37)

CButton.BackgroundColor3 =
    Color3.fromRGB(65, 65, 65)

CButton.BorderColor3 =
    Color3.fromRGB(0, 0, 0)

CButton.Text =
    "Wrench C Mover: OFF"

CButton.TextColor3 =
    Color3.new(1, 1, 1)

CButton.Font =
    Enum.Font.SourceSansBold

CButton.TextSize =
    12

CButton.Parent =
    ClientPage

--============================================================
-- CLIENT SYSTEM
--============================================================

local MeshEnabled = false
local PauseEnabled = false
local CEnabled = false

local originalTransparency = {}
local trackedC = {}
local originalCFrames = {}

local pauseConnection
local cFolderConnection
local meshWatcherConnection

local function IsMeshObject(Object)

    return Object:IsA("MeshPart")
        or Object:IsA("SpecialMesh")
end

local function HideMesh(Object)

    if HubClosed then
        return
    end

    if Object:IsA("MeshPart") then

        if originalTransparency[Object] == nil then

            originalTransparency[Object] =
                Object.LocalTransparencyModifier
        end

        Object.LocalTransparencyModifier =
            1

    elseif Object:IsA("SpecialMesh") then

        local Parent =
            Object.Parent

        if Parent
        and Parent:IsA("BasePart") then

            if originalTransparency[Parent] == nil then

                originalTransparency[Parent] =
                    Parent.LocalTransparencyModifier
            end

            Parent.LocalTransparencyModifier =
                1
        end
    end
end

local function RestoreMeshes()

    for Object, Transparency in
        pairs(originalTransparency) do

        if Object
        and Object.Parent then

            pcall(function()

                Object.LocalTransparencyModifier =
                    Transparency

            end)
        end
    end

    table.clear(originalTransparency)
end

local function SetMeshEnabled(Value)

    if HubClosed then
        return
    end

    MeshEnabled =
        Value

    if MeshEnabled then

        for _, Object in ipairs(
            workspace:GetDescendants()
        ) do

            if IsMeshObject(Object) then
                HideMesh(Object)
            end
        end

        ClientStatus.Text =
            "Mesh Hider enabled."

    else

        RestoreMeshes()

        ClientStatus.Text =
            "Mesh Hider disabled."
    end

    MeshButton.Text =
        "Mesh Hider: " ..
        (
            MeshEnabled
            and "ON"
            or "OFF"
        )
end

local function SetPauseEnabled(Value)

    if HubClosed then
        return
    end

    PauseEnabled =
        Value

    if pauseConnection then

        pauseConnection:Disconnect()
        pauseConnection = nil
    end

    if PauseEnabled then

        pcall(function()
            LocalPlayer.GameplayPaused = false
        end)

        pauseConnection =
            LocalPlayer:GetPropertyChangedSignal(
                "GameplayPaused"
            ):Connect(function()

                if HubClosed then
                    return
                end

                pcall(function()
                    LocalPlayer.GameplayPaused = false
                end)

            end)

        ClientStatus.Text =
            "Anti-Pause enabled."

    else

        ClientStatus.Text =
            "Anti-Pause disabled."
    end

    PauseButton.Text =
        "Anti-Pause: " ..
        (
            PauseEnabled
            and "ON"
            or "OFF"
        )
end

local function TrackC(Object)

    if HubClosed then
        return
    end

    if not Object:IsA("BasePart") then
        return
    end

    if Object.Name:lower() ~= "c" then
        return
    end

    if not originalCFrames[Object] then

        originalCFrames[Object] =
            Object.CFrame
    end

    trackedC[Object] =
        true
end

local function ScanC()

    if HubClosed then
        return
    end

    local Folder =
        workspace:FindFirstChild(
            "WrenchObjs"
        )

    if not Folder then
        return
    end

    for _, Object in ipairs(
        Folder:GetDescendants()
    ) do

        if Object:IsA("BasePart")
        and Object.Name:lower() == "c" then

            TrackC(Object)

            if CEnabled
            and originalCFrames[Object] then

                pcall(function()

                    Object.CFrame =
                        originalCFrames[Object]
                        + Vector3.new(
                            0,
                            -999,
                            0
                        )

                end)
            end
        end
    end
end

local function RestoreC()

    for Object in pairs(trackedC) do

        if Object
        and Object.Parent
        and originalCFrames[Object] then

            pcall(function()

                Object.CFrame =
                    originalCFrames[Object]

            end)
        end
    end

    table.clear(trackedC)
    table.clear(originalCFrames)
end

local function SetCEnabled(Value)

    if HubClosed then
        return
    end

    CEnabled =
        Value

    if cFolderConnection then

        cFolderConnection:Disconnect()
        cFolderConnection = nil
    end

    if CEnabled then

        ScanC()

        local Folder =
            workspace:FindFirstChild(
                "WrenchObjs"
            )

        if Folder then

            cFolderConnection =
                Folder.DescendantAdded:Connect(
                    function(Object)

                        if HubClosed then
                            return
                        end

                        task.wait()

                        if HubClosed then
                            return
                        end

                        if Object:IsA("BasePart")
                        and Object.Name:lower() == "c" then

                            TrackC(Object)

                            if CEnabled
                            and originalCFrames[Object] then

                                pcall(function()

                                    Object.CFrame =
                                        originalCFrames[Object]
                                        + Vector3.new(
                                            0,
                                            -999,
                                            0
                                        )

                                end)
                            end
                        end
                    end
                )
        end

        ClientStatus.Text =
            "Wrench C Mover enabled."

    else

        RestoreC()

        ClientStatus.Text =
            "Wrench C Mover disabled."
    end

    CButton.Text =
        "Wrench C Mover: " ..
        (
            CEnabled
            and "ON"
            or "OFF"
        )
end

--============================================================
-- CLIENT BUTTONS
--============================================================

AddConnection(MeshButton.MouseButton1Click:Connect(
    function()

        SetMeshEnabled(
            not MeshEnabled
        )

    end
))

AddConnection(PauseButton.MouseButton1Click:Connect(
    function()

        SetPauseEnabled(
            not PauseEnabled
        )

    end
))

AddConnection(CButton.MouseButton1Click:Connect(
    function()

        SetCEnabled(
            not CEnabled
        )

    end
))

--============================================================
-- MESH WATCHER
--============================================================

meshWatcherConnection =
    workspace.DescendantAdded:Connect(
        function(Object)

            if HubClosed then
                return
            end

            if MeshEnabled
            and IsMeshObject(Object) then

                task.wait()

                if HubClosed then
                    return
                end

                HideMesh(Object)
            end
        end
    )

AddConnection(meshWatcherConnection)

--============================================================
-- CLOSE / COMPLETE SHUTDOWN
--============================================================

local function ShutdownHub()

    if HubClosed then
        return
    end

    HubClosed =
        true

    -- STOP TOOL AUTO TP
    WrenchRow.AutoEnabled = false
    BuildingRow.AutoEnabled = false
    ForkRow.AutoEnabled = false
    BucketRow.AutoEnabled = false

    WrenchRow.Auto.Text = "AUTO OFF"
    BuildingRow.Auto.Text = "AUTO OFF"
    ForkRow.Auto.Text = "AUTO OFF"
    BucketRow.Auto.Text = "AUTO OFF"

    -- STOP ADMIN AUTO TP
    for i = 1, MAX_ADMIN_PADS do

        local Data =
            AdminRows[i]

        Data.AutoEnabled =
            false

        Data.Auto.Text =
            "OFF"
    end

    -- STOP CLIENT SYSTEMS
    MeshEnabled = false
    PauseEnabled = false
    CEnabled = false

    -- DISCONNECT SPECIAL CONNECTIONS
    if pauseConnection then
        pcall(function()
            pauseConnection:Disconnect()
        end)
        pauseConnection = nil
    end

    if cFolderConnection then
        pcall(function()
            cFolderConnection:Disconnect()
        end)
        cFolderConnection = nil
    end

    if meshWatcherConnection then
        pcall(function()
            meshWatcherConnection:Disconnect()
        end)
        meshWatcherConnection = nil
    end

    -- RESTORE MESHES
    RestoreMeshes()

    -- RESTORE C PARTS
    RestoreC()

    -- DISCONNECT EVERYTHING
    DisconnectAll()

    -- DESTROY GUI
    if ScreenGui then
        pcall(function()
            ScreenGui:Destroy()
        end)
    end
end

AddConnection(Close.MouseButton1Click:Connect(
    function()
        ShutdownHub()
    end
))

--============================================================
-- MAIN LOOP
--============================================================

local LastAdminRefresh = 0
local LastToolRefresh = 0

AddConnection(
    RunService.Heartbeat:Connect(
        function()

            if HubClosed then
                return
            end

            local Now =
                os.clock()

            --================================================
            -- ADMIN REFRESH
            --================================================

            if Now - LastAdminRefresh >= 0.5 then

                LastAdminRefresh =
                    Now

                RefreshAdminPads()
            end

            --================================================
            -- TOOL AVAILABILITY
            --================================================

            if Now - LastToolRefresh >= 1 then

                LastToolRefresh =
                    Now

                UpdateToolAvailability()
            end

            --================================================
            -- TOOL AUTO-TP
            --================================================

            local ToolAutoRows = {
                {
                    Data = WrenchRow,
                    Name = WRENCH_NAME,
                    Label = "Super Cool Wrench"
                },
                {
                    Data = BuildingRow,
                    Name = BUILDING_NAME,
                    Label = "Building Tools"
                },
                {
                    Data = ForkRow,
                    Name = FORK3X_NAME,
                    Label = "Fork3X"
                }
            }

            for _, Info in ipairs(ToolAutoRows) do

                local Data =
                    Info.Data

                if Data.AutoEnabled
                and Now - Data.LastTP >= 0.35 then

                    Data.LastTP =
                        Now

                    local Tool =
                        GetTool(Info.Name)

                    if Tool then

                        TeleportToolToPlayer(
                            Tool,
                            Info.Label
                        )
                    end
                end
            end

            --================================================
            -- BLUE BUCKET AUTO
            --================================================

            if BucketRow.AutoEnabled
            and Now - BucketRow.LastTP >= 1 then

                BucketRow.LastTP =
                    Now

                local Bucket =
                    GetTool("Blue Bucket")

                if Bucket then

                    TeleportToolToPlayer(
                        Bucket,
                        "Blue Bucket"
                    )
                end
            end

            --================================================
            -- ADMIN AUTO TP
            --================================================

            for i = 1, MAX_ADMIN_PADS do

                local Data =
                    AdminRows[i]

                if Data.AutoEnabled
                and Data.Part
                and Now - Data.LastTP >= 1 then

                    Data.LastTP =
                        Now

                    TeleportToPart(
                        Data.Part
                    )
                end
            end

            --================================================
            -- MESH SELF HEAL
            --================================================

            if MeshEnabled then

                for _, Object in ipairs(
                    workspace:GetDescendants()
                ) do

                    if HubClosed then
                        return
                    end

                    if IsMeshObject(Object) then
                        HideMesh(Object)
                    end
                end
            end

            --================================================
            -- C SELF HEAL
            --================================================

            if CEnabled then
                ScanC()
            end

            --================================================
            -- ANTI PAUSE
            --================================================

            if PauseEnabled then

                pcall(function()

                    LocalPlayer.GameplayPaused =
                        false

                end)
            end
        end
    )
)

--============================================================
-- START
--============================================================

ShowPage(
    ToolsPage
)

RefreshAdminPads()

UpdateToolAvailability()

-- Start OFF without running unnecessary systems
MeshEnabled = false
PauseEnabled = false
CEnabled = false

MeshButton.Text =
    "Mesh Hider: OFF"

PauseButton.Text =
    "Anti-Pause: OFF"

CButton.Text =
    "Wrench C Mover: OFF"

WrenchRow.Auto.Text =
    "AUTO OFF"

BuildingRow.Auto.Text =
    "AUTO OFF"

ForkRow.Auto.Text =
    "AUTO OFF"

BucketRow.Auto.Text =
    "AUTO OFF"

for i = 1, MAX_ADMIN_PADS do
    AdminRows[i].Auto.Text =
        "OFF"
end
