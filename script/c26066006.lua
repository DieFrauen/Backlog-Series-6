--Charon, the Riverbound
function c26066006.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c26066006.target)
	e1:SetOperation(c26066006.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(26066006)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26066006,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c26066006.thcost)
	e3:SetTarget(c26066006.thtg)
	e3:SetOperation(c26066006.thop)
	c:RegisterEffect(e3)
	--immune to necro valley
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_NECRO_VALLEY_IM)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(26066006,ACTIVITY_SPSUMMON,aux.FALSE)
end
c26066006.listed_series={0x666}
c26066006.listed_names={26066007,47355498}
function c26066006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c26066006.thfilter(c)
	return c:IsSetCard(0x4666) and c:IsAbleToHand()
end
function c26066006.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c26066006.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26066006.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c26066006.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c26066006.cfilter(e,c)
	return c:IsMonster() and c:IsCode(26066006) and e:GetHandler()~=c 
end
function c26066006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	if chk==0 then return Duel.GetCustomActivityCount(26066006,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_CARD,tp,26066006)
	c26066006.noss(e,tp)
end
function c26066006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=0
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
		for _,te in ipairs(ce) do
			ct=math.max(ct,te:GetValue())
		end
		return ct<3 and Duel.GetCustomActivityCount(26066006,tp,ACTIVITY_SPSUMMON)==0
	end
end
function c26066006.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c26066006.noss(e,tp)
end
function c26066006.noss(e,tp)
	if Duel.GetFlagEffect(tp,26066006)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TRUE)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,26066006,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,tp,26066006)
end
function c26066006.charon(c)
	return c:IsCode(26066006) and c:IsAbleToDeckAsCost() 
end
function c26066006.ferry(e,tp)
	local tg=Duel.GetMatchingGroup(c26066006.charon,tp,LOCATION_GRAVE,0,1,1,nil)
	if #tg>0 
	and Duel.GetCustomActivityCount(26066006,tp,ACTIVITY_SPSUMMON)==0 
	and Duel.SelectYesNo(tp,aux.Stringid(26066006,1)) then
		local tc=tg:Select(tp,1,1,nil)
		Duel.HintSelection(tc)
		Duel.SendtoDeck(tc,nil,1,REASON_COST)
		c26066006.noss(e,tp)
		return true
	end
	return false
end