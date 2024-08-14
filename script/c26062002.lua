--Blazon - Serpure the Seeker
function c26062002.initial_effect(c)
	c:SetSPSummonOnce(26062002)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26062002.spcon)
	e1:SetTarget(c26062002.sptg)
	e1:SetOperation(c26062002.spop)
	c:RegisterEffect(e1)
	--summon eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062002,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	--e2:SetCountLimit(1,26062002)
	e2:SetTarget(c26062002.target)
	e2:SetOperation(c26062002.operation)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2c)
	--grave eff
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062002,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c26062002.grtg)
	e3:SetOperation(c26062002.grop)
	c:RegisterEffect(e3)
end
function c26062002.dcost(c,tp)
	return (c:IsSetCard(0x662) or (c:IsAttribute(ATTRIBUTE_FIRE)
	and c:IsMonster()))
	and Duel.IsPlayerCanRelease(tp,c)
end
function c26062002.otcost(c,tc)
	return c:IsCode(tc:GetCode()) and c:IsFaceup()
end
function c26062002.dkcost(c,tp)
	return c:IsSetCard(0x662) and c:IsMonster() and not c:IsType(TYPE_TUNER) and Duel.IsPlayerCanRelease(tp,c) and not Duel.IsExistingMatchingCard(c26062002.otcost,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,c) and not c:IsCode(26062002)
end
function c26062002.spcon(e,c)
	local sc=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c26062002.dcost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	local g2=Duel.GetMatchingGroup(c26062002.cfcost,tp,LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c26062002.dkcost,tp,LOCATION_DECK,0,c,tp)
	g1:Merge(g2)
	if #g3>0 and Duel.IsPlayerAffectedByEffect(tp,26062007) and Duel.GetFlagEffect(tp,26062007)==0
	then g1:Merge(g3) end
	return aux.SelectUnselectGroup(g1,e,tp,1,1,aux.ChkfMMZ(1),0,c)
end
function c26062002.cfcost(c)
	return c:IsCode(26062011) and c:IsAbleToRemoveAsCost()
end
function c26062002.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local sc=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.GetMatchingGroup(c26062002.dcost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,sc,tp)
	local g2=Duel.GetMatchingGroup(c26062002.cfcost,tp,LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c26062002.dkcost,tp,LOCATION_DECK,0,sc,tp,e:GetHandler())
	if #g3>0 and Duel.IsPlayerAffectedByEffect(tp,26062007) and Duel.GetFlagEffect(tp,26062007)==0
	then g1:Merge(g3) end
	local sc=nil
	if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(26062011,3))) then
		sc=g2:Select(tp,1,1,nil):GetFirst()
	else 
		sc=aux.SelectUnselectGroup(g1,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true):GetFirst()
	end
	if sc then
		if g3:IsContains(sc) then 
			Duel.Hint(HINT_CARD,tp,26062007)
			Duel.RegisterFlagEffect(tp,26062007,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetLabelObject(sc)
		return true
	end
	return false
end
function c26062002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	if not tc then return end
	if tc:IsCode(26062011) and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_RELEASE)
	end 
end
function c26062002.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc and rc:IsSetCard(0x662)
end
function c26062002.filter(c)
	return c:IsSetCard(0x662) and c:IsAbleToGrave()
end
function c26062002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26062002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26062002.lvfilter(c,g)
	return g:IsExists(Card.IsLevel,1,nil,c:GetLevel())
end
function c26062002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26062002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26062002.grfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c26062002.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062002.grfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062002.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062002.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062002.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:IsLevelBelow(2) and Duel.SelectYesNo(tp,aux.Stringid(26062002,1)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(4)
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
