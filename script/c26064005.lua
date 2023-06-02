--Sidereal Over-wind Marshall - Saeculum
function c26064005.initial_effect(c)
	c:EnableReviveLimit()
--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26064005.fliptg)
	e1:SetOperation(c26064005.flipop)
	c:RegisterEffect(e1)
--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064005,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DRAW)
	e3:SetCost(c26064005.thcost)
	e3:SetTarget(c26064005.drtg)
	e3:SetOperation(c26064005.drop)
	c:RegisterEffect(e3)
--leave field
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26064005.setcon1)
	e4:SetTarget(c26064005.settg)
	e4:SetOperation(c26064005.setop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c26064005.setcon2)
	c:RegisterEffect(e5)
end
function c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c26064005.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gp=Duel.GetTurnPlayer()
	local g1=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	if (gp~=tp and Duel.SelectYesNo(tp,aux.Stringid(26064005,0)))
	or (Duel.SelectYesNo(tp,aux.Stringid(26064005,0)) and Duel.SelectYesNo(tp,aux.Stringid(26064005,1))) then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.SkipPhase(gp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(gp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(gp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(gp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(gp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
function c26064005.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064005.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064005.filter(c,e,sp)
	return c:IsSetCard(0x664) and c:IsAbleToHand()
end
function c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064005.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c26064005.thfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x664) and c:IsAbleToHand()
end
function c26064005.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c26064005.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,tp,1)
end
function c26064005.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c26064005.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if t>s then
		Duel.Draw(tp,t-s,REASON_EFFECT)
	end
	if t<s then
		Duel.Draw(1-tp,s-t,REASON_EFFECT)
	end
end