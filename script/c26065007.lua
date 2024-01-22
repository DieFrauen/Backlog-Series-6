--Entrophys Regulator of Liquids
function c26065007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetOperation(c26065007.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065007,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabel(1)
	e2:SetCondition(c26065007.condition)
	e2:SetTarget(c26065007.target)
	e2:SetOperation(c26065007.activate)
	c:RegisterEffect(e2)
	--transform spells
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c26065007.limit)
	e3:SetValue(0x665)
	c:RegisterEffect(e3)
	--activate in reaction to spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26063007,6))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetLabel(0)
	e4:SetCondition(c26065007.tfcond)
	e4:SetTarget(c26065007.tftg)
	e4:SetOperation(c26065007.tfop)
	c:RegisterEffect(e4)
end
function c26065007.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and
	re:IsActiveType(TYPE_SPELL) and
	re:GetHandler()~=e:GetHandler()
end
function c26065007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26065007.thfilter,tp,LOCATION_DECK,0,nil)
	local b1=Duel.GetFlagEffect(tp,26065007)==0
	local b2=Duel.GetFlagEffect(tp,26065107)==0 and #g>0
	if chk==0 then return (b1 or b2) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26065007.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26065007.thfilter,tp,LOCATION_DECK,0,nil)
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.GetFlagEffect(tp,26065007)==0
	local b2=Duel.GetFlagEffect(tp,26065107)==0 and #g>0
	if (b1 or b2) and (e:GetLabel()==1 or Duel.SelectYesNo(tp,aux.Stringid(26065007,0))) then   
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(26065007,2)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(26065007,3)
			opval[off-1]=2
			off=off+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26065007,1))
		op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			c26065007.b1(e,tp,eg,ep,ev,re,r,rp)
		elseif opval[op]==2 then
			c26065007.b2(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c26065007.nsfilter(c,e)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(false,e)
end
function c26065007.b1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanAdditionalSummon(tp) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065007,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.GetMatchingGroup(c26065007.nsfilter,tp,LOCATION_HAND,0,nil,e1)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26065007,4)) then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.BreakEffect()
		Duel.Summon(tp,tc,false,nil)
	end
	Duel.RegisterFlagEffect(tp,26065007,RESET_PHASE+PHASE_END,0,1)
end
function c26065007.thfilter(c)
	return c:IsLevelBelow(4)
	and c:IsRace(RACE_AQUA)
	and c:IsType(TYPE_SPIRIT)
	and c:IsAbleToHand()
end
function c26065007.b2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c26065007.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	Duel.RegisterFlagEffect(tp,26065107,RESET_PHASE+PHASE_END,0,1)
end
function c26065007.limit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c26065007.tfcond(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_SPELL) and rp~=tp
end
function c26065007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp,true,true) end
end
function c26065007.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) and c:GetActivateEffect():IsActivatable(tp,true,true) and Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)~=0  then
		Duel.BreakEffect()
		c:CreateEffectRelation(e)
		c26065007.activate(e,tp,eg,ep,ev,re,r,rp)
	end
end