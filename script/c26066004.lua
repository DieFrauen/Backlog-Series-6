--Siphantom Lethos
function c26066004.initial_effect(c)
	--summon with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26066004,3))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c26066004.ntcon)
	c:RegisterEffect(e0)
	--Can also tribute trap  cards for its tribute summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCondition(c26066004.nscon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsTrap))
	e1:SetValue(POS_FACEUP)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetTargetRange(LOCATION_HAND,0)
	e1a:SetCondition(c26066004.nscon2)
	c:RegisterEffect(e1a)
	--Search 1 "Siphant" Spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26066004,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(2,26066004)
	--e2:SetCondition(c26066004.trsumcon)
	e2:SetTarget(c26066004.thtg)
	e2:SetOperation(c26066004.thop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2:SetDescription(aux.Stringid(26066004,1))
	e2a:SetCode(EVENT_RELEASE)
	e2a:SetCondition(c26066004.sumtrcon)
	c:RegisterEffect(e2a)
	--return self to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26066004,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCountLimit(2,26066004)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c26066004.rthcon)
	e3:SetTarget(c26066004.rthtg)
	e3:SetOperation(c26066004.rthop)
	c:RegisterEffect(e3)
end
function c26066004.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c26066004.nscon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c26066004.nscon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(tp,26066007) and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c26066004.trsumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function c26066004.sumtrcon(e,tp,eg,ep,ev,re,r,rp)
	return true --e:GetHandler():IsReason(REASON_SUMMON)
end
function c26066004.thfilter(c)
	return c:IsSetCard(0x666) and c:IsTrap() and c:IsAbleToHand()
end
function c26066004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26066004.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,26066004)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.RegisterFlagEffect(tp,26066004,RESET_CHAIN,0,1)
end
function c26066004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26066004,4))
	if c26066004.disable(e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26066004.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26066004.gfilter(c,g)
	return g:IsContains(c) and c:IsTrap()
end
function c26066004.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and rp~=tp 
end
function c26066004.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) and Duel.GetFlagEffect(tp,26066004) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.RegisterFlagEffect(tp,26066004,RESET_CHAIN,0,1)
end
function c26066004.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26066004,4))
	if c26066004.disable(e,tp) then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)==1 then
		Duel.ConfirmCards(1-tp,c)
	end
end
function c26066004.cfilter(c,tp)
	return c:IsTrap() and Duel.IsPlayerCanRelease(tp,c)
end
function c26066004.disable(e,tp)
	local p=1-tp
	local g=Duel.GetMatchingGroup(c26066004.cfilter,p,LOCATION_HAND,0,nil,tp)
	local kozi=Duel.IsPlayerAffectedByEffect(tp,26066002)
	local p1=true
	local p2= (not kozi and #g>0)
	local p3= (kozi and #g>0)
	local op=Duel.SelectEffect(p,
		{p2,aux.Stringid(26066004,6)},
		{p1,aux.Stringid(26066004,5)},
		{p3,aux.Stringid(26066004,7)})
	if op==2 then return false
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
		sg:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
		if op==1 then
			if Duel.IsPlayerAffectedByEffect(tp,26066006) then
				if c26066006.ferry(e,tp) then
					return false
				else 
					Duel.NegateEffect(0)
					return true
				end
			else
				Duel.NegateEffect(0)
				return true
			end
		end
	end
end