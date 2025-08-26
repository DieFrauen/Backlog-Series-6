--Over-wind Flux
function c26064010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064009,4))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c26064010.cost)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c26064010.destg)
	e2:SetValue(c26064010.desval)
	e2:SetOperation(c26064010.desop)
	c:RegisterEffect(e2)
	--when drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064005,5))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DRAW)
	e3:SetCost(c26064010.thcost)
	e3:SetTarget(c26064010.drtg)
	e3:SetOperation(c26064010.drop)
	c:RegisterEffect(e3)
	--leave field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26064005,6))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26064010.setcon)
	e4:SetTarget(c26064010.settg)
	e4:SetOperation(c26064010.setop)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetCode(EVENT_TO_GRAVE)
	e4a:SetCondition(c26064010.setcon2)
	c:RegisterEffect(e4a)
	--inactivatable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c26064010.efffilter)
	c:RegisterEffect(e5)
end
c26064010.FLIP=true
c26064010.DRAW=true
c26064010.TURN=true
function c26064010.efffilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler():IsType(TYPE_FLIP)
end
function c26064010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,0)
	and Duel.SelectYesNo(tp,aux.Stringid(26064010,0)) then 
		e:SetTarget(c26064010.fliptg)
		e:SetCategory(CATEGORY_POSITION)
		e:SetOperation(c26064010.flipop)
	end
end
function c26064010.desfilter(c)
	return (c:IsSetCard(0x664) or c:IsFacedown()) and c:IsOnField() and not c:IsReason(REASON_REPLACE)
end
function c26064010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c26064010.desfilter,c)*2
		e:SetLabel(count)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x1b,count,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c26064010.desval(e,c)
	return c26064010.desfilter(c,e:GetHandlerPlayer())
end
function c26064010.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,0,0x1b,count,REASON_COST)
end
function c26064010.flfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x664)
end
function c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064010.flfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end
function c26064010.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26064010.flfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	local gc1,gc2=g1:GetCount(),g2:GetCount()
	local gc=math.min(gc1,gc2)
	if gc>0 then
		tg1=g1:Select(tp,1,gc,nil)
		Duel.ChangePosition(tg1,POS_FACEUP_DEFENSE)
		tgc=tg1:GetCount()
		Duel.BreakEffect()
		tg2=g2:Select(tp,tgc,tgc,nil)
		Duel.ChangePosition(tg2,POS_FACEDOWN_DEFENSE)
	end
end
function c26064010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064010.drfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c26064010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064010.drfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c26064010.drfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c26064010.setfilter(c)
	return c:IsSpellTrap() and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c26064010.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26064010.drfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
		local tc=nil
		local g=Duel.GetMatchingGroup(c26064010.setfilter,tp,LOCATION_HAND,0,nil)
		local sz=Duel.GetLocationCount(tp,LOCATION_SZONE)
		Duel.Hint(HINT_SELECTMSG,tp,527)
		if #g>0 and sz>0 and Duel.SelectYesNo(tp,aux.Stringid(26064010,3)) then
			local sg=g:Select(tp,1,sz,nil)
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.SSet(tp,sg,tp,false)
		end
	end
end
function c26064010.remfilter(c)
	return c:IsSpellTrap() and c:IsAbleToRemove()
end
function c26064010.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064010.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not (c:GetPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP))
end
function c26064010.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26064010.remfilter,rp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetType()&EFFECT_TYPE_TRIGGER_F ~=0 or #g>0 end
	Duel.SetTargetPlayer(rp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c26064010.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c26064010.remfilter,p,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end