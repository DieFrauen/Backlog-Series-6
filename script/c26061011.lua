--Fulmiknight Devotion
function c26061011.initial_effect(c)
	c:EnableCounterPermit(0x5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMING_END_PHASE)
	e1:SetTarget(c26061011.target)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(26061011,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(1000)
	e2:SetCost(c26061011.spcost)
	e2:SetTarget(c26061011.sptg)
	e2:SetOperation(c26061011.spop)
	c:RegisterEffect(e2)
	--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26061011,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PAY_LPCOST)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c26061011.eqcon)
	e3:SetTarget(c26061011.eqtg)
	e3:SetOperation(c26061011.eqop)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26061011,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c26061011.mtop)
	c:RegisterEffect(e4)
end
function c26061011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(c26061011.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	and c26061011.spcost(e,tp,eg,ep,ev,re,r,rp,0))
	local b2=c26061011.eqtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return true end
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26061011,0)},
			{b2,aux.Stringid(26061011,1)})
		if op==1 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
			e:SetProperty(0)
			e:SetOperation(c26061011.spop)
			c26061011.spcost(e,tp,eg,ep,ev,re,r,rp,1)
			c26061011.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if op==2 then
			e:SetCategory(CATEGORY_EQUIP)
			e:SetProperty(0)
			e:SetOperation(c26061011.eqop)
			c26061011.eqtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c26061011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpc=1
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	if Duel.CheckLPCost(tp,2000) then
		lpc=Duel.AnnounceNumber(tp,{1000,2000})
	end
	Duel.PayLPCost(tp,lpc)
	e:SetLabel(lpc)
end
function c26061011.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
	and c:IsSetCard(0x661)
	and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c26061011.eqhfilter(c,ec,tp)
	return c:IsType(TYPE_UNION)
	and c:CheckUnionTarget(ec)
	and aux.CheckUnionEquip(c,ec)
	and c:GetLocation()~=ec:GetLocation()
end
function c26061011.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c26061011.spfilter(chkc,e,tp) end
	local rg=Duel.GetMatchingGroup(c26061011.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #rg>0 and Duel.GetFlagEffect(tp,26061011)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	if e:GetLabel()==2000 then
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	end
	Duel.RegisterFlagEffect(tp,26061011,RESET_PHASE+PHASE_END,0,1)
end
function c26061011.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26061011.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	sg1=rg:Select(tp,1,1,nil):GetFirst()
	local rg2=Duel.GetMatchingGroup(c26061011.eqhfilter,tp,LOCATION_DECK,0,c,sg1,tp)
	if Duel.SpecialSummon(sg1,0,tp,tp,true,true,POS_FACEUP) and #rg>0 and e:GetLabel()==2000 and Duel.SelectYesNo(tp,aux.Stringid(26061011,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		sg2=rg2:Select(tp,1,1,nil):GetFirst()
		Duel.Equip(tp,sg2,sg1)
		aux.SetUnionState(sg2)
	end
end
function c26061011.tgfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and Duel.IsExistingMatchingCard(c26061011.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c26061011.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>=1000 and ep==e:GetHandlerPlayer()
end
function c26061011.eqfilter(c,ec)
	return c:IsSetCard(0x661) and c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function c26061011.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c26061011.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c26061011.tgfilter,tp,LOCATION_MZONE,0,1,c,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,26061011)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.RegisterFlagEffect(tp,26061011,RESET_PHASE+PHASE_END,0,1)
end
function c26061011.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26061011.tgfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c26061011.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
		local ec=sg:GetFirst()
		if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end
function c26061011.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.CheckLPCost(tp,1000) then 
		if Duel.SelectYesNo(tp,aux.Stringid(26061011,2)) then
			Duel.PayLPCost(tp,1000)
			if c:IsCanAddCounter(0x5,1) then c:AddCounter(0x5,1) end
		else
			Duel.Destroy(e:GetHandler(),REASON_COST)
		end
	else
		local ct=c:GetCounter(0x5)
		Duel.Destroy(e:GetHandler(),REASON_COST)
		Duel.Hint(HINT_CARD,tp,26061011)
		Duel.Recover(tp,ct*1000,REASON_EFFECT)
	end
end