--Entrophys Manifest
function c26065008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26065008,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26065008.target)
	e1:SetOperation(c26065008.activate)
	c:RegisterEffect(e1)
end

function c26065008.filter(c)
	return c:IsSetCard(0x665) and not c:IsCode(26065008) and c:IsAbleToHand()
end
function c26065008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c26065008.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26065008.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26065008.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil,code)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end