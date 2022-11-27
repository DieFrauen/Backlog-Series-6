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
	--gain effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.IsGeminiState)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c26063008.stat)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3b)
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
	--turn Gemini
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c26063008.gturn)
	e4:SetCondition(aux.IsGeminiState)
	c:RegisterEffect(e4)
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_DISABLE)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4a:SetTarget(c26063008.gturn)
	e4a:SetCondition(aux.IsGeminiState)
	c:RegisterEffect(e4a)
	local e4b=e4:Clone()
	e4b:SetCode(EFFECT_ADD_TYPE)
	e4b:SetValue(TYPE_GEMINI)
	c:RegisterEffect(e4b)
	local e4c=e4:Clone()
	e4c:SetCode(EFFECT_REMOVE_TYPE)
	e4c:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e4c)
	local e4d=e4:Clone()
	e4d:SetCode(EFFECT_GEMINI_SUMMONABLE)
	c:RegisterEffect(e4d)
end
function c26063008.gturn(e,c)
	return c:IsFaceup()
	and (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT 
	and (c:GetOriginalType()&TYPE_GEMINI)==0
	and c:IsSummonableCard()
	and not c:IsGeminiState()
end
function c26063008.distg(e,c)
	return not c==e:GetHandler()
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