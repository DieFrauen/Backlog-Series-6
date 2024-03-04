--Siphantasm Advance
function c26066009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26066009.target)
	e1:SetOperation(c26066009.activate)
	c:RegisterEffect(e1)
	--Register Special Summons from the Extra Deck
	aux.GlobalCheck(c26066009,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26066009.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26066009.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in eg:Iter() do
		local sp=tc:GetSummonPlayer()
		Duel.RegisterFlagEffect(sp,26066009,RESET_PHASE|PHASE_END,0,2)
	end
end
function c26066009.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x666)
end
function c26066009.filter2(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x666)
end
function c26066009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1=not Duel.HasFlagEffect(tp,26066009,1)
	local p2=Duel.HasFlagEffect(1-tp,26066009,1)
	if chk==0 then return (p1 or p2) and 
	(Duel.IsExistingMatchingCard(c26066009.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) or 
	Duel.IsExistingMatchingCard(c26066009.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26066009.activate(e,tp,eg,ep,ev,re,r,rp)
	local p1=(not Duel.HasFlagEffect(tp,26066009,1))
	local p2=(  Duel.HasFlagEffect(1-tp,26066009,1))
	local b1=(Duel.IsExistingMatchingCard(c26066009.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil))
	local b2=(Duel.IsExistingMatchingCard(c26066009.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil))
	local p3=(Duel.IsExistingMatchingCard(c26066009.filter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0,1,nil))
	local b3=(b2 and p3 and p1 and p2)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(26066009,0))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26066009,1)},
		{b2,aux.Stringid(26066009,2)},
		{b3,aux.Stringid(26066009,3)})
	if op~=2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c26066009.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g1 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
	if op~=1 then 
		local g2=Duel.SelectMatchingCard(tp,c26066009.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.Summon(tp,tc2,true,nil)
		end
	end
end
