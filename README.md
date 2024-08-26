# Hot slot inserter
 This is a Roblox script which allows users to insert their own slots using a GUI. \
 Shoutout to `outrun917` and `sjark` for the original GUI, scripts, and idea.

[![Static Badge](https://img.shields.io/badge/download_rbxm-here?style=for-the-badge&color=blue)](https://github.com/Hypurrnating/Roblox-slot-inserter/raw/main/SlotInserter.rbxm) \
If you wish to suggest improvements to the code, you can create a pull request and edit the .lua scripts in /src

 The script creates a record of what models were insert by who and when in a lua table. It then uses that data to set a cool-down (or debounce) on each player. \
 The script also logs the insert to a discord webhook, although you should also specify a guilded webhook as fallback (will be introduced later).

 > [!IMPORTANT]
 > Although the script does help enhance security, it is not an alternative for manually checking the slots that are inserted.
 
 I do aim to introduce better security features in the future, but as the warning above says, you have to be aware of what you are allowing into the game.

 ## How to install this to my game?

 ### 1: Download the file
 Download the RBXM file using the blue button above, and drop it into the game.

 ### 2: Move the objects to where they belong
 Open the explorer tab. \
 The Model Inserter itself is a screen GUI, move it to the `StarterGUI` folder in the Explorer tab. \
 After that expand the model inserter, you will find two folders: \
 One folder is called `sendToServerScriptService` and the other is called `sendToReplicatedStorage`. Now move the contents of those folders to where they belong.

 ### 3: Setup webhooks
 Now you need to open the `RemoteEventScript` file, which you should have already moved to the ServerScriptService.
 When you open the file, you will notice a table called `post_urls`. Just add your webhook urls to the table.

 It's important that you do this whenever you have to update the inserter.

 ## Can I change the GUI?
 Yeah just swap it out for anything. As long as the `LocalScript` in the GUI is firing to the correct remote event, with the correct data, it doesn't matter what the GUI looks like.

 ## How to access the records/logs of everyone who inserted using the GUI?
 There is a BindableEvent in the ServerScriptService called `CallRecords`. \
 The script is connected to this event, and will return a readonly clone of the records when something fires to this event. When you fire to `CallRecord`, make sure to pass the `BindableEvent` you want the script to fire the data to.

  So the flow looks a little like this: \
  `Your script` --fires--> `CallRecords` --connects--> `inserter script` --fires--> `the bindable event you specified *with the data in payload*`

  Heres a sample:
  ```lua
    local ServerScriptService = game:GetService("ServerScriptService")
    local CallRecords = ServerScriptService:WaitForChild("CallRecords")
    local aCustomEvent = ServerScriptService:WaitForChild("Your Event Name")
    
    aCustomEvent.Event:Connect(function(records: table)
        "... do what you want. Go crazy"
    end)

    CallRecords:Fire(aCustomEvent)
  ```

 The payload is a table with this structure:

  ```lua
{
    ["User ID"] = {
        ["UTC Timestamp"] = "Model ID"
    }
}
  ```

  The inserter script also fires `NewInsert` event (once again, in ServerScriptService) every time a model is inserted. Kinda like a webhook.
  
  ```lua
    local ServerScriptService = game:GetService("ServerScriptService")
    local NewInsert = ServerScriptService:WaitForChild("NewInsert")

    NewInsert.Event:Connect(function(payload)
        "... do what you want. Go crazy."
    end)
  ```

  The payload is a table with this structure:

  ```lua
    {
        ['Asset'] = (Asset that was inserted by InsertService),
        ['Product'] = (ProductInfo from MarketplaceService),
        ['Player'] = (The player who inserted),
        ['utc'] = (UTC timestamp of when they inserted, kinda useless),
    }
  ```

  - ProductInfo dictionary: https://create.roblox.com/docs/reference/engine/classes/MarketplaceService#GetProductInfo
  You might not always receive `Product` info in the `NewInsert` event.
 
 Both these events are `BindableEvents`, so that means they will only work on server scripts. You can wrap around them if you wish to do something on local scripts.