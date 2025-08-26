--Siphantom Kozitos
function c26066002.initial_effect(c)
	--Can also tribute spell/trap cards for its tribute summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
	e1:SetValue(POS_FACEUP)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(c26066002.nsfilter))
	e2:SetCondition(c26066002.nscon)
	c:RegisterEffect(e2)
	--monster effect tax
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26066002.drcon)
	e3:SetOperation(c26066002.spdrain)
	c:RegisterEffect(e3)
	--deactivate self negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26066002)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--Register Special Summons from the Extra Deck
	aux.GlobalCheck(c26066002,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26066002.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26066002.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in eg:Iter() do
		local sp=tc:GetSummonPlayer()
		Duel.RegisterFlagEffect(sp,26066002,RESET_PHASE|PHASE_END,0,1)
		if Duel.HasFlagEffect(sp,26066002,2) then
			Duel.RegisterFlagEffect(sp,26066102,RESET_PHASE|PHASE_END,0,2)
		end
	end
end
function c26066002.nscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),26066007)
end
function c26066002.nsfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x666)
end
function c26066002.drain(c,p)
	return c:IsMonster()
	and c:IsReleasableByEffect()
	and not Duel.IsExistingMatchingCard(c26066002.eqfilter,p,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c26066002.eqfilter(c,cd)
	return c:IsCode(cd) and c:IsFaceup()
end
function c26066002.drcon(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	local rc=re:GetHandler()
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and not Duel.HasFlagEffect(tp,26066102) and not (rc:IsDisabled() or rc:IsStatus(STATUS_DISABLED))
end
function c26066002.spdrain(e,tp,eg,ep,ev,re,r,rp)
	local p=1-tp
	local sg=Duel.GetMatchingGroup(c26066002.drain,p,LOCATION_HAND+LOCATION_DECK,0,nil,p)
	local p1=#sg>0
	local p2=Duel.IsChainDisablable(ev) or p1
	if not (p1 or p2) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(26066002,1))
	local op=Duel.SelectEffect(p,
		{p1,aux.Stringid(26066002,2)},
		{p2,aux.Stringid(26066002,3)})
	if op==1 then
		local sc=sg:Select(p,1,1,nil):GetFirst()
		Duel.SendtoGrave(sc,REASON_EFFECT+REASON_RELEASE)
		sc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.BreakEffect()
	elseif op==2 then Duel.NegateEffect(ev) end
end