--Astelloy Guard - Ferrix
function c26063004.initial_effect(c)
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
	e0a:SetCondition(c26063004.gemini)
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
	e1:SetValue(200)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Material effects
		local e1m=Effect.CreateEffect(c)
		e1m:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
		e1m:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1m:SetCode(EFFECT_UPDATE_ATTACK)
		e1m:SetCondition(c26063004.xmcond)
		e1m:SetTargetRange(LOCATION_MZONE,0)
		e1m:SetValue(200)
		e1m:SetTarget(c26063004.xmtg)
		c:RegisterEffect(e1m)
		local e2m=e1m:Clone()
		e2m:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2m)
	--indestructible
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--material effects
		local e3m=Effect.CreateEffect(c)
		e3m:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
		e3m:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3m:SetCondition(c26063004.xmcond)
		e3m:SetTargetRange(LOCATION_MZONE,0)
		e3m:SetTarget(c26063004.xmtg)
		e3m:SetValue(1)
		c:RegisterEffect(e3m)
	--normal summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26063004,0))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(c26063004.gtg)
	e5:SetOperation(c26063004.gop)
	c:RegisterEffect(e5)
	--summon eff
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26063004,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCountLimit(1,26063004)
	e6:SetCondition(Gemini.EffectStatusCondition)
	e6:SetTarget(c26063004.target)
	e6:SetOperation(c26063004.operation)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6a)
	local e6b=e6:Clone()
	e6b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6b)
end
function c26063004.xmcond(e,tp,eg,ep,ev,re,r,rp)
	local c,tp=e:GetHandler(),e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,26068010) and c:IsType(TYPE_EFFECT) then return c==e:GetHandler() end
	return c.StelloyEff1~=nil 
end
function c26063004.xmtg(e,c)
	local ec,tp=e:GetHandler(),e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,26068010) and c:IsType(TYPE_EFFECT) then return c==e:GetHandler() end
	return ec.StelloyEff1~=nil and ec.ovmtg(e,c)
end
function c26063004.gemini(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) or Gemini.NormalStatusCondition(e) 
end
function c26063004.gfilter(c,tp)
	return c:IsSummonable(true,nil)
	and c:IsType(TYPE_NORMAL)
	and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c26063004.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26063004.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26063004.gop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26063004.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26063004.filter(c)
	return c:IsSetCard(0x663) and c:IsMonster() and c:IsAbleToHand()
end
function c26063004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26063004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26063004.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26063004.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c26063004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		if #sg==2 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
