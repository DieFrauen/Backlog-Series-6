--Siphantasm Siphon
function c26066011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(c26066011.target)
	e1:SetOperation(c26066011.activate)
	c:RegisterEffect(e1)
end
function c26066011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c26066011.gfilter1(c,typ,code)
	return c:IsType(typ) and not c:IsCode(code)
end
function c26066011.gfilter2(c,tp)
	local code=c:GetCode()
	return not Duel.IsExistingMatchingCard(c26066011.code,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,code)
end
function c26066011.code(c,code)
	return c:IsFaceup() and not c:IsCode(code)
end
function c26066011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct,b1,b2,b3,code=0,true,false,false,tc:GetCode()
		if tc:IsMonster() then ct=TYPE_MONSTER 
		elseif tc:IsSpell() then ct=TYPE_SPELL
		elseif tc:IsSpell() then ct=TYPE_TRAP
		end
		local tg1=Duel.GetMatchingGroup(c26066011.gfilter1,tp,0,LOCATION_HAND+LOCATION_DECK,nil,ct,code)
		local tg2=Duel.GetMatchingGroup(c26066011.gfilter2,tp,0,LOCATION_HAND+LOCATION_DECK,nil,tp)
		if tg1:GetClassCount(Card.GetCode)>2 then b2=true end
		if #tg2>1 then b3=true end
		local sg=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26066011,1))
		local op=Duel.SelectEffect(1-tp,
			{b3,aux.Stringid(26066011,2)},
			{b2,aux.Stringid(26066011,3)},
			{b1,aux.Stringid(26066011,4)})
		if op==1 then
			sg=tg2:FilterSelect(1-tp,Card.IsCode,2,2,nil,tc:GetCode())
			Duel.SendtoGrave(sg,REASON_EFFECT)
			for tc in aux.Next(sg) do
				tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		elseif op==2 then
			sg=aux.SelectUnselectGroup(tg1,e,1-tp,3,3,aux.dncheck,1,1-tp,HINTMSG_TOGRAVE)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			for tc in aux.Next(sg) do
				tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		elseif op==3 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			tc:RegisterFlagEffect(26066007,RESET_EVENT+RESETS_STANDARD,0,1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	else
		Duel.BreakEffect()
		local c=e:GetHandler()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end