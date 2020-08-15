-- tools tab
setDefaultTab("Tools")

-- allows to test/edit bot lua scripts ingame, you can have multiple scripts like this, just change storage.ingame_lua
UI.Button("Ingame macro editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros or "", {title="Macro editor", description="You can add your custom macros (or any other lua code) here"}, function(text)
    storage.ingame_macros = text
    reload()
  end)
end)
UI.Button("Ingame hotkey editor", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys or "", {title="Hotkeys editor", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
    storage.ingame_hotkeys = text
    reload()
  end)
end)

UI.Separator()

for _, scripts in ipairs({storage.ingame_macros, storage.ingame_hotkeys}) do
  if type(scripts) == "string" and scripts:len() > 3 then
    local status, result = pcall(function()
      assert(load(scripts, "ingame_editor"))()
    end)
    if not status then 
      error("Ingame edior error:\n" .. result)
    end
  end
end

UI.Separator()

UI.Button("Zoom In map [ctrl + =]", function() zoomIn() end)
UI.Button("Zoom Out map [ctrl + -]", function() zoomOut() end)

UI.Separator()

local moneyIds = {3031, 3035} -- gold coin, platinium coin
macro(1000, "Exchange money", function()
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(moneyIds) do
            if item:getId() == moneyId then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

macro(1000, "Stack items", function()
  local containers = g_game.getContainers()
  local toStack = {}
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 100 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            g_game.move(item, stackWith[1], math.min(stackWith[2], item:getCount()))
            return
          end
          toStack[item:getId()] = {container:getSlotPosition(i - 1), 100 - item:getCount()}
        end
      end
    end
  end
end)

macro(10000, "Anti Kick",  function()
  local dir = player:getDirection()
  turn((dir + 1) % 4)
  turn(dir)
end)

UI.Separator()
UI.Label("Drop items:")
if type(storage.dropItems) ~= "table" then
  storage.dropItems = {283, 284, 285}
end

local foodContainer = UI.Container(function(widget, items)
  storage.dropItems = items
end, true)
foodContainer:setHeight(35)
foodContainer:setItems(storage.dropItems)

macro(5000, "drop items", function()
  if not storage.dropItems[1] then return end
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  for _, container in pairs(g_game.getContainers()) do
    for __, item in ipairs(container:getItems()) do
      for i, dropItem in ipairs(storage.dropItems) do
        if item:getId() == dropItem.id then
          if item:isStackable() then
            return g_game.move(item, player:getPosition(), item:getCount())
          else
            return g_game.move(item, player:getPosition(), dropItem.count) -- count is also subtype
          end
        end
      end
    end
  end
end)

UI.Separator()

macro(100, "Utito tempo", function()
  if not hasPartyBuff() and player:getMana() >= 290 and not isInPz() then
    say("utito tempo")
  end
end)

macro(3000, "Exeta res", function()
  if player:getMana() >= 20 and not isInPz() then
    say("exeta res")
  end
end)

UI.Separator()

UI.Label("Auto Summon")

macro(10000, "Knight", function()
  say("utevo gran res eq")
end)

macro(10000, "Paladin", function()
  say("utevo gran res sac")
end)

macro(10000, "Sorcerer", function()
  say("utevo gran res ven")
end)

macro(10000, "Druid", function()
  say("utevo gran res dru")
end)

UI.Separator()

UI.Label("Imbuements")

macro(3000, "Full Knight", function()
  if NPC.isTrading() then return end
  local m = 1
  schedule(1000 * m, function() NPC.say("hi") end)
  m = m + 1
  schedule(1000 * m, function() NPC.say("trade") end)
  m = m + 1

  -- Life
  schedule(1000 * m, function() NPC.buy(9685, 50) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(9633, 30) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(9663, 10) end)
  m = m + 1

  -- Mana
  schedule(1000 * m, function() NPC.buy(11492, 50) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(20200, 50) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(22730, 10) end)
  m = m + 1

  -- Critical
  schedule(1000 * m, function() NPC.buy(11444, 20) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(10311, 25) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(22728, 5) end)
  m = m + 1

  -- Axe
  schedule(1000 * m, function() NPC.buy(10196, 20) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(11447, 25) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(21200, 20) end)
  m = m + 1

  -- Death Protection
  schedule(1000 * m, function() NPC.buy(11466, 50) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(22007, 40) end)
  m = m + 1
  schedule(1000 * m, function() NPC.buy(9660, 10) end)
  m = m + 1
end)

macro(3000, "Life Leech", function()
  if NPC.isTrading() then return end
  schedule(1000, function() NPC.say("hi") end)
  schedule(2000, function() NPC.say("trade") end)
  schedule(3000, function() NPC.buy(9685, 25) end)
  schedule(4000, function() NPC.buy(9633, 15) end)
  schedule(5000, function() NPC.buy(9663, 5) end)
end)

macro(3000, "Mana Leech", function()
  if NPC.isTrading() then return end
  schedule(1000, function() NPC.say("hi") end)
  schedule(2000, function() NPC.say("trade") end)
  schedule(3000, function() NPC.buy(11492, 25) end)
  schedule(4000, function() NPC.buy(20200, 25) end)
  schedule(5000, function() NPC.buy(22730, 5) end)
end)

macro(3000, "Critical", function()
  if NPC.isTrading() then return end
  schedule(1000, function() NPC.say("hi") end)
  schedule(2000, function() NPC.say("trade") end)
  schedule(3000, function() NPC.buy(11444, 20) end)
  schedule(4000, function() NPC.buy(10311, 25) end)
  schedule(5000, function() NPC.buy(22728, 5) end)
end)

macro(3000, "Distance", function()
  if NPC.isTrading() then return end
  schedule(1000, function() NPC.say("hi") end)
  schedule(2000, function() NPC.say("trade") end)
  schedule(3000, function() NPC.buy(11464, 25) end)
  schedule(4000, function() NPC.buy(18994, 20) end)
  schedule(5000, function() NPC.buy(10298, 10) end)
end)

macro(3000, "Axe", function()
  if NPC.isTrading() then return end
  schedule(1000, function() NPC.say("hi") end)
  schedule(2000, function() NPC.say("trade") end)
  schedule(3000, function() NPC.buy(10196, 20) end)
  schedule(4000, function() NPC.buy(11447, 25) end)
  schedule(5000, function() NPC.buy(21200, 20) end)
end)

macro(3000, "Magic Level", function()
  if NPC.isTrading() then return end
  schedule(1000, function() NPC.say("hi") end)
  schedule(2000, function() NPC.say("trade") end)
  schedule(3000, function() NPC.buy(9635, 25) end)
  schedule(4000, function() NPC.buy(11452, 15) end)
  schedule(5000, function() NPC.buy(10309, 15) end)
end)

UI.Separator()

UI.Label("Mana training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  if TargetBot and TargetBot.isActive() then return end -- pause when attacking
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
    say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)

UI.Separator()

macro(60000, "Send message on trade", function()
  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end
  if trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(trade, storage.autoTradeMessage)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "I'm using OTClientV8!", function(widget, text)    
  storage.autoTradeMessage = text
end)

UI.Separator()
