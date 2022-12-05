--The Desceptim Balberith
function c26067006.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,26067006)
	e1:SetCondition(c26067006.decon)
	e1:SetTarget(c26067006.detg)
	e1:SetOperation(c26067006.deop)
	c:RegisterEffect(e1)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(0)
	e2:SetTarget(c26067006.sptg)
	e2:SetOperation(c26067006.spop)
	e2:SetCondition(c26067006.spcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--disable search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e4:SetTarget(c26067006.tgtg)
	e4:SetValue(1)
	e4:SetLabel(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetTargetRange(0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
	e5:SetLabel(1)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	--e6:SetCountLimit(1,{26067006,1})
	e6:SetCondition(c26067006.condition)
	e6:SetTarget(c26067006.target)
	e6:SetOperation(c26067006.activate)
	c:RegisterEffect(e6)
end
function c26067006.decon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if (ex1 and (dv1&LOCATION_DECK)==LOCATION_DECK) then return true end
	return false
end
function c26067006.defilter(c)
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067006.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067004.defilter,tp,LOCATION_HAND,0,1,nil) and Duel.CheckPendulumZones(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067006.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)==0 then return end
	local g=Duel.GetMatchingGroup(c26067006.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if #sg>0 and Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
		sc:ReverseInDeck()
		sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD &~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
	end
end
function c26067006.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabel()==0 or (e:GetLabel()==1 and e:GetHandler():GetFlagEffect(26067001)>0)
end
function c26067006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067006.tgtg(e,c,sump,sumtype,sumpos,targetp,se)
	local tp=e:GetHandlerPlayer()
	if c:IsSetCard(0x667) then return end
	if sumtype==SUMMON_TYPE_PENDULUM then return false end
	if e:GetLabel()==1 then tp=1-tp end
	local mdeck=Duel.GetDecktopGroup(tp,1):GetFirst()
	local xd=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	local xdeck=Duel.GetFieldCard(tp,LOCATION_EXTRA,xd-1)
	local gy=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local gydk=Duel.GetFieldCard(tp,LOCATION_GRAVE,gy-1)
	return (mdeck and mdeck:IsFaceup() and mdeck:IsSetCard(0x667) and c:GetSequence()<mdeck:GetSequence() and c:IsLocation(LOCATION_DECK))
	or  (xdeck and xdeck:IsFaceup() and xdeck:IsSetCard(0x667) and c:GetSequence()<xdeck:GetSequence() and c:IsLocation(LOCATION_EXTRA))
	or  (gydk and gydk:IsFaceup() and gydk:IsSetCard(0x667) and c:GetSequence()<gydk:GetSequence() and c:IsLocation(LOCATION_GRAVE))
end
function c26067006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_REMOVED and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.SelectYesNo(tp,aux.Stringid(77631175,0)) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		return true
	else return false end
end
function c26067006.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067006.spfilter(c,e,tp)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 then return false end
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsSetCard(0x667) and
	c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26067006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067006.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c26067006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26067006.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
