--Towerbridge of Lemegeton
function c26067009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(26067009,0))
	c:RegisterEffect(e1)
	--decrease ATK/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c26067009.atkval)
	e2:SetTarget(c26067009.atktg)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2a)
	--enable deck for devious purposes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(26067009)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c26067009.deckcon)
	c:RegisterEffect(e3)
	--destroy redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(c26067009.redir)
	c:RegisterEffect(e4)
	--draw 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26067009,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCost(c26067009.effcost)
	e5:SetTarget(c26067009.drtg)
	e5:SetOperation(c26067009.drop)
	c:RegisterEffect(e5)
end
function c26067009.atkval(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(Card.IsFaceup,1-tp,LOCATION_EXTRA,0,nil)*-100
end
function c26067009.atktg(e,c)
	return not c:IsType(TYPE_PENDULUM)
end
function c26067009.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_ONFIELD)  and c:IsReason(REASON_EFFECT) and c:IsSetCard(0x667) and c:IsAbleToDeck()
end
function c26067009.redir(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c26067009.defilter,nil)
	if rp==tp or Duel.GetFlagEffect(tp,26067009)>1 or Duel.GetFlagEffect(tp,26067309)>0 or not Duel.CheckLPCost(tp,700) then return end
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26067009,1)) then
		g=g:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		Duel.PayLPCost(tp,700)
		for tc in aux.Next(g) do
			if Duel.SendtoDeck(tc,1-tp,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
				tc:ReverseInDeck()
				tc:RegisterFlagEffect(26067001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26067001,2))
			end
		end
		Duel.RegisterFlagEffect(tp,26067009,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,26067309,RESET_PHASE+PHASE_END,0,1)
	end
end
function c26067009.deckcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,26067009)<2
	and Duel.GetFlagEffect(tp,26067209)==0 
end
function c26067009.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26067009)<2
	and Duel.GetFlagEffect(tp,26067109)==0 
	and Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
	Duel.RegisterFlagEffect(tp,26067009,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,26067109,RESET_PHASE+PHASE_END,0,1)
end
function c26067009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local top1=Duel.GetDecktopGroup(tp,1)
	local top2=Duel.GetDecktopGroup(1-tp,1)
	local b1=top1:GetFirst():IsFaceup() and Duel.IsPlayerCanDraw(tp,1)
	local b2=top2:GetFirst():IsFaceup() and Duel.IsPlayerCanDraw(1-tp,1)
	if chk==0 then return b1 or b2 end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if b2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	end
end
function c26067009.drop(e,tp,eg,ep,ev,re,r,rp)
	local top1=Duel.GetDecktopGroup(tp,1)
	local top2=Duel.GetDecktopGroup(1-tp,1)
	local b1=top1:GetFirst():IsFaceup() and Duel.IsPlayerCanDraw(tp,1)
	local b2=top2:GetFirst():IsFaceup() and Duel.IsPlayerCanDraw(1-tp,1)
	if chk==0 then return b1 or b2 and e:GetHandler():IsRelateToEffect(e) end
	if b1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if b2 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end