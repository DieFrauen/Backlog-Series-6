--Entrophys Manifest
function c26065008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065008,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26065008.target)
	e1:SetOperation(c26065008.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065008,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c26065008.thcon)
	e2:SetTarget(c26065008.thtg)
	e2:SetOperation(c26065008.thop)
	c:RegisterEffect(e2)
end

function c26065008.filter(c,code,tp,flag)
	return Duel.GetFlagEffect(tp,flag)==0 and c:IsSetCard(0x665) and not c:IsCode(code) and c:IsAbleToHand()
end
function c26065008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return
	Duel.IsExistingMatchingCard(c26065008.filter,tp,LOCATION_DECK,0,1,nil,code,tp,26065008) or
	Duel.IsExistingMatchingCard(c26065008.filter,tp,0x0c,0x0c,1,nil,code,tp,26065108) or
	Duel.IsExistingMatchingCard(c26065008.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,code,tp,26065208) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26065008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=c:GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.GetMatchingGroup(c26065008.filter,tp,LOCATION_DECK,0,nil,code,tp,26065008)
	local g2=Duel.GetMatchingGroup(c26065008.filter,tp,0x0c,0x0c,nil,code,tp,26065108)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c26065008.filter,tp,LOCATION_GRAVE,0,nil,code,tp,26065208)
	g1:Merge(g3)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tc:GetOwner(),tc) end
		local loc=tc:GetPreviousLocation()
		if   loc&LOCATION_DECK  ==LOCATION_DECK then
			Duel.RegisterFlagEffect(tp,26065008,RESET_PHASE+PHASE_END,0,1)
		elseif loc&LOCATION_ONFIELD ==LOCATION_ONFIELD then
			Duel.RegisterFlagEffect(tp,26065108,RESET_PHASE+PHASE_END,0,1)
		elseif loc&LOCATION_GRAVE   ==LOCATION_GRAVE   then
			Duel.RegisterFlagEffect(tp,26065208,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c26065008.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.exccon(e) and rp~=tp and eg:IsExists(c26065008.recfilter,1,nil,tp) 
end
function c26065008.recfilter(c,p)
	return not c:IsReason(REASON_DRAW) and Duel.GetFieldGroup(p,0,LOCATION_HAND):IsContains(c) and c:GetPreviousLocation()==LOCATION_DECK and c:GetPreviousControler()~=p
end
function c26065008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26065008.tdfilter,tp,LOCATION_HAND,0,nil)
	if c:IsAbleToDeck() then g:AddCard(c) end
	if chk==0 then return c:IsAbleToHand() and (c:IsAbleToDeck() or #g>0) and Duel.GetFlagEffect(tp,26065208)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c26065008.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.GetFlagEffect(tp,26065208)==0 and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND)) then return end
	Duel.ConfirmCards(1-tp,c)
	Duel.RegisterFlagEffect(tp,26065208,RESET_PHASE+PHASE_END,0,1)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c26065008.tdfilter,tp,LOCATION_HAND,0,nil)
	local sc=g:Select(tp,1,1,nil)
	if not sc:IsExists(Card.IsCode,1,nil,26065008) then Duel.ConfirmCards(1-tp,sc) end
	Duel.SendtoDeck(sc,tp,2,REASON_EFFECT)
	Duel.ShuffleHand(tp)
end
function c26065008.tdfilter(c)
	return c:IsSetCard(0x665) and c:IsAbleToDeck()
end