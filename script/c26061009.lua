--Fulmiknight Essence
function c26061009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26061009.target)
	e1:SetOperation(c26061009.activate)
	c:RegisterEffect(e1)
	--LP Cost replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26061009,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_LPCOST_REPLACE)
	e4:SetCountLimit(26061009,1)
	e4:SetCondition(c26061009.lrcon)
	e4:SetOperation(c26061009.lrop)
	c:RegisterEffect(e4)
end
function c26061009.filter(c)
	return (c:GetAttack()==0 or c:GetDefense()==0) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsReleasable()
end
function c26061009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061009.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c26061009.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpv,dwv=0,0
	if chk==0 then return Duel.IsExistingMatchingCard(c26061009.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,atv,dfv) end
	local g=Duel.SelectMatchingCard(tp,c26061009.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,2,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
	lpv=g:GetSum(Card.GetAttack)+g:GetSum(Card.GetDefense)
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.Recover(tp,lpv,REASON_EFFECT)
	if lpv==5000 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c26061009.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	if Duel.GetLP(ep)>ev then return false end
	if not (re and re:IsActivated()) then return false end
	local rc=re:GetHandler()
	return e:GetHandler():IsAbleToRemoveAsCost()
end
function c26061009.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Recover(tp,ev*2,REASON_EFFECT)
	Duel.PayLPCost(ep,ev)
end