--Fulmiknight Partisan
function c26061002.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26061002)
	e1:SetTarget(c26061002.UnionTarget)
	e1:SetOperation(c26061002.UnionOperation)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCost(c26061002.eqcost)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetCost(c26061002.eqcost)
	e1b:SetCondition(c26061002.lcond)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetType(EFFECT_TYPE_QUICK_O)
	e1c:SetDescription(aux.Stringid(26061002,3))
	e1c:SetCode(EVENT_FREE_CHAIN)
	e1c:SetCondition(c26061002.qcond)
	c:RegisterEffect(e1c)
	local e1d=e1:Clone()
	e1d:SetType(EFFECT_TYPE_QUICK_O)
	e1d:SetDescription(aux.Stringid(26061002,3))
	e1d:SetCode(EVENT_FREE_CHAIN)
	e1d:SetRange(LOCATION_HAND)
	e1d:SetCost(c26061002.eqcost)
	e1d:SetCondition(c26061002.qcond)
	c:RegisterEffect(e1d)
	local e1e=e1:Clone()
	e1e:SetRange(LOCATION_GRAVE)
	e1e:SetDescription(aux.Stringid(26061002,3))
	e1e:SetType(EFFECT_TYPE_QUICK_O)
	e1e:SetCode(EVENT_FREE_CHAIN)
	e1e:SetCost(c26061002.eqcost)
	e1e:SetCondition(c26061002.lqcond)
	c:RegisterEffect(e1e)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26061002)
	e2:SetTarget(c26061002.UnionSumTarget)
	e2:SetOperation(c26061002.UnionSumOperation)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetRange(LOCATION_HAND)
	e2a:SetCost(c26061002.eqcost)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetRange(LOCATION_GRAVE)
	e2b:SetCost(c26061002.eqcost)
	e2b:SetCondition(c26061002.lcond)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetType(EFFECT_TYPE_QUICK_O)
	e2c:SetDescription(aux.Stringid(26061002,4))
	e2c:SetCode(EVENT_FREE_CHAIN)
	e2c:SetCondition(c26061002.qcond)
	c:RegisterEffect(e2c)
	local e2d=e2:Clone()
	e2d:SetType(EFFECT_TYPE_QUICK_O)
	e2d:SetDescription(aux.Stringid(26061002,4))
	e2d:SetCode(EVENT_FREE_CHAIN)
	e2d:SetRange(LOCATION_HAND)
	e2d:SetCost(c26061002.eqcost)
	e2d:SetCondition(c26061002.qcond)
	c:RegisterEffect(e2d)
	local e2e=e2:Clone()
	e2e:SetRange(LOCATION_GRAVE)
	e2e:SetDescription(aux.Stringid(26061002,4))
	e2e:SetType(EFFECT_TYPE_QUICK_O)
	e2e:SetCode(EVENT_FREE_CHAIN)
	e2e:SetCost(c26061002.eqcost)
	e2e:SetCondition(c26061002.lqcond)
	c:RegisterEffect(e2e)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c26061002.UnionLimit)
	c:RegisterEffect(e4)
	--Atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(2600)
	e5:SetCondition(c26061002.uncond)
	c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetType(EFFECT_TYPE_EQUIP)
	e6a:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e6a)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(c26061002.atcond1)
	e7:SetValue(c26061002.efilter)
	c:RegisterEffect(e7)
	local e7a=e7:Clone()
	e7a:SetType(EFFECT_TYPE_EQUIP)
	e7a:SetCondition(c26061002.atcond2)
	c:RegisterEffect(e7a)
end
function c26061002.UnionLimit(e,c)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c26061002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),2600)
end
function c26061002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,2600)
end
function c26061002.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2600) end
	Duel.PayLPCost(tp,2600)
end
function c26061002.UnionTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c26061002.UnionOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if not c:IsRelateToEffect(e) then return end
	if #g<1 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	aux.SetUnionState(c)
end
function c26061002.UnionSumTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061002.union(c,tc)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(tc)
	and aux.CheckUnionEquip(c,tc)
end
function c26061002.UnionSumOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local eg=Duel.GetMatchingGroup(c26061002.union,tp,LOCATION_ONFIELD,0,c,c)
	if #eg>=1 and Duel.IsPlayerAffectedByEffect(tp,26061001) and Duel.SelectYesNo(tp,aux.Stringid(26061001,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_CARD,tp,26061001)
		local eg1=eg:Filter(Card.IsLocation,nil,LOCATION_SZONE)
		for ec in eg1:Iter() do
			if ec and aux.CheckUnionEquip(ec,c) and Duel.Equip(tp,ec,c,true) then
			aux.SetUnionState(ec) end
		end
		eg:Remove(Card.IsLocation,nil,LOCATION_SZONE)
		for ec in eg:Iter() do
			if ec and aux.CheckUnionEquip(ec,c) and Duel.Equip(tp,ec,c,true) then
			aux.SetUnionState(ec) end
		end
		Duel.EquipComplete()
	end
end
function c26061002.lcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061002.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end
function c26061002.lqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and  Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061002.uqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and aux.IsUnionState(e)
end
function c26061002.uncond(e,c)
	local ep=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,ep,LOCATION_MZONE,0,nil)
	local sg=g:GetFirst()
	return #g==1 and (c==sg or c:GetEquipTarget()==sg)
end
function c26061002.efilter(e,te)
	local c,tc=e:GetHandler(),te:GetHandler()
	return te:IsActivated() 
end
function c26061002.atcond1(e,c)
	local c,ac=e:GetHandler(),Duel.GetAttacker()
	return ac and ac==c
end
function c26061002.atcond2(e,c)
	local c,ac=e:GetHandler(),Duel.GetAttacker()
	return aux.IsUnionState(e) and ac and ac==c
end