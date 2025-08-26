--Blazon - Argent the Ardent
function c26062008.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsAttribute,ATTRIBUTE_FIRE),1,99)
	c:EnableReviveLimit()
	--summon eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062008,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c26062008.target)
	e2:SetOperation(c26062008.operation)
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
end
function c26062008.atkval(e,c)
	return c:GetLevel()*100
end
function c26062008.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x662) and not c:IsType(TYPE_TUNER)
end
function c26062008.tgfilter(c,e,tp)
	return c:IsSetCard(0x662) and c:IsAbleToGrave() and not Duel.IsExistingMatchingCard(c26062008.nmfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c26062008.nmfilter(c,code)
	return c:IsCode(code)
end
function c26062008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26062008.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26062008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26062008.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
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
	if c:IsType(TYPE_SYNCHRO) then return end
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
end
function c26062008.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(26062008)==e:GetLabel()
end
function c26062008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
end
function c26062008.eftg(e,c)
	local ep=c:GetControler()
	return c:IsSetCard(0x662) and not c:IsType(TYPE_TUNER)
end