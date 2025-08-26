--Over-Rewind Protocol
function c26064008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064008,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetTarget(c26064008.target1)
	e1:SetOperation(c26064008.activate1)
	c:RegisterEffect(e1)
	--when drawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26064008,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetCost(c26064008.cost2)
	e2:SetTarget(c26064008.target2)
	e2:SetOperation(c26064008.activate2)
	c:RegisterEffect(e2)
	--leave field
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26064008,2))
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
function c26064008.filter1(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0x664) and c:IsFaceup()
	and c:IsCanBeEffectTarget(e)  then
		return ((c.FLIP and c.fliptg(e,tp,eg,ep,ev,re,r,rp,0))
		or (c.RITU and c.fliptg(e,tp,eg,ep,ev,re,r,rp,0)))
	else return false end
end
function c26064008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26064008.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then
		e:SetLabelObject(nil)
		return #g1>0
	end
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.HintSelection(tc)
	Duel.SetTargetCard(tc)
	e:SetLabelObject(tc)
	if tc.ACTV then
		local eff=tc:GetActivateEffect()
		e:SetCategory(eff:GetCategory())
	elseif tc.FLIP or tc.RITU then
		tc.fliptg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc.ACTV then
			local eff=tc:CheckActivateEffect(true,true,false)
			if eff then eff(e,tp,eg,ep,ev,re,r,rp) end
		elseif tc.FLIP or tc.RITU then
			tc.flipop(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,26064008)
		if #g>0 then Duel.HintSelection(g) end
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function c26064008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064008.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e)  then
		return ((c.DRAW and c.drtg(e,tp,eg,ep,ev,re,r,rp,0)))
	else return false end
end
function c26064008.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26064008.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return #g1>0 end
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.HintSelection(tc)
	Duel.SetTargetCard(tc)
	e:SetLabelObject(tc)
	if tc.DRAW then
		tc.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc.DRAW then
			tc.drop(e,tp,eg,ep,ev,re,r,rp,1)
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
function c26064008.filter3(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0x664) and c:IsFaceup() and c:IsCanBeEffectTarget(e) then
		return ((c.TURN and c.settg(e,tp,eg,ep,ev,re,r,rp,0)))
	else return false end
end
function c26064008.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c26064008.filter3,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return #g1>0 end
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.HintSelection(tc)
	Duel.SetTargetCard(tc)
	e:SetLabelObject(tc)
	if tc.TURN then
		tc.settg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c26064008.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc.TURN then
			tc.setop(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end