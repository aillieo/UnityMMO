BagConst = require("Game/Bag/BagConst")
BagModel = require("Game/Bag/BagModel")

BagController = {}

function BagController:Init(  )
	self.model = BagModel:GetInstance()
	self:AddEvents()
end

function BagController:GetInstance()
	return BagController
end

function BagController:AddEvents(  )
	local onGameStart = function (  )
        self.model:Reset()
        self:ReqBagList(BagConst.Pos.Bag)
        self:ReqBagList(BagConst.Pos.Warehouse)
        self:ReqBagList(BagConst.Pos.Equip)
        self:ListenBagChange()
    end
    GlobalEventSystem:Bind(GlobalEvents.GameStart, onGameStart)

end

function BagController:ReqBagList( pos )
	local on_ack = function ( ackData )
		print("Cat:BagController [start:29] ackData: ", ackData)
		PrintTable(ackData)
		print("Cat:BagController [end]")
		self.model:SetBagInfo(ackData)
	end
    NetDispatcher:SendMessage("Bag_GetInfo", {pos=pos}, on_ack)
end

function BagController:ListenBagChange(  )
	local onBagChanged = function ( ackData )
        print("Cat:BagController [start:38] onBagChanged ackData:", ackData)
        PrintTable(ackData)
        print("Cat:BagController [end]")
        self.model:UpdateBagInfos(ackData)
    end
    NetDispatcher:Listen("Bag_GetChangeList", nil, onBagChanged)
end

return BagController