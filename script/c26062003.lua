--Blazon Sergeant - Azure
function c26062003.initial_effect(c)
	c:SetSPSummonOnce(26062003)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c26062003.spcon)
	e1:SetTarget(c26062003.sptg)
	e1:SetOperation(c26062003.spop)
	c:RegisterEffect(e1)
	--summon eff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26062003,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	--e2:SetCountLimit(1,26062003)
	e2:SetTarget(c26062003.target)
	e2:SetOperation(c26062003.operation)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2c)
	--grave eff
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26062003,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c26062003.grtg)
	e3:SetOperation(c26062003.grop)
	c:RegisterEffect(e3)
end
function c26062003.dcost(c)
	return (c:IsSetCard(0x662) or (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsMonster())) and c:IsAbleToGrave()
end
function c26062003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c26062003.dcost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c26062003.cfcost,tp,LOCATION_GRAVE,0,nil)
	g1:Merge(g2)
	return aux.SelectUnselectGroup(g1,e,tp,1,1,aux.ChkfMMZ(1),0,c)
end
function c26062003.cfcost(c)
	return c:IsCode(26062011) and c:IsAbleToRemoveAsCost()
end
function c26062003.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=Duel.GetMatchingGroup(c26062003.dcost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c26062003.cfcost,tp,LOCATION_GRAVE,0,nil)
	local sg=nil
	if g2:GetCount()>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(26062011,3))) then
		sg=g2:Select(tp,1,1,nil)
	else 
		sg=aux.SelectUnselectGroup(g1,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_DISCARD,nil,nil,true)
	end
	if #sg>0 then
		e:SetLabelObject(sg:GetFirst())
		return true
	end
	return false
end
function c26062003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	if not tc then return end
	if tc:IsCode(26062011) and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_COST)
	end 
end
function c26062003.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc and rc:IsSetCard(0x662)
end
--effect/add from field/gy to hand
function c26062003.filter(c)
	return c:IsSetCard(0x662) and c:IsAbleToHand()
end
function c26062003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26062003.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26062003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26062003.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c26062003.grfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c26062003.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062003.grfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062003.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062003.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062003.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:GetLevel()+1~=3 and Duel.SelectYesNo(tp,aux.Stringid(26062003,1)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(3)
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