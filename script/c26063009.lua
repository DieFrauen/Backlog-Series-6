--Astelloy Noble Guild
function c26063009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26063009,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26063009.target)
	c:RegisterEffect(e1)
	--normal summon normal monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063009,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c26063009.gcond)
	e2:SetTarget(c26063009.gtg)
	e2:SetOperation(c26063009.gop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetDescription(aux.Stringid(26063009,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,26063009)
	e3:SetCost(c26063009.tdcost)
	e3:SetTarget(c26063009.tdtg)
	e3:SetOperation(c26063009.tdop)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(c26063009.effilter)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4a)
	local e4b=e4:Clone()
	e4b:SetCode(EFFECT_CANNOT_DISABLE)
	e4b:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE)
	e4b:SetTarget(c26063009.effilter2)
	e4b:SetValue(1)
	c:RegisterEffect(e4b)
end
function c26063009.dfilter(c)
	return not c:IsType(TYPE_NORMAL) or not c:IsDiscardable()
end
function c26063009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	if chk==0 then return true end
	if #cg>0 and Duel.GetFlagEffect(tp,26063009)==0 and Duel.IsPlayerCanDraw(tp,#cg-1) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#cg-1)
		e:SetOperation(c26063009.activate)
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	else
		e:SetOperation(nil)
		e:SetCategory(0)
	end
end
function c26063009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,26063009)==0 and Duel.SelectYesNo(tp,aux.Stringid(26063009,0)) then
		Duel.RegisterFlagEffect(tp,26063009,RESET_PHASE+PHASE_END,0,1)
	else return end
	local cg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if #cg<1 then return end
	Duel.ConfirmCards(1-tp,cg)
	local g=Duel.GetMatchingGroup(c26063009.dfilter,tp,LOCATION_HAND,0,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,#cg-1,REASON_EFFECT)
end
function c26063009.cfilter(c)
	return c:IsType(TYPE_NORMAL) and c:GetSummonLocation(LOCATION_HAND)
end
function c26063009.gcond(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26063009.cfilter,1,nil,tp)
end
function c26063009.sumfilter(c,tp,tc)
	return c:IsSummonable(true,nil)
	and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	and c:IsAttribute(tc:GetAttribute()) and c:IsRace(tc:GetRace())
end
function c26063009.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c26063009.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp,tc)
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26063009.gop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26063009.sumfilter,ep,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp,tc)
	local sc=g:GetFirst()
	if sc then
		Duel.Summon(tp,sc,true,nil)
	end
end
function c26063009.effilter(e,ct)
	local te,tl=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x663) and te:IsActiveType(TYPE_MONSTER) and tl&(LOCATION_ONFIELD+LOCATION_GRAVE)~=0
end
function c26063009.effilter2(e,c)
	return c:IsSetCard(0x663) and c:IsType(TYPE_MONSTER)
end
function c26063009.sfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x663)
end
function c26063009.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,1,c) end
	local oc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,1,1,c):GetFirst()
	Duel.SendtoDeck(Group.FromCards(oc,c),nil,1,REASON_COST)
end
function c26063009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26063009.sfilter,tp,LOCATION_MZONE,0,1,nil)) or Duel.IsExistingMatchingCard(c26063009.sfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26063009.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26063009.sfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end