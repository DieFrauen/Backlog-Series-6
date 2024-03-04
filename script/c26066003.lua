--Siphantom Acheros
function c26066003.initial_effect(c)
	--Can also tribute opposing Special Summoned monsters
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c26066003.ming)
	e1:SetValue(POS_FACEUP)
	e1:SetCondition(c26066003.spcon)
	c:RegisterEffect(e1)
	--Search 1 "Siphantom" Monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26066003,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26066003)
	e2:SetCondition(c26066003.thcon)
	e2:SetTarget(c26066003.thtg)
	e2:SetOperation(c26066003.thop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2:SetDescription(aux.Stringid(26066003,1))
	e2a:SetCode(EVENT_RELEASE)
	e2a:SetCondition(c26066003.sumtrcon)
	c:RegisterEffect(e2a)
end
function c26066003.ming(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26066003.mfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	return tg:IsContains(c)
end
function c26066003.mfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c26066003.spfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL 
end
function c26066003.spcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26066003.spfilter,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c26066003.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26066003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE)
end
function c26066003.sumtrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function c26066003.thfilter(c)
	return c:IsSetCard(0x666) and c:IsMonster() and c:IsAbleToHand()
end
function c26066003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26066003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26066003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26066003,3))
	if c26066003.disable(e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26066003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26066003.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c26066003.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26066003.rthop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26066003,3))
	if c26066003.disable(e,tp) then return end
	if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)==1 then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c26066003.cfilter(c)
	return c:IsMonster() and c:IsReleasableByEffect()
end
function c26066003.disable(e,tp)
	local p=1-tp
	local g=Duel.GetMatchingGroup(c26066003.cfilter,p,LOCATION_HAND,0,nil,tp)
	local kozi=Duel.IsPlayerAffectedByEffect(tp,26066002)
	local p1=true
	local p2= (not kozi and #g>0)
	local p3= (kozi and #g>0)
	local op=Duel.SelectEffect(p,
		{p2,aux.Stringid(26066003,5)},
		{p1,aux.Stringid(26066003,4)},
		{p3,aux.Stringid(26066003,6)})
	if op==2 then return false
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RELEASE)
		sg:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
		if op==1 then
			Duel.NegateEffect(0)
			return true
		end
	end
end