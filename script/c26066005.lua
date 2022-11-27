--The Desceptim Vephar
function c26066005.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,26066005)
	e1:SetCondition(c26066005.decon)
	e1:SetTarget(c26066005.detg)
	e1:SetOperation(c26066005.deop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26066005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetLabel(0)
	e2:SetTarget(c26066005.sptg)
	e2:SetOperation(c26066005.spop)
	e2:SetCondition(c26066005.spcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,{26066005,1})
	e4:SetCondition(c26066005.condition)
	e4:SetTarget(c26066005.target)
	e4:SetOperation(c26066005.activate)
	c:RegisterEffect(e4)
	--sort opponent deck
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c26066005.decon)
	e5:SetTarget(c26066005.dktg)
	e5:SetOperation(c26066005.dkop)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e5a)
	local e5b=e5:Clone()
	e5b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5b)
end
function c26066005.cfilter(c,tp)
	return (c:IsControler(tp) or c:IsSummonPlayer(tp)) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c26066005.decon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26066005.cfilter,1,nil,1-tp) 
end
function c26066005.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666) and c:IsAbleToDeck()
end
function c26066005.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26066005.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26066005.defilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,e:GetHandler())
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26066005,2)) then
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		if sc and Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
			sc:ReverseInDeck()
			sc:RegisterFlagEffect(26066001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26066001,2))
		end
	end
end
function c26066005.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(26066001)>0 or e:GetType()&EFFECT_TYPE_TRIGGER_O ~=0
end
function c26066005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26066005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26066005.pcon(e)
	local p=e:GetHandlerPlayer()
	if e:GetLabel()==1 then p=1-p end
	local tc=Duel.GetDecktopGroup(p,1):GetFirst()
	return tc and tc:IsSetCard(0x666) and tc:IsFaceup()
end
function c26066005.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26066005.tefilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c26066005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26066005.tefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c26066005.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26066005,0))
	local g=Duel.SelectMatchingCard(tp,c26066005.tefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c26066005.dkfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666) and c:IsFaceup()
end
function c26066005.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local top=Duel.GetDecktopGroup(1-tp,1)
	if #top>0 and top:GetFirst():IsFaceup() then return false end
	if chk==0 then
		local g=Duel.GetMatchingGroup(c26066005.dkfilter,1-tp,LOCATION_DECK,0,nil,tp)
		return #g>0
	end
end
function c26066005.dkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26066005.dkfilter,1-tp,LOCATION_DECK,0,nil,tp)
	if #rg>0 then
		local rg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,rg)
		--Duel.ShuffleDeck(tp)
		Duel.MoveToDeckTop(rg)
	end
end