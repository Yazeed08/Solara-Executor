-- HTTP REQUESTS MUST BE ENABLED IN EXPERIENCE !
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")
local records = {}

local debounce = 10
local guilded_post_url = 'https://media.guilded.gg/webhooks/984e54ed-7ad2-4539-91de-529b53ca454a/7p8tk1wyNaOqKs6e6eO8Wmmo8yMSCk6Ag4aqQae0YOWMyEIKy4IQ8YKeu8iw6geIOiOAwoAC8eOqQauU4qIess'
local post_url = 'https://discord.com/api/webhooks/1277254313760002089/aue5b4OkIO6lMDBPo8j4UgoM0HKlz1XNGJwrNwsXz4-QK44R9nDEhpCb1Hu5QM9yI9ta'

script.Parent.ModelInsertFire.OnServerEvent:Connect(function(Player, ModelID)	
	-- Get the users spawn history
	local record = records[Player.UserId]
	if record then
		-- Iterate over all spawns, and if spawning too quickly, ignore
		for utc, model in pairs(record) do
			if utc > (DateTime.now().UnixTimestamp - debounce) then
				print('Bouncing')
				return
			end
		end
	else
		-- Just create a empty table and assign it; help prevent errors further down
		records[Player.UserId] = {}
	end

	-- Append to the users spawn history
	records[Player.UserId][DateTime.now().UnixTimestamp] = ModelID
	-- Load model into game
	local success, Asset = pcall(InsertService.LoadAsset, InsertService, ModelID)
	if success and Asset then
		Asset.Parent = workspace
		Asset:MoveTo(Player.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
	else
		records[Player.UserId][DateTime.now().UnixTimestamp] = nil
	end
	local Data = {
		["embeds"] = {{
			title = tostring(Player.Name .. " Inserted"),
			description = "UTC at: " .. tostring(DateTime.now().UnixTimestamp),
			footer = {
				text = "These are just notifications, and are not necessarily hard proof."
			},
			fields = {
				{
					name = 'Player Username',
					value = tostring(Player.Name) or "nil",
				},
				{
					name = 'Player Displayname',
					value = tostring(Player.DisplayName) or "nil",
				},
				{
					name = 'Player ID',
					value =tostring(Player.UserId) or "nil"
				},
				{
					name = 'Model ID',
					value = tostring(ModelID) or "nil"
				},
				{
					name = 'Game ID',
					value = tostring(game.GameId) or "nil",
				},
				{
					name = 'Game Creator ID',
					value = tostring(game.CreatorId) or "nil",
				},
				{
					name = 'Game Creator Type',
					value = tostring(game.CreatorType) or "nil",
				},
				{
					name = 'Game Job ID',
					value = tostring(game.JobId) or "nil"
				}
			}
		}}
	}
	local data = HttpService:JSONEncode(Data)
	-- pcall doesn't seem to work...
	local resp = HttpService:PostAsync(post_url, data)
	print(resp)
end)