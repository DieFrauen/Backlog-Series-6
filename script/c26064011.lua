--Over-wind Accel
function c26064011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064011,6))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c26064011.cost)
	c:RegisterEffect(e1)
	--uncounterable flip summons
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c26064011.efilter)
	--c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	--c:RegisterEffect(e3)
	--rewrite and draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(c26064011.recon)
	e4:SetOperation(c26064011.reop)
	c:RegisterEffect(e4)
	--when drawn
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26064011,5))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DRAW)
	e5:SetCost(c26064011.thcost)
	--e5:SetTarget(c26064011.drtg)
	e5:SetOperation(c26064011.drop)
	c:RegisterEffect(e5)
	--leave field
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26064011,6))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c26064011.setcon)
	e6:SetTarget(c26064011.settg)
	e6:SetOperation(c26064011.setop)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetCode(EVENT_TO_GRAVE)
	e6a:SetCondition(c26064011.setcon2)
	c:RegisterEffect(e6a)
end
c26064011.FLIP=true
c26064011.DRAW=true
c26064011.TURN=true
function c26064011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=c26064011.fliptg(e,tp,eg,ep,ev,re,r,rp,2)
	if chk==0 then return true end
	if b and Duel.SelectYesNo(tp,aux.Stringid(26064011,0)) then 
		e:SetTarget(c26064011.fliptg)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c26064011.flipop)
	end
end
function c26064011.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if chk==2 then return Duel.IsExistingMatchingCard(c26064011.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c26064011.spfilter(c)
	return c:IsSetCard(0x664) and c:IsType(TYPE_MONSTER)
end
function c26064011.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c26064011.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(26064011,3)) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)
		if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	else
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c26064011.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsType(TYPE_FLIP)
end

function c26064011.recon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x664) then return false end
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_SEARCH))
	if ((ex1 and (dv1&LOCATION_DECK)==LOCATION_DECK) and not re:IsHasCategory(CATEGORY_DRAW))
		or ex2 then return not re:GetHandler():IsSetCard(0x664) end
	return false
end
function c26064011.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c26064011.repop)
end
function c26064011.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave(false)
	end
	Duel.Hint(HINT_CARD,tp,26064011)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c26064011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c26064011.drfilter(c,e,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x664) and not c:IsPublic()
end
function c26064011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c26064011.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetDescription(aux.Stringid(26064011,1))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c26064011.handcon)
	e1:SetValue(c26064011.handvalue)
	Duel.RegisterEffect(e1,tp)
	--Activation cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c26064011.costtg)
	e2:SetOperation(c26064011.costop)
	Duel.RegisterEffect(e2,tp)
end
function c26064011.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c26064011.costfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c26064011.handvalue(e,rc,re)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x664) then rc:RegisterFlagEffect(26064011,RESET_CHAIN,0,0,e:GetHandler():GetFieldID()) end
end
function c26064011.costtg(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsLocation(LOCATION_HAND) and tc:IsSetCard(0x664) and tc:GetFlagEffect(26064011)>0 and tc:GetFlagEffectLabel(26064011)==e:GetHandler():GetFieldID()
end
function c26064011.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,26064011)
	local g=Duel.SelectMatchingCard(tp,c26064011.costfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c26064011.costfilter(c)
	return c:IsFacedown()
	and c:IsAbleToHandAsCost()
	--and c:GetSequence()<4
end
function c26064011.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and (c:IsStatus(STATUS_SUMMON_TURN) or c:IsStatus(STATUS_FLIP_SUMMON_TURN) or c:IsStatus(STATUS_SPSUMMON_TURN))
end
function c26064011.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064011.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not (c:GetPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP))
end
function c26064011.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(rp,0,LOCATION_HAND)
	local gc=g:FilterCount(Card.IsAbleToRemove,nil)
	if chk==0 then return e:GetType()&EFFECT_TYPE_TRIGGER_F ~=0
	or (#g==gc and gc>0 and Duel.IsPlayerCanDraw(rp,gc)) end
	Duel.SetTargetPlayer(rp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,rp,gc)
end
function c26064011.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if p==nil then return end
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	local gc=#g
	if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if oc>0 then
			Duel.Draw(p,oc,REASON_EFFECT)
		end
	end
end