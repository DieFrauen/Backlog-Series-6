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
	return c:IsSetCard(0x661) and (c:IsAbleToGrave() or c:IsAbleToDeck())
end
function c26061009.rescon1(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x661) and Duel.IsPlayerCanDraw(tp,#sg)
end
function c26061009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061009.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c26061009.eqfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x661)
end
function c26061009.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lpv,dwv=0,0
	if chk==0 then return Duel.IsExistingMatchingCard(c26061009.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26061009.rescon1,1,tp,HINTMSG_TOGRAVE)
	local b1,b2=sg:FilterCount(Card.IsAbleToGrave,nil)==#sg,sg:FilterCount(Card.IsAbleToDeck,nil)==#sg
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26061009,0))
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(26061009,1)},
		{b2,aux.Stringid(26061009,2)})
	local eqg=sg:Filter(c26061009.eqfilter,nil)
	lpv=eqg:GetSum(Card.GetBaseAttack)+eqg:GetSum(Card.GetBaseDefense)
	Duel.Recover(tp,lpv,REASON_EFFECT)
	if op==1 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if op==2 then
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
	local val=#sg
	if lpv==5000 then val=val+1 end
	Duel.Draw(tp,val,REASON_EFFECT)
end
function c26061009.tbfilter(c,reas)
	return c:IsAbleToRemoveAsCost() and c:GetOriginalCode()==26061009
end
function c26061009.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	if Duel.GetLP(ep)>ev then return false end
	if not (re and re:IsActivated()) then return false end
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(c26061009.tbfilter,tp,LOCATION_GRAVE,0,nil,true)
	g:Sub(g:Filter(Card.IsDisabled,nil))
	return #g>0 and e:GetHandler()==g:GetFirst()
end
function c26061009.lrop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26061009.tbfilter,tp,LOCATION_GRAVE,0,nil,false)
	local sg=g:Select(tp,1,3,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.Recover(tp,ev*#sg,REASON_EFFECT)
	Duel.PayLPCost(ep,ev)
end