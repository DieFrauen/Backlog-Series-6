--Entrophys Reaction
function c26065011.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26065011,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,26065011,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26065011.negcon)
	e1:SetTarget(c26065011.negtg)
	e1:SetOperation(c26065011.negop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26065011,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,{26065011,1},EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c26065011.condition)
	e2:SetTarget(c26065011.target)
	e2:SetOperation(c26065011.activate)
	c:RegisterEffect(e2)
end
function c26065011.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and re:GetHandler():IsSetCard(0x665)
end

function c26065011.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and re:GetHandler():IsSetCard(0x665) and re:GetCode()~=26065011
end
function c26065011.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,re:GetHandler():GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,re:GetHandler():GetPreviousLocation())
	end
end
function c26065011.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) and not rc:IsRelateToEffect(re) then return end
	local g=Group.FromCards(c,rc)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26065011,2))
	local opt=Duel.SelectEffect(tp,
		{true,aux.Stringid(26065011,3)},
		{true,aux.Stringid(26065011,4)})
	if opt==1 then
		c:CancelToGrave(true)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	elseif opt==2 then
		rc:CancelToGrave(true)
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
	end
end
function c26065011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if re:GetHandler():IsCode(26065011) then return false end
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c26065011.activate(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
