--Fulmiknight Crown Marshal - Damocross
function c26061006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,false,false,aux.FilterBoolFunctionEx(Card.IsType,TYPE_UNION),2,99,26061001)
	--eqlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNION_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(aux.TRUE)
	c:RegisterEffect(e1)
	--Atk/DEF up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c26061006.unval)
	e3:SetCondition(c26061006.uncond)
	c:RegisterEffect(e3)
	local e3a=e3:Clone()
	e3a:SetType(EFFECT_TYPE_EQUIP)
	c:RegisterEffect(e3a)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3b)
	local e3c=e3:Clone()
	e3c:SetType(EFFECT_TYPE_EQUIP)
	e3c:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26061006)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c26061006.uncond)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4a)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1068)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c26061006.UnionTarget)
	e5:SetOperation(c26061006.UnionOperation)
	c:RegisterEffect(e5)
	local e5a=e5:Clone()
	e5a:SetType(EFFECT_TYPE_QUICK_O)
	e5a:SetDescription(aux.Stringid(26061006,0))
	e5a:SetCode(EVENT_FREE_CHAIN)
	e5a:SetCondition(c26061006.qcond)
	c:RegisterEffect(e5a)
	--unequip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(2)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c26061006.UnionSumTarget)
	e6:SetOperation(c26061006.UnionSumOperation)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetType(EFFECT_TYPE_QUICK_O)
	e6a:SetDescription(aux.Stringid(26061006,1))
	e6a:SetCode(EVENT_FREE_CHAIN)
	e6a:SetCondition(c26061006.qcond)
	c:RegisterEffect(e6a)
end
function c26061006.uncond(e,c)
	local ep=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,ep,LOCATION_MZONE,0,nil)
	local sg=g:GetFirst()
	return #g==1 and (c==sg or c:GetEquipTarget()==sg)
end
function c26061006.unval(e,c)
	local cont=c:GetControler()
	return math.max(0,Duel.GetLP(1-cont)-Duel.GetLP(cont))
end
function c26061006.UnionTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	c:RegisterFlagEffect(code,RESET_EVENT+(RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c26061006.UnionOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,c)
	if not c:IsRelateToEffect(e) then return end
	if #g<1 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	aux.SetUnionState(c)
end
function c26061006.UnionSumTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(code,RESET_EVENT+(RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061006.union(c,tc)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(tc)
	and aux.CheckUnionEquip(c,tc)
end
function c26061006.UnionSumOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local eg=Duel.GetMatchingGroup(c26061006.union,tp,LOCATION_ONFIELD,0,c,c)
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
function c26061006.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end