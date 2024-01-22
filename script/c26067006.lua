--The Desceptim Berith
function c26067006.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabel(0)
	e1:SetCondition(c26067006.decon)
	e1:SetTarget(c26067006.detg)
	e1:SetOperation(c26067006.deop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetLabel(1)
	e1a:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1a)
	--when drawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetTarget(c26067006.sptg)
	e2:SetOperation(c26067006.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCondition(c26067006.spcon)
	c:RegisterEffect(e3)
	--disable tograve
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA)
	e4:SetTarget(c26067006.tgtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(2)
	e5:SetCondition(c26067006.tgcon)
	e5:SetLabel(0)
	c:RegisterEffect(e5)
	local e5b=e5:Clone()
	e5b:SetLabel(1)
	c:RegisterEffect(e5b)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	--e6:SetCountLimit(1,{26067006,1})
	e6:SetCondition(c26067006.condition)
	e6:SetTarget(c26067006.target)
	e6:SetOperation(c26067006.activate)
	c:RegisterEffect(e6)
end
function c26067006.decon(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandlerPlayer()==e:GetHandlerPlayer() then return false end
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DECKDES) or re:IsHasCategory(CATEGORY_DECKDES))
	local ex3=(Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_TOGRAVE))
	if (ex1 and (dv1&LOCATION_DECK)==LOCATION_DECK) or ex2 or ex3 then return true end
	return false
end
function c26067006.defilter(c)
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) 
end
function c26067006.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_EXTRA 
	if Duel.IsPlayerAffectedByEffect(tp,26067010) and Duel.CheckLPCost(tp,700) then
		loc=loc+LOCATION_DECK 
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c26067003.defilter,tp,loc,0,1,e:GetHandler()) and (e:GetLabel()==0 or Duel.CheckPendulumZones(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067006.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==1 and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c26067006.defilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26067006.defilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26067010) and Duel.CheckLPCost(tp,700) then
		g:Merge(g2)
	end
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	local sc=sg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067006,3))
	local opt=Duel.SelectOption(tp,aux.Stringid(26067006,4),aux.Stringid(26067006,5))
	if sc:IsLocation(LOCATION_DECK) then Duel.PayLPCost(tp,700) end
	if opt==0 then
		if Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
			sc:ReverseInDeck()
			sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD &~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		end
	elseif opt==1 then
		Duel.SendtoExtraP(sc,1-tp,REASON_EFFECT)
	end
end
function c26067006.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandlerPlayer()~=e:GetHandler():GetOwner()
end
function c26067006.tgfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and not c:IsForbidden()
end
function c26067006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetType()&EFFECT_TYPE_TRIGGER_F~=EFFECT_TYPE_TRIGGER_F or (not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067006.tgtg(e,c)
	local tp=e:GetHandlerPlayer()
	if e:GetLabel()==2 then tp=1-tp end
	local md1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local md2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local xd1=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	local xd2=Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)
	local xdk1=Duel.GetFieldCard(tp,LOCATION_EXTRA,xd1)
	local xdk2=Duel.GetFieldCard(1-tp,LOCATION_EXTRA,xd2)
	return (md1 and md1:IsFaceup() and md1:IsSetCard(0x667) and c:IsLocation(LOCATION_DECK))
	or   (md2 and md2:IsFaceup() and md2:IsSetCard(0x667) and c:IsLocation(LOCATION_DECK))
	or   (xdk1 and xdk1:IsFaceup() and xdk1:IsSetCard(0x667) and c:IsLocation(LOCATION_EXTRA))
	or   (xdk2 and xdk2:IsFaceup() and xdk2:IsSetCard(0x667) and c:IsLocation(LOCATION_EXTRA))
end
function c26067006.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if e:GetLabel()==1 then tp=1-tp end
	local mdeck=Duel.GetDecktopGroup(tp,1):GetFirst()
	return mdeck and mdeck:IsFaceup() and mdeck:IsSetCard(0x667)
end
function c26067006.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067006.tefilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and not c:IsForbidden() and c:GetOwner()==tp
end
function c26067006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067006.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,tp) end
end
function c26067006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067006,1))
	local g=Duel.SelectMatchingCard(tp,c26067006.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end