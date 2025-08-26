--Astelloy Vigilante - Cypra
function c26063003.initial_effect(c)
	--Gemini
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_GEMINI_SUMMONABLE)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0a:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e0a:SetCode(EFFECT_ADD_TYPE)
	e0a:SetCondition(c26063003.gemini)
	e0a:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0a)
	local e0b=e0a:Clone()
	e0b:SetCode(EFFECT_REMOVE_TYPE)
	e0b:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e0b)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Material effects
		local e1m=Effect.CreateEffect(c)
		e1m:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
		e1m:SetCode(EFFECT_UPDATE_ATTACK)
		e1m:SetCondition(c26063003.xmcond)
		e1m:SetTargetRange(LOCATION_MZONE,0)
		e1m:SetValue(300)
		e1m:SetTarget(c26063003.xmtg)
		c:RegisterEffect(e1m)
		local e2m=e1m:Clone()
		e2m:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2m)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--material effects
		local e3m=Effect.CreateEffect(c)
		e3m:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
		e3m:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3m:SetCondition(c26063003.xmcond)
		e3m:SetTargetRange(LOCATION_MZONE,0)
		e3m:SetTarget(c26063003.xmtg)
		e3m:SetValue(aux.tgoval)
		c:RegisterEffect(e3m)
	--normal summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26063003,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c26063003.gtg)
	e4:SetOperation(c26063003.gop)
	c:RegisterEffect(e4)
	--summon eff
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26063003,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,26063003)
	e5:SetCondition(Gemini.EffectStatusCondition)
	e5:SetTarget(c26063003.target)
	e5:SetOperation(c26063003.operation)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5a)
	local e5b=e5:Clone()
	e5b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5b)
end
function c26063003.xmcond(e,tp,eg,ep,ev,re,r,rp)
	local c,tp=e:GetHandler(),e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,26068010) and c:IsType(TYPE_EFFECT) then return c==e:GetHandler() end
	return c.StelloyEff1~=nil 
end
function c26063003.xmtg(e,c)
	local ec,tp=e:GetHandler(),e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,26068010) and c:IsType(TYPE_EFFECT) then return c==e:GetHandler() end
	return ec.StelloyEff1~=nil and ec.ovmtg(e,c)
end
function c26063003.gemini(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) or Gemini.NormalStatusCondition(e)
end
function c26063003.gfilter(c,tp)
	return c:IsSummonable(true,nil)
	and c:IsType(TYPE_NORMAL)
	and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c26063003.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26063003.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26063003.gop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26063003.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26063003.cfilter(c)
	return c:IsSetCard(0x663) and not c:IsCode(26063003) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c26063003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26063003.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26063003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26063003,2))
	local tc=Duel.SelectMatchingCard(tp,c26063003.cfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	aux.ToHandOrElse(tc,tp)
end
function c26063003.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and
	(e:IsCode(EVENT_SUMMON_SUCCESS) or
	e:IsCode(EVENT_SPSUMMON_SUCCESS) or
	e:IsCode(EVENT_FLIP_SUMMON_SUCCESS))
end