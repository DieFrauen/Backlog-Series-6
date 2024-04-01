--Over-wind Planetarium
function c26064007.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c26064007.cost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064007,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c26064007.fliptg)
	e1:SetOperation(c26064007.flipop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c26064007.ctop)
	c:RegisterEffect(e2)
	--convert counters to level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064007,1))
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c26064007.lvtg)
	e3:SetOperation(c26064007.lvop)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_QUICK_O)
	e3a:SetCode(EVENT_FREE_CHAIN)
	e3a:SetCondition(c26064007.bpcon)
	c:RegisterEffect(e3a)
	--when drawn
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetDescription(aux.Stringid(26064007,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DRAW)
	e4:SetCost(c26064007.spcost)
	e4:SetTarget(c26064007.drtg)
	e4:SetOperation(c26064007.drop)
	c:RegisterEffect(e4)
--leave field
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetDescription(aux.Stringid(26064007,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c26064007.setcon)
	e5:SetTarget(c26064007.settg)
	e5:SetOperation(c26064007.setop)
	c:RegisterEffect(e5)
end
function c26064007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=c26064007.fliptg(e,tp,eg,ep,ev,re,r,rp,2)
	if chk==0 then return true end
	if b and Duel.SelectYesNo(tp,aux.Stringid(26064007,0)) then 
		e:SetTarget(c26064007.fliptg)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetOperation(c26064007.flipop)
	end
end
function c26064007.tdfilter(c)
	return c:IsSetCard(0x664) and c:IsAbleToDeck()
end
function c26064007.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==2 or chk==0 then return Duel.IsExistingMatchingCard(c26064007.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c26064007.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(tdfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	if g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,c):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064007,5))
		local opt=Duel.SelectOption(tp,aux.Stringid(26064007,6),aux.Stringid(26064007,7))
		Duel.ConfirmCards(tp,sg)
		if sg and Duel.SendtoDeck(sg,nil,opt,REASON_EFFECT) then
			Duel.ShuffleHand(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c26064007.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:GetCount()
	e:GetHandler():AddCounter(0x1b,ct)
end
function c26064007.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetCurrentChain()==0 and Duel.GetAttacker()==nil
end
function c26064007.lvfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FLIP) and c:IsLevelAbove(1)
end
function c26064007.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062001.grfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26064007.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanRemoveCounter(tp,0x1b,2,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26064007.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26064007.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1b)
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ctt,i = {},1
		while ct>=i*2 do
			ctt[i]=i*2
			i=i+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064007,4))
		val=Duel.AnnounceNumber(tp,table.unpack(ctt))
		c:RemoveCounter(tp,0x1b,val,REASON_EFFECT)
		e:GetHandler():RemoveCounter(tp,0x1b,val,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(val/2)
		tc:RegisterEffect(e1)
	end
end
function c26064007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,Duel.GetTurnCount(),0,0x1b)
end
function c26064007.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp) then
		c:AddCounter(0x1b,Duel.GetTurnCount())
	end
end
function c26064007.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp
end
function c26064007.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gy=Duel.GetFieldGroupCount(rp,0,LOCATION_GRAVE)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,gy,0,0x1b)
end
function c26064007.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gy=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
	if c:IsRelateToEffect(e) and Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp) then
		c:AddCounter(0x1b,gy)
	end
end