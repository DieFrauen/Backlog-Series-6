--Over-wind Planetarium
function c26064007.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetDescription(aux.Stringid(26064007,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,26064007,EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(c26064007.activate)
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
	--atkdown
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c26064007.atktg)
	e4:SetValue(c26064007.atkval)
	c:RegisterEffect(e4)
end
c26064007.FLIP=true
function c26064007.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26064007.tdfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26064007,0)) then
		c26064007.flipop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c26064007.atkval(e,c)
	return e:GetHandler():GetCounter(0x1b)*-50
end
function c26064007.fil(c)
	local tid=Duel.GetTurnCount()
	return not (c:IsType(TYPE_FLIP) or c:GetTurnID()==tid)
end
function c26064007.atktg(e,c)
	return c26064007.fil(c)
end
function c26064007.target(e,tp,eg,ep,ev,re,r,rp,chk)
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
	if chk==2 or chk==0 then return Duel.IsExistingMatchingCard(c26064007.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c26064007.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26064007.tdfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,c):GetFirst()
		local opt=0
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064007,3))
			opt=Duel.SelectOption(tp,aux.Stringid(26064007,4),aux.Stringid(26064007,5))
		end
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
function c26064007.lvfilter(c,ct)
	return c:IsFaceup()
	and c:IsType(TYPE_FLIP)
	and c:HasLevel()
	and (c:IsLevelAbove(2) or (ct>1))
end
function c26064007.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1b)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062007.lvfilter(chkc,ct) end
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1b,1,REASON_EFFECT) and Duel.IsExistingTarget(c26064007.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26064007.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ct)
end
function c26064007.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.min(c:GetCounter(0x1b),Duel.GetTurnCount())
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		lv=Duel.AnnounceLevel(tp,1,ct,tc:GetLevel())
		c:RemoveCounter(tp,0x1b,lv,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
	end
end