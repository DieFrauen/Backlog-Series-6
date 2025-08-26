--The Desceptim Amonel
function c26067001.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--play Towerbridge of Lemegeton
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,26067001)
	e1:SetCondition(c26067001.decon1)
	e1:SetTarget(c26067001.detg1)
	e1:SetOperation(c26067001.deop1)
	c:RegisterEffect(e1)
	--tamper draw effect
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_QUICK_O)
	e1a:SetCode(EVENT_CHAINING)
	e1a:SetRange(LOCATION_HAND+LOCATION_PZONE)
	e1a:SetCountLimit(1,26067004)
	e1a:SetCondition(c26067001.decon2)
	e1a:SetTarget(c26067001.detg2)
	e1a:SetOperation(c26067001.deop2)
	c:RegisterEffect(e1a)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetLabel(0)
	e2:SetCondition(c26067001.spcon)
	e2:SetTarget(c26067001.sptg)
	e2:SetOperation(c26067001.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c26067001.condition)
	e4:SetTarget(c26067001.target)
	e4:SetOperation(c26067001.activate)
	c:RegisterEffect(e4)
end
function c26067001.defilter(c,tp,dck)
	return c:IsCode(26067009) and (dck or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function c26067001.decon1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local atype=re:GetActiveType()
	local rc=re:GetHandler()
	return atype==TYPE_PENDULUM+TYPE_SPELL and (loc&LOCATION_PZONE)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc~=e:GetHandler() and rc:IsSetCard(0x667) and rp==tp
end
function c26067001.detg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067001.defilter,tp,LOCATION_DECK,0,1,nil,tp,false)and not Duel.IsExistingMatchingCard(c26067001.defilter,tp,LOCATION_FZONE,0,1,nil,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067001.deop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstMatchingCard(c26067001.defilter,tp,LOCATION_DECK,0,nil,tp)
	Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp) 
end
function c26067001.decon2(e,tp,eg,ep,ev,re,r,rp)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_DRAW))
	return ex2 and rp~=tp
end
function c26067001.defilter2(c)
	return not c:IsForbidden() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067001.detg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,26067009) and Duel.CheckLPCost(tp,700) then
		loc=loc+LOCATION_DECK 
	end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26067001.defilter2,tp,loc,0,1,e:GetHandler()) and not (c:IsLocation(LOCATION_HAND) and c:IsPublic()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,loc)
end
function c26067001.deop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_PZONE) and not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26067006.defilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26067006.defilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26067009) and Duel.CheckLPCost(tp,700) then
		g:Merge(g2)
	end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.PayLPCost(tp,700)
		Duel.RegisterFlagEffect(tp,26067009,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,26067209,RESET_PHASE+PHASE_END,0,1)
	end
	if tc and Duel.SendtoDeck(tc,1-tp,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		tc:ReverseInDeck()
		tc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD &~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
	end
end
function c26067001.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabel()==0 or (e:GetLabel()==1 and e:GetHandler():GetFlagEffect(26067001)>0)
end
function c26067001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=e:GetHandler():GetOwner()
	if chk==0 then return e:GetType()&EFFECT_TYPE_TRIGGER_F~=EFFECT_TYPE_TRIGGER_F or --not e:GetHandler():IsStatus(STATUS_CHAINING) and
	(Duel.GetLocationCount(op,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,op,false,false)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067001.thfilter(c)
	return c:IsSetCard(0x667) and c:IsAbleToHand()
end
function c26067001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	local g=Duel.GetMatchingGroup(c26067001.thfilter,op,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067001.pcon(e)
	local p=e:GetHandlerPlayer()
	if e:GetLabel()==1 then p=1-p end
	local tc=Duel.GetDecktopGroup(p,1):GetFirst()
	return tc and tc:IsSetCard(0x667) and tc:IsFaceup()
end
function c26067001.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) or Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c26067001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end