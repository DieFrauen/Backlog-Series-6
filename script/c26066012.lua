--Siphanthomonium
function c26066012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(TYPE_MONSTER)
	e1:SetCost(c26066012.cost1)
	e1:SetTarget(c26066012.target)
	e1:SetOperation(c26066012.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(TYPE_SPELL+TYPE_TRAP)
	e2:SetCost(c26066012.cost2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c26066012.qpcond)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c26066012.qpcond(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(0,LOCATION_GRAVE,LOCATION_GRAVE)>19 
end
function c26066012.trib(c)
	return c:IsSummonType(SUMMON_TYPE_TRIBUTE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c26066012.cfilter(c,tp,type)
	return c:IsType(type) and Duel.IsPlayerCanRelease(tp,c) and c:IsSetCard(0x666)
end
function c26066012.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local type,g=(re:GetActiveType()&e:GetLabel()),nil
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26066012.cfilter,1,true,nil,nil,tp,type) end
	local rg=Duel.SelectReleaseGroupCost(tp,c26066012.cfilter,1,1,true,nil,nil,tp,type)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RELEASE)
end
function c26066012.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local type=(re:GetActiveType()&e:GetLabel())
	local g=Duel.GetMatchingGroup(c26066012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c,tp,type)
	if chk==0 then return #g>0 end
	local rg=g:Select(tp,1,1,c)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RELEASE)
end
function c26066012.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c26066012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c26066012.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) or Duel.IsPlayerCanSendtoDeck(tp,re:GetHandler())) and rp~=tp end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function c26066012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26066012.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	local rc=re:GetHandler()
	rc:CancelToGrave()
	g:AddCard(rc)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.DiscardDeck(1-tp,#g,REASON_EFFECT)
	og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:RegisterFlagEffect(26066012,RESET_EVENT+RESETS_STANDARD,0,1)
	end 
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c26066012.discon)
	e2:SetOperation(c26066012.disop)
	e2:SetReset(RESET_CHAIN,1)
	Duel.RegisterEffect(e2,tp)
end
function c26066012.distg(c,code1,code2)
	return c:IsCode(code1,code2) and not c:IsSetCard(0x666)
end
function c26066012.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return Duel.IsExistingMatchingCard(c26066012.distg,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,code1,code2)
end
function c26066012.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26066012)
	Duel.NegateEffect(ev)
end