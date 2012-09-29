--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012 Kenny Shields --
--]]------------------------------------------------

-- checkbox class
checkbox = class("checkbox", base)
checkbox:include(loveframes.templates.default)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function checkbox:initialize()

	self.type           = "checkbox"
	self.width          = 0
	self.height         = 0
	self.boxwidth       = 20
	self.boxheight      = 20
	self.font           = loveframes.basicfont
	self.checked        = false
	self.lastvalue      = false
	self.internal       = false
	self.down           = true
	self.internals      = {}
	self.OnChanged      = nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function checkbox:update(dt)
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	self:CheckHover()
	
	local hover     = self.hover
	local internals = self.internals
	local boxwidth  = self.boxwidth
	local boxheight = self.boxheight
	local parent    = self.parent
	local base      = loveframes.base
	local update    = self.Update
	
	if not hover then
		self.down = false
	else
		if loveframes.hoverobject == self then
			self.down = true
		end
	end
	
	if not self.down and loveframes.hoverobject == self then
		self.hover = true
	end
	
	-- move to parent if there is a parent
	if parent ~= base and parent.type ~= "list" then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if internals[1] then
	
		self.width = boxwidth + 5 + internals[1].width
		
		if internals[1].height == boxheight then
			self.height = boxheight
		else
			if internals[1].height > boxheight then
				self.height = internals[1].height
			else
				self.height = boxheight
			end
		end
		
	else
	
		self.width = boxwidth
		self.height = boxheight
		
	end
	
	for k, v in ipairs(internals) do
		v:update(dt)
	end
	
	if update then
		update(self, dt)
	end

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function checkbox:draw()
	
	local visible = self.visible
	
	if not visible then
		return
	end

	local skins         = loveframes.skins.available
	local skinindex     = loveframes.config["ACTIVESKIN"]
	local defaultskin   = loveframes.config["DEFAULTSKIN"]
	local selfskin      = self.skin
	local skin          = skins[selfskin] or skins[skinindex]
	local drawfunc      = skin.DrawCheckBox or skins[defaultskin].DrawCheckBox
	local draw          = self.Draw
	local internals     = self.internals
	local drawcount     = loveframes.drawcount
	
	loveframes.drawcount = drawcount + 1
	self.draworder = loveframes.drawcount
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
	for k, v in ipairs(internals) do
		v:draw()
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function checkbox:mousepressed(x, y, button)

	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	
	if hover and button == "l" then
		
		local baseparent = self:GetBaseParent()
	
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		
		self.down = true
		loveframes.hoverobject = self
		
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function checkbox:mousereleased(x, y, button)
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover     = self.hover
	local checked   = self.checked
	local onchanged = self.OnChanged
	
	if hover and button == "l" then
	
		if checked then
			self.checked = false
		else
			self.checked = true
		end
		
		if onchanged then
			onchanged(self)
		end
		
	end
		
end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function checkbox:SetText(text)

	local boxwidth  = self.boxwidth
	local boxheight = self.boxheight
	
	if text ~= "" then
		
		self.internals = {}
		
		local textobject = loveframes.Create("text")
		textobject:Remove()
		textobject.parent = self
		textobject.collide = false
		textobject:SetFont(self.font)
		textobject:SetText(text)
		textobject.Update = function(object, dt)
			if object.height > boxheight then
				object:SetPos(boxwidth + 5, 0)
			else
				object:SetPos(boxwidth + 5, boxheight/2 - object.height/2)
			end
		end
		
		table.insert(self.internals, textobject)
		
	else
	
		self.width     = boxwidth
		self.height    = boxheight
		self.internals = {}
		
	end
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function checkbox:GetText()

	local internals = self.internals
	local text      = internals[1]
	
	if text then
		return text.text
	else
		return false
	end
	
end

--[[---------------------------------------------------------
	- func: SetSize(width, height)
	- desc: sets the object's size
--]]---------------------------------------------------------
function checkbox:SetSize(width, height)

	self.boxwidth  = width
	self.boxheight = height
	
end

--[[---------------------------------------------------------
	- func: SetWidth(width)
	- desc: sets the object's width
--]]---------------------------------------------------------
function checkbox:SetWidth(width)

	self.boxwidth = width
	
end

--[[---------------------------------------------------------
	- func: SetHeight(height)
	- desc: sets the object's height
--]]---------------------------------------------------------
function checkbox:SetHeight(height)

	self.boxheight = height
	
end

--[[---------------------------------------------------------
	- func: SetChecked(bool)
	- desc: sets whether the object is checked or not
--]]---------------------------------------------------------
function checkbox:SetChecked(bool)

	local onchanged = self.OnChanged
	
	self.checked = bool
	
	if onchanged then
		onchanged(self)
	end
	
end

--[[---------------------------------------------------------
	- func: GetChecked()
	- desc: gets whether the object is checked or not
--]]---------------------------------------------------------
function checkbox:GetChecked()

	return self.checked
	
end

--[[---------------------------------------------------------
	- func: SetFont(font)
	- desc: sets the font of the object's text
--]]---------------------------------------------------------
function checkbox:SetFont(font)

	local internals = self.internals
	local text      = internals[1]
	
	self.font = font
	
	if text then
		text:SetFont(font)
	end
	
end

--[[---------------------------------------------------------
	- func: checkbox:GetFont()
	- desc: gets the font of the object's text
--]]---------------------------------------------------------
function checkbox:GetFont()

	return self.font

end

--[[---------------------------------------------------------
	- func: checkbox:GetBoxHeight()
	- desc: gets the object's box size
--]]---------------------------------------------------------
function checkbox:GetBoxSize()

	return self.boxwidth, self.boxheight
	
end

--[[---------------------------------------------------------
	- func: checkbox:GetBoxWidth()
	- desc: gets the object's box width
--]]---------------------------------------------------------
function checkbox:GetBoxWidth()

	return self.boxwidth
	
end

--[[---------------------------------------------------------
	- func: checkbox:GetBoxHeight()
	- desc: gets the object's box height
--]]---------------------------------------------------------
function checkbox:GetBoxHeight()

	return self.boxheight
	
end