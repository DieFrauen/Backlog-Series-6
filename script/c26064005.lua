--Sidereal Over-wind Marshall - Saeculum
function c26064005.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c26064005.splimit)
	c:RegisterEffect(e0)
--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064005,2))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c26064005.fliptg)
	e1:SetOperation(c26064005.flipop)
	c:RegisterEffect(e1)
--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064005,4))
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
	e4:SetDescription(aux.Stringid(26064005,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26064005.setcon1)
	e4:SetTarget(c26064005.settg)
	e4:SetOperation(c26064005.setop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c26064005.setcon2)
	c:RegisterEffect(e6)
end
c26064005.FLIP=true
c26064005.DRAW=true
c26064005.TURN=true
function c26064005.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c26064005.bfilter(c,e,sp)
	return c:IsCode(26064006,26064008) and c:IsAbleToRemove()
end
function c26064005.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	e:SetLabel(0)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	local g2=Duel.GetMatchingGroup(c26064005.bfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	if #g2>0 and Duel.GetTurnPlayer()~=tp
	and c:GetType()&TYPE_RITUAL ~=0 and e:IsActiveType(EFFECT_TYPE_FLIP)
	and Duel.SelectYesNo(tp,aux.Stringid(26064005,0)) then
		local tc=g2:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
		e:SetLabel(26064005)
	end
end
function c26064005.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gp=Duel.GetTurnPlayer()
	local g1=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	local g2=Duel.GetMatchingGroup(c26064005.bfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	if e:GetLabel()==26064005 then
		local e1=Effect.CreateEffect(c)
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
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD) and c26064005.setcon(c,tp,rp)
end
function c26064005.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK) and c26064005.setcon(c,tp,rp)
end
function c26064005.setcon(c,tp,rp)
	return c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp~=tp)
end
function c26064005.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064005.filter(c,e,sp)
	return c:IsSetCard(0x664) and c:IsAbleToHand()
end
function c26064005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26064005.drop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x664) then
		Duel.Draw(tp,1,REASON_EFFECT)
	else return end
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
end