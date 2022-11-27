--Blazon Field Marshal - Aurh
function c26062009.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,nil,2,99,nil,nil,nil,c26062009.matfilter)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
	e1:SetValue(c26062009.auhr)
	e1:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c26062009.regop)
	--e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c26062009.atkval)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c26062009.efilter)
	c:RegisterEffect(e4)
	--banish ALL
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(26062009,2)
	e5:SetCategory(CATEGORY_LVCHANGE+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c26062009.rmcon)
	e5:SetTarget(c26062009.rmtg)
	e5:SetOperation(c26062009.rmop)
	c:RegisterEffect(e5)
end
function c26062009.cfilter(c,sc,tp)
	return c:IsSetCard(0x662,sc,SUMMON_TYPE_SYNCHRO,tp) and not c:IsType(TYPE_TUNER,sc,SUMMON_TYPE_SYNCHRO,tp)
end
function c26062009.matfilter(g,sc,tp)
	return g:IsExists(c26062009.cfilter,1,nil,sc,tp)
end
function c26062009.auhr(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local val=Group.GetSum(g,Card.GetLevel)
	if val>=13 then return val else return 0 end
end
function c26062009.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) then
		local gc=c:GetMaterial():GetSum(Card.GetPreviousLevelOnField)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(gc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	--e:GetLabelObject():SetLabel(0)
end
function c26062009.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLevel)*100
end
--immunity
function c26062009.efilter(e,te)
	local c,tc=e:GetHandler(),te:GetHandler()
	return (not tc:HasLevel())
end
--banish ALL for lv gain
	--condition
function c26062009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)>=6
end
function c26062009.rmfilter(c,chn)
	return c:IsAbleToRemove() and (c:IsLocation(0x0a) or aux.SpElimFilter(c,false,true)) and c:IsPublic() and c:IsLevelBelow(chn)
end
function c26062009.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chn=e:GetLabel()
	if chk==0 then return true end
	local chn=Duel.GetCurrentChain()
	local g=Duel.GetMatchingGroup(c26062009.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE ,LOCATION_MZONE+LOCATION_GRAVE ,e:GetHandler(),chn)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	e:SetLabel(chn)
end
function c26062009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c,chn=e:GetHandler(),e:GetLabel()
	local g=Duel.GetMatchingGroup(c26062009.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE ,LOCATION_MZONE+LOCATION_GRAVE,c,chn)
	local rlv=Group.GetSum(g,Card.GetLevel)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(rlv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end