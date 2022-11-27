--Fulmiknight Leonais
function c26061005.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,26061005),LOCATION_ONFIELD)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26061005)
	e1:SetTarget(c26061005.UnionTarget)
	e1:SetOperation(c26061005.UnionOperation)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCost(c26061005.eqcost)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetCost(c26061005.eqcost)
	e1b:SetCondition(c26061005.lcond)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetType(EFFECT_TYPE_QUICK_O)
	e1c:SetDescription(aux.Stringid(26061005,3))
	e1c:SetCode(EVENT_FREE_CHAIN)
	e1c:SetCondition(c26061005.qcond)
	c:RegisterEffect(e1c)
	local e1d=e1:Clone()
	e1d:SetType(EFFECT_TYPE_QUICK_O)
	e1d:SetDescription(aux.Stringid(26061005,3))
	e1d:SetCode(EVENT_FREE_CHAIN)
	e1d:SetRange(LOCATION_HAND)
	e1d:SetCost(c26061005.eqcost)
	e1d:SetCondition(c26061005.qcond)
	c:RegisterEffect(e1d)
	local e1e=e1:Clone()
	e1e:SetRange(LOCATION_GRAVE)
	e1e:SetDescription(aux.Stringid(26061005,3))
	e1e:SetType(EFFECT_TYPE_QUICK_O)
	e1e:SetCode(EVENT_FREE_CHAIN)
	e1e:SetCost(c26061005.eqcost)
	e1e:SetCondition(c26061005.lqcond)
	c:RegisterEffect(e1e)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26061005)
	e2:SetTarget(c26061005.UnionSumTarget)
	e2:SetOperation(c26061005.UnionSumOperation)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetRange(LOCATION_HAND)
	e2a:SetCost(c26061005.eqcost)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetRange(LOCATION_GRAVE)
	e2b:SetCost(c26061005.eqcost)
	e2b:SetCondition(c26061005.lcond)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetType(EFFECT_TYPE_QUICK_O)
	e2c:SetDescription(aux.Stringid(26061005,4))
	e2c:SetCode(EVENT_FREE_CHAIN)
	e2c:SetCondition(c26061005.qcond)
	c:RegisterEffect(e2c)
	local e2d=e2:Clone()
	e2d:SetType(EFFECT_TYPE_QUICK_O)
	e2d:SetDescription(aux.Stringid(26061005,4))
	e2d:SetCode(EVENT_FREE_CHAIN)
	e2d:SetRange(LOCATION_HAND)
	e2d:SetCost(c26061005.eqcost)
	e2d:SetCondition(c26061005.qcond)
	c:RegisterEffect(e2d)
	local e2e=e2:Clone()
	e2e:SetRange(LOCATION_GRAVE)
	e2e:SetDescription(aux.Stringid(26061005,4))
	e2e:SetType(EFFECT_TYPE_QUICK_O)
	e2e:SetCode(EVENT_FREE_CHAIN)
	e2e:SetCost(c26061005.eqcost)
	e2e:SetCondition(c26061005.lqcond)
	c:RegisterEffect(e2e)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c26061005.UnionLimit)
	c:RegisterEffect(e4)
	--def up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(2300)
	e5:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c26061005.discon1)
	e6:SetOperation(c26061005.disop1)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6a:SetRange(LOCATION_SZONE)
	e6a:SetCondition(c26061005.eqcond)
	c:RegisterEffect(e6a)
	--Untargetable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c26061005.uncond)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	local e7a=e7:Clone()
	e7a:SetType(EFFECT_TYPE_EQUIP)
	e7a:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7a:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e7a)
end
function c26061005.UnionLimit(e,c)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c26061005.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),2300)
end
function c26061005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,2300)
end
function c26061005.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2300) end
	Duel.PayLPCost(tp,2300)
end
function c26061005.UnionTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061005.UnionOperation(e,tp,eg,ep,ev,re,r,rp)
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
function c26061005.UnionSumTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061005.union(c,tc)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(tc)
	and aux.CheckUnionEquip(c,tc)
end
function c26061005.UnionSumOperation(e,tp,eg,ep,ev,re,r,rp)
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
function c26061005.lcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061005.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end
function c26061005.lqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and  Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061005.uqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and aux.IsUnionState(e)
end
function c26061005.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ac,dc=Duel.GetAttacker(),Duel.GetAttackTarget()
	local c=e:GetHandler()
	return ac and dc and (c==ac or c:GetEquipTarget()==ac)
end
function c26061005.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac,dc=Duel.GetAttacker(),Duel.GetAttackTarget()
	if ac and (ac==c or ac==c:GetEquipTarget()) and dc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE_EFFECT)
		e1:SetValue(RESET_TURN_SET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e2)
	end
end
function c26061005.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c26061005.disop2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and re:GetHandler()==e:GetLabelObject() then
		Duel.NegateEffect(ev)
	end
end
function c26061005.eqcond(e)
	local c=e:GetHandler()
	return c:GetEquipTarget()
end
function c26061005.uncond(e,c)
	local ep=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,ep,LOCATION_MZONE,0,nil)
	local sg=g:GetFirst()
	return #g==1 and (c==sg or c:GetEquipTarget()==sg) and sg:GetBattledGroupCount()==0
end