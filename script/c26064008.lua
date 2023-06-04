--Over-Rewind Protocol
function c26064008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetTarget(c26064008.target1)
	e1:SetOperation(c26064008.activate1)
	c:RegisterEffect(e1)
	--when drawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26064005,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetCost(c26064008.cost2)
	e2:SetTarget(c26064008.target2)
	e2:SetOperation(c26064008.activate2)
	c:RegisterEffect(e2)
	--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c26064008.setcon)
	e3:SetTarget(c26064008.target3)
	e3:SetOperation(c26064008.activate3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26064008.setcon2)
	c:RegisterEffect(e4)
end

function c26064008.filter1(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and (
	(c:GetOriginalCode()==(26064001) and c26064001.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064002) and c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064003) and c26064003.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064004) and c26064004.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064005) and c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064006) and c26064006.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064009) and c26064009.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064010) and c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064011) and c26064011.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064012) and c26064012.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064904) and c26064904.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064905) and c26064905.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26068013) and c26068013.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26068014) and c26068014.fliptg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26068015) and c26068015.fliptg(e,tp,eg,ep,ev,re,r,rp,0))) 
	 and (c:IsOnField() or c:GetTurnID()==tid)
end
function c26064008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26064008.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp,tid)
	if chk==0 then return #g1>0 end
	local opc=g1:Select(tp,1,1,nil)
	Duel.HintSelection(opc)
	Duel.SetTargetCard(opc)
	local op=opc:GetFirst():GetOriginalCode()
	if op==26064001 then
		e:SetCategory(CATEGORY_TODECK)
		c26064001.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064002 then
		e:SetCategory(CATEGORY_TODECK)
		c26064002.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064003 then
		c26064003.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064004 then
		e:SetCategory(CATEGORY_DRAW)
		c26064004.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064005 then
		e:SetCategory(CATEGORY_POSITION)
		c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064904 then
		e:SetCategory(CATEGORY_DRAW)
		c26064904.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064905 then
		e:SetCategory(CATEGORY_POSITION)
		c26064905.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064006 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
		c26064006.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064009 then
		e:SetCategory(CATEGORY_POSITION)
		c26064009.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064010 then
		e:SetCategory(CATEGORY_POSITION)
		c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064011 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		c26064011.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064016 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
		c26064012.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26068013 then
		c26068013.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064014 then
		e:SetCategory(CATEGORY_LEAVE_GRAVE)
		c26064014.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==c26064015 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
		c26064015.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local op=tc:GetOriginalCode()
		if op==26064001 then
		c26064001.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064002 then
			c26064002.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064003 then
			c26064003.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064004 then
			c26064004.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064005 then
			c26064005.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064904 then
			c26064904.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064905 then
			c26064905.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064006 then
			c26064006.activate(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064009 then
			c26064009.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064010 then
			c26064010.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064011 then
			c26064011.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064012 then
			c26064012.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068013 then
			c26068013.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068014 then
			c26068014.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068015 then
			c26068015.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function c26064008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064008.filter2(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and (
	(c:GetOriginalCode()==26064904 and c26064904.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064004 and c26064004.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064905 and c26064905.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064005 and c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064006 and c26064006.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064009 and c26064009.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064010 and c26064010.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26064011) or
	--(c:GetOriginalCode()==26068014 and c26068014.drtg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==26068015 and c26068015.drtg(e,tp,eg,ep,ev,re,r,rp,0))) 
	 and (c:IsOnField() or c:GetTurnID()==tid)
end
function c26064008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26064008.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp,tid)
	if chk==0 then return #g1>0 end
	local opc=g1:Select(tp,1,1,nil)
	Duel.HintSelection(opc)
	Duel.SetTargetCard(opc)
	local op=opc:GetFirst():GetOriginalCode()
	if op==26064004 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		c26064004.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064005 then
		e:SetCategory(CATEGORY_DRAW)
		c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064904 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		c26064004.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064905 then
		e:SetCategory(CATEGORY_DRAW)
		c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064006 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		c26064006.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064009 then
		e:SetCategory(CATEGORY_TOHAND)
		c26064009.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064010 then
		e:SetCategory(CATEGORY_TOHAND)
		c26064010.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26068014 then
		e:SetCategory(CATEGORY_DRAW)
		c26068014.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26068015 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		c26068015.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local op=tc:GetOriginalCode()
		if op==26064004 then
			c26064004.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064005 then
			c26064005.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064006 then
			c26064006.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064009 then
			c26064009.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064010 then
			c26064010.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064011 then
			c26064011.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068014 then
			c26068014.drop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068015 then
			c26068015.drop(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c26064008.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK) and c:IsPreviousPosition(POS_FACEUP)
end
function c26064008.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not (c:GetPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP))
end
function c26064008.filter3(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and (
	(c:GetOriginalCode()==(26064001) and c26064001.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064002) and c26064002.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064003) and c26064003.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064004) and c26064004.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064005) and c26064005.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26064009) and c26064009.settg(e,tp,eg,ep,ev,re,r,rp,2)) or
	(c:GetOriginalCode()==(26064010) and c26064010.settg(e,tp,eg,ep,ev,re,r,rp,2)) or
	(c:GetOriginalCode()==(26064011) and c26064011.settg(e,tp,eg,ep,ev,re,r,rp,2)) or
	(c:GetOriginalCode()==(26064012) and c26064012.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26068013) and c26068013.settg(e,tp,eg,ep,ev,re,r,rp,0)) or
	(c:GetOriginalCode()==(26068015) and c26068015.settg(e,tp,eg,ep,ev,re,r,rp,0))) 
	 and (c:IsOnField() or c:GetTurnID()==tid)
end
function c26064008.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26064008.filter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp,tid)
	if chk==0 then return #g1>0 end
	local opc=g1:Select(tp,1,1,nil)
	Duel.HintSelection(opc)
	Duel.SetTargetCard(opc)
	local op=opc:GetFirst():GetOriginalCode()
	if op==26064001 then
		e:SetCategory(CATEGORY_DRAW)
		c26064001.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064002 then
		e:SetCategory(CATEGORY_DRAW)
		c26064002.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064003 then
		e:SetCategory(CATEGORY_DRAW)
		c26064003.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064004 then
		e:SetCategory(CATEGORY_DRAW)
		c26064004.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064005 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		c26064005.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064904 then
		e:SetCategory(CATEGORY_DRAW)
		c26064904.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064905 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		c26064905.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064909 then
		e:SetCategory(CATEGORY_TOHAND)
		c26064909.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064010 then
		e:SetCategory(CATEGORY_TODECK)
		c26064010.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064011 then
		e:SetCategory(CATEGORY_TODECK)
		c26064011.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26064012 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		c26064012.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26068013 then
		e:SetCategory(CATEGORY_DRAW)
		c26068013.settg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==26068015 then
		e:SetCategory(CATEGORY_POSITION)
		c26068015.settg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local op=tc:GetOriginalCode()
		if op==26064001 then
			c26064001.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064002 then
			c26064002.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064003 then
			c26064003.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064004 then
			c26064004.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064005 then
			c26064005.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064904 then
			c26064904.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064905 then
			c26064905.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064909 then
			c26064009.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064010 then
			c26064010.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064011 then
			c26064011.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26064012 then
			c26064012.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068013 then
			c26068013.setop(e,tp,eg,ep,ev,re,r,rp,1)
		elseif op==26068015 then
			c26068015.setop(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end