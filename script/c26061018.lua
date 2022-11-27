--Fulmiknight Beckon
function c26061009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26061009,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26061009.thtg)
	e1:SetOperation(c26061009.thop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26061009,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c26061009.target)
	e2:SetOperation(c26061009.activate)
	c:RegisterEffect(e2)
	--LP Cost replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26061009,5))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_LPCOST_REPLACE)
	e4:SetCondition(c26061009.lrcon)
	e4:SetOperation(c26061009.lrop)
	c:RegisterEffect(e4)
	
end

function c26061009.thfilter(c)
	return c:IsSetCard(0x661) and c:IsAbleToHand()
end
function c26061009.tdfilter(c)
	return c:IsSetCard(0x661) and c:IsAbleToDeck()
end
function c26061009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c26061009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26061009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local g1=Duel.GetMatchingGroup(c26061009.tdfilter,tp,LOCATION_HAND,0,nil)
		local tg1=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,tg1)
		Duel.BreakEffect()
		if Duel.SendtoDeck(tg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then
			Duel.Recover(tp,lpv,REASON_EFFECT)
		end
	end
end

function c26061009.tfilter(c,tp)
	return c:IsType(TYPE_FIELD) and (c:GetActivateEffect():IsActivatable(tp,true,true) or c:GetActivateEffect():IsActivatable(1-tp,true,true))
end
function c26061009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26061009.tfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then Duel.RegisterFlagEffect(tp,CARD_MAGICAL_MIDBREAKER,RESET_CHAIN,0,1) end
end
function c26061009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26061009,2))
	local tc=Duel.SelectMatchingCard(tp,c26061009.tfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	local op=Duel.SelectOption(tp,aux.Stringid(26061009,3),aux.Stringid(26061009,4))
	--local target_player=op==1 and tp or 1-tp
	if op==0 and Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp) then
		Duel.Recover(1-tp,2000,REASON_EFFECT)
	end
	if op==1 and Duel.ActivateFieldSpell(tc,e,1-tp,eg,ep,ev,re,r,rp) then
		Duel.Recover(tp,2000,REASON_EFFECT)
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
	Duel.PayLPCost(ep,Duel.GetLP(ep)/2)
end