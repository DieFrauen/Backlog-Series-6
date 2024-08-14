--Entrophys Alchemist - Rebis
function c26065005.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,1,2,c26065005.lcheck)
	--summon spirits
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065005,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26065005)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(c26065005.spcond)
	e1:SetTarget(c26065005.sptg)
	e1:SetOperation(c26065005.spop)
	c:RegisterEffect(e1)
	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c26065005.atcon)
	e2:SetValue(c26065005.atlimit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26065005,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c26065005.thconM)
	e3:SetTarget(c26065005.thtgM)
	e3:SetOperation(c26065005.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCondition(c26065005.thconO)
	e4:SetTarget(c26065005.thtgO)
	c:RegisterEffect(e4)
end
function c26065005.lcheck(g,lc,sumtype,tp)
	return g:IsExists(c26065005.lfilter,1,nil,lc,sumtype,tp)
end
function c26065005.lfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_SPIRIT,lc,sumtype,tp)
	and not c:IsCode(26065005)
end
function c26065005.spcond(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x665) and rp~=tp
end
function c26065005.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg and sg:GetClassCount(Card.GetCode)==#sg and sg:GetClassCount(Card.GetAttribute)<2
end
function c26065005.spfilter(c,e,tp,zone)
	return c:IsType(TYPE_SPIRIT)
	and ((c:IsAttackBelow(2000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,zone))
	or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone))
end
function c26065005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=Duel.GetZoneWithLinkedCount(1,tp)&0x1f
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		local g=Duel.GetMatchingGroup(c26065005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,zone)
		return ct>0 and aux.SelectUnselectGroup(g,e,tp,1,2,c26065005.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26065005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=Duel.GetZoneWithLinkedCount(1,tp)&0x1f
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local sg=Duel.GetMatchingGroup(c26065005.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,zone)
	if #sg==0 or ct==0 then return end
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
	local rg=aux.SelectUnselectGroup(sg,e,tp,1,ct,c26065005.spcheck,1,tp,HINTMSG_SPSUMMON)
	if #rg>0 then
		Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP,zone)
	end
end
function c26065005.thconM(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (c:IsLinked() or c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN))
end
function c26065005.thconO(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLinked() or c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function c26065005.thtgM(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c26065005.thtgO(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c26065005.thfilter(c)
	return c:IsSetCard(0x665) and c:IsAbleToHand()
end
function c26065005.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26065005.thfilter),tp,LOCATION_GRAVE,0,nil)
	local sg=Group.FromCards(c)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26065005,3)) then
		sg=g:Select(tp,1,1,nil)
		sg:AddCard(c)
	end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c26065005.atfilter(c)
	return not c:IsType(TYPE_LINK)
end
function c26065005.atcon(e)
	return Duel.IsExistingMatchingCard(c26065005.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c26065005.atlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end