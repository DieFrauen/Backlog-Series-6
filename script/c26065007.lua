--Entrophys Regulator of Liquids
function c26065007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--transform spells
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c26065007.limit)
	e1:SetValue(0x665)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065007,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26063007,1))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(c26065007.tfcond)
	e1:SetTarget(c26065007.tftg)
	e1:SetOperation(c26065007.tfop)
	c:RegisterEffect(e1)
end
function c26065007.limit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c26065007.tfcond(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_SPELL) and rp~=tp
end
function c26065007.tfilter(c)
	return c:IsSummonable(false,nil) and c:IsSetCard(0x665)
end
function c26065007.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() end
end
function c26065007.tfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26065007.tfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26065007,2)) then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Summon(tp,tc,false,nil)
	end
end