--Over Rewind
function c26064012.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW+TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetTarget(c26064012.target)
	e1:SetOperation(c26064012.activate)
	c:RegisterEffect(e1)
	--quickdraw act
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetOperation(c26064012.checkop2)
	c:RegisterEffect(e2)
	--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26064012.setcon)
	e3:SetOperation(c26064012.setop)
	c:RegisterEffect(e3)
end
function c26064012.qpcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c26064012.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetPreviousLocation()==LOCATION_ONFIELD and tc:GetReason()==REASON_DESTROY then
			tc:RegisterFlagEffect(26064012,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c26064012.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentPhase()&PHASE_DRAW~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetHintTiming(TIMING_CHAIN_END)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		c:RegisterEffect(e1)
	end
end
function c26064012.filter(c,e,tp)
	return
		(c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsType(TYPE_TRAP) and c:IsSetCard(0x664) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable()) or
		c:IsCode(26064007)
end
function c26064012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26064012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26064012.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectTarget(tp,c26064012.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c26064012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_FLIP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		elseif (tc:IsType(TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
			Duel.SSet(tp,tc,tp,false)
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		elseif tc:IsCode(26064007) then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,tp,26064012)
			Duel.BreakEffect()
			local trn=Duel.GetTurnCount(tp)+Duel.GetTurnCount(1-tp)
			tc:AddCounter(0xb6,trn)
		end
	end
end

function c26064012.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD) and re
end
function c26064012.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(nil,rp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if chk==0 then return true end
	Duel.SetTargetPlayer(rp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,rp,1)
end
function c26064012.setop(e,tp,eg,ep,ev,re,r,rp)
	local p=rp
	local g1=Duel.GetMatchingGroup(nil,p,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	Duel.SendtoDeck(g1,p,2,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(nil,p,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,1-p,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local gv=g2-g1
	if gv>0 then Duel.Draw(p,gv,REASON_EFFECT) end
end