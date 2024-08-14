--Crystelloy Marshall - Diamundo
function c26063008.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_NORMAL+TYPE_GEMINI),4,3,nil,nil,99,nil,false,c26063008.xyzcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(TYPE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Gemini.NormalStatusCondition)
	c:RegisterEffect(e1)
	--gemini
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c26063008.spcon)
	e0:SetOperation(c26063008.spop)
	c:RegisterEffect(e0)
	--geminize
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(Gemini.EffectStatusCondition)
	e2:SetCode(26063008)
	c:RegisterEffect(e2)
	--geminize
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IMMEDIATELY_APPLY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26063008.gemcon)
	e3:SetOperation(c26063008.gemop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c26063008.StelloyEff1=true
function c26063008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,26063001)
end
function c26063008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,tp,26063008)
	c:EnableGeminiStatus()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,64)
end
function c26063008.ovmtg(e,c)
	return c==e:GetHandler() or not c:IsType(TYPE_EFFECT)
end
function c26063008.gemcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(0,26063008) or Duel.IsPlayerAffectedByEffect(1,26063008)
end
function c26063008.distg(e,c)
	return not c==e:GetHandler()
end
function c26063008.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetCode)==#g
end
function c26063008.gcond(e)
	local c=e:GetHandler()
	return Gemini.EffectStatusCondition(e) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,e:GetLabel())
end
function c26063008.xcond(e)
	local c=e:GetHandler()
	return Gemini.NormalStatusCondition(e) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26063001)
end
function c26063008.ovfilter(c)
	return c:IsType(TYPE_NORMAL+TYPE_GEMINI)
end
function c26063008.xtg(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():EnableGeminiState()
	return true
end
function c26063008.gemfilter(c)
	return c:IsFaceup()
	and (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT 
	and (c:GetOriginalType()&TYPE_GEMINI)==0
	and c:IsSummonableCard()
	and not c:IsGeminiStatus()
end
function c26063008.gemcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26063008.gemfilter,1,nil) and e:GetHandler():IsGeminiStatus()
end
function c26063008.gemop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c26063008.gemfilter,nil)
	for tc in g:Iter() do
		--turn Gemini
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_GEMINI)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetCondition(Gemini.NormalStatusCondition)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_GEMINI_SUMMONABLE)
		e6:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e6)
	end
	if #g>0 then Duel.Hint(HINT_CARD,1-tp,26063008) end
end
function c26063008.gturn(e,c)
	return c:IsFaceup()
	and c:IsType(TYPE_GEMINI) 
	and (c:GetOriginalType()&TYPE_GEMINI)==0
	and c:IsSummonableCard()
	and not c:IsGeminiStatus()
end