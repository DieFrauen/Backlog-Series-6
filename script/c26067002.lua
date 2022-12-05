--The Desceptim Lerash
function c26067002.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--place in opponent deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26067002.decond)
	e1:SetCost(c26067002.decost)
	e1:SetTarget(c26067002.detg)
	e1:SetOperation(c26067002.deop)
	c:RegisterEffect(e1)
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
	--disable search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_DECK,0)
	e4:SetLabel(0)
	e4:SetCondition(c26067002.pcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetTargetRange(0,LOCATION_DECK)
	e5:SetLabel(1)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,{26067002,1})
	e6:SetCondition(c26067002.condition)
	e6:SetTarget(c26067002.target)
	e6:SetOperation(c26067002.activate)
	c:RegisterEffect(e6)
	--pendulum effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,{26067002,2})
	e1:SetTarget(c26067002.tdtg)
	e1:SetOperation(c26067002.tdop)
	c:RegisterEffect(e1)
end
function c26067002.decond(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetTurnPlayer()~=tp
end
function c26067002.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067002.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26067002.filter(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c26067002.defilter,tp,LOCATION_HAND,0,1,c) and not c:IsPublic() end
	local tc=Duel.SelectMatchingCard(tp,c26067002.defilter,tp,LOCATION_HAND,0,1,1,c):GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c26067002.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067002.defilter,tp,LOCATION_HAND,0,1,nil) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067002.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave()
	if Duel.SendtoDeck(c,1-tp,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		c:ReverseInDeck()
		c:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
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
function c26067002.pcon(e)
	local p=e:GetHandlerPlayer()
	if e:GetLabel()==1 then p=1-p end
	local tc=Duel.GetDecktopGroup(p,1):GetFirst()
	return tc and tc:IsSetCard(0x667) and tc:IsFaceup()
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
function c26067002.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067002.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,tp,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		c:ReverseInDeck()
		c:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(2)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
end