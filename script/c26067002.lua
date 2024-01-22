--The Desceptim Lerash
function c26067002.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetDescription(aux.Stringid(26067002,0))
	e1:SetLabel(0)
	e1:SetCondition(c26067002.decon)
	e1:SetTarget(c26067002.detg)
	e1:SetOperation(c26067002.deop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetLabel(1)
	e1a:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1a)
	--when drawn effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetLabel(0)
	e2:SetTarget(c26067002.sptg)
	e2:SetOperation(c26067002.spop)
	e2:SetCondition(c26067002.spcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--Activate
	local e6=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067002,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,{26067002,1})
	e6:SetCondition(c26067002.condition)
	e6:SetTarget(c26067002.target)
	e6:SetOperation(c26067002.activate)
	c:RegisterEffect(e6)
end
function c26067002.decon(e,tp,eg,ep,ev,re,r,rp,chk)
	--condition 1: Special Summons (from GY)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	--condition 2: Targets a card(s) in GY
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ex2=re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
	--condition 3: activates itself from GY
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local ex3=loc==LOCATION_GRAVE 

	if (ex1 and (dv1&LOCATION_GRAVE)==LOCATION_GRAVE) or ex2 or ex3 then return true end
	return false
end
function c26067002.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067002.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067002.defilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,CATEGORY_TOHAND)
end
function c26067002.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26067004.defilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	local g2=Duel.GetMatchingGroup(c26067004.defilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsPlayerAffectedByEffect(tp,26067010) and Duel.CheckLPCost(tp,700) then
		g:Merge(g2)
	end
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	local sc=sg:GetFirst()
	if sc:IsLocation(LOCATION_DECK) then Duel.PayLPCost(tp,700) end
	if Duel.SendtoGrave(sc,REASON_EFFECT,1-tp)~=0 and Duel.CheckPendulumZones(tp) and Duel.SelectYesNo(tp,aux.Stringid(26067002,3)) then
		local sc=g2:Select(tp,1,1,nil):GetFirst()
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c26067002.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetLabel()==0 or (e:GetLabel()==1 and e:GetHandler():GetFlagEffect(26067001)>0)
end
function c26067002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26067002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,op,op,false,false,POS_FACEUP)
	end
end
function c26067002.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) or c:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c26067002.thfilter(c)
	return c:IsSetCard(0x667) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26067002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067004.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
end
function c26067002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26067002.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end