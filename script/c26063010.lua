--Astelloy Smelting
function c26063010.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--protects normal summons
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	--discard for draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26063010,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabel(0)
	e2:SetCondition(c26063010.gcond)
	e2:SetCost(c26063010.gcost)
	e2:SetTarget(c26063010.gtg)
	e2:SetOperation(c26063010.gop)
	c:RegisterEffect(e2)
	--grave effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(26063010,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c26063010.tdcost)
	--e3:SetCondition(c26063010.tdcon)
	e3:SetTarget(c26063010.tdtg)
	e3:SetOperation(c26063010.tdop)
	c:RegisterEffect(e3)
end

function c26063010.condition(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup()
	return cg:IsContains(eg:GetFirst())
end
function c26063010.gcond(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local ec=eg:GetFirst()
	local cg=e:GetHandler():GetColumnGroup()
	if cg:IsContains(ec) and ec:IsRace(RACE_ROCK) then e:SetLabel(1) end
	return ec:GetSummonLocation(LOCATION_HAND) and ec:IsType(TYPE_NORMAL)
end
function c26063010.gcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,nil,1,1,REASON_COST+REASON_DISCARD)
end
function c26063010.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26063010.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x663) and c:IsAbleToHand()
end
function c26063010.gop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c26063010.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(26063010,1)) then
		tc=Duel.SelectMatchingCard(tp,c26063010.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

function c26063010.dfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_NORMAL)
end
function c26063010.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,1,REASON_COST)
end
function c26063010.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	return #tg>=2 and tg:GetClassCount(Card.GetCode)==#tg
end
function c26063010.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c26063010.dfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26063010.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.SelectMatchingCard(tp,c26063010.dfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	if g:GetCode()==26063001 then d=2 end
	Duel.Draw(p,d,REASON_EFFECT)
end