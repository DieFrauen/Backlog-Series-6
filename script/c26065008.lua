--Entrophys Manifest
function c26065008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065008,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26065008,EFFECT_COUNT_CODE_OATH)
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
	e2:SetCountLimit(1,26065008,EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c26065008.thcon)
	e2:SetTarget(c26065008.thtg)
	e2:SetOperation(c26065008.thop)
	c:RegisterEffect(e2)
end

function c26065008.filter(c,code)
	return c:IsSetCard(0x665) and not c:IsCode(code) and c:IsAbleToHand()
end
function c26065008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c26065008.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26065008.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26065008.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,code)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26065008.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.exccon(e) and eg:IsExists(c26065008.recfilter,1,nil) 
end
function c26065008.recfilter(c)
	return c:IsSetCard(0x665) and not c:IsReason(REASON_DRAW)
end
function c26065008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if c:IsAbleToDeck() then g:AddCard(c) end
	if chk==0 then return c:IsAbleToHand() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26065008.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND)) then return end
	Duel.ConfirmCards(1-tp,c)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if sc~=c then Duel.ConfirmCards(1-tp,sc) end
	Duel.SendtoDeck(sc,tp,2,REASON_EFFECT)
	Duel.ShuffleHand(tp)
end