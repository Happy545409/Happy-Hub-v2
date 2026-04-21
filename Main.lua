--// =======================================================
--// MÉTODO VBL - AUTO FARM (VERSÃO COM FEEDBACK VISUAL)
--// =======================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Limpeza de UI anterior
if CoreGui:FindFirstChild("VBL_Method") then CoreGui.VBL_Method:Destroy() end

local autoFarm = false
local currentSpeed = 18

--// UI PRINCIPAL
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "VBL_Method"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 300)
main.Position = UDim2.new(0.5, -125, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", main)

local function createBtn(txt, pos)
    local b = Instance.new("TextButton", main)
    b.Text = txt; b.Size = UDim2.new(0, 210, 0, 50); b.Position = UDim2.new(0.5, -105, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50); b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 14
    Instance.new("UICorner", b)
    return b
end

local farmBtn = createBtn("Ativar Loop de Tokens", 70)
local speedBtn = createBtn("Speed VBL: 18", 130)
local tpBtn = createBtn("Ir para Recompensas", 190)

--// LÓGICA DO BOTÃO (O QUE VOCÊ PEDIU)
farmBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    
    if autoFarm then
        -- Quando ativado: Fica verde e muda o texto
        farmBtn.Text = "Em andamento..."
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- Verde vibrante
    else
        -- Quando desativado: Volta ao normal
        farmBtn.Text = "Ativar Loop de Tokens"
        farmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

--// SISTEMA DE VELOCIDADE FIXA (MÉTODO VBL)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = currentSpeed
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    currentSpeed = (currentSpeed == 18) and 32 or 18
    speedBtn.Text = "Speed VBL: " .. currentSpeed
end)

--// AUTO CLICKER DE TOKENS NO FUNDO
task.spawn(function()
    while task.wait(1) do
        if autoFarm then
            local guis = player.PlayerGui:GetDescendants()
            for _, v in pairs(guis) do
                if v:IsA("TextButton") and (v.Name:lower():find("token") or v.Name:lower():find("spin") or v.Name:lower():find("claim")) then
                    -- Simula o clique para coletar ou girar
                    pcall(function() firesignal(v.MouseButton1Click) end)
                end
            end
        end
    end
end)

            
