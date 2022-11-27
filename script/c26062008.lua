--Blazon General - Argus
function c26062008.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsLevelBelow,1),1,1,Synchro.NonTunerEx(Card.IsSetCard,0x662),1,1)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,26062008),LOCATION_ONFIELD)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c26062008.lvtg)
	e1:SetValue(c26062008.lvval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c26062008.regop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c26062008.atkval)
	c:RegisterEffect(e3)
	--Argent
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26062008,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c26062008.spcon)
	e4:SetTarget(c26062008.sptg)
	e4:SetOperation(c26062008.spop)
	c:RegisterEffect(e4)
	local e4b=Effect.CreateEffect(c)
	e4b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4b:SetRange(LOCATION_MZONE)
	e4b:SetTargetRange(LOCATION_GRAVE,0)
	e4b:SetTarget(c26062008.eftg)
	e4b:SetLabelObject(e4)
	c:RegisterEffect(e4b)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26062008)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
end
function c26062008.atkval(e,c)
	return c:GetLevel()*100
end
function c26062008.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x662) and not c:IsType(TYPE_TUNER)
end
function c26062008.lvtg(e,c)
	if (c:IsType(TYPE_TUNER) or c:IsSetCard(0x662)) and c:IsLevelBelow(9) then
		e:SetLabel(c:GetLevel())
		return true
	end
end
function c26062008.lvval(e,c)
	if c==e:GetHandler() then return 5
	else return e:GetLabel() end
end
function c26062008.regop(e,tp,eg,ep,ev,re,r,rp)
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
end
function c26062008.filter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function c26062008.spcon(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetCurrentChain()
	return e:GetHandler():GetLevel()==chain and rp~=tp
end
function c26062008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26062008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_CARD,tp,26062008)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local fid=e:GetHandler():GetFieldID()
	c:RegisterFlagEffect(26062008,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(c)
	e1:SetCondition(c26062008.descon)
	e1:SetOperation(c26062008.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(3300)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2,true)
end
function c26062008.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(26062008)==e:GetLabel()
end
function c26062008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c26062008.eftg(e,c)
	local ep=c:GetControler()
	return c:IsSetCard(0x662) and not c:IsType(TYPE_TUNER) and Duel.IsPlayerAffectedByEffect(ep,26062008)
end