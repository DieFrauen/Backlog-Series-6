--Glistening Blazon Charge
function c26062011.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062011,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26062011.cost)
	e1:SetTarget(c26062011.target1)
	e1:SetOperation(c26062011.activate1)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062011,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c26062011.cost)
	e2:SetTarget(c26062011.target2)
	e2:SetOperation(c26062011.activate2)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062011,2))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c26062011.cost)
	e3:SetTarget(c26062011.target3)
	e3:SetOperation(c26062011.activate3)
	c:RegisterEffect(e3)
end
c26062011.check=false
function c26062011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	c26062011.check=true
	if chk==0 then return true end
end
function c26062011.rfilter(c)
	return c:IsSetCard(0x662) and c:IsAbleToDeckAsCost()
end
function c26062011.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ch=Duel.GetCurrentChain()
	local loc=LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND 
	local rg=Duel.GetMatchingGroup(c26062011.rfilter,tp,loc,0,e:GetHandler())
	if chk==0 then
		if not c26062011.check then return false end
		c26062011.check=false
		return aux.SelectUnselectGroup(rg,e,tp,1,ch,aux.dncheck,0) and Duel.IsExistingMatchingCard(c26062011.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rsg=aux.SelectUnselectGroup(rg,e,tp,1,ch,aux.dncheck,1,tp,HINTMSG_TODECK)
	Duel.SendtoDeck(rsg,tp,2,REASON_COST)
	e:SetLabel(#rsg)
	local sg=Duel.GetMatchingGroup(c26062011.filter1,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c26062011.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c26062011.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26062011.filter1,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,e:GetLabel(),nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c26062011.filter2(c)
	return not c:IsDisabled()
end
function c26062011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ch=Duel.GetCurrentChain()
	local loc=LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND 
	local rg=Duel.GetMatchingGroup(c26062011.rfilter,tp,loc,0,e:GetHandler())
	if chk==0 then
		if not c26062011.check then return false end
		c26062011.check=false
		return ch>1 and aux.SelectUnselectGroup(rg,e,tp,2,ch,aux.dncheck,0) and Duel.IsExistingMatchingCard(c26062011.filter2,tp,0,LOCATION_MZONE,1,nil)
		end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rsg=aux.SelectUnselectGroup(rg,e,tp,2,ch,aux.dncheck,1,tp,HINTMSG_TODECK)
	Duel.SendtoDeck(rsg,tp,2,REASON_COST)
	e:SetLabel(math.floor(#rsg/2))
	local sg=Duel.GetMatchingGroup(c26062011.filter3,tp,0,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c26062011.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26062011.filter2,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local sg=g:Select(tp,1,e:GetLabel(),nil)
	for tc in aux.Next(sg) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(tc)
		tc:RegisterEffect(e2)
	end
end
function c26062011.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ch=Duel.GetCurrentChain()
	local loc=LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND 
	local rg=Duel.GetMatchingGroup(c26062011.rfilter,tp,loc,0,e:GetHandler())
	if chk==0 then
		if not c26062011.check then return false end
		c26062011.check=false
		return ch>2 and aux.SelectUnselectGroup(rg,e,tp,1,ch,aux.dncheck,0) and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1)
		end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local dc=math.min(
	Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),
	Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))
	local max=math.min(ch,dc)
	local rsg=aux.SelectUnselectGroup(rg,e,tp,1,max,aux.dncheck,1,tp,HINTMSG_TODECK)
	Duel.SendtoDeck(rsg,tp,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,#rsg)
	e:SetLabel(#rsg)
end
function c26062011.activate3(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if not (Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanDiscardDeck(1-tp,ct)) then return end
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	if Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(26262011,4)) then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end