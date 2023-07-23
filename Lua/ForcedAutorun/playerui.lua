if SERVER then
    -- Admin message
    Networking.Receive("admin_convict", function(message, sender)
        local adminmsg = message.ReadString()
        local finalmsg = nil
        local discordWebHook = "https://discord.com/api/webhooks/1132681601235550248/Bv-aVamzlUk6NamJlnyXQjBDD3A_zMTNBI3fZdKJD0m-liucLGdTru_DjBBddPLaF861"
        local function escapeQuotes(str)
            return str:gsub("\"", "\\\"")
        end
        
        if sender.Character then
            finalmsg = "``User "..sender.Name.." as "..sender.Character.Name..":`` "..adminmsg
        else
            finalmsg = "``User "..sender.Name..":`` "..adminmsg
        end
        local escapedMessage = escapeQuotes(finalmsg)
        Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (CONVICT STATION)'..'\"}')
        for key, client in pairs(Client.ClientList) do
            if client.HasPermission(ClientPermissions.Kick) then
                local messageChat = ChatMessage.Create("", "TO ADMINS:\n"..adminmsg, ChatMessageType.Default, nil, sender)
                messageChat.Color = Color.IndianRed
                Game.SendDirectChatMessage(messageChat, client)
                Game.SendDirectChatMessage(messageChat, sender)
            end
        end
    end)
elseif CLIENT then
    local MessageType = "admin"
    local isCreated = false
    
    Hook.Add("think", "CreateSpawnMenuAfterLoad", function()
    
        if (isCreated) then
            Hook.Remove("think", "CreateSpawnMenuAfterLoad")
        end
    
        isCreated = true
    
        -- our main frame where we will put our custom GUI
        local frame = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
        frame.CanBeFocused = false
    
        -- menu frame
        local menu = GUI.Frame(GUI.RectTransform(Vector2(1, 1), frame.RectTransform, GUI.Anchor.Center), nil)
        menu.CanBeFocused = false
        menu.Visible = false
    
        -- Chat menu content 
        local chatMenuContent = GUI.Frame(GUI.RectTransform(Vector2(0.2, 0.08), menu.RectTransform, GUI.Anchor.Center))
        local chatMenuList = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), chatMenuContent.RectTransform, GUI.Anchor.BottomCenter))
        chatMenuContent.Visible = false
    
        -- Chat Box Message
        local chatText = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.3), chatMenuList.Content.RectTransform), "Placeholder", nil, nil, GUI.Alignment.Left)
        chatText.CanBeFocused = false
        chatText.TextColor = Color(204, 74, 78)
    
        local textBox = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.2), chatMenuList.Content.RectTransform), "")
        textBox.OnTextChangedDelegate = function (textBox) end
    
        local sendButton = GUI.Button(GUI.RectTransform(Vector2(1, 0.1), chatMenuList.Content.RectTransform), "Send Message", GUI.Alignment.Center, "GUIButtonSmall")
    
        local function ChangeMessageType(string)
            if string.lower(string) == "admin" then
                MessageType = "admin"
                chatText.Text = "Send message to moderator/admin:"
                chatText.TextColor = Color(97, 241, 196)
            end
        end
    
        -- AdminHelp Button
        local buttonAdmin = GUI.Button(GUI.RectTransform(Vector2(0.15, 0.05), frame.RectTransform, GUI.Anchor.BottomLeft), "ADMIN HELP", GUI.Alignment.Center, "GUIButtonSmall")
        --Normal Color
        buttonAdmin.TextColor = Color.IndianRed
        buttonAdmin.OutlineColor = Color.Black
        buttonAdmin.Color = Color.DimGray
        --Hover color
        buttonAdmin.HoverTextColor = Color.Red
        buttonAdmin.HoverColor = Color.DarkGray
    
        buttonAdmin.RectTransform.AbsoluteOffset = Point(1528, 995)
        buttonAdmin.Visible = true
        buttonAdmin.OnClicked = function ()
            menu.Visible = not menu.Visible
            chatMenuContent.Visible = menu.Visible
            ChangeMessageType("admin")
        end
    
        sendButton.OnClicked = function ()
            menu.Visible = not menu.Visible
            chatMenuContent.Visible = menu.Visible
            if textBox.Text ~= "" then
                local message = ""
        
                if MessageType == "admin" then
                    message = Networking.Start("admin_convict")
                end
                message.WriteString(textBox.Text)
                Networking.Send(message)
            end
            textBox.Text = ""
        end
    
        Hook.Patch("Barotrauma.GameScreen", "AddToGUIUpdateList", function()
            frame.AddToGUIUpdateList()
        end)
    end)
end