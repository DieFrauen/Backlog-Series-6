--Astelloy Crucible
function c26063011.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DELAY)
	e0:SetCondition(c26063011.actcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SUMMON,TIMING_SUMMON)
	e1:SetTarget(c26063011.target)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063011,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetTarget(c26063011.target1)
	e2:SetOperation(c26063011.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26063011,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e3:SetTarget(c26063011.target2)
	e3:SetOperation(c26063011.operation2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26063011,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e4:SetTarget(c26063011.target3)
	e4:SetOperation(c26063011.operation3)
	c:RegisterEffect(e4)
end
function c26063011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c26063011.target1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c26063011.target2(e,tp,eg,ep,ev,re,r,rp,0)
	local b3=c26063011.target3(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return true end
	local ops={}
	local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(26063011,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(26063011,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(26063011,2)
			opval[off-1]=3
			off=off+1
		end
	local op=0
	if (b1 or b2 or b3) and Duel.SelectYesNo(tp,94) then
		op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
			e:SetProperty(0)
			e:SetOperation(c26063011.operation1)
			c26063011.target1(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if opval[op]==2 then
			e:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
			e:SetProperty(0)
			e:SetOperation(c26063011.operation2)
			c26063011.target2(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if opval[op]==3 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
			e:SetProperty(0)
			e:SetOperation(c26063011.operation3)
			c26063011.target3(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c26063011.actfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c26063011.actcon(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup()
	return cg:IsExists(c26063011.actfilter,1,nil)
end
function c26063011.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:IsAbleToGrave()
end
function c26063011.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26063011.filter1,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(26063111)==0 and c:GetFlagEffect(26063211)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	c:RegisterFlagEffect(26063111,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(26063211,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26063011.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c26063011.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c26063011.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c26063011.cfilter2(c)
	return c:IsSetCard(0x663) and c:IsDiscardable()
end
function c26063011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c26063011.filter2(chkc) and chkc~=c end
	if chk==0 then return 
		Duel.IsExistingTarget(c26063011.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and
		Duel.IsExistingMatchingCard(c26063011.cfilter2,tp,LOCATION_HAND,0,1,nil) and c:GetFlagEffect(26063111)==0  and c:GetFlagEffect(26063311)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c26063011.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetChainLimit(c26063011.limit(g:GetFirst()))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_HAND)
	c:RegisterFlagEffect(26063111,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(26063311,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26063011.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c26063011.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and c:IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c26063011.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c26063011.filter3a(c,e,tp)
	return c:IsType(TYPE_MONSTER)
	and c:IsAttribute(ATTRIBUTE_EARTH)
	and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c26063011.filter3b(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK)
end
function c26063011.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c26063011.filter3a,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingTarget(c26063011.filter3b,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(26063111)==0 and e:GetHandler():GetFlagEffect(26063411)==0 end
	local g=Duel.SelectTarget(tp,c26063011.filter3b,tp,LOCATION_MZONE,0,1,99,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	c:RegisterFlagEffect(26063111,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(26063411,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
end
function c26063011.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c26063011.filter3a),tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26063011.filter3a),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
			if tc:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(26063011,3)) then
				Duel.Overlay(tc,sg)
			else
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end