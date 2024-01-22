--The Desceptim Moloch
function c26067003.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetDescription(aux.Stringid(26067003,0))
	e1:SetLabel(0)
	e1:SetCondition(c26067003.decon)
	e1:SetTarget(c26067003.detg)
	e1:SetOperation(c26067003.deop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetLabel(1)
	e1a:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1a)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(0)
	e2:SetTarget(c26067003.sptg)
	e2:SetOperation(c26067003.spop)
	e2:SetCondition(c26067003.spcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e4:SetTarget(c26067003.tgtg)
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
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	--e6:SetCountLimit(1,{26067003,1})
	e6:SetCondition(c26067003.condition)
	e6:SetTarget(c26067003.target)
	e6:SetOperation(c26067003.activate)
	c:RegisterEffect(e6)
end
function c26067003.decon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	if ex1 and re:GetHandlerPlayer()~=e:GetHandlerPlayer() then return true end
	return false
end
function c26067003.defilter(c)
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and (c:IsAbleToDeck() or c:IsAbleToGrave())
end
function c26067003.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_EXTRA 
	if Duel.IsPlayerAffectedByEffect(tp,26067010) then
		loc=loc+LOCATION_DECK 
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c26067003.defilter,tp,loc,0,1,nil) and (e:GetLabel()==0 or Duel.CheckPendulumZones(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067003.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==1 and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)==0 then return end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c26067003.defilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26067003.defilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26067010) then
		g:Merge(g2)
	end
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	local sc=sg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067003,3))
	local opt=Duel.SelectOption(tp,aux.Stringid(26067003,4),aux.Stringid(26067003,5))
	if opt==0 then
		if Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
			sc:ReverseInDeck()
			sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD &~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		end
	elseif opt==1 then
		Duel.SendtoGrave(sc,REASON_EFFECT,1-tp)
	end
end
function c26067003.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabel()==0 or (e:GetLabel()==1 and e:GetHandler():GetFlagEffect(26067001)>0)
end
function c26067003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067003.tgtg(e,c,sump,sumtype,sumpos,targetp,se)
	local tp=e:GetHandlerPlayer()
	--if c:IsSetCard(0x667) then return end
	if sumtype==SUMMON_TYPE_PENDULUM then return false end
	if e:GetLabel()==1 then tp=1-tp end
	local mdeck=Duel.GetDecktopGroup(tp,1):GetFirst()
	local gy=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local gydk=Duel.GetFieldCard(tp,LOCATION_GRAVE,gy-1)
	return (mdeck and mdeck:IsFaceup() and mdeck:IsSetCard(0x667) and c:GetSequence()<mdeck:GetSequence() and c:IsLocation(LOCATION_DECK))
	or  (gydk and gydk:IsFaceup() and gydk:IsSetCard(0x667) and c:GetSequence()<gydk:GetSequence() and c:IsLocation(LOCATION_GRAVE))
end
function c26067003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_REMOVED and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.SelectYesNo(tp,aux.Stringid(77631175,0)) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		return true
	else return false end
end
function c26067003.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067003.spfilter(c,e,tp)
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 then return false end
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsSetCard(0x667) and
	c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and  c:GetOwner()==e:GetHandlerPlayer()
end
function c26067003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067003.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,LOCATION_EXTRA+LOCATION_GRAVE,1,nil,e,tp) end
end
function c26067003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26067003.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,LOCATION_EXTRA+LOCATION_GRAVE,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
