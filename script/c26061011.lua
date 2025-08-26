--Fulmiknight Resolution
function c26061011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26061011,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCost(c26061011.cost)
	e1:SetTarget(c26061011.target)
	e1:SetOperation(c26061011.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26063010,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,26061011,EFFECT_COUNT_CODE_OATH)
	e3:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c26061011.lpcond)
	e3:SetOperation(c26061011.lpop)
	c:RegisterEffect(e3)
	aux.GlobalCheck(c26061011,function()
		c26061011[0]=0
		c26061011[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c26061011.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			c26061011[0]=0
			c26061011[1]=0
		end)
	end)
end
function c26061011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	local sg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local min=#sg-(math.floor(lp/2000))
	if min<0 then min=0 end
	if chk==0 then return (min>0 and Duel.CheckLPCost(tp,min*2000)) or #sg>0 end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.DiscardHand(tp,Card.IsDiscardable,min,#sg,REASON_COST+REASON_DISCARD)
		Duel.BreakEffect()
		sg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
		Duel.PayLPCost(tp,#sg*2000)
	end
end
function c26061011.filter1(c)
	return c:IsSetCard(0x661) and c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c26061011.filter2(c,e,tp,tid)
	return c:IsSetCard(0x661) and c:IsType(TYPE_UNION) and c:GetTurnID()==tid --and (c:GetPreviousLocation()&LOCATION_ONFIELD)~=0
	and c:IsAbleToHand()
end
function c26061011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26061011.filter1(chkc,e,tp,tid) end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c26061011.filter1,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(c26061011.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid)
	end
	local g1=Duel.GetMatchingGroup(c26061011.filter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c26061011.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,tid)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
end
function c26061011.operation(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local g1=Duel.GetMatchingGroup(c26061011.filter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c26061011.filter2,tp,LOCATION_GRAVE,0,nil,e,tp,tid)
	g1:Merge(g2)
	if #g1>0 then
		Duel.BreakEffect()
		local sg=aux.SelectUnselectGroup(g1,e,tp,1,#g1,aux.dncheck,1,tp,HINTMSG_ATOHAND)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local lpv=sg:GetSum(Card.GetAttack)+sg:GetSum(Card.GetDefense)
		Duel.Recover(tp,lpv,REASON_EFFECT)
	end
end
function c26061011.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		local val=ev
		c26061011[ep]=c26061011[ep]+val
	end
end
function c26061011.lpcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=c26061011[tp] and c26061011[tp]>0
end
function c26061011.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,c26061011[tp])
end