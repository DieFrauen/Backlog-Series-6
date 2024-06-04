--Glistening Blazon Charge
function c26062011.initial_effect(c)
	--deck destruction
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062011,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
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
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c26062011.condition)
	e2:SetTarget(c26062011.target2)
	e2:SetOperation(c26062011.activate2)
	c:RegisterEffect(e2)
	--damage spread
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062011,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c26062011.condition)
	e3:SetTarget(c26062011.target3)
	e3:SetOperation(c26062011.activate3)
	c:RegisterEffect(e3)
	if not c26062011.global_check then
		c26062011.global_check=true
		c26062011[0]=0
		c26062011[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c26062011.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(c26062011.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c26062011.condition(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return c26062011[tp]>0
end
function c26062011.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	local g1=Group.CreateGroup()
	local p1,p2=0,0
	for i=1,ch do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tc:IsSetCard(0x662) then
			if tgp==0 then
				p1=p1+1
			else
				p2=p2+1
			end
		end
	end
	c26062011[tp]=p1
	c26062011[1-tp]=p2
end
function c26062011.clearop(e,tp,eg,ep,ev,re,r,rp)
	c26062011[0]=0
	c26062011[1]=0
end
function c26062011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c26062011[tp]
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c26062011.excfilter(c)
	return c:IsSetCard(0x662) and c:IsMonster()
end
function c26062011.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ct=c26062011[tp]
	ct=math.min(ct,10)
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local sg=g:Filter(c26062011.excfilter,nil)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26062011,4))
		if #sg==#g or Duel.SelectOption(tp,aux.Stringid(26062011,5),aux.Stringid(26062011,6)) then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_EFFECT|REASON_EXCAVATE)
			Duel.ShuffleDeck(tp)
		else
			Duel.SendtoGrave(g,REASON_EFFECT|REASON_EXCAVATE)
		end
	end
end
function c26062011.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c26062011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c26062011[tp]
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c26062011.thfilter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c26062011.thfilter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c26062011.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26062011.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,c26062011[tp]-1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c26062011.bfilter(c,ct)
	return c:IsMonster() and c:IsFaceup() and c:IsAbleToRemove() and not (c:IsType(TYPE_TUNER) or c:IsLevelAbove(ct))
end
function c26062011.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c26062011[tp]
	local g=Duel.GetMatchingGroup(c26062011.bfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,ct)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26062011.activate3(e,tp,eg,ep,ev,re,r,rp)
	local ct=c26062011[tp]
	local tc=Duel.SelectMatchingCard(tp,c26062011.bfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,ct):GetFirst()
	if tc then
		Duel.HintSelection(tc)
		local lab=0
		if tc:IsOnField() then lab=1 end
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(26062011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetLabel(lab)
			e1:SetCondition(c26062011.retcon)
			e1:SetOperation(c26062011.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c26062011.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(26062011)~=0
end
function c26062011.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if e:GetLabel()==1 then
		Duel.ReturnToField(c)
	else
		Duel.SendtoGrave(c,REASON_RETURN)
	end
end