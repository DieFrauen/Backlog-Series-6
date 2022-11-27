--Towerbridge of Lemegeton
function c26066009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(26066009,0))
	c:RegisterEffect(e1)
	--decrease ATK/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c26066009.atkval)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2b)
	--indestructible
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(1)
	e3:SetCondition(c26066009.indcon)
	c:RegisterEffect(e3)
	--destroy redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(c26066009.redir)
	c:RegisterEffect(e4)
	--draw (opponent)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26066009,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(c26066009.effcost)
	e5:SetTarget(c26066009.drtg)
	e5:SetOperation(c26066009.drop)
	c:RegisterEffect(e5)
end
function c26066009.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,e:GetHandler():GetControler(),LOCATION_EXTRA,0,nil)*-100
end
function c26066009.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldCard(tp,LOCATION_PZONE,0) or Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c26066009.defilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_ONFIELD)  and c:IsReason(REASON_EFFECT) and c:IsSetCard(0x666) and c:IsAbleToDeck()
end
function c26066009.redir(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c26066009.defilter,nil)
	if rp==tp then return end
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26066009,1)) then
		g=g:Select(tp,#g,#g,nil)
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			if Duel.SendtoDeck(tc,1-tp,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
				tc:ReverseInDeck()
				tc:RegisterFlagEffect(26066001,RESET_EVENT|(RESETS_STANDARD&~RESET_TOHAND),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26066001,2))
			end
		end
	end
end

function c26066009.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26066009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c26066009.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
