--The Desceptim Bephar
function c26067005.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetDescription(aux.Stringid(26067005,0))
	e1:SetLabel(0)
	e1:SetCondition(c26067005.decon)
	e1:SetTarget(c26067005.detg)
	e1:SetOperation(c26067005.deop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetLabel(1)
	e1a:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1a)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetLabel(0)
	e2:SetTarget(c26067005.sptg)
	e2:SetOperation(c26067005.spop)
	e2:SetCondition(c26067005.spcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--disable search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e4:SetTarget(c26067005.tgtg)
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
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	--e6:SetCountLimit(1,{26067005,1})
	e6:SetCondition(c26067005.condition)
	e6:SetTarget(c26067005.target)
	e6:SetOperation(c26067005.activate)
	c:RegisterEffect(e6)
end
function c26067005.decon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_DRAW))
	local ex3=(Duel.GetOperationInfo(ev,CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_SEARCH))
	if re:GetHandlerPlayer()~=e:GetHandlerPlayer() and ((ex1 and (dv1&LOCATION_DECK+LOCATION_GRAVE)~=0) or ex2 or ex3) then return true end
	return false
end
function c26067005.defilter(c)
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and (c:IsAbleToDeck() or c:IsAbleToGrave())
end
function c26067005.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_EXTRA 
	if Duel.IsPlayerAffectedByEffect(tp,26067009) then
		loc=loc+LOCATION_DECK 
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c26067005.defilter,tp,loc,0,1,e:GetHandler()) and (e:GetLabel()==0 or Duel.CheckPendulumZones(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067005.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==1 and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c26067005.defilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26067005.defilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26067009) and Duel.CheckLPCost(tp,700) then
		g:Merge(g2)
	end
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	local sc=sg:GetFirst()
	if sc:IsLocation(LOCATION_DECK) then
		Duel.PayLPCost(tp,700)
		Duel.RegisterFlagEffect(tp,26067009,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,26067209,RESET_PHASE+PHASE_END,0,1)
	end
	local b1=sc:IsAbleToDeck() or sc:IsAbleToChangeControler()
	local b2=sc:IsAbleToGrave()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067005,3))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26067005,4)},
		{b2,aux.Stringid(26067005,5)})
	if op==1 then
		if Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
			sc:ReverseInDeck()
			sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD &~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		end
	elseif op==2 then
		Duel.SendtoGrave(sc,REASON_EFFECT,1-tp)
	end
end
function c26067005.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabel()==0 or (e:GetLabel()==1 and e:GetHandler():GetFlagEffect(26067001)>0)
end
function c26067005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067005.thfilter(c)
	return c:IsSetCard(0x667) and c:IsAbleToHand()
end
function c26067005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067005.tgtg(e,c)
	local tp=e:GetHandlerPlayer()
	if e:GetLabel()==1 then tp=1-tp end
	local mdeck=Duel.GetDecktopGroup(tp,1):GetFirst()
	--local xd=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	--local xdeck=Duel.GetFieldCard(tp,LOCATION_EXTRA,xd-1)
	local gy=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local gydk=Duel.GetFieldCard(tp,LOCATION_GRAVE,gy-1)
	return (mdeck and mdeck:IsFaceup() and mdeck:IsSetCard(0x667) and c:GetSequence()<mdeck:GetSequence() and c:IsLocation(LOCATION_DECK))
	--or   (xdeck and xdeck:IsFaceup() and xdeck:IsSetCard(0x667) and c:GetSequence()<xdeck:GetSequence() and c:IsLocation(LOCATION_EXTRA))
	or   (gydk and gydk:IsFaceup() and gydk:IsSetCard(0x667) and c:GetSequence()<gydk:GetSequence() and c:IsLocation(LOCATION_GRAVE))
end
function c26067005.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067005.tefilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c26067005.t2filter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x667) and c:IsType(TYPE_PENDULUM)
end
function c26067005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26067005.tefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local g2=Duel.GetMatchingGroup(c26067005.t2filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,nil)
	g:Merge(g2)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c26067005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26067005.tefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local g2=Duel.GetMatchingGroup(c26067005.t2filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,nil)
	g:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end