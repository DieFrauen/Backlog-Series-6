--Blazon - Vair the Vanguard
function c26062006.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26062006,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,26062006)
	e1:SetCost(c26062006.cost)
	e1:SetTarget(c26062006.target)
	e1:SetOperation(c26062006.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--grave eff
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26062006,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c26062006.grtg)
	e4:SetOperation(c26062006.grop)
	c:RegisterEffect(e4)
	--lv up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26062006,2))
	e5:SetCategory(CATEGORY_LVCHANGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0x1c0)
	e5:SetTarget(c26062006.lvtg)
	e5:SetOperation(c26062006.lvop)
	c:RegisterEffect(e5)
end
function c26062006.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x662) and not c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function c26062006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26062006.cfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.IsExistingMatchingCard(c26062006.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c26062006.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c26062006.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.SendtoGrave(Group.FromCards(g1,g2),REASON_COST)
end
function c26062006.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x662) and c:IsAbleToGraveAsCost()
end
function c26062006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26062006.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c26062006.grfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x662) and (c:IsLevelAbove(2) or not c:IsType(TYPE_TUNER))
end
function c26062006.grtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062006.grfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062006.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062006.grfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062006.grop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:IsSetCard(0x662) and (tc:IsLevelAbove(2) or not tc:IsType(TYPE_TUNER)) and Duel.SelectYesNo(tp,aux.Stringid(26062006,1)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_TUNER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			return
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c26062006.lvfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and not c:GetLevel()~=ch
end
function c26062006.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	e:SetLabel(Duel.GetCurrentChain())
	local lv=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26062006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26062006.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c26062006.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26062006.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end