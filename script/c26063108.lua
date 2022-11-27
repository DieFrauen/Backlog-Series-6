

--Crystelloy Marshall - Adamante
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
	e1:SetCondition(aux.GeminiNormalCondition)
	c:RegisterEffect(e1)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c26063008.xcond)
	e0:SetTarget(c26063008.xtg)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--turn all to Gemini
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsGeminiState)
	e2:SetOperation(c26063008.gemop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2c)
	local e2d=e2:Clone()
	e2d:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2d)
	--gain effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.IsGeminiState)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c26063008.stat)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Alum
		local e71=Effect.CreateEffect(c)
		e71:SetType(EFFECT_TYPE_SINGLE)
		e71:SetCode(EFFECT_IMMUNE_EFFECT)
		e71:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e71:SetRange(LOCATION_MZONE)
		e71:SetLabel(26063002)
		e71:SetValue(c26063008.protval)
		c:RegisterEffect(e71)
	--Cypra
		local e72=Effect.CreateEffect(c)
		e72:SetType(EFFECT_TYPE_SINGLE)
		e72:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e72:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e72:SetRange(LOCATION_MZONE)
		e72:SetValue(aux.tgoval)
		e72:SetLabel(26063003)
		e72:SetCondition(c26063008.gcond)
		e72:SetValue(aux.tgoval)
		c:RegisterEffect(e72)
	--Ferrix
		local e73=Effect.CreateEffect(c)
		e73:SetType(EFFECT_TYPE_SINGLE)
		e73:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e73:SetRange(LOCATION_MZONE)
		e73:SetLabel(26063004)
		e73:SetCondition(c26063008.gcond)
		e73:SetValue(1)
		c:RegisterEffect(e73)
	--Niclas
		local e74=Effect.CreateEffect(c)
		e74:SetType(EFFECT_TYPE_SINGLE)
		e74:SetCode(EFFECT_UNRELEASABLE_SUM)
		e74:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e74:SetRange(LOCATION_MZONE)
		e74:SetLabel(26063005)
		e74:SetCondition(c26063008.gcond)
		e74:SetValue(1)
		c:RegisterEffect(e74)
		local e74a=e74:Clone()
		e74a:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e74a)
		local e74b=Effect.CreateEffect(c)
		e74b:SetType(EFFECT_TYPE_SINGLE)
		e74b:SetCode(EFFECT_CANNOT_REMOVE)
		e74b:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e74b:SetRange(LOCATION_MZONE)
		e74b:SetLabel(26063003)
		e74b:SetTargetRange(1,1)
		e74b:SetCondition(c26063008.gcond)
		e74b:SetTarget(c26063008.rmlimit)
		c:RegisterEffect(e74b)
end
function c26063008.stat(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	local v,v1,v2,v3,v4=0,0,0,0,0
	local gf=g:GetFirst()
	while gf do
	   if Card.GetCode(gf)==26063002 then v1=v1+1 end
	   if Card.GetCode(gf)==26063003 then v2=v2+3 end
	   if Card.GetCode(gf)==26063004 then v3=v3+4 end
	   if Card.GetCode(gf)==26063005 then v4=v4+2 end
	   gf=g:GetNext()
	end
	v=(v1+v2+v3+v4)*100
	return v
end
function c26063008.xyzcheck(g,tp,xyz)
	return g:GetClassCount(Card.GetCode)==#g
end
function c26063008.gcond(e)
	local c=e:GetHandler()
	return c:IsGeminiState() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,e:GetLabel())
end
function c26063008.xcond(e)
	local c=e:GetHandler()
	return not c:IsGeminiState() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26063001)
end
function c26063008.ovfilter(c)
	return c:IsType(TYPE_NORMAL+TYPE_GEMINI)
end
function c26063008.protval(e,te,tp)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated() and not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and not te:IsHasCategory(CATEGORY_DESTROY)
end
function c26063008.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end
function c26063008.xtg(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():EnableGeminiState()
	return true
end
--Gemini conversion
function c26063008.gemtg2(e,c)
	return c:IsSummonable(false,nil) and not c:IsGeminiState()
end
function c26063008.gemtg(c)
	return c:GetFlagEffect(26063008)==0
		and c:IsFaceup()
		and (c:IsType(TYPE_EFFECT) or ((c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT))
		and not c:IsType(TYPE_GEMINI)
		and c:IsSummonableCard()
end
function c26063008.gemop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26063008.gemtg,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=false
	if #g>=1 then tc=g:GetFirst() end
	while tc do
		tc:RegisterFlagEffect(26063008,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(aux.GeminiNormalCondition)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_GEMINI+TYPE_NORMAL)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetCondition(aux.GeminiNormalCondition)
		tc:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_REMOVE_TYPE)
		e4:SetValue(TYPE_EFFECT)
		c:RegisterEffect(e4)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_GEMINI_SUMMONABLE)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end