--Entrophys Reaction
function c26065011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065011,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(c26065011.target)
	e1:SetOperation(c26065011.activate)
	c:RegisterEffect(e1)
end
function c26065011.reg(c)
	return c:IsSetCard(0x1665) and c:IsFaceup()
end
function c26065011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c,rc=e:GetHandler(),re:GetHandler()
	local g=Duel.GetMatchingGroup(c26065011.reg,tp,LOCATION_ONFIELD,0,nil)
	local sg=g:GetClassCount(Card.GetCode)
	sg=math.min(sg,3)
	local ftg=re:GetTarget()
	local b1=(c26065011.copy(e,tp,eg,ep,ev,re,r,rp,0,ftg)
	and Duel.GetFlagEffect(tp,26065011)==0)
	local b2=(Duel.IsChainNegatable(ev)
	and Duel.GetFlagEffect(tp,26065111)==0)
	local b3=(Duel.IsPlayerCanSendtoHand(tp,c)
	and Duel.GetFlagEffect(tp,26065211)==0)
	local b4=false
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) or b2 or b3 end
	if chk==0 then
		e:SetLabel(0)
		return sg>0 and re:GetHandler():IsSetCard(0x665) and (b1 or b2 or b3)
		and (re:IsActiveType(TYPE_MONSTER)
		or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and (b1 or b2 or b3)
	end
	local lab=0
	while (b1 or b2 or b3) and sg>0 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26065011,3+sg))
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(26065011,0)},
			{b2,aux.Stringid(26065011,1)},
			{b3,aux.Stringid(26065011,2)},
			{b4,aux.Stringid(26065011,3)})
		if op==1 then
			if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
				e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			end
			c26065011.copy(e,tp,eg,ep,ev,re,r,rp,1,ftg)
			lab=lab+100
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(26065011,0))
			Duel.RegisterFlagEffect(tp,26065011,RESET_PHASE+PHASE_END,0,1)
			b1=false
		elseif op==2 then
			Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
			lab=lab+10
			b4=false
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(26065011,1))
			Duel.RegisterFlagEffect(tp,26065111,RESET_PHASE+PHASE_END,0,1)
			b2=false
		elseif op==3 then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
			lab=lab+1
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(26065011,2))
			Duel.RegisterFlagEffect(tp,26065211,RESET_PHASE+PHASE_END,0,1)
			b3=false
		elseif op==4 then
			b1=false;b2=false;b3=false
		end
		b4=true
		sg=sg-1
	end
	Duel.SetChainLimit(function(te,rp,tp) return not te:GetHandler():IsCode(26065011) end)
	e:SetLabel(lab)
end
function c26065011.copy(e,tp,eg,ep,ev,re,r,rp,chk,ftg)
	if ftg then 
		if ftg(e,tp,eg,ep,ev,re,r,rp,chk) then return true
		end
	else return true end
end
function c26065011.activate(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	local fop=re:GetOperation()
	if e:GetLabel()>99 then
		fop(e,tp,eg,ep,ev,re,r,rp)
		lab=lab-100
	end
	if lab>9 then
		local rc=re:GetHandler()
		if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then 
			rc:CancelToGrave(true)
			Duel.SendtoHand(rc,nil,REASON_EFFECT)
		end
		lab=lab-10
	end
	local c=e:GetHandler()
	if lab==1 and c:IsRelateToEffect(e) then
		c:CancelToGrave(true)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end