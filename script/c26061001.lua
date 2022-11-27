--Fulmiknight Commander - Gladius
function c26061001.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,26061001),LOCATION_ONFIELD)
	--ss and equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26061001,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26061001)
	e1:SetCost(c26061001.eqcost)
	e1:SetTarget(c26061001.eqtg)
	e1:SetOperation(c26061001.eqop)
	c:RegisterEffect(e1)
	local e1c=e1:Clone()
	e1c:SetType(EFFECT_TYPE_QUICK_O)
	e1c:SetDescription(aux.Stringid(26061001,1))
	e1c:SetCode(EVENT_FREE_CHAIN)
	e1c:SetCondition(c26061001.qcond)
	c:RegisterEffect(e1c)
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
	e4:SetValue(c26061001.UnionLimit)
	c:RegisterEffect(e4)
end
function c26061001.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 then
		c26061001[0]=Duel.GetChainInfo(cid,CHAININFO_CHAIN_ID)
	end
end
function c26061001.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==c26061001[0]
end
function c26061001.UnionLimit(e,c)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c26061001.union(c,ec,tp,ign_ct)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(ec)
	and aux.CheckUnionEquip(c,ec,ign_ct)
	and c:CheckUniqueOnField(tp)
end
function c26061001.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c26061001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_ONFIELD,0,c,c,tp,1):Filter(Card.IsFaceup,nil)
	local g2=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,c,tp,1)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then
		return #g1>0 or (#g2>0 and #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE)
end
function c26061001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c26061001.union,tp,LOCATION_ONFIELD,0,c,c,tp,0)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26061001.union),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,c,tp,0)
	if c:IsFacedown() or not c:IsRelateToEffect(e) or (#g1==0 and #g2==0) then return end
	local fm=0
	if #g1==0 then fm=1 end
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil))
	local sg=aux.SelectUnselectGroup(g2,e,tp,fm,ft,aux.dncheck,1,tp,HINTMSG_EQUIP)
	for tc in g1:Iter() do
		if tc and tc:IsFaceup() and aux.CheckUnionEquip(tc,c) and Duel.Equip(tp,tc,c,true) then
		aux.SetUnionState(tc) end
	end
	if #sg>0 then
		for tc in sg:Iter() do
			if tc and aux.CheckUnionEquip(tc,c) and Duel.Equip(tp,tc,c,true) then
			aux.SetUnionState(tc) end
		end
	Duel.EquipComplete()
	end
end
function c26061001.qcond(e,c)
	local ep=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(ep,26061007)
end