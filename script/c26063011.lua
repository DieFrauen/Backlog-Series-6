--Astelloy Crucible
function c26063011.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DELAY)
	e0:SetCondition(c26063011.actcon)
	c:RegisterEffect(e0)
	if not c26063011.global_check then
		c26063011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c26063011.checkop)
		ge1:SetReset(RESET_EVENT+EVENT_CHAIN_SOLVING)
		Duel.RegisterEffect(ge1,0)
	end
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
function c26063011.actfilter(c,cg)
	return c:GetFlagEffect(26063011)~=0
end
function c26063011.actcon(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup():GetFirst()
	return cg and cg:GetFlagEffect(26063011)~=0 and not cg:IsType(TYPE_EFFECT)
end
function c26063011.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	if c:IsRace(RACE_ROCK) then 
		c:RegisterFlagEffect(26063011,0,RESET_CHAIN,0,1)
	end
end
function c26063011.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:IsAbleToGrave()
end
function c26063011.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26063011.filter1,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(26063111)==0 and c:GetFlagEffect(26063211)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	c:RegisterFlagEffect(26063111,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(26063211,RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_END,0,1)
end
function c26063011.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c26063011.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c26063011.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c26063011.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:IsDiscardable()
end
function c26063011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c26063011.filter2(chkc) and chkc~=c end
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c26063011.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and
		Duel.IsExistingMatchingCard(c26063011.cfilter2,tp,LOCATION_HAND,0,1,nil) and c:GetFlagEffect(26063111)==0  and c:GetFlagEffect(26063311)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	c:RegisterFlagEffect(26063111,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(26063311,RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_END,0,1)
end
function c26063011.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	local gc=#g1
	if gc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g2=Duel.SelectMatchingCard(tp,c26063011.cfilter2,tp,LOCATION_HAND,0,1,gc,nil)
	if #g2>0 and Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=g1:Select(tp,#g2,#g2,c)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c26063011.filter3a(c,e,tp)
	return c:IsType(TYPE_MONSTER)
	and c:IsAttribute(ATTRIBUTE_EARTH)
	and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c26063011.filter3b(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:IsAbleToGrave()
end
function c26063011.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26063011.filter3a,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c26063011.filter3b,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(26063111)==0 and e:GetHandler():GetFlagEffect(26063411)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	c:RegisterFlagEffect(26063111,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(26063411,RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_END,0,1)
end
function c26063011.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c26063011.filter3b,tp,LOCATION_MZONE,0,1,1,nil)
	if #g1>0 and Duel.SendtoGrave(g1,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26063011.filter3a),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end