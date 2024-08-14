--Astelloy Smelting
function c26063010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(7)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate on certain column
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063010,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabel(0)
	e2:SetCountLimit(1,26063010)
	e2:SetValue(c26063010.seq)
	e2:SetCountLimit(1,26063010)
	e2:SetTarget(c26063010.target)
	e2:SetOperation(c26063010.activate)
	c:RegisterEffect(e2)
	--trigger on summon on column
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26063010,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,26063010)
	e3:SetCondition(c26063010.gcond)
	e3:SetTarget(c26063010.target)
	e3:SetOperation(c26063010.activate)
	c:RegisterEffect(e3)
	--grave effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(26063010,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,26063010)
	e4:SetCost(c26063010.tdcost)
	e4:SetTarget(c26063010.target)
	e4:SetOperation(c26063010.activate)
	c:RegisterEffect(e4)
	--burst counters
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c26063010.remtcon)
	e5:SetOperation(c26063010.remtop)
	c:RegisterEffect(e5)
end
function c26063010.cfilter(c)
	return c:IsSetCard(0x663) and c:IsFaceup()
end
function c26063010.seq(e,c)
	local tp=e:GetHandlerPlayer()
	local zone=0
	local lg=Duel.GetMatchingGroup(c26063010.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		zone=(zone|2^tc:GetSequence())
	end
	return zone
end
function c26063010.nsfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c26063010.gcond(e,tp,eg,ep,ev,re,r,rp)
	local col=e:GetHandler():GetColumnGroup()
	if eg and eg:IsExists(c26063010.nsfilter,1,nil) then
		for tc in eg:Iter() do
			if col:IsContains(tc) then return true end
		end
	end
	return false
end
function c26063010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,CATEGORY_TOHAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26063010.dfilter(c,tp)
	return c:IsDiscardable() and not c:IsPublic() and (Duel.IsPlayerCanDraw(tp,1) or c:IsCode(26063001))
end
function c26063010.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x663) and c:IsAbleToHand()
end
function c26063010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c26063010.dfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local sp=false
	if tc:IsType(TYPE_NORMAL) then sp=true end
	Duel.ConfirmCards(1-tp,tc)
	if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local dg=Duel.GetMatchingGroup(c26063010.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=#dg>0
	local b2=Duel.IsPlayerCanDraw(tp,2)
	local b3=Duel.IsPlayerCanDraw(tp,1)
	if sp and (b1 or b2) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26063010,2))
		local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26063010,4)},
		{b2,aux.Stringid(26063010,3)},
		{b3,aux.Stringid(26063010,5)})
		if op==1 then
			tc=Duel.SelectMatchingCard(tp,c26063010.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			return
		elseif op==2 then
			Duel.Draw(tp,2,REASON_EFFECT)
			return
		end
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c26063010.tdfilter(c)
	return c:IsSetCard(0x663) and c:IsAbleToDeckAsCost()
end
function c26063010.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c26063010.tdfilter,tp,LOCATION_GRAVE,0,1,c) end
	local oc=Duel.SelectMatchingCard(tp,c26063010.tdfilter,tp,LOCATION_GRAVE,0,1,1,c):GetFirst()
	Duel.SendtoDeck(Group.FromCards(oc,c),nil,1,REASON_COST)
end
function c26063010.remtfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():FilterCount(Card.IsAbleToHand,nil)>0
end
function c26063010.remtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=c:GetColumnGroup()
	if eg and eg:IsExists(c26063010.remtfilter,1,nil) then
		for tc in eg:Iter() do
			if col:IsContains(tc) then return c:IsAbleToGrave() and not eg:IsContains(c) end
		end
	end
	return false
end
function c26063010.remtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=c:GetColumnGroup()
	local mtg=Group.CreateGroup()
	for tc in eg:Iter() do
		mtg:Merge(tc:GetOverlayGroup():Filter(Card.IsAbleToHand,nil))
	end
	if #mtg>0 and c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(26063010,6)) then
		mtc=mtg:Select(tp,1,1,nil)
		if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
			Duel.SendtoHand(mtc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mtc)
		end
	end
end