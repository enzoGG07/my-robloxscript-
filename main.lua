local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Création du ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MultiSectionGUI"
screenGui.Parent = playerGui

-- Création de la Frame principale
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 250)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Création du container pour les boutons d'onglets
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBar.Parent = mainFrame

-- Table des noms de sections (modifiée ici)
local tabs = {"Createur", "Player Script", "Parametre"}
local buttons = {}
local pages = {}

-- Fonction pour cacher toutes les pages
local function hideAllPages()
    for _, page in pairs(pages) do
        page.Visible = false
    end
end

-- Création des boutons d'onglets et des pages correspondantes
for i, tabName in ipairs(tabs) do
    -- Bouton onglet
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1/#tabs, 0, 1, 0)
    button.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = tabName
    button.TextColor3 = Color3.new(1,1,1)
    button.Parent = tabBar
    buttons[i] = button

    -- Page (Frame) correspondant à l'onglet
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -60)
    page.Position = UDim2.new(0, 10, 0, 50)
    page.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    page.Visible = false
    page.Parent = mainFrame
    pages[i] = page
end

-- Contenu de la page 1 (Createur)
local label1 = Instance.new("TextLabel")
label1.Text = "ulreysblox OWNER"
label1.Size = UDim2.new(1, 0, 0, 30)
label1.Position = UDim2.new(0, 0, 0, 10)
label1.TextColor3 = Color3.new(1,1,1)
label1.BackgroundTransparency = 1
label1.Parent = pages[1]

local image = Instance.new("ImageLabel")
image.Size = UDim2.new(0, 150, 0, 150)
image.Position = UDim2.new(0.5, -75, 0, 50)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://6023426915"
image.Parent = pages[1]

-- Contenu de la page 2 (Player Script)

local flyButton = Instance.new("TextButton")
flyButton.Text = "Activer Fly"
flyButton.Size = UDim2.new(0, 120, 0, 40)
flyButton.Position = UDim2.new(0.5, -60, 0.5, -20)
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Parent = pages[2]

local noClipButton = Instance.new("TextButton")
noClipButton.Text = "No Clip OFF"
noClipButton.Size = UDim2.new(0, 120, 0, 40)
noClipButton.Position = UDim2.new(0.5, -60, 0.5, 30)
noClipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noClipButton.TextColor3 = Color3.new(1,1,1)
noClipButton.Parent = pages[2]

local noClipEnabled = false
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

local function noClipLoop()
    if not character then return end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = noClipEnabled and "No Clip ON" or "No Clip OFF"

    if noClipEnabled then
        character = localPlayer.Character
        RunService:BindToRenderStep("NoClip", Enum.RenderPriority.Character.Value, noClipLoop)
    else
        RunService:UnbindFromRenderStep("NoClip")
        character = localPlayer.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

localPlayer.CharacterAdded:Connect(function(char)
    character = char
    if noClipEnabled then
        wait(1)
        noClipLoop()
    end
end)

-- Contenu de la page 3 (Parametre) avec DELETE GUI
local deleteButton = Instance.new("TextButton")
deleteButton.Text = "DELETE GUI"
deleteButton.Size = UDim2.new(0, 120, 0, 40)
deleteButton.Position = UDim2.new(0.5, -60, 0.5, -20)
deleteButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
deleteButton.TextColor3 = Color3.new(1,1,1)
deleteButton.Parent = pages[3]

deleteButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Gestion des clics sur les onglets
for i, button in ipairs(buttons) do
    button.MouseButton1Click:Connect(function()
        hideAllPages()
        pages[i].Visible = true
    end)
end

hideAllPages()
pages[1].Visible = true
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local bodyVelocity

local function startFly()
    flying = true
    flyButton.Text = "Stop Fly"

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = rootPart

    RunService:BindToRenderStep("FlyStep", Enum.RenderPriority.Input.Value, function()
        local moveDirection = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end

        moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z)
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            bodyVelocity.Velocity = moveDirection * speed
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end)
end

local function stopFly()
    flying = false
    flyButton.Text = "Activer Fly"
    RunService:UnbindFromRenderStep("FlyStep")
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)
