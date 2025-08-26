--Fulmiknight Pavise
function c26061003.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26061003)
	e1:SetTarget(c26061003.UnionTarget)
	e1:SetOperation(c26061003.UnionOperation)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCost(c26061003.eqcost)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetCost(c26061003.eqcost)
	e1b:SetCondition(c26061003.lcond)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetType(EFFECT_TYPE_QUICK_O)
	e1c:SetDescription(aux.Stringid(26061003,3))
	e1c:SetCode(EVENT_FREE_CHAIN)
	e1c:SetCondition(c26061003.qcond)
	c:RegisterEffect(e1c)
	local e1d=e1:Clone()
	e1d:SetType(EFFECT_TYPE_QUICK_O)
	e1d:SetDescription(aux.Stringid(26061003,3))
	e1d:SetCode(EVENT_FREE_CHAIN)
	e1d:SetRange(LOCATION_HAND)
	e1d:SetCost(c26061003.eqcost)
	e1d:SetCondition(c26061003.qcond)
	c:RegisterEffect(e1d)
	local e1e=e1:Clone()
	e1e:SetRange(LOCATION_GRAVE)
	e1e:SetDescription(aux.Stringid(26061003,3))
	e1e:SetType(EFFECT_TYPE_QUICK_O)
	e1e:SetCode(EVENT_FREE_CHAIN)
	e1e:SetCost(c26061003.eqcost)
	e1e:SetCondition(c26061003.lqcond)
	c:RegisterEffect(e1e)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26061003)
	e2:SetTarget(c26061003.UnionSumTarget)
	e2:SetOperation(c26061003.UnionSumOperation)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetRange(LOCATION_HAND)
	e2a:SetCost(c26061003.eqcost)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetRange(LOCATION_GRAVE)
	e2b:SetCost(c26061003.eqcost)
	e2b:SetCondition(c26061003.lcond)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetType(EFFECT_TYPE_QUICK_O)
	e2c:SetDescription(aux.Stringid(26061003,4))
	e2c:SetCode(EVENT_FREE_CHAIN)
	e2c:SetCondition(c26061003.qcond)
	c:RegisterEffect(e2c)
	local e2d=e2:Clone()
	e2d:SetType(EFFECT_TYPE_QUICK_O)
	e2d:SetDescription(aux.Stringid(26061003,4))
	e2d:SetCode(EVENT_FREE_CHAIN)
	e2d:SetRange(LOCATION_HAND)
	e2d:SetCost(c26061003.eqcost)
	e2d:SetCondition(c26061003.qcond)
	c:RegisterEffect(e2d)
	local e2e=e2:Clone()
	e2e:SetRange(LOCATION_GRAVE)
	e2e:SetDescription(aux.Stringid(26061003,4))
	e2e:SetType(EFFECT_TYPE_QUICK_O)
	e2e:SetCode(EVENT_FREE_CHAIN)
	e2e:SetCost(c26061003.eqcost)
	e2e:SetCondition(c26061003.lqcond)
	c:RegisterEffect(e2e)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
	--Atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(2700)
	e5:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e5)
	--indestructible
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_ONFIELD,0)
	e6:SetCondition(c26061003.uncond1)
	e6:SetTarget(c26061003.intg)
	e6:SetValue(c26061003.efilter)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetRange(LOCATION_SZONE)
	e6a:SetCondition(c26061003.uncond2)
	c:RegisterEffect(e6a)
	local e7=Effect.CreateEffect(c)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetCondition(c26061003.uncond1)
	e7:SetValue(0)
	c:RegisterEffect(e7)
	local e7a=e7:Clone()
	e7a:SetRange(LOCATION_SZONE)
	e7a:SetCondition(c26061003.uncond2)
	c:RegisterEffect(e7a)
	local e7b=e7:Clone()
	e7b:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e7b)
	local e7c=e7:Clone()
	e7c:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e7c:SetRange(LOCATION_SZONE)
	e7c:SetCondition(c26061003.uncond2)
	c:RegisterEffect(e7c)
end
function c26061003.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),2700)
end
function c26061003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,2700)
end
function c26061003.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2700) end
	Duel.PayLPCost(tp,2700)
end
function c26061003.UnionTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061003.UnionOperation(e,tp,eg,ep,ev,re,r,rp)
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
function c26061003.UnionSumTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061003.union(c,tc)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(tc)
	and aux.CheckUnionEquip(c,tc)
end
function c26061003.UnionSumOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) then
			Duel.SendtoGrave(c,REASON_RULE) end
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
function c26061003.lcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061003.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end
function c26061003.lqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and  Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061003.uqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and aux.IsUnionState(e)
end
function c26061003.eqcond(e)
	local c=e:GetHandler()
	return c:GetEquipTarget()
end
function c26061003.repfilter(c,e,ec)
	return c:IsSetCard(0x661) and c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c26061003.intg(e,c)
	local ec=e:GetHandler()
	return c:IsFaceup() and (
	(c:IsSetCard(0x661) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or
	(c==ec or c==ec:GetEquipTarget()))
end
function c26061003.uncond1(e,c)
	local ep=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,ep,LOCATION_MZONE,0,nil)
	local sg=g:GetFirst()
	return #g==1 and sg==e:GetHandler() and sg:GetBattledGroupCount()==0
end
function c26061003.uncond2(e,c)
	local ep=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,ep,LOCATION_MZONE,0,nil)
	local sg=g:GetFirst()
	return aux.IsUnionState(e) and #g==1 and sg==e:GetHandler():GetEquipTarget() and ep~=e:GetHandler() and sg:GetBattledGroupCount()==0
end
function c26061003.efilter(e,te)
	if not te then return end
	local c,tc=e:GetHandler(),te:GetHandler()
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end