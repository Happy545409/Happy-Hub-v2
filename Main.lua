--// =======================================================
--// HAPPY HUB V11 - MÉTODO VBL (FOCUS: TOKENS & SPINS)
--// =======================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Limpeza de UI antiga
if CoreGui:FindFirstChild("HappyHubV11") then CoreGui.HappyHubV11:Destroy() end

local currentSpeed = 18 -- Velocidade padrão do VBL conforme sua print
local flyActive = false

--// INTERFACE
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "HappyHubV11"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 320)
main.Position = UDim2.new(0.5, -140, 0.5, -160)
main.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Arrastar no Mobile
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function createBtn(txt, pos, clr)
    local b = Instance.new("TextButton", main)
    b.Text = txt; b.Size = UDim2.new(0, 240, 0, 50); b.Position = UDim2.new(0.5, -120, 0, pos)
    b.BackgroundColor3 = clr or Color3.fromRGB(245, 245, 245); b.Font = Enum.Font.GothamBold; b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local title = Instance.new("TextLabel", main)
title.Text = "VBL METHOD - HUB"; title.Size = UDim2.new(1, 0, 0, 60); title.Font = Enum.Font.GothamBold; title.TextSize = 20; title.BackgroundTransparency = 1

--// BOTÕES DE AÇÃO
local speedBtn = createBtn("👟 Speed (VBL: 18)", 80)
local farmBtn = createBtn("💎 Farm Tokens (Loop)", 140)
local flyBtn = createBtn("🪁 Modo Voo / Spectate", 200)

--// LÓGICA DE VELOCIDADE (FORCE LOOP)
-- Garante que o jogo não force sua velocidade de volta para 18 se você quiser correr mais
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = currentSpeed
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    if currentSpeed == 18 then
        currentSpeed = 30 -- Velocidade segura para farm sem kick
    else
        currentSpeed = 18
    end
    speedBtn.Text = "👟 Speed (VBL: " .. currentSpeed .. ")"
end)

--// VOO (FLY)
flyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    flyBtn.BackgroundColor3 = flyActive and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(245, 245, 245)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if flyActive and hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "VBL_Fly"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while flyActive do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- Créditos
local c = Instance.new("TextLabel", main)
c.Text = "Happy & Gb"; c.Size = UDim2.new(1, 0, 0, 30); c.Position = UDim2.new(0, 0, 1, -40); c.BackgroundTransparency = 1
task.spawn(function() while task.wait(0.1) do c.TextColor3 = Color3.fromHSV(tick()%5/5, 0.8, 1) end end)
