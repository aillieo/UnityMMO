require "Game.Common.UIManager"
require "Game.Common.UIWidgetPool"
require "Common.UI.UIComponent"
require("Common.UI.ItemListCreator")
require("Game.Common.Message")

--管理器--
local Game = {}
local Ctrls = {}

function LuaMain()
    print("logic start")     
    UpdateManager:GetInstance():Startup()
    Game:OnInitOK()
end

--初始化完成
function Game:OnInitOK()
    print('Cat:Game.lua[Game.OnInitOK()]')
    Game:InitUI()
    Game:InitControllers()
end

function Game.InitUI()
    local msg_panel = GameObject.Find("UICanvas/Dynamic/MessagePanel")
    assert(msg_panel, "cannot fine message panel!")
    Message:Init(msg_panel.transform)

    UIMgr:Init({"UICanvas/Normal","UICanvas/MainUI", "UICanvas/Dynamic"}, "Normal")
    
    local pre_load_prefab = {
        "Assets/AssetBundleRes/ui/common/Background.prefab",
        "Assets/AssetBundleRes/ui/common/GoodsItem.prefab",
    }
    UIWidgetPool:Init("UICanvas/HideUI")
    UIWidgetPool:RegisterWidgets(pre_load_prefab)
end

function Game:InitControllers()
    local ctrl_paths = {
        "Game/Test/TestController",
        "Game/Login/LoginController", 
        "Game/MainUI/MainUIController", 
        "Game/Task/TaskController", 
        "Game/Scene/SceneController", 
        "Game/Bag/BagController", 
        "Game/GM/GMController", 
    }
    for i,v in ipairs(ctrl_paths) do
        local ctrl = require(v)
        if type(ctrl) ~= "boolean" then
            --调用每个Controller的Init函数
            ctrl:Init()
            table.insert(Ctrls, ctrl)
        else
            --Controller类忘记了在最后return
            assert(false, 'Cat:Main.lua error : you must forgot write a return in you controller file :'..v)
        end
    end
end

--销毁--
function Game:OnDestroy()
end
