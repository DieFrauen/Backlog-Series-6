--Blazon Incinerator
function c26062011.initial_effect(c)
	--deck destruction
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062011,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetLabel(0)
	e1:SetCondition(c26062011.condition)
	e1:SetTarget(c26062011.target1)
	e1:SetOperation(c26062011.activate1)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062011,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabel(0)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c26062011.condition)
	e2:SetTarget(c26062011.target2)
	e2:SetOperation(c26062011.activate2)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062011,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabel(0)
	e3:SetCondition(c26062011.condition)
	e3:SetTarget(c26062011.target3)
	e3:SetOperation(c26062011.activate3)
	c:RegisterEffect(e3)
end
function c26062011.condition(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ch=Duel.GetCurrentChain()
	local g1=Group.CreateGroup()
	for i=1,ch do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and
		te:IsActiveType(TYPE_MONSTER) and
		tc:IsSetCard(0x662) then
			g1:AddCard(tc)
		end
	end
	e:SetLabel(#g1)
	if #g1>0 then return true end
end
function c26062011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()+3
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c26062011.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+3
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end

function c26062011.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c26062011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26062011.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c26062011.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c26062011.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26062011.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,e:GetLabel(),nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c26062011.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ch=Duel.GetCurrentChain()
	local g1=Group.CreateGroup()
	for i=1,ch do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp~=tp then
			g1:AddCard(tc)
		end
	end
	if chk==0 then return #g1>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,0,tp,#g1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c26062011.activate3(e,tp,eg,ep,ev,re,r,rp)
	--Negate
	e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(e:GetLabel())
	e1:SetLabel(1-tp)
	e1:SetReset(RESET_CHAIN)
	e1:SetCondition(c26062011.discon)
	e1:SetOperation(c26062011.disop)
	Duel.RegisterEffect(e1,tp)
end
function c26062011.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetLabel()
end
function c26062011.disop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	if Duel.SelectYesNo(tp,aux.Stringid(26062011,4)) then
		if Duel.GetLP(tp)>1000 or not Duel.SelectYesNo(tp,aux.Stringid(26062011,5)) then
			Duel.Hint(HINT_CARD,tp,26062011)
			Duel.Damage(tp,1000,REASON_EFFECT)
			return
		end
	end
	Duel.Hint(HINT_CARD,tp,26062011)
	Duel.NegateEffect(ev)
end
