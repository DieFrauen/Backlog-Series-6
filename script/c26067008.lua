--The First Deception
function c26067008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26067008,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26067008.target)
	e1:SetOperation(c26067008.activate)
	c:RegisterEffect(e1)
	--sort opp deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26067008,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26067008.tdtg)
	e2:SetOperation(c26067008.tdop)
	c:RegisterEffect(e2)
end
function c26067008.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26067008.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26067008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26067008.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	if #sg>0 and Duel.SendtoDeck(sc,1-tp,0,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_DECK) then
		sc:ReverseInDeck()
		sc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c26067008.refilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x667) and c:IsFaceup() and c:GetOwner()==tp
end
function c26067008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local top=Duel.GetDecktopGroup(1-tp,1)
	if #top>0 and top:GetFirst():IsFaceup() then return false end
	if chk==0 then
		local g=Duel.GetMatchingGroup(c26067008.refilter,1-tp,LOCATION_DECK,0,nil,tp)
		return #g>0
	end
end
function c26067008.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26067008.refilter,1-tp,LOCATION_DECK,0,nil,tp)
	local op=1-tp
	local rg=aux.SelectUnselectGroup(g,e,op,#g,#g,nil,1,op,aux.Stringid(26067008,2))
	if #rg>0 then
		Duel.ConfirmCards(tp,rg)
		sg=rg:GetFirst()
		Duel.ShuffleDeck(op)
		for sg in aux.Next(rg) do
			Duel.MoveToDeckTop(sg)
			sg:ReverseInDeck()
		end
	end
end