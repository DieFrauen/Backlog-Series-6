--Over-Wind Leap
function c26064009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064009,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c26064009.cost)
	c:RegisterEffect(e1)
	--direct attack/
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FLIP))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage trans
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetTargetRange(LOCATION_MZONE,0)
	e2a:SetTarget(c26064009.damtg)
	c:RegisterEffect(e2a)
	--deck damage
	local e2b=Effect.CreateEffect(c)
	e2b:SetDescription(aux.Stringid(26064009,6))
	e2b:SetCategory(CATEGORY_DRAW)
	e2b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2b:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_CAL)
	e2b:SetRange(LOCATION_SZONE)
	e2b:SetCode(EVENT_BATTLE_DAMAGE)
	e2b:SetCondition(c26064009.reccon)
	e2b:SetTarget(c26064009.rectg)
	e2b:SetOperation(c26064009.recop)
	c:RegisterEffect(e2b)
	--when drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26064009,4))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DRAW)
	e3:SetCost(c26064009.thcost)
	e3:SetTarget(c26064009.drtg)
	e3:SetOperation(c26064009.drop)
	c:RegisterEffect(e3)
	--leave field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26064009,5))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26064009.setcon)
	e4:SetTarget(c26064009.settg)
	e4:SetOperation(c26064009.setop)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetCode(EVENT_TO_GRAVE)
	e4a:SetCondition(c26064009.setcon2)
	c:RegisterEffect(e4a)
end
c26064009.FLIP=true
c26064009.DRAW=true
c26064009.TURN=true
function c26064009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c26064009.fliptg(e,tp,eg,ep,ev,re,r,rp,0)
	and Duel.SelectYesNo(tp,aux.Stringid(26064009,0)) then 
		e:SetTarget(c26064009.fliptg)
		e:SetCategory(CATEGORY_POSITION)
		e:SetOperation(c26064009.flipop)
	end
end
function c26064009.posfilter(c)
	return c:IsCanChangePosition() and not c:IsPosition(POS_FACEUP_ATTACK)
end
function c26064009.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26064009.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c26064009.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOriginalType()&TYPE_CONTINUOUS ~=0 and not c:IsRelateToEffect(e) then return end
	local sg=Duel.SelectMatchingCard(tp,c26064009.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.ChangePosition(sg,POS_FACEUP_ATTACK)
end
function c26064009.damtg(e,c)
	if c and c:IsType(TYPE_FLIP) and c:IsLevelAbove(1) then
		e:SetValue(c:GetLevel()*100)
		return true
	end
end
function c26064009.reccon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc:IsType(TYPE_FLIP)
end
function c26064009.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=eg:GetFirst()
	local lv=rc:GetLevel()
	if chk==0 then return rc and lv>=1 end
	Duel.SetTargetPlayer(ep)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ev)
end
function c26064009.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	val=Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	local dg=g:RandomSelect(1-tp,d)
	Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
end
function c26064009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064009.drfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c26064009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,1-tp,LOCATION_MZONE)
end
function c26064009.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsSSetable() then return end
	Duel.SSet(tp,c,tp,false)
	local s1=Duel.GetMatchingGroup(Card.IsFacedown,  tp,LOCATION_ONFIELD,0,nil)
	local s2=Duel.GetMatchingGroup(Card.IsFacedown,1-tp,LOCATION_ONFIELD,0,nil)
	local g1=Duel.GetMatchingGroup(c26064009.drfilter,  tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c26064009.drfilter,1-tp,LOCATION_MZONE,0,nil)
	local max1,max2=math.min(#g1,#s2),math.min(#g2,#s1)
	g1=g1:Select(  tp,max1,max1,nil)
	g2=g2:Select(1-tp,max2,max2,nil)
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_RULE)
	Duel.ConfirmCards(PLAYER_ALL,g1)
end
function c26064009.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK) and re
end
function c26064009.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not (c:GetPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP))
end
function c26064009.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c26064009.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26064009.thfilter,rp,LOCATION_MZONE,0,nil)
	if chk==0 then return e:GetType()&EFFECT_TYPE_TRIGGER_F ~=0 or #g>0 end
	Duel.SetTargetPlayer(rp) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,rp,LOCATION_MZONE)
end
function c26064009.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c26064009.thfilter,p,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c26064009.atfilter(e,c)
	return c:IsFacedown() or not c:IsType(TYPE_FLIP)
end