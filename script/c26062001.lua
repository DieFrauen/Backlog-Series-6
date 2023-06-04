--Blazon Brigadier - Gurez
function c26062001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26062001.spcon)
	e1:SetOperation(c26062001.spop)
	c:RegisterEffect(e1)
	--summon eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26062001)
	e2:SetTarget(c26062001.target)
	e2:SetOperation(c26062001.operation)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2c)
	--grave eff
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062001,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c26062001.grtg)
	e3:SetOperation(c26062001.grop)
	c:RegisterEffect(e3)
end
function c26062001.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDiscardable()
end
function c26062001.cfcost(c)
	return c:IsCode(26062011) and c:IsAbleToRemoveAsCost()
end
function c26062001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.IsExistingMatchingCard(c26062001.cfilter,tp,LOCATION_HAND,0,1,c)
	local b2=Duel.IsExistingMatchingCard(c26062001.cfcost,tp,LOCATION_GRAVE,0,1,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (b1 or b2)
end
function c26062001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local b1=Duel.GetMatchingGroup(c26062001.cfilter,tp,LOCATION_HAND,0,c)
	local b2=Duel.GetMatchingGroup(c26062001.cfcost,tp,LOCATION_GRAVE,0,nil)
	if b2:GetCount()>0 and (b1:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(26062011,3))) then
		local tg=Duel.GetFirstMatchingCard(c26062001.cfcost,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=b1:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
	end 
end

function c26062001.filter(c,e,tp)
	return c:IsRace(RACE_PYRO) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c26062001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c26062001.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c26062001.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26062001.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c26062001.grfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c26062001.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062001.grfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062001.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062001.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062001.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:IsLevelBelow(3) and Duel.SelectYesNo(tp,aux.Stringid(26062001,1)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(5)
			tc:RegisterEffect(e1)
			return
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
