--Fulmiknight Labrys
function c26061004.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,26061004),LOCATION_ONFIELD)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26061004)
	e1:SetTarget(c26061004.UnionTarget)
	e1:SetOperation(c26061004.UnionOperation)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCost(c26061004.eqcost)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetRange(LOCATION_GRAVE)
	e1b:SetCost(c26061004.eqcost)
	e1b:SetCondition(c26061004.lcond)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetType(EFFECT_TYPE_QUICK_O)
	e1c:SetDescription(aux.Stringid(26061004,4))
	e1c:SetCode(EVENT_FREE_CHAIN)
	e1c:SetCondition(c26061004.qcond)
	c:RegisterEffect(e1c)
	local e1d=e1:Clone()
	e1d:SetType(EFFECT_TYPE_QUICK_O)
	e1d:SetDescription(aux.Stringid(26061004,4))
	e1d:SetCode(EVENT_FREE_CHAIN)
	e1d:SetRange(LOCATION_HAND)
	e1d:SetCost(c26061004.eqcost)
	e1d:SetCondition(c26061004.qcond)
	c:RegisterEffect(e1d)
	local e1e=e1:Clone()
	e1e:SetRange(LOCATION_GRAVE)
	e1e:SetDescription(aux.Stringid(26061004,4))
	e1e:SetType(EFFECT_TYPE_QUICK_O)
	e1e:SetCode(EVENT_FREE_CHAIN)
	e1e:SetCost(c26061004.eqcost)
	e1e:SetCondition(c26061004.lqcond)
	c:RegisterEffect(e1e)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,26061004)
	e2:SetTarget(c26061004.UnionSumTarget)
	e2:SetOperation(c26061004.UnionSumOperation)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetRange(LOCATION_HAND)
	e2a:SetCost(c26061004.eqcost)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetRange(LOCATION_GRAVE)
	e2b:SetCost(c26061004.eqcost)
	e2b:SetCondition(c26061004.lcond)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetType(EFFECT_TYPE_QUICK_O)
	e2c:SetDescription(aux.Stringid(26061004,5))
	e2c:SetCode(EVENT_FREE_CHAIN)
	e2c:SetCondition(c26061004.qcond)
	c:RegisterEffect(e2c)
	local e2d=e2:Clone()
	e2d:SetType(EFFECT_TYPE_QUICK_O)
	e2d:SetDescription(aux.Stringid(26061004,5))
	e2d:SetCode(EVENT_FREE_CHAIN)
	e2d:SetRange(LOCATION_HAND)
	e2d:SetCost(c26061004.eqcost)
	e2d:SetCondition(c26061004.qcond)
	c:RegisterEffect(e2d)
	local e2e=e2:Clone()
	e2e:SetRange(LOCATION_GRAVE)
	e2e:SetDescription(aux.Stringid(26061004,5))
	e2e:SetType(EFFECT_TYPE_QUICK_O)
	e2e:SetCode(EVENT_FREE_CHAIN)
	e2e:SetCost(c26061004.eqcost)
	e2e:SetCondition(c26061004.lqcond)
	c:RegisterEffect(e2e)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c26061004.UnionLimit)
	c:RegisterEffect(e4)
	--Atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(2400)
	e5:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e5)
	--halve ATK
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetValue(1)
	e6:SetTarget(c26061004.desreptg)
	e6:SetOperation(c26061004.desrepop)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6a:SetRange(LOCATION_SZONE)
	e6a:SetCondition(c26061004.eqcond)
	c:RegisterEffect(e6a)
	--multi attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e7:SetCondition(c26061004.rdcon)
	e7:SetOperation(c26061004.rdop)
	c:RegisterEffect(e7)
	local e7a=e7:Clone()
	e7a:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e7a)
end
function c26061004.UnionLimit(e,c)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c26061004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),2400)
end
function c26061004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,2400)
end
function c26061004.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2400) end
	Duel.PayLPCost(tp,2400)
end
function c26061004.UnionTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) and c:CheckUniqueOnField(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061004.UnionOperation(e,tp,eg,ep,ev,re,r,rp)
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
function c26061004.UnionSumTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCode()
	if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
end
function c26061004.union(c,tc)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(tc)
	and aux.CheckUnionEquip(c,tc)
end
function c26061004.UnionSumOperation(e,tp,eg,ep,ev,re,r,rp)
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
function c26061004.lcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061004.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end
function c26061004.lqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and  Duel.IsPlayerAffectedByEffect(ep,26061006)
end
function c26061004.uqcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007) and aux.IsUnionState(e)
end
function c26061004.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac,dc=Duel.GetAttacker(),Duel.GetAttackTarget()
	local c,bc=e:GetHandler(),nil
	if c==ac then bc=dc else bc=ac end
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if #g1~=1 or not g1:GetFirst()==(c or c:GetEquipTarget()) then return end
	if chk==0 then return eg:IsContains(bc) and bc:IsReason(REASON_BATTLE) and not bc:IsImmuneToEffect(e) and bc:IsCanChangePosition() end
	return bc~=c and (bc==ac or bc==dc) and Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c26061004.cuttg(c,e)
	return c:IsFaceup()
	and c:IsAttackAbove(2)
	and not c:IsImmuneToEffect(e)
end
function c26061004.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,26061004)
	Duel.ChangePosition(Duel.GetAttackTarget(),POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
end
function c26061004.eqcond(e)
	local c=e:GetHandler()
	return c:GetEquipTarget()
end
function c26061004.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	local dc=Duel.GetAttackTarget()
	if c~=tc and c:GetEquipTarget()~=tc then return end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	return tc and tc==g:GetFirst() and dc and not dc:IsImmuneToEffect(e)
end
function c26061004.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(26061004,3)) then
		Duel.ChangeBattleDamage(ep,0)
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=tg:GetFirst()
		while tc do
			local atk=tc:GetBaseAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk/2)
			tc:RegisterEffect(e1)
			local def=tc:GetBaseDefense()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(def/2)
			tc:RegisterEffect(e2)
			tc=tg:GetNext()
		end
	end
end