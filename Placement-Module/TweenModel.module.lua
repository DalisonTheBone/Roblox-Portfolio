local TM = {}

-- Services
local TweenService = game:GetService("TweenService")

function TM:Tween(Model: Model, Info: TweenInfo, cf: CFrame)
	
	if cf then
		
		pcall(function()
			
			TM.Animation:Cancel()
			TM.Temp:Disconnect()
			
		end)
		
		--print(cf)
		
		local CFrameValue = Instance.new("CFrameValue")
		CFrameValue.Parent = Model
		CFrameValue.Value = Model:GetPivot()
		
		TM.Animation = TweenService:Create(CFrameValue, Info, {["Value"] = cf})
		
		TM.Animation:Play()
		
		TM.Temp = CFrameValue.Changed:Connect(function()
			
			Model:PivotTo(CFrameValue.Value)
			
		end)
			
	end
	
end



return TM
