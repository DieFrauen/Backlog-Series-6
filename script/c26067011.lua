--Desceptim Evocation
function c26067011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26067011,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26067011.condition)
	e1:SetTarget(c26067011.target)
	e1:SetOperation(c26067011.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067011,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabel(1)
	e2:SetCondition(c26067011.setcon)
	e2:SetTarget(c26067011.settg)
	e2:SetOperation(c26067011.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
end
function c26067011.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandlerPlayer()~=tp
end
function c26067011.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck() and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c26067011.d2filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and not c:IsForbidden()
end
function c26067011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067003.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26067011.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0,1,e:GetHandler())
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if #sg>0 and Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
		sc:ReverseInDeck()
		sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		local g2=Duel.GetMatchingGroup(c26067011.d2filter,tp,LOCATION_DECK,0,1,e:GetHandler())
		if #g2>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(26067011,1)) then
			local sg=g2:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
			sc:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	end
end
function c26067011.setcon(e,tp,eg,ep,ev,re,r,rp)
	local dk=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then return e:GetLabel()==1 or (c:IsSSetable() and dk:IsFaceup() and dk:IsCode(26067007) and dk:GetOwner()==tp) end
end
function c26067011.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dk=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then return c:IsSSetable() and dk:IsFaceup() and dk:IsSetCard(0x667) and dk:GetOwner()==tp end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c26067011.setop(e,tp,eg,ep,ev,re,r,rp)
	local ec=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local c=e:GetHandler()
	if ec:IsFaceup() and ec:IsSetCard(0x667) and ec:GetOwner()==tp and Duel.SendtoExtraP(ec,tp,REASON_EFFECT)~=0 then
		if not c:IsRelateToEffect(e) or not c:IsSSetable() then return end
		Duel.SSet(tp,c)
	end
end