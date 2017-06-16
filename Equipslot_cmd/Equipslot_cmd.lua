--[[ Variables ]]--
local Slot_List	= {
    slot0  = "AmmoSlot",
    slot1  = "HeadSlot",
    slot2  = "NeckSlot",
    slot3  = "ShoulderSlot",
    slot4  = "ShirtSlot",
    slot5  = "ChestSlot",
    slot6  = "WaistSlot",
    slot7  = "LegsSlot",
    slot8  = "FeetSlot",
    slot9  = "WristSlot",
    slot10 = "HandsSlot",
    slot11 = "Finger0Slot",
    slot12 = "Finger1Slot",
    slot13 = "Trinket0Slot",
    slot14 = "Trinket1Slot",
    slot15 = "BackSlot",
    slot16 = "MainHandSlot",
    slot17 = "SecondaryHandSlot",
    slot18 = "RangedSlot",
    slot19 = "TabardSlot"
};

--[[ Slash Command Handler ]]--
SLASH_Equipslot1 = "/equipslot";
SLASH_Equipslot2 = "/одеть";

local HelpFrame	= nil

SlashCmdList["Equipslot"] = function( msg )
	if ( not msg or msg == "" or msg == "?" or msg == "help" ) then
	
		if not HelpFrame then
			-- [[ MAIN HELP FRAME ]] --
			HelpFrame = CreateFrame( "Frame", nil, UIParent )
			HelpFrame:SetFrameStrata("BACKGROUND")
			HelpFrame:EnableMouse(true)
			HelpFrame:SetWidth(360)
			HelpFrame:SetHeight(520)
			HelpFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true, tileSize = 16, edgeSize = 16,
				insets = {left = 4, right = 4, top = 4, bottom = 4}
			})
			HelpFrame:SetPoint("CENTER",0, 60)
			
		-- [[ HELP TITLE ]] --
			local	HelpFrameTitle = CreateFrame( "Frame", nil, HelpFrame )
					HelpFrameTitle:SetFrameStrata( "LOW" )
					HelpFrameTitle:SetWidth(220) 
					HelpFrameTitle:SetHeight(50)
					HelpFrameTitle:SetPoint( "TOP",0, 11 )
					HelpFrameTitle:Show()
					-- [ Texture ] --
					local	HFT_Texture = HelpFrameTitle:CreateTexture( nil, "BACKGROUND" )
							HFT_Texture:SetTexture( "Interface\\DialogFrame\\UI-DialogBox-Header" )
							HFT_Texture:SetAllPoints( HelpFrameTitle )
					-- [ Text ] --
					HelpFrameTitle.text = HelpFrameTitle:CreateFontString( nil ,"OVERLAY" )      
					HelpFrameTitle.text:SetFont( STANDARD_TEXT_FONT, 10 )
					HelpFrameTitle.text:SetTextColor( 1, 0.5, 0.25 )
					HelpFrameTitle.text:SetText("Equipslot HELP")
					HelpFrameTitle.text:SetPoint( "CENTER", 0, 10 )
	
			-- [[ IMAGE FRAME ]] --
			local	ImageFrame = CreateFrame( "Frame", nil, HelpFrame )
					ImageFrame:SetFrameStrata( "BACKGROUND" )
					ImageFrame:SetWidth(256) 
					ImageFrame:SetHeight(252)
					ImageFrame:SetPoint( "TOP",0, -18 )
					ImageFrame:Show()
					-- [ Texture ] --
					ImageFrame:SetBackdrop({bgFile = "Interface\\Addons\\Equipslot_cmd\\Textures\\InventorySlots.tga",
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
						tile = true, tileSize = 250, edgeSize = 16,
						insets = {left = 4, right = 4, top = 4, bottom = 4}
					})
			-- [[ INFO FRAME ]] --
				local	InfoFrame = CreateFrame( "EditBox", nil, HelpFrame )
						InfoFrame:SetFrameStrata( "BACKGROUND" )
						InfoFrame:SetWidth(340)
						InfoFrame:SetHeight(150)
						InfoFrame:SetAutoFocus(false)
						InfoFrame:SetMultiLine(true)
						InfoFrame:SetFontObject( ChatFontNormal )
						InfoFrame:SetPoint( "TOP", 0, -270)
				local	IF_Tex	  = "\r|cFFF7950A                     Руководство по использованию|r\r" ..
									"|cFF000000                 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |r\r" ..
									"|cFFFFFB00/equipslot|r |cFF04FAF717|r |cFF2CEA056223|r                   \r" ..
									"          |cFFB5B5B5или|r \r" ..
									"|cFFFFFB00/одеть|r |cFF04FAF717|r |cFF2CEA05\"Рыцарский щит Темнолесья\"|r              \r" ..
									"|cFF000000                 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |r\r" ..
									"|cFF04FAF717|r - Номер слота,в который одевается вещь\r" ..
									"       |cFFB5B5B5(см. рисунок выше)|r\r\r" ..
									"|cFF2CEA056223|r - ID вещи\r" ..
									"       |cFFB5B5B5или|r \r" ..
									"|cFF2CEA05\"Рыцарский щит Темнолесья\"|r - Название вещи\r" ..
									"|cFF000000                 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |r\r" ..
									"|cFFFF0000*|r |cFFB5B5B5Вещь которую вы одеваете, должна быть в вашем Рюкзаке|r"
		
						InfoFrame:SetText( IF_Tex )
						InfoFrame:SetScript("OnTextChanged", function()
							this:SetText( IF_Tex )
							this:ClearFocus();
						end )
			-- [[ CLOSE BUTTON ]] --
			local	CloseBtn = CreateFrame( "Button", nil, HelpFrame, "UIPanelButtonTemplate" )
					CloseBtn:SetWidth( 60 ) 
					CloseBtn:SetHeight( 25 )
					CloseBtn:SetPoint( "BOTTOM", 0, 10 )
					CloseBtn:SetText( "CLOSE" )
					CloseBtn:RegisterForClicks( "LeftButtonUp" )
					CloseBtn:SetScript( "OnClick", function()
						this:GetParent():Hide();
					end ) 
					CloseBtn:Show()
		else
			HelpFrame:Show()
		end
		-- [[ END MAIN HELP FRAME ]] --
	else
		local _, _, Slot, Item	= string.find( msg, "^(%d+) +(.+)$" )
		local SlotName			= "slot" .. Slot
		local CurItem			= nil
		if ( not Slot or type(Slot_List[SlotName]) == nil or not Item ) then return end
		-- [[ trim spaces ]]
		Item = gsub(gsub( Item, "^ +", "" ), " +$", "" )
		if ( string.find( Item, "^(%d+)$" ) ) then
			CurItem				= GetItemInfo( Item )
		elseif ( string.find( Item, "|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[.+]|h|r" ) ) then
			local _, _, _, ID	= string.find( Item, "|c%x+|H(item:(%d+):%d+:%d+:%d+)|h%[.+]|h|r" )
			CurItem				= GetItemInfo( ID )
		else
			CurItem				= Item
		end
		if type(CurItem) == "string" then else return end
		if string.find( CurItem, "^[%s%p]+(.+)[%s%p]+$" ) then
			_, _, CurItem		= string.find( CurItem, "^[%s%p]+(.+)[%s%p]+$" )
		end
		if not CurItem then return end
		Equipslot( Slot, CurItem )
	end
end

function Equipslot( Slot, ItemName )
	if CursorHasItem() or SpellIsTargeting() then
		ClearCursor()
	end
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots( bag ) do
			local ItemTexture = GetContainerItemInfo( bag, slot )
			if ItemTexture then
				local ItemLink = GetContainerItemLink( bag, slot )
				if ItemLink and string.find( ItemLink, ItemName ) then
					PickupContainerItem( bag, slot )
					if ( CursorCanGoInSlot( Slot ) ) then
						EquipCursorItem( Slot )
					else
						ClearCursor()
					end
					return
				end 
			end
		end
	end
end