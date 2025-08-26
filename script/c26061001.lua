--Fulmiknight Gladius
function c26061001.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26061001,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26061001,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c26061001.eqtg)
	e1:SetOperation(c26061001.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER_E+TIMING_END_PHASE+TIMING_BATTLE_STEP_END,TIMINGS_CHECK_MONSTER_E+TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(26061001,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c26061001.qcond)
	c:RegisterEffect(e2)
	--gladius
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(26061001)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
end
function c26061001.union(c,ec,tp,ign_ct)
	return (c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(ec)
	and aux.CheckUnionEquip(c,ec,ign_ct))
end
function c26061001.ofilter(c,ec,tp,ign_ct)
	return c26061001.union(c,ec,rp,ign_ct) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c26061001.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c26061001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_SZONE,0,c,c,tp,1):Filter(Card.IsFaceup,c)
	g1:Sub(c:GetEquipGroup())
	local g2=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_MZONE,0,nil,c,tp,1)
	local g3=Duel.GetMatchingGroup(c26061001.ofilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,c,tp,1)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	g1:Sub(c:GetEquipGroup())
	if chk==0 then
		return #g1>0 or (#g2>0 and ft>0) or  (#g3>0 and ft>0 and Duel.CheckLPCost(tp,2000))
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,0,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c26061001.rescon(sg,e,tp,mg)
	return Duel.CheckLPCost(tp,#sg*2000)
	and sg:GetClassCount(Card.GetCode)==#sg
	and #sg:Filter(Card.IsLocation,nil,LOCATION_DECK)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
end
function c26061001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_SZONE,0,c,c,tp,0)
	local g2=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_MZONE,0,c,c,tp,0)
	local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26061001.ofilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,c,tp,0)
	g1:Sub(c:GetEquipGroup())
	if c:IsFacedown() or ft==0 or not c:IsRelateToEffect(e)
	or (#g1==0 and #g2==0 and (#g3==0 and not Duel.CheckLPCost(tp,1000))) then return end
	local sel=#g3>0
	if #g1+#g2>0 and (not sel or Duel.SelectYesNo(tp,aux.Stringid(26061001,3))) then
		for tc in g1:Iter() do
			Duel.Equip(tp,tc,c,false,false)
			aux.SetUnionState(tc)
		end
		if #g2>ft then g2=g2:Select(tp,1,ft,nil) end
		for tc in g2:Iter() do
			Duel.Equip(tp,tc,c,false,false)
			aux.SetUnionState(tc)
		end
		Duel.EquipComplete()
		sel=false
	else sel=true end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and #g3>0 and (sel or Duel.SelectYesNo(tp,aux.Stringid(26061001,4))) then
		Duel.BreakEffect()
		local sg=aux.SelectUnselectGroup(g3,e,tp,fm,ft,c26061001.rescon,1,tp,HINTMSG_EQUIP)
		Duel.PayLPCost(tp,#sg*2000)
		for tc in sg:Iter() do
			Duel.Equip(tp,tc,c,true)
			aux.SetUnionState(tc)
		end
		Duel.EquipComplete()
	end
end
function c26061001.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end