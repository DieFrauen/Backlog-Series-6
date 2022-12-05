--Over-wind Fluctuation
function c26064010.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c26064010.cost)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c26064010.indfilter)
	e2:SetValue(c26064010.indct)
	c:RegisterEffect(e2)
	--when drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064005,2))
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
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26064010.setcon)
	e4:SetTarget(c26064010.settg)
	e4:SetOperation(c26064010.setop)
	c:RegisterEffect(e4)
end
function c26064010.indfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x664)
end
function c26064010.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c26064010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return true end
	if b and Duel.SelectYesNo(tp,aux.Stringid(26064010,0)) then 
		e:SetTarget(c26064010.fliptg)
		e:SetCategory(CATEGORY_POSITION)
		e:SetOperation(c26064010.flipop)
	end
end
function c26064010.filter(c)
	return c:IsFacedown() and c:IsSetCard(0x664)
end
function c26064010.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064010.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end
function c26064010.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c26064010.filter,tp,LOCATION_MZONE,0,nil)
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
function c26064010.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26064010.drfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
		Duel.BreakEffect()
		local tc=nil
		local g=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)
		local sz=Duel.GetLocationCount(tp,LOCATION_SZONE)
		Duel.Hint(HINT_SELECTMSG,tp,527)
		local sg=g:Select(tp,1,sz,nil)
		Duel.ShuffleHand(tp)
		Duel.SSet(tp,sg,tp,false)
	end
end
function c26064010.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c26064010.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064010.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26064010.tdfilter,rp,LOCATION_SZONE,0,nil)
	if chk==0 then return true end
	if chk==2 then return #g>0 end
	Duel.SetTargetPlayer(rp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,rp,1)
end
function c26064010.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c26064010.tdfilter,p,LOCATION_SZONE,0,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end