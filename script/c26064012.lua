--Over-Wind Back
function c26064012.initial_effect(c)
	--ACTIVATE effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26064012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW+TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetTarget(c26064012.fliptg)
	e1:SetOperation(c26064012.flipop)
	c:RegisterEffect(e1)
	--DRAW effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetTarget(c26064012.drtg)
	e2:SetOperation(c26064012.drop)
	c:RegisterEffect(e2)
	--TURN effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26064012.setcon)
	e3:SetOperation(c26064012.setop)
	c:RegisterEffect(e3)
end
c26064012.FLIP=true
c26064012.DRAW=true
c26064012.TURN=true
function c26064012.filter(c,e,tp)
	local TRAP =TYPE_TRAP+TYPE_CONTINUOUS 
	return
		(c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:GetType()&TRAP ==TRAP and c:IsSetCard(0x664) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable()) or
		(c:IsCode(26064007) and c:GetActivateEffect():IsActivatable(tp))
end
function c26064012.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26064012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26064012.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectTarget(tp,c26064012.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c26064012.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local TRAP =TYPE_TRAP+TYPE_CONTINUOUS 
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_FLIP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_DEFENSE) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		elseif (tc:GetType()&TRAP ==TRAP and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		elseif tc:IsCode(26064007) then
			Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
			tc:AddCounter(0x1b,12,trn)
		end
	end
end
function c26064012.drfilter(c)
	return c:IsSetCard(0x664) and c:IsAbleToHand()
end
function c26064012.rescon(sg,e,tp,mg)
	return #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and  #sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)<2
end
function c26064012.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c26064012.drfilter(chkc) end
	local rg=Duel.GetMatchingGroup(c26064012.drfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	if chk==0 then 
		if e:GetHandler():IsReason(REASON_RULE) then e:SetLabel(2)
		else e:SetLabel(1) end
		return aux.SelectUnselectGroup(rg,e,tp,1,1,c26064012.rescon,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26064012.drop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c26064012.drfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local mx=e:GetLabel()
	local rsg=aux.SelectUnselectGroup(rg,e,tp,1,mx,c26064012.rescon,1,tp,HINTMSG_ATOHAND)
	if rsg:GetCount()>0 then
		Duel.SendtoHand(rsg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rsg)
	end
end
function c26064012.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD) and rp~=tp
end
function c26064012.setfilter(c)
	return c:IsAbleToDeck() and not c:IsCode(26064012)
end
function c26064012.setfilter2(c,tid)
	return c:IsAbleToDeck() and c:GetTurnID()==tid and not c:IsCode(26064012)
end
function c26064012.rescon2(sg,e,tp,mg)
	return #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
end
function c26064012.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(c26064012.setfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c26064012.setfilter2,tp,LOCATION_GRAVE,0,nil,tid)
	g:Merge(g2)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,3,c26064012.rescon2,0) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,0,tp,1)
end
function c26064012.setop(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local g=Duel.GetMatchingGroup(c26064012.setfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c26064012.setfilter2,tp,LOCATION_GRAVE,0,nil,tid)
	g:Merge(g2)
	local gc=aux.SelectUnselectGroup(g,e,tp,1,3,c26064012.rescon2,1,tp,HINTMSG_ATOHAND)
	Duel.SendtoDeck(gc,tp,0,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.Draw(tp,#gc,REASON_EFFECT)
end