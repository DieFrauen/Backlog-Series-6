--Siphantheonium
function c26066012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c26066012.cost)
	e1:SetTarget(c26066012.target)
	e1:SetOperation(c26066012.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c26066012.qpcond)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c26066012.resfilter(c,total,min)
	local tb=c:GetMaterialCount()*10
	return tb>0 and c:IsFaceup() and c:GetSummonType(SUMMON_TYPE_ADVANCE) and min+tb>=total 
end
function c26066012.qpcond(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local total=30
	local min=Duel.GetFieldGroupCount(0,LOCATION_GRAVE,LOCATION_GRAVE)
	return Duel.IsExistingMatchingCard(c26066012.resfilter,tp,LOCATION_MZONE,0,1,nil,total,min) or min>=total 
end
function c26066012.trib(c)
	return c:IsSummonType(SUMMON_TYPE_TRIBUTE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c26066012.cfilter(c,tp,type)
	return Duel.IsPlayerCanRelease(tp,c) and c:IsSpellTrap()
end
function c26066012.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local type,g=(re:GetActiveType()&e:GetLabel()),nil
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c26066012.cfilter,1,true,nil,nil,tp,type) end
	local rg=Duel.SelectReleaseGroupCost(tp,c26066012.cfilter,1,1,true,nil,nil,tp,type)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RELEASE)
end
function c26066012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local usehand=Duel.IsPlayerAffectedByEffect(tp,26066007)
	local loc=LOCATION_ONFIELD
	if usehand then loc=loc+LOCATION_HAND end
	local g=Duel.GetReleaseGroup(tp,usehand,false,REASON_COST) 
	local g2=Duel.GetMatchingGroup(c26066012.cfilter,tp,loc,0,c,tp)
	g:Merge(g2)
	if chk==0 then return #g>0 end
	local rg=g:FilterSelect(tp,Card.IsSetCard,1,3,c,0x666)
	Duel.SendtoGrave(rg,REASON_COST+REASON_RELEASE)
	local typ=0
	for tc in rg:Iter() do
		typ=typ|(tc:GetOriginalType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
	end
	e:SetLabel(typ)
end
function c26066012.tdfilter(c,typ)
	return c:IsFaceup() and c:IsAbleToDeck() and c:GetType()&typ~=0
end
function c26066012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp~=tp end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function c26066012.activate(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local dg=Duel.GetMatchingGroup(c26066012.tdfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil,typ)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local rc=te:GetHandler()
		if tgp~=tp and rc:IsOnField() and rc:GetType()&typ~=0 and rc:IsRelateToEffect(te) and not rc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,rc) then
			rc:CancelToGrave()
			dg:AddCard(rc)
		end
	end
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.DiscardDeck(1-tp,#dg,REASON_EFFECT)
	og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:RegisterFlagEffect(26066012,RESET_CHAIN,0,2)
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